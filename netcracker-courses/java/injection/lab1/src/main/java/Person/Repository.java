package Person;

import Comparators.CompareByBirthday;
import Comparators.CompareByFirstName;
import Comparators.CompareById;
import Comparators.CompareByLastName;
import Config.Configurator;
import Interfaces.*;
import SearchMethods.PersonBirthdayChecker;
import SearchMethods.PersonFirstNameChecker;
import SearchMethods.PersonIdChecker;
import SearchMethods.PersonLastNameChecker;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.joda.time.LocalDate;
import java.util.Arrays;
import Person.Person;



public class Repository extends RepositoryAbstract<Person>{

    /*
    private static Logger LOGGER = LogManager.getLogger();
    private Person[] persons = new Person[1];
    private int size=0;
    private Configurator configurator = new Configurator();

    public void add(Person object) {
        if (size == 0) {
            size++;
            persons[0] = object;
        } else {
            Person[] newpersons =  Arrays.copyOf(this.persons, size+1);
            for (int i = 0; i < persons.length; i++)
                newpersons[i] = persons[i];
            newpersons[size] = object;
            size++;
            this.persons = newpersons;
        }
    }
    public void printList() {
        for (Person p : persons) {
            System.out.println(p);
        }
    }

    public void sort(Person[] objects, Comparator<Person> comparator){
        LOGGER.info("search");
        InterfaceSorter sorter= new Configurator().getSorter(configurator.config);
        sorter.sort(objects, comparator);
    }
    */
    public void sortByFirstName(){
        this.sort(this.getRepository(), new CompareByFirstName());
    }

    public void sortByLastName(){
        this.sort(this.getRepository(), new CompareByLastName());
    }

    public void sortById(){
        this.sort(this.getRepository(), new CompareById());
    }

    public void sortByBirthday(){
        this.sort(this.getRepository(), new CompareByBirthday());
    }

    public void searchById(int i){
        this.search(new PersonIdChecker(),i);
    }

    public void searchByFirstName(String name){
        this.search(new PersonFirstNameChecker(),name);
    }

    public void searchByLastName(String name){
        this.search(new PersonLastNameChecker(),name);
    }

    public void searchByBirthday(LocalDate date){
        this.search(new PersonBirthdayChecker(),date);
    }


    /*
    public void remove(int id) {
        System.arraycopy(persons, id, persons, id-1, size - id);
        persons[size - 1] = null;
        size--;
        this.persons = Arrays.copyOf(this.persons,size);
    }

    public Person get(int i) {
        return (Person) persons[i-1];
    }

    public Person[] getRepository() {
        return (Person[]) persons;
    }

    public Repository search(Checker<Person> comparator, Object object){
        LOGGER.info("search");
        Repository result = new Repository();
        for(int i=0; i<persons.length;i++){
            if (comparator.check((Person) persons[i], object)){
                result.add((Person) persons[i]);
                //System.out.println("Person "+ object +" is exist" );
            }
        }
        return result;
    }

    public int getSize() {
        return size;
    }
    */
}
