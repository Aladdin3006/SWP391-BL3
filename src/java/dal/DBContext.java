package dal;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    private final String serverName = "localhost";
    private final String dbName = "swp";
    private final String portNumber = "3306";
    private final String userID = "root";
    private final String password = "abc123";

    public Connection getConnection() throws Exception {
        String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName
                + "?useUnicode=true&characterEncoding=UTF-8";
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, userID, password);
    }
}