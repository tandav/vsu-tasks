package Car;
import Interfaces.*;

import java.util.Arrays;

public class Repository extends RepositoryAbstract<Car> {
    private Car[] cars = new Car[1];
    private int size;
/*
    public void add(Car object) {
        if (size == 0) {
            //cars = Arrays.copyOf(this.cars, size+1);
            size++;
            cars[0] = object;
        } else {
            Car[] newcars =  Arrays.copyOf(this.cars, size+1);
            for (int i = 0; i < cars.length; i++)
                newcars[i] = cars[i];
            newcars[size] = object;
            size++;
            this.cars = newcars;
        }
    }

*/
}
