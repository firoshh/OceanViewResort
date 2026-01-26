package com.oceanview.presentation;

import com.oceanview.data.ReservationDAO;
import javax.swing.*;

public class AddReservationUI extends JFrame {

    public AddReservationUI() {
        setTitle("Add New Reservation");
        setSize(400, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE); // Only closes this window, not the whole app
        setLayout(null);

        // 1. Guest Name
        JLabel lblName = new JLabel("Guest Name:");
        lblName.setBounds(30, 30, 100, 25);
        add(lblName);
        JTextField txtName = new JTextField();
        txtName.setBounds(140, 30, 200, 25);
        add(txtName);

        // 2. Address
        JLabel lblAddr = new JLabel("Address:");
        lblAddr.setBounds(30, 70, 100, 25);
        add(lblAddr);
        JTextField txtAddr = new JTextField();
        txtAddr.setBounds(140, 70, 200, 25);
        add(txtAddr);

        // 3. Contact
        JLabel lblPhone = new JLabel("Contact No:");
        lblPhone.setBounds(30, 110, 100, 25);
        add(lblPhone);
        JTextField txtPhone = new JTextField();
        txtPhone.setBounds(140, 110, 200, 25);
        add(txtPhone);

        // 4. Room Type (Dropdown)
        JLabel lblRoom = new JLabel("Room Type:");
        lblRoom.setBounds(30, 150, 100, 25);
        add(lblRoom);
        // The numbers 1, 2, 3 correspond to IDs in your database
        String[] rooms = {"1 - Single (5000)", "2 - Double (8500)", "3 - Suite (15000)"};
        JComboBox<String> cbRoom = new JComboBox<>(rooms);
        cbRoom.setBounds(140, 150, 200, 25);
        add(cbRoom);

        // 5. Dates
        JLabel lblIn = new JLabel("Check-In (YYYY-MM-DD):");
        lblIn.setBounds(30, 190, 150, 25);
        add(lblIn);
        JTextField txtIn = new JTextField("2025-02-01");
        txtIn.setBounds(180, 190, 160, 25);
        add(txtIn);

        JLabel lblOut = new JLabel("Check-Out (YYYY-MM-DD):");
        lblOut.setBounds(30, 230, 150, 25);
        add(lblOut);
        JTextField txtOut = new JTextField("2025-02-05");
        txtOut.setBounds(180, 230, 160, 25);
        add(txtOut);

        // 6. Save Button
        JButton btnSave = new JButton("Save Reservation");
        btnSave.setBounds(100, 300, 180, 40);
        add(btnSave);

        btnSave.addActionListener(e -> {
            // Get data from form
            String name = txtName.getText();
            String address = txtAddr.getText();
            String phone = txtPhone.getText();
            String checkIn = txtIn.getText();
            String checkOut = txtOut.getText();

            // Extract ID from dropdown (e.g., "1 - Single" becomes 1)
            String selected = (String) cbRoom.getSelectedItem();
            int typeId = Integer.parseInt(selected.split(" - ")[0]);

            // Call the Data Layer
            ReservationDAO dao = new ReservationDAO();
            boolean success = dao.addReservation(name, address, phone, typeId, checkIn, checkOut);

            if (success) {
                JOptionPane.showMessageDialog(null, "Reservation Saved Successfully!");
                dispose(); // Close form
            } else {
                JOptionPane.showMessageDialog(null, "Error saving data.");
            }
        });
    }
}