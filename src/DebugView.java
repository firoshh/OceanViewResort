import com.oceanview.data.ReservationDAO;
import java.util.List;

public class DebugView {
    public static void main(String[] args) {
        System.out.println("--- STARTING DEBUG TEST ---");

        ReservationDAO dao = new ReservationDAO();
        try {
            List<String[]> data = dao.getAllReservations();

            if (data.isEmpty()) {
                System.out.println("RESULT: List is EMPTY. (Database connection is okay, but found no rows)");
            } else {
                System.out.println("RESULT: Found " + data.size() + " reservations!");
                for (String[] row : data) {
                    System.out.println(" - Guest: " + row[1] + " | Cost: " + row[4]);
                }
            }
        } catch (Exception e) {
            System.out.println("CRITICAL ERROR: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("--- TEST FINISHED ---");
    }
}