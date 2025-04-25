import java.io.*;
import java.util.*;

public class CSVLoader {

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

            try {
                BufferedReader br = new BufferedReader(new FileReader(filename));
                String line;
                boolean isFirstLine = true;
        
                while ((line = br.readLine()) != null) {
                    // Skip header if needed
                    if (isFirstLine) {
                        isFirstLine = false;
                        continue;
                    }
        
                    String[] parts = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1); // Handles quoted commas
        
                    try {
                        String id = parts[0];
                        String polygon = parts[1];
                        int height = Integer.parseInt(parts[2]);
                        double windSpeed = Double.parseDouble(parts[3]);
        
                        // Process or store your data
                        //System.out.println("ID: " + id + " | Height: " + height + " | Wind: " + windSpeed);
                        data.add(new WindData(id, polygon, height, windSpeed));
        
                    } catch (NumberFormatException e) {
                        System.out.println("Skipping bad line: " + line);
                        continue; // Skip this line and keep going
                    }
                }
        
                br.close();
            } catch (IOException e) {
                e.printStackTrace();
                System.err.println("Error reading the file: " + e.getMessage());
            }
        return data;
    }

    // For testing
    public static void main(String[] args) {
        String filename = "04 swera_wind_inpe_hi_res.csv"; // replace with your actual path
        List<WindData> windDataList = loadCSV(filename);
        int len = windDataList.size();
        for (int i =0;i<len;i++) {
            System.out.println(windDataList.get(i));
        }
    }
}
