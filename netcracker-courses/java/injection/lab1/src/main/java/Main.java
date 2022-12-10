import Comparators.CompareByBirthday;
import Comparators.CompareByFirstName;
import Comparators.CompareById;
import Interfaces.Checker;
import Person.Repository;
import SearchMethods.*;
import SortMethods.*;
import Person.*;


public class Main {
    public static void main(String[] args) {
        Repository persons = new Repository();

        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(2, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(3, "Donald", "Trump", "1946-06-14"));
        persons.add(new Person(4, "Quentin", "Tarantino", "1963-03-27"));
        persons.add(new Person(5, "George", "Clooney", "1971-05-06"));
        persons.add(new Person(7, "Konstantin", "Khabensky", "1972-01-11"));
        persons.add(new Person(8, "Mikhail", "Lomonosov", "1711-11-19"));
        persons.add(new Person(9, "Nikola", "Tesla", "1856-07-10"));

        persons.printList();
        //persons.remove(2);
        //persons.remove(3);
        //persons.search(new CompareByFirstName(), persons.get(5));
        //System.out.println(persons.searchId(5));
        //persons.searchByBirthday(LocalDate.parse("1996-10-24"));
        System.out.println(persons.search(new PersonIdChecker(), 7));
        //persons.sort(persons.getRepository(),new CompareByBirthday());
        //System.out.println();
        //System.out.println(persons.get(1));
        persons.printList();
    }
}
