class Mine {
    int field_1;

    public Mine(int a) {
        field_1 = a;
    }
}

class Main {
    static void myMethod(int[] x, Mine y, int z) {
        x[0] = 12;

        // y.field_1 = 7;

        y = new Mine(15);

        z = 10;
    }



    public static void main(String args[]) {
        int[] arr = new int[10];

        Mine y = new Mine(5);

        arr[0] = 10;

        int z = 4;
        Main.myMethod(arr, y, z);
        
        System.out.println(arr[0]);
        System.out.println(y.field_1);
        System.out.println(z);
    }   
}
