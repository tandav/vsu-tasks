package Comparators;
import Car.Car;
import Interfaces.Comparator;

public class CompareCarById implements Comparator<Car> {
        public boolean compare(Car p1, Car p2) {
            return p1.getId()>p2.getId();
        }
}
