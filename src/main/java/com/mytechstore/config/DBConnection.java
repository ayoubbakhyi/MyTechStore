package com.mytechstore.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_HOST = System.getenv().getOrDefault("DB_HOST", "127.0.0.1");
    private static final String DB_NAME = System.getenv().getOrDefault("DB_NAME", "mytechstore");
    private static final String USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "test");

    private static final String URL = "jdbc:mysql://" + DB_HOST + ":3306/" + DB_NAME
            + "?allowMultiQueries=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static Connection connection = null;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("MySQL JDBC Driver not found in classpath.");
        }
    }

    private DBConnection() {
        // Private constructor for singleton
    }

    public static synchronized Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        }
        return connection;
    }
}