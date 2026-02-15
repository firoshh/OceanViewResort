package com.oceanview.data;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    // 1. GET ALL ROOM TYPES
    public List<String[]> getAllRoomTypes() {
        List<String[]> rooms = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try {
            String query = "SELECT type_id, type_name, price_per_night FROM room_types";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                rooms.add(new String[]{
                        String.valueOf(rs.getInt("type_id")),
                        rs.getString("type_name"),
                        String.valueOf(rs.getDouble("price_per_night"))
                });
            }
        } catch (Exception e) { e.printStackTrace(); }
        return rooms;
    }

    // 2. UPDATE ROOM (Edit Price/Name)
    public boolean updateRoomType(String id, String newName, String newPrice) {
        Connection conn = DBConnection.getConnection();
        try {
            String query = "UPDATE room_types SET type_name = ?, price_per_night = ? WHERE type_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, newName);
            stmt.setDouble(2, Double.parseDouble(newPrice));
            stmt.setInt(3, Integer.parseInt(id));
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 3. ADD NEW ROOM (NEW!)
    public boolean addRoomType(String name, String price) {
        Connection conn = DBConnection.getConnection();
        try {
            String query = "INSERT INTO room_types (type_name, price_per_night) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, name);
            stmt.setDouble(2, Double.parseDouble(price));
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 4. DELETE ROOM (NEW!)
    public boolean deleteRoomType(String id) {
        Connection conn = DBConnection.getConnection();
        try {
            String query = "DELETE FROM room_types WHERE type_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(id));
            return stmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 5. GET PRICE (Keep this for other pages to work)
    public double getPrice(int roomTypeId) {
        double price = 0.0;
        try {
            Connection conn = DBConnection.getConnection();
            String query = "SELECT price_per_night FROM room_types WHERE type_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, roomTypeId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) { price = rs.getDouble("price_per_night"); }
        } catch (SQLException e) { e.printStackTrace(); }
        return price;
    }
}