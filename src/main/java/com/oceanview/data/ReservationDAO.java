package com.oceanview.data;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class ReservationDAO {

    // --- METHOD 1: ADD RESERVATION ---
    public boolean addReservation(String name, String address, String contact, int roomTypeId, String checkIn, String checkOut) {
        Connection conn = DBConnection.getConnection();
        try {
            // 1. Calculate Bill
            RoomDAO roomDao = new RoomDAO();
            double pricePerNight = roomDao.getPrice(roomTypeId);

            LocalDate date1 = LocalDate.parse(checkIn);
            LocalDate date2 = LocalDate.parse(checkOut);
            long days = ChronoUnit.DAYS.between(date1, date2);
            if (days < 1) days = 1; // Prevent negative/zero days
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

            // 3. Insert Reservation
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

    // --- METHOD 2: GET ALL RESERVATIONS ---
    public List<String[]> getAllReservations() {
        List<String[]> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- METHOD 3: DELETE RESERVATION ---
    public boolean deleteReservation(int id) {
        Connection conn = DBConnection.getConnection();
        try {
            String query = "DELETE FROM reservations WHERE reservation_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- METHOD 4: UPDATE DATES (Simple) ---
    public boolean updateDates(int id, String newCheckIn, String newCheckOut) {
        Connection conn = DBConnection.getConnection();
        try {
            String query = "UPDATE reservations SET check_in_date = ?, check_out_date = ? WHERE reservation_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, newCheckIn);
            stmt.setString(2, newCheckOut);
            stmt.setInt(3, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- METHOD 5: GET FULL DETAILS (For Editing) ---
    public String[] getReservationDetails(int resId) {
        Connection conn = DBConnection.getConnection();
        try {
            String query = "SELECT g.full_name, g.address, g.contact_number, r.room_type_id, r.check_in_date, r.check_out_date " +
                    "FROM reservations r " +
                    "JOIN guests g ON r.guest_id = g.guest_id " +
                    "WHERE r.reservation_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, resId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new String[] {
                        rs.getString("full_name"),
                        rs.getString("address"),
                        rs.getString("contact_number"),
                        String.valueOf(rs.getInt("room_type_id")),
                        rs.getString("check_in_date"),
                        rs.getString("check_out_date")
                };
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- METHOD 6: UPDATE EVERYTHING (With Cost Recalculation) ---
    public boolean updateFullReservation(int resId, String name, String addr, String phone, int typeId, String in, String out) {
        Connection conn = DBConnection.getConnection();
        try {
            // 1. Get Guest ID
            int guestId = 0;
            PreparedStatement getG = conn.prepareStatement("SELECT guest_id FROM reservations WHERE reservation_id = ?");
            getG.setInt(1, resId);
            ResultSet rs = getG.executeQuery();
            if (rs.next()) guestId = rs.getInt(1);

            // 2. Update Guest Info
            String upGuest = "UPDATE guests SET full_name=?, address=?, contact_number=? WHERE guest_id=?";
            PreparedStatement s1 = conn.prepareStatement(upGuest);
            s1.setString(1, name);
            s1.setString(2, addr);
            s1.setString(3, phone);
            s1.setInt(4, guestId);
            s1.executeUpdate();

            // 3. RECALCULATE COST
            RoomDAO roomDao = new RoomDAO();
            double price = roomDao.getPrice(typeId);

            // Calculate days
            LocalDate d1 = LocalDate.parse(in);
            LocalDate d2 = LocalDate.parse(out);
            long days = ChronoUnit.DAYS.between(d1, d2);
            if (days < 1) days = 1;

            double newCost = days * price;

            // 4. Update Reservation with NEW COST
            String upRes = "UPDATE reservations SET room_type_id=?, check_in_date=?, check_out_date=?, total_cost=? WHERE reservation_id=?";
            PreparedStatement s2 = conn.prepareStatement(upRes);
            s2.setInt(1, typeId);
            s2.setString(2, in);
            s2.setString(3, out);
            s2.setDouble(4, newCost);
            s2.setInt(5, resId);

            return s2.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    //  NEW METHODS FOR DASHBOARD & SEARCH
    // ==========================================

    // --- METHOD 7: GET DASHBOARD STATS ---
    public int[] getDashboardStats() {
        int[] stats = {0, 0, 0}; // [Total Bookings, Total Revenue, Pending]
        Connection conn = DBConnection.getConnection();
        try {
            // 1. Count Total Bookings & Revenue
            PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*), SUM(total_cost) FROM reservations");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats[0] = rs.getInt(1); // Total Count
                stats[1] = rs.getInt(2); // Total Revenue (Sum)
            }

            // 2. Count "Upcoming" (Future Check-ins)
            // Note: Uses CURDATE() which is standard MySQL
            PreparedStatement stmt2 = conn.prepareStatement("SELECT COUNT(*) FROM reservations WHERE check_in_date >= CURDATE()");
            ResultSet rs2 = stmt2.executeQuery();
            if (rs2.next()) {
                stats[2] = rs2.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    // --- METHOD 8: SEARCH RESERVATIONS (By Guest Name) ---
    public List<String[]> searchReservations(String keyword) {
        List<String[]> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        try {
            // We must JOIN guests again to check the name
            String query = "SELECT r.reservation_id, g.full_name, r.check_in_date, r.check_out_date, r.total_cost, r.status " +
                    "FROM reservations r " +
                    "JOIN guests g ON r.guest_id = g.guest_id " +
                    "WHERE g.full_name LIKE ?"; // <--- The Search Filter

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, "%" + keyword + "%"); // Surrounds keyword with % for partial match
            ResultSet rs = stmt.executeQuery();

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
            e.printStackTrace();
        }
        return list;
    }

} // End of Class