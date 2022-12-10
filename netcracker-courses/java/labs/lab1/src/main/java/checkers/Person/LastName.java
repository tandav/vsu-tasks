package checkers.Person;
import entities.person.Person;

public class LastName implements Checker {
    public boolean check(Person p, Object value) {
        return p.getLastName().equals(value);
    }
}
