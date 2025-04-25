import java.io.*;
import java.util.*;
import java.util.function.Function;

public class Lab3 {

    // Trapezoidal Rule with equal-size segments
    public static double trapEq(Function<Double, Double> f, int n, double a, double b) {
        double h = (b - a) / n;
        double sum = f.apply(a) + f.apply(b);
        
        for (int i = 1; i < n; i++) {
            double x = a + i * h;
            sum += 2 * f.apply(x);
        }
        
        return (b - a) * sum / (2 * n);
    }

    // Romberg Integration
    public static double romberg(Function<Double, Double> f, double a, double b, int maxit, double es) {
        double[][] I = new double[maxit][maxit];
        I[0][0] = trapEq(f, 1, a, b);
        
        int iter = 0;
        double ea = 100;
        
        while (iter < maxit - 1 && ea > es) {
            iter++;
            int n = (int) Math.pow(2, iter); //It calculates n, the number of subintervals for the trapezoidal rule.
            I[iter][0] = trapEq(f, n, a, b); 
            
            for (int k = 1; k <= iter; k++) { //his loop refines the integral estimates using Richardson Extrapolation.
                I[iter - k][k] = (Math.pow(4, k) * I[iter - k + 1][k - 1] - I[iter - k][k - 1]) / (Math.pow(4, k) - 1);
            }
            
            ea = Math.abs((I[0][iter] - I[1][iter - 1]) / I[0][iter]) * 100; //calculates the approximate relative error (ea).
        }
        
        return I[0][iter];
    }

//daptive Quadrature Initialization

//Calls the recursive function qstep with the function f, interval [a, b], and a small tolerance tol = 0.000001 to control accuracy.

//Computes function values at:

//    a → fa = f(a) (left endpoint)

//    c = (a + b) / 2 → fc = f(c) (midpoint)

//    b → fb = f(b) (right endpoint)

//These values help estimate the integral using Simpson’s 1/3 Rule.


    // Adaptive Quadrature Integration
    public static double quadapt(Function<Double, Double> f, double a, double b) {
        double tol = 0.000001;
        double c = (a + b) / 2;
        double fa = f.apply(a);
        double fc = f.apply(c);
        double fb = f.apply(b);
        return qstep(f, a, b, tol, fa, fc, fb); 
    }
//Recursive Adaptive Simpson’s Rule implementation.
    private static double qstep(Function<Double, Double> f, double a, double b, double tol, double fa, double fc, double fb) {
        double h1 = b - a;
        double h2 = h1 / 2;
        double c = (a + b) / 2;
        double fd = f.apply((a + c) / 2);
        double fe = f.apply((c + b) / 2);
        
        double I1 = h1 / 6 * (fa + 4 * fc + fb); // Simpson's 1/3 rule
        double I2 = h2 / 6 * (fa + 4 * fd + 2 * fc + 4 * fe + fb);
        
        if (Math.abs(I2 - I1) <= tol) {
            return I2 + (I2 - I1) / 15;
        } else {
            double Ia = qstep(f, a, c, tol, fa, fd, fc);
            double Ib = qstep(f, c, b, tol, fc, fe, fb);
            return Ia + Ib;
        }
    }

    // Creating Sample Data
    public static void creatingSample(double h, double a, double b, Function<Double, Double> f, String filename) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filename))) {
            for (double x = a; x <= b; x += h) {
                writer.write(x + "," + f.apply(x) + "\n");
            }
        } catch (IOException e) {
            System.err.println("Error writing file: " + e.getMessage());
        }
    }

    // Loading Sample Data
    public static List<double[]> loadingSample(String filename) {
        List<double[]> data = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                data.add(new double[]{Double.parseDouble(parts[0]), Double.parseDouble(parts[1])});
            }
        } catch (IOException | NumberFormatException e) {
            System.err.println("Error reading file: " + e.getMessage());
        }
        return data;
    }

    public static void main(String[] args) {
        Function<Double, Double> f = x -> 0.2 + 25 * x - 200 * Math.pow(x, 2) + 675 * Math.pow(x, 3) - 900 * Math.pow(x, 4) + 400 * Math.pow(x, 5);
        String filename = "sample_data.txt";
        
        creatingSample(0.1, 0, 0.8, f, filename);
        List<double[]> data = loadingSample(filename);
        
        double rombergResult = romberg(f, 0, 0.8, 10, 0.0001);
        System.out.println("Romberg Integration Result: " + rombergResult);
        
        double quadaptResult = quadapt(f, 0, 0.8);
        System.out.println("Adaptive Quadrature Integration Result: " + quadaptResult);
    }
}
