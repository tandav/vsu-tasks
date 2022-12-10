package repositories;
import entities.person.Person;
import java.util.Arrays;

/**
 * Class for storing Persons objects.
 */
public class PersonRepository extends AbstractRepository<Person> {
    public PersonRepository() {
        super(Person.class);
    }

    // private Person[] repo = new Person[16];
    // private int numberOfElements = 0;

    // public Person getByIndex(int index) {
    //     return this.repo[index];
    // }
    //
    // public void addPerson(Person p) {
    //     this.repo[numberOfElements] = p;
    //     this.numberOfElements += 1;
    //     if (this.numberOfElements == this.repo.length)
    //         expandRepo();
    // }
    //
    // private void expandRepo() {
    //     Person[] biggerRepo = Arrays.copyOf(repo, repo.length * 2);
    //     repo = biggerRepo;
    // }
    //
    // public void deleteByIndex(int index) {
    //     for(int i = index; i < repo.length - 2; i++)
    //         this.repo[i] = this.repo[i + 1];
    //     this.repo[this.repo.length - 1] = null;
    //     this.numberOfElements -= 1;
    // }

    // private PersonRepository search(Checker checker, Object value) {
    //     PersonRepository result = new PersonRepository();
    //     for (int i = 0; i < this.repo.length; i++)
    //         if (checker.check(this.repo[i], value))
    //             result.addPerson(repo[i]);
    //     return result;
    //
    //     public PersonRepository searchByLastName(String lastName) {
    //         return search(new LastNamePersonChecker(), lastName);
    //     }
    //
    //     public PersonRepository searchByAge(Integer age) {
    //         return search((p, a) -> p.getAge().equals(a), age);
    //     }
    //
    //     public PersonRepository searchByBirthDate(LocalDate date) {
    //         return search((p, a) -> p.getBirthday() != null && p.getBirthday().equals(a), date);
    //     }
    //
    // }

    /** // TODO: move to actual classes and del from here
     * uses comparators
     */
    // public void sort() {
    //     Sorter<T> bubbleSorter = new BubbleSorter<T>(); // TODO: read from application.properties
    //
    //     // sorter
    //     // comparator
    // }


    /** // TODO: move to actual classes and del from here
     * uses checkers
     */
    // public void search() {
    //
    // }
}
