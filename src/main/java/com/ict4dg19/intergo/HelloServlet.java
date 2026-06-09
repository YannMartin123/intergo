package com.ict4dg19.intergo;

import java.io.*;

import jakarta.servlet.http.*;
// Pas d'import annotation — servlet déclaré dans web.xml (exigence projet)

// Mapping déclaré dans WEB-INF/web.xml : <url-pattern>/hello-servlet</url-pattern>
public class HelloServlet extends HttpServlet {
    private String message;

    public void init() {
        message = "Hello World!";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");

        // Hello
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>" + message + "</h1>");
        out.println("</body></html>");
    }

    public void destroy() {
    }
}