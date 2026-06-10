package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.*;
import com.ict4dg19.intergo.model.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private EmployeDAO employeDAO;
    private CongeDAO congeDAO;
    private FichePaieDAO fichePaieDAO;
    private DepartementDAO departementDAO;

    @Override
    public void init() {
        employeDAO = new EmployeDAOImpl();
        congeDAO = new CongeDAOImpl();
        fichePaieDAO = new FichePaieDAOImpl();
        departementDAO = new DepartementDAOImpl();
        
        // Auto-seed if the database is empty (no employees)
        if (employeDAO.countTotalEmployes() == 0) {
            com.ict4dg19.intergo.util.DatabaseSeeder.seed();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Determine user roles
        List<Role> roles = user.getRoles();
        boolean isAdmin = false;
        boolean isRh = false;
        boolean isManager = false;
        boolean isEmployee = false;
        if (roles != null) {
            for (Role r : roles) {
                if ("ADMIN".equals(r.getNom())) isAdmin = true;
                if ("RH".equals(r.getNom())) isRh = true;
                if ("MANAGER".equals(r.getNom())) isManager = true;
                if ("EMPLOYE".equals(r.getNom())) isEmployee = true;
            }
        }

        // Fetch master lists
        List<Employe> allEmployes = employeDAO.findAll();
        List<Conge> allConges = congeDAO.findAll();
        List<FichePaie> allFiches = fichePaieDAO.findAll();
        List<Departement> allDepts = departementDAO.findAll();

        // Get context details
        Employe currentEmp = (user.getEmployeId() != null) ? employeDAO.findById(user.getEmployeId()) : null;
        Long currentDeptId = (currentEmp != null) ? currentEmp.getDepartementId() : null;

        // Filter data lists based on roles
        List<Employe> filteredEmployes = new ArrayList<>();
        List<Conge> filteredConges = new ArrayList<>();
        List<FichePaie> filteredFiches = new ArrayList<>();

        if (isAdmin || isRh) {
            // Full access to everything
            filteredEmployes.addAll(allEmployes);
            filteredConges.addAll(allConges);
            filteredFiches.addAll(allFiches);
        } else if (isManager) {
            // Managers see employees and leaves in their department, plus their own payslips
            filteredEmployes = allEmployes.stream()
                    .filter(e -> e.getDepartementId() != null && e.getDepartementId().equals(currentDeptId))
                    .collect(Collectors.toList());
            filteredConges = allConges.stream()
                    .filter(c -> c.getEmploye() != null && c.getEmploye().getDepartementId() != null && c.getEmploye().getDepartementId().equals(currentDeptId))
                    .collect(Collectors.toList());
            filteredFiches = allFiches.stream()
                    .filter(f -> f.getEmployeId() != null && f.getEmployeId().equals(user.getEmployeId()))
                    .collect(Collectors.toList());
        } else {
            // Regular employees see only their own data
            filteredEmployes = allEmployes.stream()
                    .filter(e -> e.getId().equals(user.getEmployeId()))
                    .collect(Collectors.toList());
            filteredConges = allConges.stream()
                    .filter(c -> c.getEmployeId().equals(user.getEmployeId()))
                    .collect(Collectors.toList());
            filteredFiches = allFiches.stream()
                    .filter(f -> f.getEmployeId() != null && f.getEmployeId().equals(user.getEmployeId()))
                    .collect(Collectors.toList());
        }

        // Compute summary KPIs
        int totalEmployes = filteredEmployes.size();
        long congesAttente = filteredConges.stream()
                .filter(c -> "DEMANDE".equals(c.getStatut()))
                .count();
        BigDecimal masseSalariale = filteredFiches.stream()
                .map(FichePaie::getSalaireNet)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        double avgSalary = filteredEmployes.stream()
                .filter(e -> e.getSalaireBase() != null)
                .mapToDouble(e -> e.getSalaireBase().doubleValue())
                .average()
                .orElse(0.0);

        // Representation 1: Employee Hire Growth (by month YYYY-MM)
        Map<String, Long> hireHistory = filteredEmployes.stream()
                .filter(e -> e.getDateEmbauche() != null)
                .collect(Collectors.groupingBy(e -> {
                    return e.getDateEmbauche().getYear() + "-" + String.format("%02d", e.getDateEmbauche().getMonthValue());
                }, TreeMap::new, Collectors.counting()));

        // Representation 2: Department Distribution (Employee counts)
        Map<String, Long> deptCounts = filteredEmployes.stream()
                .filter(e -> e.getDepartement() != null && e.getDepartement().getNom() != null)
                .collect(Collectors.groupingBy(e -> e.getDepartement().getNom(), Collectors.counting()));

        // Representation 3: Contract Type Distribution
        Map<String, Long> contractCounts = filteredEmployes.stream()
                .filter(e -> e.getTypeContrat() != null)
                .collect(Collectors.groupingBy(Employe::getTypeContrat, Collectors.counting()));

        // Representation 4: Leave Status Distribution
        Map<String, Long> congeCounts = filteredConges.stream()
                .filter(c -> c.getStatut() != null)
                .collect(Collectors.groupingBy(c -> c.getStatut(), Collectors.counting()));

        // Representation 5: Salary Distribution Groups
        Map<String, Long> salaryDist = new LinkedHashMap<>();
        salaryDist.put("< 2000 FCFA", filteredEmployes.stream().filter(e -> e.getSalaireBase() != null && e.getSalaireBase().doubleValue() < 2000).count());
        salaryDist.put("2000 FCFA - 4000 FCFA", filteredEmployes.stream().filter(e -> e.getSalaireBase() != null && e.getSalaireBase().doubleValue() >= 2000 && e.getSalaireBase().doubleValue() < 4000).count());
        salaryDist.put("4000 FCFA - 6000 FCFA", filteredEmployes.stream().filter(e -> e.getSalaireBase() != null && e.getSalaireBase().doubleValue() >= 4000 && e.getSalaireBase().doubleValue() < 6000).count());
        salaryDist.put("> 6000 FCFA", filteredEmployes.stream().filter(e -> e.getSalaireBase() != null && e.getSalaireBase().doubleValue() >= 6000).count());

        // Representation 6 (NEW): Budget vs Actual Salary Spend by Department
        Map<String, Map<String, Double>> budgetVsActual = new LinkedHashMap<>();
        List<Departement> targetDepts = (isAdmin || isRh) ? allDepts : allDepts.stream()
                .filter(d -> d.getId().equals(currentDeptId))
                .collect(Collectors.toList());

        for (Departement d : targetDepts) {
            double allocated = d.getBudgetMasseSalariale() != null ? d.getBudgetMasseSalariale().doubleValue() : 0.0;
            double spent = allEmployes.stream()
                    .filter(e -> e.getDepartementId() != null && e.getDepartementId().equals(d.getId()) && e.getSalaireBase() != null)
                    .mapToDouble(e -> e.getSalaireBase().doubleValue())
                    .sum();
            Map<String, Double> val = new HashMap<>();
            val.put("allocated", allocated);
            val.put("spent", spent);
            budgetVsActual.put(d.getNom(), val);
        }

        // Representation 7 (NEW): Leave Requests by Type
        Map<String, Long> congeTypeCounts = filteredConges.stream()
                .filter(c -> c.getTypeConge() != null)
                .collect(Collectors.groupingBy(Conge::getTypeConge, Collectors.counting()));

        // Representation 8 (NEW): Remuneration Structure Breakdown
        Map<String, Double> salaryStructure = new LinkedHashMap<>();
        double totalBase = filteredFiches.stream().mapToDouble(f -> f.getSalaireBase() != null ? f.getSalaireBase().doubleValue() : 0.0).sum();
        double totalOT = filteredFiches.stream().mapToDouble(f -> f.getMontantHeuresSup() != null ? f.getMontantHeuresSup().doubleValue() : 0.0).sum();
        double totalPrimes = filteredFiches.stream().mapToDouble(f -> f.getPrimes() != null ? f.getPrimes().doubleValue() : 0.0).sum();
        double totalRetenues = filteredFiches.stream().mapToDouble(f -> f.getRetenues() != null ? f.getRetenues().doubleValue() : 0.0).sum();
        double totalNet = filteredFiches.stream().mapToDouble(f -> f.getSalaireNet() != null ? f.getSalaireNet().doubleValue() : 0.0).sum();
        salaryStructure.put("Salaire de Base", totalBase);
        salaryStructure.put("Heures Sup", totalOT);
        salaryStructure.put("Primes / Bonus", totalPrimes);
        salaryStructure.put("Retenues / Taxes", totalRetenues);
        salaryStructure.put("Salaire Net", totalNet);

        // Serialize all data feeds to JSON
        ObjectMapper mapper = new ObjectMapper();
        String hireJson = mapper.writeValueAsString(hireHistory);
        String deptJson = mapper.writeValueAsString(deptCounts);
        String contractJson = mapper.writeValueAsString(contractCounts);
        String congeJson = mapper.writeValueAsString(congeCounts);
        String salaryJson = mapper.writeValueAsString(salaryDist);
        String budgetVsActualJson = mapper.writeValueAsString(budgetVsActual);
        String congeTypeJson = mapper.writeValueAsString(congeTypeCounts);
        String structureJson = mapper.writeValueAsString(salaryStructure);

        // Inject attributes into JSP scope
        request.setAttribute("totalEmployes", totalEmployes);
        request.setAttribute("congesAttente", congesAttente);
        request.setAttribute("masseSalariale", masseSalariale);
        request.setAttribute("avgSalary", Math.round(avgSalary * 100.0) / 100.0);
        
        request.setAttribute("hireJson", hireJson);
        request.setAttribute("deptJson", deptJson);
        request.setAttribute("contractJson", contractJson);
        request.setAttribute("congeJson", congeJson);
        request.setAttribute("salaryJson", salaryJson);
        request.setAttribute("budgetVsActualJson", budgetVsActualJson);
        request.setAttribute("congeTypeJson", congeTypeJson);
        request.setAttribute("structureJson", structureJson);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
