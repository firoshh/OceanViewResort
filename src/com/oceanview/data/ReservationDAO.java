package com.oceanview.data;

import java.sql.*;

public class ReservationDAO {

    public boolean addReservation(String name, String address, String contact, int roomTypeId, String checkIn, String checkOut) {
        Connection conn = DBConnection.getConnection();
        try {
            // 1. Insert Guest First
            String insertGuest = "INSERT INTO guests (full_name, address, contact_number) VALUES (?, ?, ?)";
            // We need the generated ID of the new guest
            PreparedStatement guestStmt = conn.prepareStatement(insertGuest, Statement.RETURN_GENERATED_KEYS);
            guestStmt.setString(1, name);
            guestStmt.setString(2, address);
            guestStmt.setString(3, contact);
            guestStmt.executeUpdate();

            // Get the Guest ID
            ResultSet rs = guestStmt.getGeneratedKeys();
            int guestId = 0;
            if (rs.next()) {
                guestId = rs.getInt(1);
            }

            // 2. Insert Reservation linked to that Guest
            String insertRes = "INSERT INTO reservations (guest_id, room_type_id, check_in_date, check_out_date, status) VALUES (?, ?, ?, ?, 'Confirmed')";
            PreparedStatement resStmt = conn.prepareStatement(insertRes);
            resStmt.setInt(1, guestId);
            resStmt.setInt(2, roomTypeId);
            resStmt.setString(3, checkIn);
            resStmt.setString(4, checkOut);

            int rows = resStmt.executeUpdate();
            return rows > 0; // Returns true if saved successfully

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}