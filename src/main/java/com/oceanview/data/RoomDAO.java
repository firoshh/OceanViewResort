package com.oceanview.data;

import java.sql.*;

public class RoomDAO {
    // This gets the price for a specific room type (e.g., Single = 5000)
    public double getPrice(int roomTypeId) {
        double price = 0.0;
        try {
            Connection conn = DBConnection.getConnection();
            String query = "SELECT price_per_night FROM room_types WHERE type_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, roomTypeId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                price = rs.getDouble("price_per_night");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return price;
    }
}