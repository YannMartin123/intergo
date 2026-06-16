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
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        com.ict4dg19.intergo.model.Utilisateur user = (session != null) ? (com.ict4dg19.intergo.model.Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        
        List<Conge> listConges = new ArrayList<>();
        if (user != null) {
            List<com.ict4dg19.intergo.model.Role> roles = user.getRoles();
            boolean isAdmin = false;
            boolean isRh = false;
            boolean isManager = false;
            if (roles != null) {
                for (com.ict4dg19.intergo.model.Role r : roles) {
                    if ("ADMIN".equals(r.getNom())) isAdmin = true;
                    if ("RH".equals(r.getNom())) isRh = true;
                    if ("MANAGER".equals(r.getNom())) isManager = true;
                }
            }
            
            if (isAdmin || isRh) {
                listConges = congeDAO.findAll();
            } else if (isManager) {
                Employe mgr = (user.getEmployeId() != null) ? employeDAO.findById(user.getEmployeId()) : null;
                if (mgr != null) {
                    Long mgrDeptId = mgr.getDepartementId();
                    List<Conge> allConges = congeDAO.findAll();
                    listConges = new ArrayList<>();
                    for (Conge c : allConges) {
                        if (c.getEmploye() != null && (mgrDeptId.equals(c.getEmploye().getDepartementId()) || c.getEmployeId().equals(user.getEmployeId()))) {
                            listConges.add(c);
                        }
                    }
                } else {
                    listConges = congeDAO.findByEmployeId(user.getEmployeId());
                }
            } else if (user.getEmployeId() != null) {
                listConges = congeDAO.findByEmployeId(user.getEmployeId());
            }
            // else: utilisateur sans fiche employé associée (ex: admin pur) -> liste vide
        }
        
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
        
        // Send email notification to RH / Admin
        Employe e = employeDAO.findById(c.getEmployeId());
        if (e != null) {
            String subject = "Nouvelle demande de conge - " + e.getNom() + " " + e.getPrenom();
            String htmlContent = "<h3>Nouvelle demande de conge soumise</h3>"
                    + "<p><strong>Employe :</strong> " + e.getNom() + " " + e.getPrenom() + " (" + e.getMatricule() + ")</p>"
                    + "<p><strong>Type de conge :</strong> " + c.getTypeConge() + "</p>"
                    + "<p><strong>Periode :</strong> du " + c.getDateDebut() + " au " + c.getDateFin() + " (" + c.getNbJours() + " jours)</p>"
                    + "<p><strong>Motif :</strong> " + (c.getMotif() != null ? c.getMotif() : "Aucun") + "</p>"
                    + "<p>Veuillez vous connecter sur le portail InterGo pour valider ou refuser cette demande.</p>";
            com.ict4dg19.intergo.util.SendGridEmailUtil.sendEmail("admin@entreprise.com", subject, htmlContent);
            com.ict4dg19.intergo.util.SendGridEmailUtil.sendEmail("m.laurent@entreprise.com", subject, htmlContent);
            
            // Send SMS notification to RH / Admin if telephone is provided
            try {
                Employe adminEmp = employeDAO.findByEmail("admin@entreprise.com");
                if (adminEmp != null && adminEmp.getTelephone() != null && !adminEmp.getTelephone().trim().isEmpty()) {
                    com.ict4dg19.intergo.util.SMSUtil.sendSMS(adminEmp.getTelephone(), "InterGo : Nouvelle demande de conge de " + e.getPrenom() + " " + e.getNom() + " (" + c.getNbJours() + "j)");
                }
                Employe managerEmp = employeDAO.findByEmail("m.laurent@entreprise.com");
                if (managerEmp != null && managerEmp.getTelephone() != null && !managerEmp.getTelephone().trim().isEmpty()) {
                    com.ict4dg19.intergo.util.SMSUtil.sendSMS(managerEmp.getTelephone(), "InterGo : Nouvelle demande de conge de " + e.getPrenom() + " " + e.getNom() + " (" + c.getNbJours() + "j)");
                }
            } catch (Exception ex) {
                System.err.println("[CongeServlet] Failed to send leave submission SMS: " + ex.getMessage());
            }
        }
        
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
        
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        com.ict4dg19.intergo.model.Utilisateur user = (session != null) ? (com.ict4dg19.intergo.model.Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<com.ict4dg19.intergo.model.Role> roles = user.getRoles();
        boolean isAdmin = false;
        boolean isRh = false;
        boolean isManager = false;
        if (roles != null) {
            for (com.ict4dg19.intergo.model.Role r : roles) {
                if ("ADMIN".equals(r.getNom())) isAdmin = true;
                if ("RH".equals(r.getNom())) isRh = true;
                if ("MANAGER".equals(r.getNom())) isManager = true;
            }
        }
        
        if (!isAdmin && !isRh && !isManager) {
            response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
            return;
        }
        
        if (isManager && !isAdmin && !isRh) {
            Employe mgr = (user.getEmployeId() != null) ? employeDAO.findById(user.getEmployeId()) : null;
            Conge c = congeDAO.findById(id);
            if (mgr != null && c != null) {
                Employe targetEmp = employeDAO.findById(c.getEmployeId());
                if (targetEmp == null || !mgr.getDepartementId().equals(targetEmp.getDepartementId())) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                    return;
                }
            }
        }
        
        Conge c = congeDAO.findById(id);
        if(c != null) {
            c.setStatut(statut);
            c.setApprouvePar(user.getEmail());
            congeDAO.update(c);
            
            // if approved, deduct from employe solde
            if("APPROUVE".equals(statut)) {
                Employe e = employeDAO.findById(c.getEmployeId());
                if (e != null) {
                    e.setSoldeCongesJours(e.getSoldeCongesJours() - c.getNbJours());
                    employeDAO.update(e);
                }
            }
            
            // Send email notification to employee
            Employe e = employeDAO.findById(c.getEmployeId());
            if (e != null && e.getEmail() != null) {
                String subject = "Mise a jour de votre demande de conge - " + statut;
                String htmlContent = "<h3>Votre demande de conge a ete traitee</h3>"
                        + "<p><strong>Type de conge :</strong> " + c.getTypeConge() + "</p>"
                        + "<p><strong>Periode :</strong> du " + c.getDateDebut() + " au " + c.getDateFin() + " (" + c.getNbJours() + " jours)</p>"
                        + "<p><strong>Statut :</strong> <span style='font-weight: bold; color: " + ("APPROUVE".equals(statut) ? "#10b981" : "#ef4444") + ";'>" + statut + "</span></p>"
                        + "<p><strong>Traitee par :</strong> " + c.getApprouvePar() + "</p>"
                        + "<p>Merci,<br>L'equipe RH InterGo</p>";
                com.ict4dg19.intergo.util.SendGridEmailUtil.sendEmail(e.getEmail(), subject, htmlContent);
            }
            
            // Send SMS notification to employee if telephone is provided
            if (e != null && e.getTelephone() != null && !e.getTelephone().trim().isEmpty()) {
                String smsMessage = "InterGo : Votre demande de conge de " + c.getNbJours() + "j a ete " + ("APPROUVE".equals(statut) ? "VALIDE" : "REFUSE") + ".";
                com.ict4dg19.intergo.util.SMSUtil.sendSMS(e.getTelephone(), smsMessage);
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
