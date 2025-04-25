import java.util.function.Function;

public class SwitchingCalculation {
    
    public static double bisection(Function<Double, Double> f, double xl, double xu, double es, int imax) {
        int iter = 0;
        double xr = 0, xrold, ea = 100;
        
        while (iter < imax && ea > es) {
            xrold = xr;
            xr = (xl + xu) / 2;
            iter++;
            
            if (xr != 0) {
                ea = Math.abs((xr - xrold) / xr) * 100;
            }
            
            double test = f.apply(xl) * f.apply(xr);
            if (test < 0) {
                xu = xr;
            } else if (test > 0) {
                xl = xr;
            } else {
                ea = 0;
                break;
            }
        }
        return xr;
    }
    
    public static double falsePosition(Function<Double, Double> f, double xl, double xu, double es, int imax) {
        int iter = 0, il = 0, iu = 0;
        double xr = 0, xrold, ea = 100;
        double fl = f.apply(xl), fu = f.apply(xu);
        
        while (iter < imax && ea > es) {
            xrold = xr;
            xr = xu - fu * (xl - xu) / (fl - fu);
            double fr = f.apply(xr);
            iter++;
            
            if (xr != 0) {
                ea = Math.abs((xr - xrold) / xr) * 100;
            }
            
            double test = fl * fr;
            if (test < 0) {
                xu = xr;
                fu = f.apply(xu);
                iu = 0;
                il++;
                if (il >= 2) fl /= 2;
            } else if (test > 0) {
                xl = xr;
                fl = f.apply(xl);
                il = 0;
                iu++;
                if (iu >= 2) fu /= 2;
            } else {
                ea = 0;
                break;
            }
        }
        return xr;
    }
    
    public static void main(String[] args) {
        Function<Double, Double> polynomial = x -> -0.6 * x * x + 2.4 * x + 5.5;
        String method = "bisection";
        double xl = 5, xu = 10, es = 0.01;
        int imax = 3;
        
        double root = 0;
        switch (method) {
            case "bisection":
                root = bisection(polynomial, xl, xu, es, imax);
                break;
            case "false-position":
                root = falsePosition(polynomial, xl, xu, es, imax);
                break;
            default:
                System.out.println("Invalid method selected.");
                return;
        }
        
        double actualRoot = (-2.4 + Math.sqrt(2.4 * 2.4 - 4 * (-0.6) * 5.5)) / (2 * -0.6);
        double trueError = Math.abs((actualRoot - root) / actualRoot) * 100;
        
        System.out.println("Estimated Root: " + root);
        System.out.println("True Root: " + actualRoot);
        System.out.println("True Error: " + trueError + "%");
    }
}
