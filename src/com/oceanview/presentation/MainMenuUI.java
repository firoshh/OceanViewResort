package com.oceanview.presentation;

import javax.swing.*;

public class MainMenuUI extends JFrame {

    public MainMenuUI() {
        setTitle("Ocean View Resort - Main Menu");
        setSize(400, 350); // Made slightly taller for the new button
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setLayout(null);

        // Title
        JLabel lblTitle = new JLabel("Resort Management System", SwingConstants.CENTER);
        lblTitle.setFont(new java.awt.Font("Segoe UI", java.awt.Font.BOLD, 16));
        lblTitle.setBounds(0, 20, 400, 25);
        add(lblTitle);

        // 1. Add Reservation Button
        JButton btnAdd = new JButton("Add New Reservation");
        btnAdd.setBounds(80, 70, 240, 40);
        add(btnAdd);

        // 2. View Reservations Button
        JButton btnView = new JButton("View Reservations");
        btnView.setBounds(80, 120, 240, 40);
        add(btnView);

        // 3. LOGOUT Button (New!)
        JButton btnLogout = new JButton("Logout");
        btnLogout.setBounds(80, 180, 240, 40);
        btnLogout.setBackground(new java.awt.Color(255, 165, 0)); // Orange color
        add(btnLogout);

        // 4. Exit Button
        JButton btnExit = new JButton("Exit System");
        btnExit.setBounds(80, 240, 240, 40);
        add(btnExit);

        // --- ACTIONS ---
        btnAdd.addActionListener(e -> new AddReservationUI().setVisible(true));

        btnView.addActionListener(e -> new ViewReservationsUI().setVisible(true));

        // Logout Logic: Close this menu -> Open Login Screen
        btnLogout.addActionListener(e -> {
            dispose();
            new LoginUI().setVisible(true);
        });

        btnExit.addActionListener(e -> System.exit(0));
    }
}