package SearchMethods;

import Interfaces.Checker;
import Person.Person;

/**
 * Чекер по фамилии персоны
 */
public class PersonLastNameChecker implements Checker<Person> {
    public boolean check(Person person, Object object){
        return(object.equals(person.getLastName()));
    }
}