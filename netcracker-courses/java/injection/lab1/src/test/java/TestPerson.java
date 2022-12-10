import Comparators.CompareByFirstName;
import Comparators.CompareById;
import Comparators.CompareByLastName;
import Person.Person;
import Person.Repository;
import SearchMethods.PersonBirthdayChecker;
import SearchMethods.PersonFirstNameChecker;
import SearchMethods.PersonIdChecker;
import SearchMethods.PersonLastNameChecker;
import org.joda.time.LocalDate;
import org.junit.*;
import java.util.Arrays;

import static org.junit.Assert.*;

public class TestPerson {
    @Test
    public void addPerson() throws Exception{
        Repository persons = new Repository();
        Person pers1= new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24");
        persons.add(pers1);
        System.out.println(persons.get(1));
        assertEquals(persons.get(1), pers1);
    }

    @Test
    public void sortById() throws Exception{
        Repository persons = new Repository();
        persons.add(new Person(2, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(3, "Donald", "Trump", "1946-06-14"));
        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(4, "Quentin", "Tarantino", "1963-03-27"));
        //Person[] pers = new Person[4];
        persons.sortById();
        Repository sortpersons = new Repository();
        sortpersons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        sortpersons.add(new Person(2, "Vladimir", "Putin", "1952-10-07"));
        sortpersons.add(new Person(3, "Donald", "Trump", "1946-06-14"));
        sortpersons.add(new Person(4, "Quentin", "Tarantino", "1963-03-27"));
        /*assertEquals(persons.get(1),sortpersons.get(1));
        assertEquals(persons.get(2),sortpersons.get(2));
        assertEquals(persons.get(3),sortpersons.get(3));
        assertEquals(persons.get(4),sortpersons.get(4));*/
        assertArrayEquals(persons.getRepository(),sortpersons.getRepository());
        //[] pers2 = new Person[4];
        //assertArrayEquals(pers,pers2);
        //for(int i=1; i == persons.getSize(); i++){
        //    assertEquals("Test sortById wrong",persons.get(i), sortpersons.get(i));
        //}
    }

    @Test
    public void sortByFirstName() throws Exception{
        Repository persons = new Repository();
        persons.add(new Person(4, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(2, "Donald", "Trump", "1946-06-14"));
        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(3, "Quentin", "Tarantino", "1963-03-27"));
        //Person[] pers = new Person[4];

        persons.sortByFirstName();
        Repository sortpersons = new Repository();
        sortpersons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        sortpersons.add(new Person(2, "Donald", "Trump", "1946-06-14"));
        sortpersons.add(new Person(3, "Quentin", "Tarantino", "1963-03-27"));
        sortpersons.add(new Person(4, "Vladimir", "Putin", "1952-10-07"));
        //Person[] pers2 = new Person[4];
        //persons.sort(persons.getRepository(),new CompareByFirstName());
        assertArrayEquals(persons.getRepository(),sortpersons.getRepository());
        /*assertEquals(persons.get(1),sortpersons.get(1));
        assertEquals(persons.get(2),sortpersons.get(2));
        assertEquals(persons.get(3),sortpersons.get(3));
        assertEquals(persons.get(4),sortpersons.get(4));*/
        //for(int i=1; i == persons.getSize(); i++){
        //    assertEquals("Test sortById wrong",persons.get(i), sortpersons.get(i));
        //}
    }
    @Test
    public void sortByLastName() throws Exception{
        Repository persons = new Repository();
        persons.add(new Person(4, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(2, "Donald", "Trump", "1946-06-14"));
        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(3, "Quentin", "Tarantino", "1963-03-27"));
        //Person[] pers = new Person[4];
        persons.sortByLastName();
        Repository sortpersons = new Repository();
        sortpersons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        sortpersons.add(new Person(4, "Vladimir", "Putin", "1952-10-07"));
        sortpersons.add(new Person(3, "Quentin", "Tarantino", "1963-03-27"));
        sortpersons.add(new Person(2, "Donald", "Trump", "1946-06-14"));
        assertArrayEquals(persons.getRepository(),sortpersons.getRepository());
        /*assertEquals(persons.get(1),sortpersons.get(1));
        assertEquals(persons.get(2),sortpersons.get(2));
        assertEquals(persons.get(3),sortpersons.get(3));
        assertEquals(persons.get(4),sortpersons.get(4));*/
        //Person[] pers2 = new Person[4];
        //persons.sort(persons.getRepository(),new CompareByLastName());
        //assertArrayEquals(pers,pers2);
        //for(int i=1; i == persons.getSize(); i++){
        //    assertEquals("Test sortById wrong",persons.get(i), sortpersons.get(i));
        //}
    }

