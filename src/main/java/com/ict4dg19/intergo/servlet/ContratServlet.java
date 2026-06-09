package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.ContratEmployeDAO;
import com.ict4dg19.intergo.dao.ContratEmployeDAOImpl;
import com.ict4dg19.intergo.dao.EmployeDAO;
import com.ict4dg19.intergo.dao.EmployeDAOImpl;
import com.ict4dg19.intergo.model.ContratEmploye;
import com.ict4dg19.intergo.model.Employe;
import com.ict4dg19.intergo.util.PdfExportUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/contrats", "/contrats/new", "/contrats/insert", "/contrats/delete", "/contrats/edit", "/contrats/update", "/contrats/export"})
public class ContratServlet extends HttpServlet {
    private ContratEmployeDAO contratDAO;
    private EmployeDAO employeDAO;

    @Override
    public void init() {
        contratDAO = new ContratEmployeDAOImpl();
        employeDAO = new EmployeDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/contrats/new":
                showNewForm(request, response);
                break;
            case "/contrats/delete":
                deleteContrat(request, response);
                break;
            case "/contrats/edit":
                showEditForm(request, response);
                break;
            case "/contrats/export":
                exportPdf(request, response);
                break;
            default:
                listContrats(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/contrats/insert".equals(action)) {
            insertContrat(request, response);
        } else if ("/contrats/update".equals(action)) {
            updateContrat(request, response);
        }
    }

    private void listContrats(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ContratEmploye> listContrats = contratDAO.findAll();
        request.setAttribute("listContrats", listContrats);
        request.getRequestDispatcher("/contrat-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Employe> listEmployes = employeDAO.findAll();
        request.setAttribute("listEmployes", listEmployes);
        request.getRequestDispatcher("/contrat-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        ContratEmploye existingContrat = contratDAO.findById(id);
        List<Employe> listEmployes = employeDAO.findAll();
        
        request.setAttribute("contrat", existingContrat);
        request.setAttribute("listEmployes", listEmployes);
        request.getRequestDispatcher("/contrat-form.jsp").forward(request, response);
    }

    private void insertContrat(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ContratEmploye c = new ContratEmploye();
        c.setEmployeId(Long.parseLong(request.getParameter("employeId")));
        c.setTypeContrat(request.getParameter("typeContrat"));
        c.setDateDebut(LocalDate.parse(request.getParameter("dateDebut")));
        
        String dateFinStr = request.getParameter("dateFin");
        if(dateFinStr != null && !dateFinStr.isEmpty()) {
            c.setDateFin(LocalDate.parse(dateFinStr));
        }
        
        c.setSalaire(new BigDecimal(request.getParameter("salaire")));
        c.setAvantages(request.getParameter("avantages"));
        
        contratDAO.create(c);
        response.sendRedirect(request.getContextPath() + "/contrats");
    }

    private void updateContrat(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ContratEmploye c = new ContratEmploye();
        c.setId(Long.parseLong(request.getParameter("id")));
        c.setEmployeId(Long.parseLong(request.getParameter("employeId")));
        c.setTypeContrat(request.getParameter("typeContrat"));
        c.setDateDebut(LocalDate.parse(request.getParameter("dateDebut")));
        
        String dateFinStr = request.getParameter("dateFin");
        if(dateFinStr != null && !dateFinStr.isEmpty()) {
            c.setDateFin(LocalDate.parse(dateFinStr));
        }
        
        c.setSalaire(new BigDecimal(request.getParameter("salaire")));
        c.setAvantages(request.getParameter("avantages"));
        
        contratDAO.update(c);
        response.sendRedirect(request.getContextPath() + "/contrats");
    }

    private void deleteContrat(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        contratDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/contrats");
    }

    private void exportPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<ContratEmploye> list = contratDAO.findAll();
        String[] headers = {"ID", "Employé", "Type", "Début", "Fin", "Salaire"};
        List<String[]> data = new ArrayList<>();
        
        for (ContratEmploye c : list) {
            data.add(new String[]{
                String.valueOf(c.getId()),
                c.getEmploye().getNom() + " " + c.getEmploye().getPrenom(),
                c.getTypeContrat(),
                c.getDateDebut().toString(),
                c.getDateFin() != null ? c.getDateFin().toString() : "Indéterminée",
                c.getSalaire().toString() + " €"
            });
        }
        
        PdfExportUtil.exportToPdf(response, "Historique des Contrats", headers, data, "contrats.pdf");
    }
}
