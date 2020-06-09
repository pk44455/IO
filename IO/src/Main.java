import java.sql.*;

public class Main {

    public static void main(String[] args) {

        try {

            Connection connection = DriverManager.getConnection
                    ("jdbc:mysql://localhost:3306/io?useSSL=false", "root", "admin");

            Statement statement = connection.createStatement();

            while (true) {

                for (int i = 1; i <= 4; i++) {

                    int pulse = generatePulse();
                    int air_pollution = generateAirPollution();
                    int dust_content = generateDust();

                    String sql = "update measurement set pulse = " + Integer.toString(pulse) + ", air_pollution = " + Integer.toString(air_pollution)
                            + ", dust_content = " + Integer.toString(dust_content) + " where Worker_ID = " + i;

                    statement.executeUpdate(sql);
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    static int generatePulse() {

        int min = 50;
        int max = 300;
        return (int) (Math.random() * (max - min + 1) + min);
    }

    static int generateAirPollution() {
        int min = 0;
        int max = 60;
        return (int) (Math.random() * (max - min + 1) + min);

    }

    static int generateDust() {
        int min = 0;
        int max = 60;
        return (int) (Math.random() * (max - min + 1) + min * 100);
    }
}
