package com.ict4dg19.intergo.util;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Properties;

/**
 * Utility class to send SMS notifications.
 * Supports multiple backends: MOCK (local simulation), TEXTBELT (free API),
 * FREE_MOBILE (for French subscribers), and TWILIO.
 */
public class SMSUtil {

    private static String SMS_PROVIDER = "MOCK";
    private static String TEXTBELT_API_KEY = "free";
    private static String FREE_MOBILE_USER;
    private static String FREE_MOBILE_PASS;
    private static String TWILIO_ACCOUNT_SID;
    private static String TWILIO_AUTH_TOKEN;
    private static String TWILIO_FROM_NUMBER;

    static {
        // 1. Try environment variables first
        SMS_PROVIDER        = System.getenv("SMS_PROVIDER");
        TEXTBELT_API_KEY    = System.getenv("TEXTBELT_API_KEY");
        FREE_MOBILE_USER    = System.getenv("FREE_MOBILE_USER");
        FREE_MOBILE_PASS    = System.getenv("FREE_MOBILE_PASS");
        TWILIO_ACCOUNT_SID  = System.getenv("TWILIO_ACCOUNT_SID");
        TWILIO_AUTH_TOKEN   = System.getenv("TWILIO_AUTH_TOKEN");
        TWILIO_FROM_NUMBER  = System.getenv("TWILIO_FROM_NUMBER");

        // 2. Fall back to config.properties
        Properties props = new Properties();
        String[] paths = {
            "d:/318/intergo/config.properties",
            "config.properties",
            System.getProperty("user.dir") + "/config.properties"
        };
        for (String path : paths) {
            try (java.io.FileInputStream fis = new java.io.FileInputStream(path)) {
                props.load(fis);
                if (isEmpty(SMS_PROVIDER))       SMS_PROVIDER       = props.getProperty("SMS_PROVIDER");
                if (isEmpty(TEXTBELT_API_KEY))   TEXTBELT_API_KEY   = props.getProperty("TEXTBELT_API_KEY");
                if (isEmpty(FREE_MOBILE_USER))   FREE_MOBILE_USER   = props.getProperty("FREE_MOBILE_USER");
                if (isEmpty(FREE_MOBILE_PASS))   FREE_MOBILE_PASS   = props.getProperty("FREE_MOBILE_PASS");
                if (isEmpty(TWILIO_ACCOUNT_SID)) TWILIO_ACCOUNT_SID = props.getProperty("TWILIO_ACCOUNT_SID");
                if (isEmpty(TWILIO_AUTH_TOKEN))  TWILIO_AUTH_TOKEN  = props.getProperty("TWILIO_AUTH_TOKEN");
                if (isEmpty(TWILIO_FROM_NUMBER)) TWILIO_FROM_NUMBER = props.getProperty("TWILIO_FROM_NUMBER");
                if (!isEmpty(SMS_PROVIDER)) {
                    System.out.println("[SMSUtil] Config loaded from: " + path);
                    break;
                }
            } catch (Exception ignored) {}
        }

        // Set defaults if empty
        if (isEmpty(SMS_PROVIDER)) {
            SMS_PROVIDER = "MOCK";
        }
        if (isEmpty(TEXTBELT_API_KEY)) {
            TEXTBELT_API_KEY = "free";
        }
        
        System.out.println("[SMSUtil] Active SMS provider: " + SMS_PROVIDER);
    }

