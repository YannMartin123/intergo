package com.ict4dg19.intergo.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.util.Properties;

/**
 * Email utility using Gmail SMTP (replaces SendGrid which had exhausted credits).
 * Reads GMAIL_USER and GMAIL_APP_PASSWORD from config.properties or environment variables.
 */
public class SendGridEmailUtil {

    private static final String GMAIL_HOST = "smtp.gmail.com";
    private static final int    GMAIL_PORT = 587;

    private static String GMAIL_USER;
    private static String GMAIL_APP_PASSWORD;

    static {
        // 1. Try environment variables first
        GMAIL_USER         = System.getenv("GMAIL_USER");
        GMAIL_APP_PASSWORD = System.getenv("GMAIL_APP_PASSWORD");

        // 2. Fall back to config.properties
        if (isEmpty(GMAIL_USER) || isEmpty(GMAIL_APP_PASSWORD)) {
            java.util.Properties props = new java.util.Properties();
            String[] paths = {
                "d:/318/intergo/config.properties",
                "config.properties",
                System.getProperty("user.dir") + "/config.properties"
            };
            for (String path : paths) {
                try (java.io.FileInputStream fis = new java.io.FileInputStream(path)) {
                    props.load(fis);
                    if (isEmpty(GMAIL_USER))         GMAIL_USER         = props.getProperty("GMAIL_USER");
                    if (isEmpty(GMAIL_APP_PASSWORD)) GMAIL_APP_PASSWORD = props.getProperty("GMAIL_APP_PASSWORD");
                    if (!isEmpty(GMAIL_USER) && !isEmpty(GMAIL_APP_PASSWORD)) {
                        System.out.println("[EmailUtil] Config loaded from: " + path);
                        break;
                    }
                } catch (Exception ignored) {}
            }
        }

        if (isEmpty(GMAIL_USER)) {
            GMAIL_USER = "maxymtene40@gmail.com";
            System.err.println("[EmailUtil] WARNING: GMAIL_USER not configured. Using default.");
        }
        if (isEmpty(GMAIL_APP_PASSWORD)) {
            System.err.println("[EmailUtil] WARNING: GMAIL_APP_PASSWORD not configured. Emails will fail.");
        }
    }

    private static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * Sends an HTML email asynchronously via Gmail SMTP.
     *
     * @param toEmail     Recipient address
     * @param subject     Email subject
     * @param htmlContent HTML body content
     */
    public static void sendEmail(String toEmail, String subject, String htmlContent) {
        if (isEmpty(GMAIL_APP_PASSWORD)) {
            System.err.println("[EmailUtil] Skipping email to " + toEmail + " — GMAIL_APP_PASSWORD not set.");
            return;
        }

        new Thread(() -> {
            try {
                Properties mailProps = new Properties();
                mailProps.put("mail.smtp.auth",            "true");
                mailProps.put("mail.smtp.starttls.enable", "true");
                mailProps.put("mail.smtp.host",            GMAIL_HOST);
                mailProps.put("mail.smtp.port",            String.valueOf(GMAIL_PORT));
                mailProps.put("mail.smtp.ssl.trust",       GMAIL_HOST);

                final String user = GMAIL_USER;
                final String pass = GMAIL_APP_PASSWORD;

                Session session = Session.getInstance(mailProps, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(user, pass);
                    }
                });

                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(GMAIL_USER, "InterGo RH"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject(subject);

                // Build multipart: plain text fallback + HTML
                MimeBodyPart htmlPart = new MimeBodyPart();
                htmlPart.setContent(htmlContent, "text/html; charset=UTF-8");

                Multipart multipart = new MimeMultipart("alternative");
                multipart.addBodyPart(htmlPart);
                message.setContent(multipart);

                Transport.send(message);
                System.out.println("[EmailUtil] Email sent successfully to " + toEmail);

            } catch (Exception e) {
                System.err.println("[EmailUtil] Failed to send email to " + toEmail + ": " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }
}
