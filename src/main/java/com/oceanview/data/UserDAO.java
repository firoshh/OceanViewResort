package com.oceanview.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // --- 1. LOGIN AUTHENTICATION ---
    public String authenticate(String inputUser, String inputPass) {
        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try {
            // We select everything so we can handle different column names
            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, inputUser);
            stmt.setString(2, inputPass);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getString("role"); // Returns "Admin" or "Staff"
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- 2. GET ALL USERS (Fixed to find ID column) ---
    public List<String[]> getAllUsers() {
        List<String[]> users = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        if (conn == null) {
            System.out.println("❌ ERROR: Database connection is NULL in getAllUsers");
            return users;
        }

        try {
            String query = "SELECT * FROM users";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                // --- SMART ID FINDER ---
                // Tries to get 'user_id'. If that fails, it grabs 'id'.
                String id;
                try {
                    id = rs.getString("user_id");
                } catch (SQLException e) {
                    id = rs.getString("id");
                }

                users.add(new String[]{
                        id,                         // Index 0: ID
                        rs.getString("username"),   // Index 1: Username
                        rs.getString("role")        // Index 2: Role
                });
            }
        } catch (Exception e) {
            System.out.println("❌ ERROR in getAllUsers: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    // --- 3. ADD NEW STAFF ---
    public boolean addUser(String username, String password, String role) {
        Connection conn = DBConnection.getConnection();
        try {
            // NOTE: If your column is 'id' (auto-increment), we don't need to insert it.
            String query = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.setString(3, role);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("❌ ERROR adding user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // --- 4. DELETE STAFF ---
    public boolean deleteUser(String userId) {
        Connection conn = DBConnection.getConnection();
        try {
            // Try 'user_id' first, if it fails, try 'id'
            String query = "DELETE FROM users WHERE user_id = ?";
            try {
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setString(1, userId);
                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                // Fallback to 'id'
                query = "DELETE FROM users WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setString(1, userId);
                return stmt.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}