    private static boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * Sends an SMS asynchronously in a background thread.
     *
     * @param toPhone Recipient phone number (ideally with country code, e.g. +33612345678)
     * @param message Text message body
     */
    public static void sendSMS(String toPhone, String message) {
        if (isEmpty(toPhone)) {
            System.err.println("[SMSUtil] Skipped SMS: phone number is empty.");
            return;
        }
        if (isEmpty(message)) {
            System.err.println("[SMSUtil] Skipped SMS: message is empty.");
            return;
        }

        // Clean phone number: remove spaces, hyphens, and parentheses
        final String cleanedPhone = toPhone.replaceAll("[\\s\\-\\(\\)]", "");

        new Thread(() -> {
            try {
                switch (SMS_PROVIDER.toUpperCase()) {
                    case "TEXTBELT":
                        sendViaTextbelt(cleanedPhone, message);
                        break;
                    case "FREE_MOBILE":
                        sendViaFreeMobile(cleanedPhone, message);
                        break;
                    case "TWILIO":
                        sendViaTwilio(cleanedPhone, message);
                        break;
                    case "MOCK":
                    default:
                        sendMock(cleanedPhone, message);
                        break;
                }
            } catch (Exception e) {
                System.err.println("[SMSUtil] Error sending SMS to " + cleanedPhone + ": " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    private static void sendMock(String phone, String message) {
        System.out.println("\n==================================================");
        System.out.println("[SMS SIMULATOR - MODE GRATUIT]");
        System.out.println("Destinataire : " + phone);
        System.out.println("Message      : " + message);
        System.out.println("==================================================\n");
    }

    private static void sendViaTextbelt(String phone, String message) throws Exception {
        System.out.println("[SMSUtil] Sending via Textbelt to " + phone);
        try {
            HttpClient client = HttpClient.newHttpClient();
            String requestBody = "phone=" + URLEncoder.encode(phone, StandardCharsets.UTF_8) +
                                 "&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8) +
                                 "&key=" + URLEncoder.encode(TEXTBELT_API_KEY, StandardCharsets.UTF_8);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://textbelt.com/text"))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            String responseBody = response.body();
            System.out.println("[SMSUtil] Textbelt Response (" + response.statusCode() + "): " + responseBody);

            if (responseBody == null || (!responseBody.contains("\"success\":true") && !responseBody.contains("\"success\": true"))) {
                System.out.println("[SMSUtil] Textbelt API error or limit reached. Falling back to MOCK (Option 1).");
                sendMock(phone, message);
            }
        } catch (Exception e) {
            System.err.println("[SMSUtil] Textbelt request failed (" + e.getMessage() + "). Falling back to MOCK (Option 1).");
            sendMock(phone, message);
        }
    }

    private static void sendViaFreeMobile(String phone, String message) throws Exception {
        if (isEmpty(FREE_MOBILE_USER) || isEmpty(FREE_MOBILE_PASS)) {
            System.err.println("[SMSUtil] Free Mobile user/pass not configured. Falling back to MOCK.");
            sendMock(phone, message);
            return;
        }
        System.out.println("[SMSUtil] Sending via Free Mobile to " + phone);
        HttpClient client = HttpClient.newHttpClient();
        String url = "https://smsapi.free-mobile.fr/sendmsg?user=" + FREE_MOBILE_USER +
                     "&pass=" + FREE_MOBILE_PASS +
                     "&msg=" + URLEncoder.encode(message, StandardCharsets.UTF_8);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println("[SMSUtil] Free Mobile Response status: " + response.statusCode());
    }

    private static void sendViaTwilio(String phone, String message) throws Exception {
        if (isEmpty(TWILIO_ACCOUNT_SID) || isEmpty(TWILIO_AUTH_TOKEN) || isEmpty(TWILIO_FROM_NUMBER)) {
            System.err.println("[SMSUtil] Twilio credentials not configured. Falling back to MOCK.");
            sendMock(phone, message);
            return;
        }
        System.out.println("[SMSUtil] Sending via Twilio to " + phone);
        HttpClient client = HttpClient.newHttpClient();
        String requestBody = "To=" + URLEncoder.encode(phone, StandardCharsets.UTF_8) +
                             "&From=" + URLEncoder.encode(TWILIO_FROM_NUMBER, StandardCharsets.UTF_8) +
                             "&Body=" + URLEncoder.encode(message, StandardCharsets.UTF_8);

        String auth = TWILIO_ACCOUNT_SID + ":" + TWILIO_AUTH_TOKEN;
        String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://api.twilio.com/2010-04-01/Accounts/" + TWILIO_ACCOUNT_SID + "/Messages.json"))
                .header("Authorization", "Basic " + encodedAuth)
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println("[SMSUtil] Twilio Response (" + response.statusCode() + "): " + response.body());
    }
}
