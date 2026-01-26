package com.oceanview.presentation;

import com.oceanview.data.ReservationDAO;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class ViewReservationsUI extends JFrame {

    public ViewReservationsUI() {
        // 1. Window Settings
        setTitle("All Reservations List");
        setSize(800, 400);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE); // Closes only this window
        setLayout(new BorderLayout());

        // 2. Define Table Columns
        String[] columns = {"ID", "Guest Name", "Check-In", "Check-Out", "Cost", "Status"};
        DefaultTableModel model = new DefaultTableModel(columns, 0);
        JTable table = new JTable(model);

        // 3. Fetch Data from Database (The code that works!)
        ReservationDAO dao = new ReservationDAO();
        List<String[]> data = dao.getAllReservations();

        // 4. Add Data to Table
        for (String[] row : data) {
            model.addRow(row);
        }

        // 5. Add Table to Window (Inside a scroll pane)
        JScrollPane scrollPane = new JScrollPane(table);
        add(scrollPane, BorderLayout.CENTER);

        // 6. Refresh (Safety measure)
        revalidate();
        repaint();
    }
}