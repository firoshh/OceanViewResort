package com.oceanview.presentation;

import com.oceanview.data.ReservationDAO;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class ViewReservationsUI extends JFrame {
    private DefaultTableModel model;
    private JTable table;
    private ReservationDAO dao;

    public ViewReservationsUI() {
        setTitle("Manage Reservations");
        setSize(900, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLayout(new BorderLayout());

        // 1. Setup Table
        String[] columns = {"ID", "Guest Name", "Check-In", "Check-Out", "Cost", "Status"};
        model = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) { return false; }
        };
        table = new JTable(model);
        dao = new ReservationDAO();

        refreshTable(); // Load data initially

        add(new JScrollPane(table), BorderLayout.CENTER);

        // 2. Buttons
        JPanel buttonPanel = new JPanel();
        JButton btnBack = new JButton("Back");
        JButton btnEdit = new JButton("Edit Full Details");
        btnEdit.setBackground(Color.ORANGE);
        JButton btnDelete = new JButton("Delete Selected");
        btnDelete.setBackground(Color.RED);
        btnDelete.setForeground(Color.WHITE);

        buttonPanel.add(btnBack);
        buttonPanel.add(Box.createHorizontalStrut(20));
        buttonPanel.add(btnEdit);
        buttonPanel.add(Box.createHorizontalStrut(10));
        buttonPanel.add(btnDelete);
        add(buttonPanel, BorderLayout.SOUTH);

        // --- ACTIONS ---
        btnBack.addActionListener(e -> dispose());

        // EDIT BUTTON
        btnEdit.addActionListener(e -> {
            int row = table.getSelectedRow();
            if (row == -1) {
                JOptionPane.showMessageDialog(null, "Select a reservation to edit.");
                return;
            }
            String idStr = (String) model.getValueAt(row, 0);
            int id = Integer.parseInt(idStr);

            // IMPORTANT: Passing 'this' allows the child window to call refreshTable() later
            new EditReservationUI(id, ViewReservationsUI.this).setVisible(true);
        });

        // DELETE BUTTON
        btnDelete.addActionListener(e -> {
            int row = table.getSelectedRow();
            if (row == -1) return;

            int id = Integer.parseInt((String) model.getValueAt(row, 0));
            int confirm = JOptionPane.showConfirmDialog(null, "Delete Reservation #" + id + "?");

            if (confirm == JOptionPane.YES_OPTION) {
                if (dao.deleteReservation(id)) {
                    refreshTable(); // <--- Updates instantly!
                }
            }
        });
    }

    // --- THE REFRESH METHOD ---
    public void refreshTable() {
        model.setRowCount(0); // Clear old data
        List<String[]> data = dao.getAllReservations(); // Get fresh data
        for (String[] row : data) {
            model.addRow(row);
        }
    }
}