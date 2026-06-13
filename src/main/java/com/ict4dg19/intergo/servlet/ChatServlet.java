package com.ict4dg19.intergo.servlet;

import com.ict4dg19.intergo.dao.EmployeDAO;
import com.ict4dg19.intergo.dao.EmployeDAOImpl;
import com.ict4dg19.intergo.model.Employe;
import com.ict4dg19.intergo.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {
    private EmployeDAO employeDAO;

    @Override
    public void init() {
        employeDAO = new EmployeDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Employe> listEmployes = employeDAO.findAll();
        request.setAttribute("listEmployes", listEmployes);
        request.getRequestDispatcher("/chat.jsp").forward(request, response);
    }
}
