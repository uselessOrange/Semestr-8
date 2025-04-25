import java.io.*;
import java.util.*;

public class stats {

    // Method to load data from CSV
    public static List<Double> loadCSV(String filename) {
        List<Double> data = new ArrayList<>();

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
                        double windSpeed = Double.parseDouble(parts[3]);
        
                        // Process or store your data
                        //System.out.println("ID: " + id + " | Height: " + height + " | Wind: " + windSpeed);
                        data.add(windSpeed);
        
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

    public static double statistics(List<Double> windSpeeds) {
        if (windSpeeds == null || windSpeeds.isEmpty()) {
            System.out.println("No wind data available for statistics.");
            return 1;
        }

        int n = windSpeeds.size();

        // Calculate mean
        double sum = 0.0;
        for (double speed : windSpeeds) {
            sum += speed;
        }
        double mean = sum / n;

        // Calculate standard deviation
        double varianceSum = 0.0;
        for (double speed : windSpeeds) {
            varianceSum += Math.pow(speed - mean, 2);
        }
        double standardDeviation = Math.sqrt(varianceSum / n);

        // Print results
        System.out.printf("Wind Speed Mean: %.4f\n", mean);
        System.out.printf("Wind Speed Standard Deviation: %.4f\n", standardDeviation);

        return mean;
    }


    // For testing
    public static void main(String[] args) {
        String filename = "04 swera_wind_inpe_hi_res.csv"; // replace with your actual path
        List<Double> windDataList = loadCSV(filename);
        double mean = statistics(windDataList);
        System.out.println(mean);
//        int len = windDataList.size();
//        for (int i =0;i<5;i++) {
//            System.out.println(windDataList.get(i));
//        }
    }
}



