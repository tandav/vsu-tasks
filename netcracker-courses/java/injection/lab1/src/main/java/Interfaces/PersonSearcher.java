package Interfaces;
import Person.Person;

public interface PersonSearcher<T> {
    void search(T var, Person[] objects);
}
