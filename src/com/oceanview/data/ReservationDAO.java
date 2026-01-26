package com.oceanview.data;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // --- METHOD 1: ADD RESERVATION (You already have this) ---
    public boolean addReservation(String name, String address, String contact, int roomTypeId, String checkIn, String checkOut) {
        Connection conn = DBConnection.getConnection();
        try {
            // Calculate Bill
            RoomDAO roomDao = new RoomDAO();
            double pricePerNight = roomDao.getPrice(roomTypeId);

            java.time.LocalDate date1 = java.time.LocalDate.parse(checkIn);
            java.time.LocalDate date2 = java.time.LocalDate.parse(checkOut);
            long days = java.time.temporal.ChronoUnit.DAYS.between(date1, date2);
            double totalCost = days * pricePerNight;

            // Insert Guest
            String insertGuest = "INSERT INTO guests (full_name, address, contact_number) VALUES (?, ?, ?)";
            PreparedStatement guestStmt = conn.prepareStatement(insertGuest, Statement.RETURN_GENERATED_KEYS);
            guestStmt.setString(1, name);
            guestStmt.setString(2, address);
            guestStmt.setString(3, contact);
            guestStmt.executeUpdate();

            ResultSet rs = guestStmt.getGeneratedKeys();
            int guestId = 0;
            if (rs.next()) guestId = rs.getInt(1);

            // Insert Reservation
            String insertRes = "INSERT INTO reservations (guest_id, room_type_id, check_in_date, check_out_date, total_cost, status) VALUES (?, ?, ?, ?, ?, 'Confirmed')";
            PreparedStatement resStmt = conn.prepareStatement(insertRes);
            resStmt.setInt(1, guestId);
            resStmt.setInt(2, roomTypeId);
            resStmt.setString(3, checkIn);
            resStmt.setString(4, checkOut);
            resStmt.setDouble(5, totalCost);

            return resStmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- METHOD 2: GET ALL RESERVATIONS (This is the new part!) ---
    public List<String[]> getAllReservations() {
        List<String[]> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try {
            // Join tables to get Guest Name instead of just Guest ID
            String query = "SELECT r.reservation_id, g.full_name, r.check_in_date, r.check_out_date, r.total_cost, r.status " +
                    "FROM reservations r " +
                    "JOIN guests g ON r.guest_id = g.guest_id";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                String[] row = {
                        String.valueOf(rs.getInt("reservation_id")),
                        rs.getString("full_name"),
                        rs.getString("check_in_date"),
                        rs.getString("check_out_date"),
                        String.valueOf(rs.getDouble("total_cost")),
                        rs.getString("status")
                };
                list.add(row);
            }
        } catch (Exception e) {
            System.out.println("CRITICAL ERROR: " + e.getMessage()); // Print error to console
            e.printStackTrace();
        }
        return list;
    }

} // End of Class