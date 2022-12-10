package Person;

import org.joda.time.LocalDate;

public class Person {
    private int id;
    private String FirstName, LastName;
    private LocalDate birthday;

    public Person(int id,String FirstName, String LastName, String birthday){
        this.id = id;
        this.FirstName = FirstName;
        this.LastName = LastName;
        this.birthday = strToDate(birthday);
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setName(String FirstName, String LastName) {
        this.FirstName = FirstName;
        this.LastName = LastName;
    }

    public String getFirstName() {
        return FirstName;
    }

    public String getLastName() {
        return LastName;
    }

    public int getAge(){
        return LocalDate.now().getYear() - birthday.getYear();
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public LocalDate strToDate(String date){
        return LocalDate.parse(date);
    }

    @Override
    public String toString() {
        return "Id = " + id +
                ", Name = '" + FirstName + " " + LastName + '\'' +
                ", Date of Birth = " + birthday.toString("dd MMMM yyyy");
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Person person = (Person) o;

        if (id != person.id) return false;
        if (FirstName != null ? !FirstName.equals(person.FirstName) : person.FirstName != null) return false;
        if (LastName != null ? !LastName.equals(person.LastName) : person.LastName != null) return false;
        return birthday != null ? birthday.equals(person.birthday) : person.birthday == null;
    }
}