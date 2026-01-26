package com.oceanview.presentation;

import com.oceanview.data.UserDAO;
import com.oceanview.models.User;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class LoginUI extends JFrame {

    public LoginUI() {
        setTitle("Ocean View Resort - Login");
        setSize(350, 200);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null); // Centers the window
        setLayout(null);

        JLabel userLabel = new JLabel("Username:");
        userLabel.setBounds(30, 30, 80, 25);
        add(userLabel);

        JTextField userText = new JTextField(20);
        userText.setBounds(110, 30, 150, 25);
        add(userText);

        JLabel passLabel = new JLabel("Password:");
        passLabel.setBounds(30, 70, 80, 25);
        add(passLabel);

        JPasswordField passText = new JPasswordField(20);
        passText.setBounds(110, 70, 150, 25);
        add(passText);

        JButton loginButton = new JButton("Login");
        loginButton.setBounds(110, 110, 100, 30);
        add(loginButton);

        // What happens when you click Login
        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String username = userText.getText();
                String password = new String(passText.getPassword());

                UserDAO dao = new UserDAO();
                User user = dao.authenticate(username, password);

                if (user != null) {
                    JOptionPane.showMessageDialog(null, "Welcome, " + user.getRole() + "!");
                    new MainMenuUI().setVisible(true);
                    dispose(); // Close login window
                } else {
                    JOptionPane.showMessageDialog(null, "Invalid Username or Password", "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new LoginUI().setVisible(true));
    }
}