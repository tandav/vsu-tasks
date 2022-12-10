package SearchMethods;

import Interfaces.Checker;
import Person.Person;

/**
 * Чекер по айди персоны
 */
public class PersonIdChecker implements Checker<Person> {
    public boolean check(Person person, Object object){
        return object.equals(person.getId());
    }
}
