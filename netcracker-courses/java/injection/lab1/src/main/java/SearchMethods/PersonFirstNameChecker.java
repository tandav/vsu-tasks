package SearchMethods;

import Interfaces.Checker;
import Person.Person;

/**
 * Чекер по имени персоны
 */
public class PersonFirstNameChecker implements Checker<Person> {
    public boolean check(Person person, Object object){
        return(object.equals(person.getFirstName()));
    }
}
