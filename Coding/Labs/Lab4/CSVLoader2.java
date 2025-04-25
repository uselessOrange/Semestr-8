import java.io.*;
import java.util.*;

public class CSVLoader2 {

    // Define a class to hold each row's data
    static class WindData {
        String id;
        String polygon;
        int height;
        double windSpeed;

        public WindData(String id, String polygon, int height, double windSpeed) {
            this.id = id;
            this.polygon = polygon;
            this.height = height;
            this.windSpeed = windSpeed;
        }

        @Override
        public String toString() {
            return "ID: " + id + ", Height: " + height + ", WindSpeed: " + windSpeed + ", Polygon: " + polygon;
        }
    }

    // Method to load data from CSV
    public static List<WindData> loadCSV(String filename) {
        List<WindData> data = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            String line;

            while ((line = br.readLine()) != null) {
                // Split line respecting quotes
                String[] parts = splitCSVLine(line);

                if (parts.length == 4) {
                    String id = parts[0].trim();
                    String polygon = parts[1].trim().replaceAll("^\"|\"$", ""); // remove quotes
                    int height = Integer.parseInt(parts[2].trim());
                    double windSpeed = Double.parseDouble(parts[3].trim());

                    data.add(new WindData(id, polygon, height, windSpeed));
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading the file: " + e.getMessage());
        }

        return data;
    }

    // Helper method to split lines respecting quoted fields
    private static String[] splitCSVLine(String line) {
        List<String> tokens = new ArrayList<>();
        boolean inQuotes = false;
        StringBuilder sb = new StringBuilder();

        for (char c : line.toCharArray()) {
            if (c == '\"') {
                inQuotes = !inQuotes; // toggle state
            } else if (c == ',' && !inQuotes) {
                tokens.add(sb.toString());
                sb = new StringBuilder();
            } else {
                sb.append(c);
            }
        }
        tokens.add(sb.toString()); // last token

        return tokens.toArray(new String[0]);
    }

    // For testing
    public static void main(String[] args) {
        String filename = "04 swera_wind_inpe_hi_res2.csv"; // replace with your actual path
        List<WindData> windDataList = loadCSV(filename);

        for (WindData data : windDataList) {
            System.out.println(data);
        }
    }
}
