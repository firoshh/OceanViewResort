package com.oceanview.presentation;

import javax.swing.*;
import java.awt.event.ActionEvent;

public class MainMenuUI extends JFrame {

    public MainMenuUI() {
        setTitle("Ocean View Resort - Main Menu");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null); // Center on screen
        setLayout(null);

        // Title Label
        JLabel lblTitle = new JLabel("Resort Management System");
        lblTitle.setBounds(110, 20, 200, 25);
        add(lblTitle);

        // Buttons
        JButton btnAdd = new JButton("Add New Reservation");
        btnAdd.setBounds(80, 70, 240, 40);
        add(btnAdd);

        JButton btnView = new JButton("View Reservations");
        btnView.setBounds(80, 120, 240, 40);
        add(btnView);

        JButton btnExit = new JButton("Exit System");
        btnExit.setBounds(80, 170, 240, 40);
        add(btnExit);

        // Button Actions
        btnAdd.addActionListener(e -> new AddReservationUI().setVisible(true));
        btnView.addActionListener(e -> new ViewReservationsUI().setVisible(true));
        btnExit.addActionListener(e -> System.exit(0));
    }
}