package Interfaces;

import Person.Person;
import Person.Repository;

public interface RepositoryInterface<T> {
    void add(T object);
    void remove(int id);
    void printList();
    void sort(Object[] objects, Comparator<T> comparator);


    T get(int i);

    Object[] getRepository();

    int getSize();

    Repository search(Checker<Person> comparator, Object object);
}
