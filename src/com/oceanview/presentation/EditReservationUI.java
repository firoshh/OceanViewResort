package com.oceanview.presentation;

import com.oceanview.data.ReservationDAO;
import javax.swing.*;

public class EditReservationUI extends JFrame {

    private JTextField txtName, txtAddr, txtPhone, txtIn, txtOut;
    private JComboBox<String> cbRoom;
    private int reservationId;
    private ViewReservationsUI parentUI; // Reference to the main list

    public EditReservationUI(int id, ViewReservationsUI parent) {
        this.reservationId = id;
        this.parentUI = parent; // Save the reference

        setTitle("Edit Reservation #" + id);
        setSize(400, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLayout(null);

        // --- UI Setup (Same as before) ---
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
        txtIn = new JTextField(); txtIn.setBounds(140, 190, 200, 25); add(txtIn);

        JLabel lblOut = new JLabel("Check-Out:"); lblOut.setBounds(30, 230, 100, 25); add(lblOut);
        txtOut = new JTextField(); txtOut.setBounds(140, 230, 200, 25); add(txtOut);

        JButton btnUpdate = new JButton("Update");
        btnUpdate.setBounds(130, 300, 140, 40);
        btnUpdate.setBackground(java.awt.Color.ORANGE);
        add(btnUpdate);

        // --- LOAD DATA ---
        ReservationDAO dao = new ReservationDAO();
        String[] data = dao.getReservationDetails(id);
        if (data != null) {
            txtName.setText(data[0]);
            txtAddr.setText(data[1]);
            txtPhone.setText(data[2]);
            cbRoom.setSelectedIndex(Integer.parseInt(data[3]) - 1);
            txtIn.setText(data[4]);
            txtOut.setText(data[5]);
        }

        // --- UPDATE ACTION ---
        btnUpdate.addActionListener(e -> {
            String name = txtName.getText();
            String addr = txtAddr.getText();
            String phone = txtPhone.getText();
            String in = txtIn.getText();
            String out = txtOut.getText();
            int typeId = cbRoom.getSelectedIndex() + 1;

            if (dao.updateFullReservation(reservationId, name, addr, phone, typeId, in, out)) {
                JOptionPane.showMessageDialog(this, "Updated Successfully!");

                // --- THE FIX: LIVE REFRESH ---
                if (parentUI != null) {
                    parentUI.refreshTable(); // <--- Triggers the refresh on the other window
                }

                dispose(); // Close this window
            } else {
                JOptionPane.showMessageDialog(this, "Update Failed.");
            }
        });
    }
}