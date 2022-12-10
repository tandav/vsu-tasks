package Comparators;

import Interfaces.Comparator;
import Person.Person;

public class CompareByFirstName implements Comparator<Person> {
    public boolean compare(Person person1, Person person2){
        return person1.getFirstName().compareTo(person2.getFirstName())>0;
    }
}
