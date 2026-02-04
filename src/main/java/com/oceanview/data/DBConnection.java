package com.oceanview.data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static DBConnection instance;
    private Connection connection;
    // UPDATE THESE IF NEEDED:
    private String url = "jdbc:mysql://localhost:3306/ocean_view_resort";
    private String username = "root";
    private String password = "";

    private DBConnection() {
        try {
            // This line loads the driver you added in Step 2
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(url, username, password);
            System.out.println("Database Connected Successfully!");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            if (instance == null || instance.connection.isClosed()) {
                instance = new DBConnection();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return instance.connection;
    }
}