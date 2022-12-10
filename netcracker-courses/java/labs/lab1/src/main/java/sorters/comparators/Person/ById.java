package sorters.comparators.Person;
import entities.person.Person;
import java.util.Comparator;

public class ById implements Comparator <Person>{
    public int compare(Person p1, Person p2) {
        return p1.getId() - p2.getId() < 0 ? -1 : (p1.getId() == p2.getId() ? 0 : 1);
    }
}
