package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.CongeDAO;
import com.ict4dg19.intergo.dao.CongeDAOImpl;
import com.ict4dg19.intergo.dao.EmployeDAO;
import com.ict4dg19.intergo.dao.EmployeDAOImpl;
import com.ict4dg19.intergo.model.Conge;
import com.ict4dg19.intergo.model.Employe;
import com.ict4dg19.intergo.util.PdfExportUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/conges", "/conges/new", "/conges/insert", "/conges/delete", "/conges/edit", "/conges/update", "/conges/export", "/conges/approve"})
public class CongeServlet extends HttpServlet {
    private CongeDAO congeDAO;
    private EmployeDAO employeDAO;

    @Override
    public void init() {
        congeDAO = new CongeDAOImpl();
        employeDAO = new EmployeDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/conges/new":
                showNewForm(request, response);
                break;
            case "/conges/delete":
                deleteConge(request, response);
                break;
            case "/conges/edit":
                showEditForm(request, response);
                break;
            case "/conges/export":
                exportPdf(request, response);
                break;
            case "/conges/approve":
                approveConge(request, response);
                break;
            default:
                listConges(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/conges/insert".equals(action)) {
            insertConge(request, response);
        } else if ("/conges/update".equals(action)) {
            updateConge(request, response);
        }
    }

    private void listConges(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Conge> listConges = congeDAO.findAll();
        request.setAttribute("listConges", listConges);
        request.getRequestDispatcher("/conge-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Employe> listEmployes = employeDAO.findAll();
        request.setAttribute("listEmployes", listEmployes);
        request.getRequestDispatcher("/conge-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Conge existingConge = congeDAO.findById(id);
        List<Employe> listEmployes = employeDAO.findAll();
        
        request.setAttribute("conge", existingConge);
        request.setAttribute("listEmployes", listEmployes);
        request.getRequestDispatcher("/conge-form.jsp").forward(request, response);
    }

    private void insertConge(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Conge c = new Conge();
        c.setEmployeId(Long.parseLong(request.getParameter("employeId")));
        c.setTypeConge(request.getParameter("typeConge"));
        LocalDate start = LocalDate.parse(request.getParameter("dateDebut"));
        LocalDate end = LocalDate.parse(request.getParameter("dateFin"));
        c.setDateDebut(start);
        c.setDateFin(end);
        c.setNbJours((int) ChronoUnit.DAYS.between(start, end) + 1); // Basic calculation
        c.setMotif(request.getParameter("motif"));
        c.setStatut("DEMANDE");
        
        congeDAO.create(c);
        response.sendRedirect(request.getContextPath() + "/conges");
    }

    private void updateConge(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Conge c = new Conge();
        c.setId(Long.parseLong(request.getParameter("id")));
        c.setEmployeId(Long.parseLong(request.getParameter("employeId")));
        c.setTypeConge(request.getParameter("typeConge"));
        LocalDate start = LocalDate.parse(request.getParameter("dateDebut"));
        LocalDate end = LocalDate.parse(request.getParameter("dateFin"));
        c.setDateDebut(start);
        c.setDateFin(end);
        c.setNbJours((int) ChronoUnit.DAYS.between(start, end) + 1);
        c.setMotif(request.getParameter("motif"));
        c.setStatut(request.getParameter("statut"));
        c.setApprouvePar(request.getParameter("approuvePar"));
        
        congeDAO.update(c);
        response.sendRedirect(request.getContextPath() + "/conges");
    }

    private void deleteConge(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        congeDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/conges");
    }
    
    private void approveConge(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        String statut = request.getParameter("statut"); // APPROUVE or REFUSE
        
        Conge c = congeDAO.findById(id);
        if(c != null) {
            c.setStatut(statut);
            c.setApprouvePar("Admin"); // Default for now
            congeDAO.update(c);
            
            // if approved, deduct from employe solde
            if("APPROUVE".equals(statut)) {
                Employe e = employeDAO.findById(c.getEmployeId());
                e.setSoldeCongesJours(e.getSoldeCongesJours() - c.getNbJours());
                employeDAO.update(e);
            }
        }
        response.sendRedirect(request.getContextPath() + "/conges");
    }

    private void exportPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Conge> list = congeDAO.findAll();
        String[] headers = {"ID", "Employé", "Type", "Dates", "Jours", "Statut"};
        List<String[]> data = new ArrayList<>();
        
        for (Conge c : list) {
            data.add(new String[]{
                String.valueOf(c.getId()),
                c.getEmploye().getNom() + " " + c.getEmploye().getPrenom(),
                c.getTypeConge(),
                c.getDateDebut() + " au " + c.getDateFin(),
                String.valueOf(c.getNbJours()),
                c.getStatut()
            });
        }
        
        PdfExportUtil.exportToPdf(response, "Registre des Congés", headers, data, "conges.pdf");
    }
}
