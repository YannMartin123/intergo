package com.ict4dg19.intergo.util;

import com.ict4dg19.intergo.model.Role;
import com.ict4dg19.intergo.model.Utilisateur;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class SecurityFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String path = request.getServletPath();

        // 1. Exclude public paths
        if (path.equals("/login") || path.equals("/register") || path.equals("/") || path.equals("/index.jsp")
                || path.startsWith("/css") || path.startsWith("/images") || path.startsWith("/js") || path.startsWith("/favicon.ico")) {
            chain.doFilter(req, res);
            return;
        }

        // 2. Check Authentication
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 3. Extract Roles
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

        // 4. Role-Based Access Control (RBAC)
        // Admin has full access to everything
        if (isAdmin) {
            chain.doFilter(req, res);
            return;
        }

        // Departements: Admin and RH only
        if (path.startsWith("/departements")) {
            if (!isRh) {
                response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                return;
            }
        }

        // Contrats: Admin and RH only
        if (path.startsWith("/contrats")) {
            if (!isRh) {
                response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                return;
            }
        }

        // Employes creation / edit / delete: Admin and RH only (except viewing list or editing own profile)
        if (path.startsWith("/employes")) {
            if (path.equals("/employes/new") || path.equals("/employes/insert") || path.equals("/employes/delete") || path.equals("/employes/update")) {
                if (!isRh) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                    return;
                }
            }
            if (path.equals("/employes/edit")) {
                // Non-RH/Admin can only edit their own profile
                if (!isRh) {
                    String paramId = request.getParameter("id");
                    if (paramId != null) {
                        try {
                            long id = Long.parseLong(paramId);
                            if (user.getEmployeId() == null || user.getEmployeId() != id) {
                                response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                                return;
                            }
                        } catch (NumberFormatException e) {
                            response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                            return;
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                        return;
                    }
                }
            }
            if (path.equals("/employes") || path.equals("/employes/")) {
                // Employees cannot view the list of all employees (redirect to their own details)
                if (isEmployee && !isRh && !isManager) {
                    if (user.getEmployeId() != null) {
                        response.sendRedirect(request.getContextPath() + "/employes/edit?id=" + user.getEmployeId());
                    } else {
                        response.sendRedirect(request.getContextPath() + "/dashboard?erreur=NoProfile");
                    }
                    return;
                }
            }
        }

        // Fiches de paie creation / edit / delete: Admin and RH only
        if (path.startsWith("/fiches-paie")) {
            if (path.equals("/fiches-paie/new") || path.equals("/fiches-paie/insert") || path.equals("/fiches-paie/delete") || path.equals("/fiches-paie/edit") || path.equals("/fiches-paie/update")) {
                if (!isRh) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                    return;
                }
            }
        }

        // Conges approval: Admin, RH, and Manager only
        if (path.equals("/conges/approve")) {
            if (!isRh && !isManager) {
                response.sendRedirect(request.getContextPath() + "/dashboard?erreur=AccessDeny");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