    @Test
    public void sortByBirthday() throws Exception{
        Repository persons = new Repository();
        persons.add(new Person(4, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(2, "Donald", "Trump", "1946-06-14"));
        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(3, "Quentin", "Tarantino", "1963-03-27"));
        //Person[] pers = new Person[4];
        persons.sortByBirthday();
        Repository sortpersons = new Repository();
        sortpersons.add(new Person(2, "Donald", "Trump", "1946-06-14"));
        sortpersons.add(new Person(4, "Vladimir", "Putin", "1952-10-07"));
        sortpersons.add(new Person(3, "Quentin", "Tarantino", "1963-03-27"));
        sortpersons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        /*assertEquals(persons.get(1),sortpersons.get(1));
        assertEquals(persons.get(2),sortpersons.get(2));
        assertEquals(persons.get(3),sortpersons.get(3));
        assertEquals(persons.get(4),sortpersons.get(4));*/
        assertArrayEquals(persons.getRepository(),sortpersons.getRepository());
        //Person[] pers2 = new Person[4];
        //persons.sort(persons.getRepository(),new CompareByFirstName());
        //assertArrayEquals(pers,pers2);
        //for(int i=1; i == persons.getSize(); i++){
        //    Assert.assertEquals("Test sortById wrong",persons.get(i), sortpersons.get(i));
        //}
    }

    @Test
    public void removePerson() throws Exception{
        Repository persons = new Repository();
        Person[] pers1 = new Person[0];
        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.remove(1);
        Person[] pers2 = (Person[]) persons.getRepository();
        assertArrayEquals(pers1,pers2);
    }

    @Test
    public void searchPersonByFirstName() throws Exception{
        Repository persons = new Repository();
        Person[] pers1 = new Person[1];
        pers1[0] = new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24");

        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(2, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(3, "Donald", "Trump", "1946-06-14"));
        Person[] pers2 = new Person[1];
        pers2 = (Person[]) persons.search(new PersonFirstNameChecker(), "Dmitriy").getRepository();
        assertArrayEquals(pers1,pers2);
    }

    @Test
    public void searchPersonByLastName() throws Exception{
        Repository persons = new Repository();
        Person[] pers1 = new Person[1];
        pers1[0] = new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24");

        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(2, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(3, "Donald", "Trump", "1946-06-14"));
        Person[] pers2 = (Person[]) persons.search(new PersonLastNameChecker(), "Akhtirskiy").getRepository();
        assertArrayEquals(pers1,pers2);
    }

    @Test
    public void searchPersonById() throws Exception{
        Repository persons = new Repository();
        Person[] pers1 = new Person[1];
        pers1[0] = new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24");

        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(2, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(3, "Donald", "Trump", "1946-06-14"));
        Person[] pers2 = (Person[]) persons.search(new PersonIdChecker(), 1).getRepository();
        assertArrayEquals(pers1,pers2);
    }

    @Test
    public void searchPersonByByrthday() throws Exception{
        Repository persons = new Repository();
        Person[] pers1 = new Person[1];
        pers1[0] = new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24");

        persons.add(new Person(1, "Dmitriy", "Akhtirskiy", "1996-10-24"));
        persons.add(new Person(2, "Vladimir", "Putin", "1952-10-07"));
        persons.add(new Person(3, "Donald", "Trump", "1946-06-14"));
        Person[] pers2 = (Person[]) persons.search(new PersonBirthdayChecker(), new LocalDate(1996,10,24)).getRepository();
        assertArrayEquals(pers1,pers2);
    }
}