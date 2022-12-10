package Comparators;
import Car.Car;
import Interfaces.Comparator;

public class CompareByModel implements Comparator<Car> {
    public boolean compare(Car person1, Car person2){
        return person1.getModel().compareTo(person2.getModel())>0;
    }
}
