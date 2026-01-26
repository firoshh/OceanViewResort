package com.oceanview.presentation;

import com.oceanview.data.ReservationDAO;
import javax.swing.*;

public class AddReservationUI extends JFrame {

    // Declare fields at class level so we can clear them later
    private JTextField txtName, txtAddr, txtPhone, txtIn, txtOut;
    private JComboBox<String> cbRoom;

    public AddReservationUI() {
        setTitle("Add New Reservation");
        setSize(400, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLayout(null);

        // --- Labels & Fields ---
        JLabel lblName = new JLabel("Guest Name:"); lblName.setBounds(30, 30, 100, 25); add(lblName);
        txtName = new JTextField(); txtName.setBounds(140, 30, 200, 25); add(txtName);

        JLabel lblAddr = new JLabel("Address:"); lblAddr.setBounds(30, 70, 100, 25); add(lblAddr);
        txtAddr = new JTextField(); txtAddr.setBounds(140, 70, 200, 25); add(txtAddr);

        JLabel lblPhone = new JLabel("Contact No:"); lblPhone.setBounds(30, 110, 100, 25); add(lblPhone);
        txtPhone = new JTextField(); txtPhone.setBounds(140, 110, 200, 25); add(txtPhone);

        JLabel lblRoom = new JLabel("Room Type:"); lblRoom.setBounds(30, 150, 100, 25); add(lblRoom);
        String[] rooms = {"1 - Single (5000)", "2 - Double (8500)", "3 - Suite (15000)"};
        cbRoom = new JComboBox<>(rooms); cbRoom.setBounds(140, 150, 200, 25); add(cbRoom);

        JLabel lblIn = new JLabel("Check-In:"); lblIn.setBounds(30, 190, 100, 25); add(lblIn);
        txtIn = new JTextField("2025-02-01"); txtIn.setBounds(140, 190, 200, 25); add(txtIn);

        JLabel lblOut = new JLabel("Check-Out:"); lblOut.setBounds(30, 230, 100, 25); add(lblOut);
        txtOut = new JTextField("2025-02-05"); txtOut.setBounds(140, 230, 200, 25); add(txtOut);

        // --- BUTTONS ---
        JButton btnBack = new JButton("Back");
        btnBack.setBounds(50, 300, 130, 40);
        add(btnBack);

        JButton btnSave = new JButton("Save");
        btnSave.setBounds(200, 300, 130, 40);
        btnSave.setBackground(new java.awt.Color(34, 139, 34)); // Green
        btnSave.setForeground(java.awt.Color.WHITE);
        add(btnSave);

        // --- ACTIONS ---
        btnBack.addActionListener(e -> dispose());

        btnSave.addActionListener(e -> {
            String name = txtName.getText().trim();
            String address = txtAddr.getText().trim();
            String phone = txtPhone.getText().trim();
            String checkIn = txtIn.getText().trim();
            String checkOut = txtOut.getText().trim();

            // Validation
            if (name.isEmpty() || address.isEmpty() || phone.isEmpty()) {
                JOptionPane.showMessageDialog(AddReservationUI.this, "Error: All fields are required!", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            if (!phone.matches("\\d{10}")) {
                JOptionPane.showMessageDialog(AddReservationUI.this, "Error: Phone must be 10 digits.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            if (!checkIn.matches("\\d{4}-\\d{2}-\\d{2}") || !checkOut.matches("\\d{4}-\\d{2}-\\d{2}")) {
                JOptionPane.showMessageDialog(AddReservationUI.this, "Error: Date must be YYYY-MM-DD.", "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }

            // Save
            String selected = (String) cbRoom.getSelectedItem();
            int typeId = Integer.parseInt(selected.split(" - ")[0]);

            boolean success = new ReservationDAO().addReservation(name, address, phone, typeId, checkIn, checkOut);

            if (success) {
                JOptionPane.showMessageDialog(AddReservationUI.this, "Reservation Saved Successfully!");
                // FIXED: We do NOT close the window (dispose). We just clear the fields.
                clearFields();
            } else {
                JOptionPane.showMessageDialog(AddReservationUI.this, "Database Error: Could not save.");
            }
        });
    }

    // Helper to empty the boxes
    private void clearFields() {
        txtName.setText("");
        txtAddr.setText("");
        txtPhone.setText("");
        // Keep dates or clear them? Let's reset to default to be helpful
        txtIn.setText("2025-02-01");
        txtOut.setText("2025-02-05");
    }
}