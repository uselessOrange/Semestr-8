public class IterativeCalculation {
    
    public static double[] IterMeth(double x, double es, int maxit) {
        int iter = 1;
        double sol = 1;
        double ea = 100;

        while (true) {
            double solOld = sol;
            sol += Math.pow(x, iter) / factorial(iter);
            iter++;

            if (sol != 0) {
                ea = Math.abs((sol - solOld) / sol) * 100;
            }

            if (ea <= es || iter >= maxit) {
                break;
            }
        }
        return new double[]{sol, ea, iter};
    }
    
    private static double factorial(int n) {
        double fact = 1;
        for (int i = 1; i <= n; i++) {
            fact *= i;
        }
        return fact;
    }

    public static void main(String[] args) {
        double x = 2.0;
        double es = 0.01;
        int maxit = 100;
        
        double[] result = IterMeth(x, es, maxit);
        System.out.println("Estimated Value: " + result[0]);
        System.out.println("Approximate Error: " + result[1] + "%");
        System.out.println("Terms Used: " + (int)result[2]);
        
        // Comparing with built-in function
        double actualValue = Math.exp(x);
        System.out.println("Actual Value: " + actualValue);
        System.out.println("Absolute Error: " + Math.abs(actualValue - result[0]));
    }
}
