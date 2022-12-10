package checkers.Person;
import entities.person.Person;

public class Id implements Checker {
    public boolean check(Person p, Object value) {
        return Integer.valueOf(p.getId()).equals(value);//TODO: спросить, пойдет так или нет
    }
}
