package entities.person;
import org.joda.time.*;
import org.joda.time.format.*;

public class Person {
    int id;
    String lastName;
    LocalDate birthDate;

    public Person(int id, String last_name, int year, int month_of_year, int day_of_month) {
        this.id = id;
        this.birthDate = new LocalDate(year, month_of_year, day_of_month);
        this.lastName = last_name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public int getAge() {
        return Years.yearsBetween(this.birthDate, LocalDate.now()).getYears();
    }
}