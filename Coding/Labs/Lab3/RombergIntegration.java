import java.util.function.Function;

public class RombergIntegration {

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
            int n = (int) Math.pow(2, iter);
            I[iter][0] = trapEq(f, n, a, b);
            
            for (int k = 1; k <= iter; k++) {
                I[iter - k][k] = (Math.pow(4, k) * I[iter - k + 1][k - 1] - I[iter - k][k - 1]) / (Math.pow(4, k) - 1);
            }
            
            ea = Math.abs((I[0][iter] - I[1][iter - 1]) / I[0][iter]) * 100;
        }
        
        return I[0][iter];
    }

    // Adaptive Quadrature Integration
    public static double quadapt(Function<Double, Double> f, double a, double b) {
        double tol = 0.000001;
        double c = (a + b) / 2;
        double fa = f.apply(a);
        double fc = f.apply(c);
        double fb = f.apply(b);
        return qstep(f, a, b, tol, fa, fc, fb);
    }

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

    public static void main(String[] args) {
        Function<Double, Double> f = x -> 0.2 + 25 * x - 200 * Math.pow(x, 2) + 675 * Math.pow(x, 3) - 900 * Math.pow(x, 4) + 400 * Math.pow(x, 5);
        
        double rombergResult = romberg(f, 0, 0.8, 10, 0.0001);
        System.out.println("Romberg Integration Result: " + rombergResult);
        
        double quadaptResult = quadapt(f, 0, 0.8);
        System.out.println("Adaptive Quadrature Integration Result: " + quadaptResult);
    }
}
