package com.mytechstore.listener;

import com.mytechstore.config.DBConnection;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("==================================================");
        System.out.println("MyTechStore Web Application Started successfully!");
        System.out.println("Initializing Database Connection...");
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("Successfully connected to MySQL database: " + conn.getMetaData().getURL());
            }
        } catch (SQLException e) {
            System.err.println("WARNING: Could not connect to MySQL database.");
            System.err.println("Application will run in limited mode without database functionality.");
            System.err.println("Error: " + e.getMessage());
        }
        System.out.println("==================================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("==================================================");
        System.out.println("MyTechStore Web Application Shutting Down...");
        
        // 1. Close active singleton database connection
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("MySQL database connection closed successfully.");
            }
        } catch (SQLException e) {
            System.err.println("Error closing MySQL database connection: " + e.getMessage());
        }

        // 2. Deregister JDBC drivers to prevent Tomcat memory leaks
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                System.out.println("Deregistered JDBC driver: " + driver.toString());
            } catch (SQLException e) {
                System.err.println("Error deregistering JDBC driver: " + e.getMessage());
            }
        }
        System.out.println("Application cleanup complete.");
        System.out.println("==================================================");
    }
}
