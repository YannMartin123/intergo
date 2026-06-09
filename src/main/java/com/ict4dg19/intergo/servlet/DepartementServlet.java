package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.DepartementDAO;
import com.ict4dg19.intergo.dao.DepartementDAOImpl;
import com.ict4dg19.intergo.model.Departement;
import com.ict4dg19.intergo.util.PdfExportUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/departements", "/departements/new", "/departements/insert", "/departements/delete", "/departements/edit", "/departements/update", "/departements/export"})
public class DepartementServlet extends HttpServlet {
    private DepartementDAO departementDAO;

    @Override
    public void init() {
        departementDAO = new DepartementDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/departements/new":
                showNewForm(request, response);
                break;
            case "/departements/delete":
                deleteDepartement(request, response);
                break;
            case "/departements/edit":
                showEditForm(request, response);
                break;
            case "/departements/export":
                exportPdf(request, response);
                break;
            default:
                listDepartement(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/departements/insert".equals(action)) {
            insertDepartement(request, response);
        } else if ("/departements/update".equals(action)) {
            updateDepartement(request, response);
        }
    }

    private void listDepartement(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Departement> listDepartement = departementDAO.findAll();
        request.setAttribute("listDepartement", listDepartement);
        request.getRequestDispatcher("/departement-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/departement-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Departement existingDepartement = departementDAO.findById(id);
        request.setAttribute("departement", existingDepartement);
        request.getRequestDispatcher("/departement-form.jsp").forward(request, response);
    }

    private void insertDepartement(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String nom = request.getParameter("nom");
        String responsable = request.getParameter("responsable");
        BigDecimal budget = new BigDecimal(request.getParameter("budgetMasseSalariale"));
        
        Departement newDepartement = new Departement(null, nom, responsable, budget);
        departementDAO.create(newDepartement);
        response.sendRedirect(request.getContextPath() + "/departements");
    }

    private void updateDepartement(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String responsable = request.getParameter("responsable");
        BigDecimal budget = new BigDecimal(request.getParameter("budgetMasseSalariale"));

        Departement departement = new Departement(id, nom, responsable, budget);
        departementDAO.update(departement);
        response.sendRedirect(request.getContextPath() + "/departements");
    }

    private void deleteDepartement(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        departementDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/departements");
    }

    private void exportPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Departement> list = departementDAO.findAll();
        String[] headers = {"ID", "Nom", "Responsable", "Budget Salarial"};
        List<String[]> data = new ArrayList<>();
        
        for (Departement d : list) {
            data.add(new String[]{
                String.valueOf(d.getId()),
                d.getNom(),
                d.getResponsable() != null ? d.getResponsable() : "N/A",
                d.getBudgetMasseSalariale() != null ? d.getBudgetMasseSalariale().toString() : "0.00"
            });
        }
        
        PdfExportUtil.exportToPdf(response, "Liste des Départements", headers, data, "departements.pdf");
    }
}
