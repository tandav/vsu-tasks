package Comparators;


import Interfaces.Comparator;
import Person.Person;


public class CompareById implements Comparator<Person> {
    public boolean compare(Person p1, Person p2) {
        return p1.getId()>p2.getId();
    }
}
