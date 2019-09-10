package nordsoft;

public class Lambda {

    public static void main(String[] args) {
        System.out.println(compute((a, b) -> a + b, 1, 2));
        System.out.println(compute((a, b) -> a - b, 1, 2));
        System.out.println(compute((a, b) -> a * b, 1, 2));
        System.out.println(compute((a, b) -> a / b, 1, 2));

    }

    public static int compute(Compute compute, int a, int b) {
        return compute.compute(a, b);
    }
}

interface Compute {

    public abstract int compute(int a, int b);
}
