package com.oceanview.data;

import com.oceanview.models.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User authenticate(String username, String password) {
        User user = null;
        try {
            Connection conn = DBConnection.getConnection();
            // Checking database for the user
            String query = "SELECT * FROM users WHERE username = ? AND password_hash = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                // If found, create a User object
                user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("role")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}