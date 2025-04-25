import java.io.*;
import java.util.*;

public class Lab4 {


    public static class WeibullParams {
        public double k;
        public double lambda;

        public WeibullParams(double k, double lambda) {
            this.k = k;
            this.lambda = lambda;
        }

        @Override
        public String toString() {
            return String.format("Weibull Parameters:\nShape (k): %.5f\nScale (λ): %.5f", k, lambda);
        }
    }
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




    public static WeibullParams parameterization(List<Double> windSpeeds) {
        int n = windSpeeds.size();
        if (n == 0) throw new IllegalArgumentException("Wind speed list is empty!");

        // Mean
        double sum = 0.0;
        for (double speed : windSpeeds) {
            sum += speed;
        }
        double mean = sum / n;

        // Standard deviation
        double sqDiffSum = 0.0;
        for (double speed : windSpeeds) {
            sqDiffSum += Math.pow(speed - mean, 2);
        }
        double stddev = Math.sqrt(sqDiffSum / n);

        // Shape parameter (k)
        double k = Math.pow(stddev / mean, -1.086);

        // Gamma function approximation: Γ(1 + 1/k)
        double gammaVal = gamma(1 + 1 / k);

        // Scale parameter (λ)
        double lambda = mean / gammaVal;

        return new WeibullParams(k, lambda);
    }

    // Lanczos approximation for the gamma function
    private static double gamma(double z) {
        double[] p = {
            676.5203681218851,
            -1259.1392167224028,
            771.32342877765313,
            -176.61502916214059,
            12.507343278686905,
            -0.13857109526572012,
            9.9843695780195716e-6,
            1.5056327351493116e-7
        };

        int g = 7;
        if (z < 0.5) {
            // Reflection formula for gamma
            return Math.PI / (Math.sin(Math.PI * z) * gamma(1 - z));
        }

        z -= 1;
        double x = 0.99999999999980993;
        for (int i = 0; i < p.length; i++) {
            x += p[i] / (z + i + 1);
        }

        double t = z + g + 0.5;
        return Math.sqrt(2 * Math.PI) * Math.pow(t, z + 0.5) * Math.exp(-t) * x;
    }


    public static double model(WeibullParams params) {
        double k = params.k;
        double lambda = params.lambda;
        return lambda * gamma(1 + 1 / k);
    }

// Simulation method
public static void simulation(WeibullParams params) {
    Random rand = new Random();
    double theoreticalMean = model(params);
    List<Double> sample = new ArrayList<>();
    double errorPercent = 100.0;
    int count=0;
    while (errorPercent > 5.0) {
        // Generate random value using inverse CDF
        double u = rand.nextDouble(); // uniform random [0,1)
        double x = params.lambda * Math.pow(-Math.log(1 - u), 1.0 / params.k);
        sample.add(x);

        count++;

        // Calculate sample mean
        double sum = 0.0;
        for (double val : sample) {
            sum += val;
        }
        double sampleMean = sum / sample.size();

        // Calculate percentage error
        errorPercent = Math.abs((sampleMean - theoreticalMean) / theoreticalMean) * 100;
    }

    System.out.println("Target mean: " + theoreticalMean);
    System.out.println("Sample mean: " + (sample.stream().mapToDouble(d -> d).sum() / sample.size()));
    System.out.println("Sample size needed: " + sample.size());
}

//--------------------------





  
    // For testing
    public static void main(String[] args) {
        String filename = "04 swera_wind_inpe_hi_res.csv"; // replace with your actual path
        List<Double> windDataList = loadCSV(filename);
        statistics(windDataList);

        //System.out.println(mean);

        WeibullParams out = parameterization(windDataList);
        System.out.println(out.toString());

        ///WeibullParams params = new WeibullParams(out.k, out.lambda); // Example shape and scale
        double theoreticalMean = model(out);
        System.out.printf("Theoretical mean (μ) of Weibull distribution: %.6f%n", theoreticalMean);
        simulation(out);
    }

//        int len = windDataList.size();
//        for (int i =0;i<5;i++) {
//            System.out.println(windDataList.get(i));
//        }
    }





