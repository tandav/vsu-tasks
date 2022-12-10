package SearchMethods;
import Person.Person;
import Interfaces.Checker;
import org.joda.time.LocalDate;

/**
 * Чекер по дню рождения персон
 */
public class PersonBirthdayChecker implements Checker<Person> {
    @Override
    public boolean check(Person person, Object object) {
        return object.equals(person.getBirthday());
    }
}
