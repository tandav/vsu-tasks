package Comparators;
import Person.Person;
import Interfaces.Comparator;

public class CompareByBirthday implements Comparator<Person> {
    public boolean compare(Person person1, Person person2){
        return person1.getBirthday().isAfter(person2.getBirthday());
    }
}
