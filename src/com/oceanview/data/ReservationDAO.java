package com.oceanview.data;

import java.sql.*;

public class ReservationDAO {

    public boolean addReservation(String name, String address, String contact, int roomTypeId, String checkIn, String checkOut) {
        Connection conn = DBConnection.getConnection();
        try {
            // 1. Calculate the Bill First
            RoomDAO roomDao = new RoomDAO();
            double pricePerNight = roomDao.getPrice(roomTypeId);

            // Calculate days between dates
            java.time.LocalDate date1 = java.time.LocalDate.parse(checkIn);
            java.time.LocalDate date2 = java.time.LocalDate.parse(checkOut);
            long days = java.time.temporal.ChronoUnit.DAYS.between(date1, date2);

            double totalCost = days * pricePerNight;

            // 2. Insert Guest
            String insertGuest = "INSERT INTO guests (full_name, address, contact_number) VALUES (?, ?, ?)";
            PreparedStatement guestStmt = conn.prepareStatement(insertGuest, Statement.RETURN_GENERATED_KEYS);
            guestStmt.setString(1, name);
            guestStmt.setString(2, address);
            guestStmt.setString(3, contact);
            guestStmt.executeUpdate();

            ResultSet rs = guestStmt.getGeneratedKeys();
            int guestId = 0;
            if (rs.next()) guestId = rs.getInt(1);

            // 3. Insert Reservation with Total Cost
            String insertRes = "INSERT INTO reservations (guest_id, room_type_id, check_in_date, check_out_date, total_cost, status) VALUES (?, ?, ?, ?, ?, 'Confirmed')";
            PreparedStatement resStmt = conn.prepareStatement(insertRes);
            resStmt.setInt(1, guestId);
            resStmt.setInt(2, roomTypeId);
            resStmt.setString(3, checkIn);
            resStmt.setString(4, checkOut);
            resStmt.setDouble(5, totalCost); // Saved calculated cost

            return resStmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }


    }
}