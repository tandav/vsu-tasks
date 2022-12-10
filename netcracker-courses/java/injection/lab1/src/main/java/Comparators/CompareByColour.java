package Comparators;
import Car.Car;
import Interfaces.Comparator;


public class CompareByColour implements Comparator<Car> {
    public boolean compare(Car person1, Car person2){
        return person1.getColour().compareTo(person2.getColour())>0;
    }
}
