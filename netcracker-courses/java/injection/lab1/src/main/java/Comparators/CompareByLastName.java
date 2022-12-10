package Comparators;

import Interfaces.Comparator;
import Person.Person;

public class CompareByLastName implements Comparator<Person> {
    public boolean compare(Person person1, Person person2){
        return person1.getLastName().compareTo(person2.getLastName())>0;
    }
}
