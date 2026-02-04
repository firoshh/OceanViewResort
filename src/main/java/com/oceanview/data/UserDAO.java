package com.oceanview.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public boolean validateUser(String inputUser, String inputPass) {
        Connection conn = DBConnection.getConnection();

        // DEBUG: Print what the user typed
        System.out.println("--- LOGIN ATTEMPT ---");
        System.out.println("Trying to login with: " + inputUser + " / " + inputPass);

        if (conn == null) {
            System.out.println("❌ ERROR: Database Connection is NULL. Check DBConnection.java");
            return false;
        }

        try {
            // Check if column names match your DB!
            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, inputUser);
            stmt.setString(2, inputPass);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                System.out.println("✅ SUCCESS: User found in database!");
                return true;
            } else {
                System.out.println("❌ FAILED: Query ran, but no match found.");
                System.out.println("Double check table 'users' has this exact username/password.");
                return false;
            }

        } catch (Exception e) {
            System.out.println("❌ EXCEPTION: Something broke during the query.");
            e.printStackTrace();
            return false;
        }
    }
}