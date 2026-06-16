package com.ict4dg19.intergo.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ict4dg19.intergo.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet("/chat/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB max file size
    maxRequestSize = 1024 * 1024 * 10    // 10MB max request size
)
public class ChatUploadServlet extends HttpServlet {

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("pdf", "png", "jpg", "jpeg", "docx", "xlsx", "pptx", "txt", "webm", "wav", "mp3", "ogg", "m4a");
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private ObjectMapper mapper;

    @Override
    public void init() {
        mapper = new ObjectMapper();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        HttpSession session = request.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateurConnecte") : null;
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        try {
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Aucun fichier envoyé\"}");
                return;
            }

            // 1. Validation de la taille
            if (filePart.getSize() > MAX_FILE_SIZE) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Fichier trop volumineux. Taille max : 5 Mo.\"}");
                return;
            }

            // 2. Récupération et validation du nom / de l'extension
            String submittedFileName = filePart.getSubmittedFileName();
            if (submittedFileName == null || !submittedFileName.contains(".")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Nom de fichier invalide\"}");
                return;
            }

            String extension = submittedFileName.substring(submittedFileName.lastIndexOf(".") + 1).toLowerCase();
            if (!ALLOWED_EXTENSIONS.contains(extension)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Type de fichier non autorisé. Formats acceptés : PDF, PNG, JPG, JPEG, DOCX, XLSX, PPTX, TXT et Audio (WEBM, WAV, MP3, OGG, M4A)\"}");
                return;
            }

            // 3. Détermination des dossiers de sauvegarde
            String uniqueFileName = UUID.randomUUID().toString() + "_" + submittedFileName;
            
            // Dossier de déploiement Tomcat
            String deployPath = request.getServletContext().getRealPath("/uploads/chat");
            File deployDir = new File(deployPath);
            if (!deployDir.exists()) {
                deployDir.mkdirs();
            }
            File deployFile = new File(deployDir, uniqueFileName);

            // Sauvegarde dans le dossier temporaire du serveur
            filePart.write(deployFile.getAbsolutePath());

            // Dossier source pour la persistance Git (optionnel)
            String sourcePath = "D:/318/intergo/src/main/webapp/uploads/chat";
            File sourceDir = new File(sourcePath);
            if (sourceDir.exists() || sourceDir.mkdirs()) {
                File sourceFile = new File(sourceDir, uniqueFileName);
                Files.copy(deployFile.toPath(), sourceFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // 4. Réponse JSON
            String fileUrl = request.getContextPath() + "/uploads/chat/" + uniqueFileName;
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(mapper.writeValueAsString(Map.of(
                "url", fileUrl,
                "fileName", submittedFileName,
                "fileType", filePart.getContentType()
            )));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Erreur lors du téléversement : " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
