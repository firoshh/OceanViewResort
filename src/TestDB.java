import com.oceanview.data.DBConnection;
import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        System.out.println("Testing connection...");
        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            System.out.println("SUCCESS! Connected to XAMPP MySQL.");
        } else {
            System.out.println("FAILURE. Could not connect.");
        }
    }
}