package com.ict4dg19.intergo.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.Statement;

public class DatabaseSeeder {
    
    public static void seed() {
        String sqlFile = "d:/318/intergo/database.sql";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             BufferedReader br = new BufferedReader(new FileReader(sqlFile))) {
             
            // Disable foreign key checks temporarily to make drops/creates robust
            stmt.execute("SET FOREIGN_KEY_CHECKS = 0;");
            
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                // Skip comments and empty lines
                String trimmed = line.trim();
                if (trimmed.startsWith("--") || trimmed.isEmpty()) {
                    continue;
                }
                sb.append(line).append("\n");
                if (trimmed.endsWith(";")) {
                    String sql = sb.toString().trim();
                    // Remove trailing semicolon
                    sql = sql.substring(0, sql.length() - 1);
                    try {
                        stmt.execute(sql);
                    } catch (Exception e) {
                        System.err.println("Error executing SQL: " + sql + " -> " + e.getMessage());
                    }
                    sb = new StringBuilder();
                }
            }
            
            // Re-enable foreign key checks
            stmt.execute("SET FOREIGN_KEY_CHECKS = 1;");
            
            System.out.println("Database reset and seeded successfully from " + sqlFile);
        } catch (Exception e) {
            System.err.println("Seeding failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
