package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.DepartementDAO;
import com.ict4dg19.intergo.dao.DepartementDAOImpl;
import com.ict4dg19.intergo.dao.EmployeDAO;
import com.ict4dg19.intergo.dao.EmployeDAOImpl;
import com.ict4dg19.intergo.model.Departement;
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

@WebServlet(urlPatterns = {"/employes", "/employes/new", "/employes/insert", "/employes/delete", "/employes/edit", "/employes/update", "/employes/export"})
public class EmployeServlet extends HttpServlet {
    private EmployeDAO employeDAO;
    private DepartementDAO departementDAO;

    @Override
    public void init() {
        employeDAO = new EmployeDAOImpl();
        departementDAO = new DepartementDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/employes/new":
                showNewForm(request, response);
                break;
            case "/employes/delete":
                deleteEmploye(request, response);
                break;
            case "/employes/edit":
                showEditForm(request, response);
                break;
            case "/employes/export":
                exportPdf(request, response);
                break;
            default:
                listEmployes(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/employes/insert".equals(action)) {
            insertEmploye(request, response);
        } else if ("/employes/update".equals(action)) {
            updateEmploye(request, response);
        }
    }

    private void listEmployes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Employe> listEmployes = employeDAO.findAll();
        request.setAttribute("listEmployes", listEmployes);
        request.getRequestDispatcher("/employe-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Departement> listDepartements = departementDAO.findAll();
        request.setAttribute("listDepartements", listDepartements);
        request.getRequestDispatcher("/employe-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Employe existingEmploye = employeDAO.findById(id);
        List<Departement> listDepartements = departementDAO.findAll();
        
        request.setAttribute("employe", existingEmploye);
        request.setAttribute("listDepartements", listDepartements);
        request.getRequestDispatcher("/employe-form.jsp").forward(request, response);
    }

    private void insertEmploye(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Employe e = new Employe();
        e.setMatricule(request.getParameter("matricule"));
        e.setNom(request.getParameter("nom"));
        e.setPrenom(request.getParameter("prenom"));
        e.setPoste(request.getParameter("poste"));
        e.setDepartementId(Long.parseLong(request.getParameter("departementId")));
        e.setDateEmbauche(LocalDate.parse(request.getParameter("dateEmbauche")));
        e.setSalaireBase(new BigDecimal(request.getParameter("salaireBase")));
        e.setTypeContrat(request.getParameter("typeContrat"));
        e.setTelephone(request.getParameter("telephone"));
        e.setEmail(request.getParameter("email"));
        e.setSoldeCongesJours(Integer.parseInt(request.getParameter("soldeCongesJours")));
        
        employeDAO.create(e);
        
        // Send welcome email to new employee
        if (e.getEmail() != null) {
            Departement dept = departementDAO.findById(e.getDepartementId());
            String deptName = (dept != null) ? dept.getNom() : "Non specifie";
            String subject = "Bienvenue chez InterGo - Votre compte employe";
            String htmlContent = "<h3>Bienvenue chez InterGo</h3>"
                    + "<p>Bonjour " + e.getPrenom() + " " + e.getNom() + ",</p>"
                    + "<p>Votre profil employe a ete cree avec succes.</p>"
                    + "<p><strong>Matricule :</strong> " + e.getMatricule() + "</p>"
                    + "<p><strong>Poste :</strong> " + e.getPoste() + "</p>"
                    + "<p><strong>Departement :</strong> " + deptName + "</p>"
                    + "<p>Vous pouvez desormais utiliser votre adresse email pour vous connecter ou vous enregistrer sur le portail InterGo.</p>"
                    + "<p>Cordialement,<br>L'equipe RH InterGo</p>";
            com.ict4dg19.intergo.util.SendGridEmailUtil.sendEmail(e.getEmail(), subject, htmlContent);
        }
        
        response.sendRedirect(request.getContextPath() + "/employes");
    }

    private void updateEmploye(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Employe e = new Employe();
        e.setId(Long.parseLong(request.getParameter("id")));
        e.setMatricule(request.getParameter("matricule"));
        e.setNom(request.getParameter("nom"));
        e.setPrenom(request.getParameter("prenom"));
        e.setPoste(request.getParameter("poste"));
        e.setDepartementId(Long.parseLong(request.getParameter("departementId")));
        e.setDateEmbauche(LocalDate.parse(request.getParameter("dateEmbauche")));
        e.setSalaireBase(new BigDecimal(request.getParameter("salaireBase")));
        e.setTypeContrat(request.getParameter("typeContrat"));
        e.setTelephone(request.getParameter("telephone"));
        e.setEmail(request.getParameter("email"));
        e.setSoldeCongesJours(Integer.parseInt(request.getParameter("soldeCongesJours")));
        
        employeDAO.update(e);
        response.sendRedirect(request.getContextPath() + "/employes");
    }

    private void deleteEmploye(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        employeDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/employes");
    }

    private void exportPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Employe> list = employeDAO.findAll();
        String[] headers = {"Matricule", "Nom", "Prénom", "Poste", "Département", "Téléphone"};
        List<String[]> data = new ArrayList<>();
        
        for (Employe e : list) {
            data.add(new String[]{
                e.getMatricule(),
                e.getNom(),
                e.getPrenom(),
                e.getPoste(),
                e.getDepartement().getNom(),
                e.getTelephone() != null ? e.getTelephone() : ""
            });
        }
        
        PdfExportUtil.exportToPdf(response, "Liste des Employés", headers, data, "employes.pdf");
    }
}
