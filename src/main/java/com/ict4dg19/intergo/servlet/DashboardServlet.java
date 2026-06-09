package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private EmployeDAO employeDAO;
    private CongeDAO congeDAO;
    private FichePaieDAO fichePaieDAO;

    @Override
    public void init() {
        employeDAO = new EmployeDAOImpl();
        congeDAO = new CongeDAOImpl();
        fichePaieDAO = new FichePaieDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int totalEmployes = employeDAO.countTotalEmployes();
        int congesAttente = congeDAO.countCongesEnAttente();
        BigDecimal masseSalariale = fichePaieDAO.sumMasseSalariale();

        request.setAttribute("totalEmployes", totalEmployes);
        request.setAttribute("congesAttente", congesAttente);
        request.setAttribute("masseSalariale", masseSalariale != null ? masseSalariale : BigDecimal.ZERO);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
