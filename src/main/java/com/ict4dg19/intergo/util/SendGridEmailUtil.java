package com.ict4dg19.intergo.util;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class SendGridEmailUtil {
    private static String API_KEY;
    private static String FROM_EMAIL;

    static {
        // 1. Try environment variables
        API_KEY = System.getenv("SENDGRID_API_KEY");
        FROM_EMAIL = System.getenv("SENDGRID_FROM");

        // 2. Try properties file in project root or custom absolute path
        if (API_KEY == null || API_KEY.isEmpty() || FROM_EMAIL == null || FROM_EMAIL.isEmpty()) {
            java.util.Properties props = new java.util.Properties();
            String[] configPaths = {
                "config.properties",
                "d:/318/intergo/config.properties",
                System.getProperty("user.dir") + "/config.properties"
            };
            for (String path : configPaths) {
                try (java.io.FileInputStream fis = new java.io.FileInputStream(path)) {
                    props.load(fis);
                    if (API_KEY == null || API_KEY.isEmpty()) {
                        API_KEY = props.getProperty("SENDGRID_API_KEY");
                    }
                    if (FROM_EMAIL == null || FROM_EMAIL.isEmpty()) {
                        FROM_EMAIL = props.getProperty("SENDGRID_FROM");
                    }
                    if (API_KEY != null && !API_KEY.isEmpty()) {
                        break;
                    }
                } catch (Exception e) {
                    // Ignore, try next path
                }
            }
        }

        // Fallbacks if not set
        if (FROM_EMAIL == null || FROM_EMAIL.isEmpty()) {
            FROM_EMAIL = "info@goglobalscm.com";
        }
    }

    public static void sendEmail(String toEmail, String subject, String htmlContent) {
        new Thread(() -> {
            try {
                String jsonBody = "{"
                        + "\"personalizations\":[{\"to\":[{\"email\":\"" + toEmail + "\"}]}],"
                        + "\"from\":{\"email\":\"" + FROM_EMAIL + "\",\"name\":\"InterGo HR\"},"
                        + "\"subject\":\"" + escapeJson(subject) + "\","
                        + "\"content\":[{\"type\":\"text/html\",\"value\":\"" + escapeJson(htmlContent) + "\"}]"
                        + "}";

                HttpClient client = HttpClient.newHttpClient();
                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create("https://api.sendgrid.com/v3/mail/send"))
                        .header("Authorization", "Bearer " + API_KEY)
                        .header("Content-Type", "application/json")
                        .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                        .build();

                HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
                if (response.statusCode() >= 200 && response.statusCode() < 300) {
                    System.out.println("Email sent successfully to " + toEmail);
                } else {
                    System.err.println("Failed to send email via SendGrid. Status code: " + response.statusCode() + ", Body: " + response.body());
                }
            } catch (Exception e) {
                System.err.println("Error sending email via SendGrid: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
