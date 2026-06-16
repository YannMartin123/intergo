package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.FichePaieDAO;
import com.ict4dg19.intergo.dao.FichePaieDAOImpl;
import com.ict4dg19.intergo.dao.EmployeDAO;
import com.ict4dg19.intergo.dao.EmployeDAOImpl;
import com.ict4dg19.intergo.model.FichePaie;
import com.ict4dg19.intergo.model.Employe;
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

@WebServlet(urlPatterns = {"/fiches-paie", "/fiches-paie/new", "/fiches-paie/insert", "/fiches-paie/delete", "/fiches-paie/edit", "/fiches-paie/update", "/fiches-paie/export"})
public class FichePaieServlet extends HttpServlet {
    private FichePaieDAO fichePaieDAO;
    private EmployeDAO employeDAO;

    @Override
    public void init() {
        fichePaieDAO = new FichePaieDAOImpl();
        employeDAO = new EmployeDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/fiches-paie/new":
                showNewForm(request, response);
                break;
            case "/fiches-paie/delete":
                deleteFiche(request, response);
                break;
            case "/fiches-paie/edit":
                showEditForm(request, response);
                break;
            case "/fiches-paie/export":
                exportPdf(request, response);
                break;
            default:
                listFiches(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        if ("/fiches-paie/insert".equals(action)) {
            insertFiche(request, response);
        } else if ("/fiches-paie/update".equals(action)) {
            updateFiche(request, response);
        }
    }

    private void listFiches(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        com.ict4dg19.intergo.model.Utilisateur user = (session != null) ? (com.ict4dg19.intergo.model.Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        
        List<FichePaie> listFiches = new ArrayList<>();
        if (user != null) {
            List<com.ict4dg19.intergo.model.Role> roles = user.getRoles();
            boolean isAdmin = false;
            boolean isRh = false;
            if (roles != null) {
                for (com.ict4dg19.intergo.model.Role r : roles) {
                    if ("ADMIN".equals(r.getNom())) isAdmin = true;
                    if ("RH".equals(r.getNom())) isRh = true;
                }
            }
            
            if (isAdmin || isRh) {
                listFiches = fichePaieDAO.findAll();
            } else if (user.getEmployeId() != null) {
                listFiches = fichePaieDAO.findByEmployeId(user.getEmployeId());
            }
            // else: user has no associated employe (e.g. pure admin without employe record) -> empty list
        }
        
        request.setAttribute("listFiches", listFiches);
        request.getRequestDispatcher("/fichepaie-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Employe> listEmployes = employeDAO.findAll();
        request.setAttribute("listEmployes", listEmployes);
        request.getRequestDispatcher("/fichepaie-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        FichePaie existingFiche = fichePaieDAO.findById(id);
        List<Employe> listEmployes = employeDAO.findAll();
        
        request.setAttribute("fiche", existingFiche);
        request.setAttribute("listEmployes", listEmployes);
        request.getRequestDispatcher("/fichepaie-form.jsp").forward(request, response);
    }

    private void insertFiche(HttpServletRequest request, HttpServletResponse response) throws IOException {
        FichePaie f = new FichePaie();
        f.setEmployeId(Long.parseLong(request.getParameter("employeId")));
        f.setMois(request.getParameter("mois"));
        
        BigDecimal sb = new BigDecimal(request.getParameter("salaireBase"));
        BigDecimal hs = new BigDecimal(request.getParameter("heuresSup"));
        BigDecimal mhs = new BigDecimal(request.getParameter("montantHeuresSup"));
        BigDecimal p = new BigDecimal(request.getParameter("primes"));
        BigDecimal r = new BigDecimal(request.getParameter("retenues"));
        
        f.setSalaireBase(sb);
        f.setHeuresSup(hs);
        f.setMontantHeuresSup(mhs);
        f.setPrimes(p);
        f.setRetenues(r);
        
        BigDecimal brut = sb.add(mhs).add(p);
        BigDecimal net = brut.subtract(r);
        f.setSalaireBrut(brut);
        f.setSalaireNet(net);
        
        fichePaieDAO.create(f);
        
        // Send email notification to employee
        Employe e = employeDAO.findById(f.getEmployeId());
        if (e != null && e.getEmail() != null) {
            String subject = "Nouvelle fiche de paie disponible - " + f.getMois();
            String htmlContent = "<h3>Votre fiche de paie pour le mois " + f.getMois() + " est disponible</h3>"
                    + "<p><strong>Salaire de Base :</strong> " + f.getSalaireBase() + " FCFA</p>"
                    + "<p><strong>Primes :</strong> " + f.getPrimes() + " FCFA</p>"
                    + "<p><strong>Retenues :</strong> " + f.getRetenues() + " FCFA</p>"
                    + "<p><strong>Salaire Net a payer :</strong> <span style='font-weight: bold; color: #10b981;'>" + f.getSalaireNet() + " FCFA</span></p>"
                    + "<p>Vous pouvez vous connecter sur le portail InterGo pour telecharger le document detaille.</p>"
                    + "<p>Merci,<br>L'equipe RH InterGo</p>";
            com.ict4dg19.intergo.util.SendGridEmailUtil.sendEmail(e.getEmail(), subject, htmlContent);
        }
        
        // Send SMS notification to employee if telephone is provided
        if (e != null && e.getTelephone() != null && !e.getTelephone().trim().isEmpty()) {
            String smsMessage = "InterGo : Votre fiche de paie pour le mois " + f.getMois() + " est disponible. Salaire Net: " + f.getSalaireNet() + " FCFA.";
            com.ict4dg19.intergo.util.SMSUtil.sendSMS(e.getTelephone(), smsMessage);
        }
        
        response.sendRedirect(request.getContextPath() + "/fiches-paie");
    }

    private void updateFiche(HttpServletRequest request, HttpServletResponse response) throws IOException {
        FichePaie f = new FichePaie();
        f.setId(Long.parseLong(request.getParameter("id")));
        f.setEmployeId(Long.parseLong(request.getParameter("employeId")));
        f.setMois(request.getParameter("mois"));
        
        BigDecimal sb = new BigDecimal(request.getParameter("salaireBase"));
        BigDecimal hs = new BigDecimal(request.getParameter("heuresSup"));
        BigDecimal mhs = new BigDecimal(request.getParameter("montantHeuresSup"));
        BigDecimal p = new BigDecimal(request.getParameter("primes"));
        BigDecimal r = new BigDecimal(request.getParameter("retenues"));
        
        f.setSalaireBase(sb);
        f.setHeuresSup(hs);
        f.setMontantHeuresSup(mhs);
        f.setPrimes(p);
        f.setRetenues(r);
        
        BigDecimal brut = sb.add(mhs).add(p);
        BigDecimal net = brut.subtract(r);
        f.setSalaireBrut(brut);
        f.setSalaireNet(net);
        
        fichePaieDAO.update(f);
        response.sendRedirect(request.getContextPath() + "/fiches-paie");
    }

    private void deleteFiche(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        fichePaieDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/fiches-paie");
    }

    private void exportPdf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<FichePaie> list = fichePaieDAO.findAll();
        String[] headers = {"Employé", "Mois", "Salaire Base", "Primes", "Retenues", "Salaire Net"};
        List<String[]> data = new ArrayList<>();
        
        for (FichePaie f : list) {
            data.add(new String[]{
                f.getEmploye().getNom() + " " + f.getEmploye().getPrenom(),
                f.getMois(),
                f.getSalaireBase().toString() + " FCFA",
                f.getPrimes().toString() + " FCFA",
                f.getRetenues().toString() + " FCFA",
                f.getSalaireNet().toString() + " FCFA"
            });
        }
        
        PdfExportUtil.exportToPdf(response, "Registre des Fiches de Paie", headers, data, "fiches_paie.pdf");
    }
}
