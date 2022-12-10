package Interfaces;
import Config.Configurator;
import Person.Person;
import Person.Repository;
import SortMethods.AutoInjectable;
import SortMethods.Injector;
import SortMethods.SorterConf;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.util.Arrays;


public abstract class RepositoryAbstract<T> implements RepositoryInterface<T>{

    //@AutoInjectable
    //private InterfaceSorter sorter;
    private Object[] persons = new Object[1];
    private int size=0;
    private Configurator configurator = new Configurator();
    //private static Logger LOGGER = LogManager.getLogger();
    private Object[] repository;

    /**
     * Добавление объекта в репозиторий
     * @param object - объект, который надо добавить
     */
    @Override
    public void add(Object object) {
        //LOGGER.info("add");
        if (size == 0) {
            //persons = Arrays.copyOf(this.persons, size+1);
            size++;

            persons[0] = object;
        } else {
            //T[] newpersons = new T[size + 1];
            Object[] newpersons =  Arrays.copyOf(this.persons, size+1);
            for (int i = 0; i < persons.length; i++)
                newpersons[i] = persons[i];
            newpersons[size] = object;
            size++;
            this.persons = newpersons;
        }
    }

    /**
     * Удаление объекта из репозитория
     * @param id - id того объекта
     */
    @Override
    public void remove(int id) {
        //LOGGER.info("remove");
        System.arraycopy(persons, id, persons, id-1, size - id);
        persons[size - 1] = null;
        size--;
    }

    /**
     * Вывод на экран массива всех объектов
     */
    @Override
    public void printList() {
        for (Object p : persons) {
            System.out.println(p);
        }
    }

    /**
     * Сортировка массива объектов
     * @param objects - массив объектов
     * @param comparator - компоратор, указывающий по чем сортировать
     */
    @Override
    public void sort(Object[] objects, Comparator comparator){
        //LOGGER.info("sort");
        //InterfaceSorter sorter= new Configurator().getSorter(configurator.config);
        SorterConf sorterConf = new Injector().inject(new SorterConf());
        //sorter.sort(objects, comparator);
        sorterConf.sort(objects, comparator);
    }

    /**
     * Выбор одного элемента
     * @param i - индест этого элемента
     * @return - возвращаемый объект
     */
    @Override
    public T get(int i) {
        return (T) persons[i-1];
    }

    /**
     * Возвращение всех объектов
     * @return - все объекты
     */
    @Override
    public Object[] getRepository() {
        //return (Person[]) persons;
        return this.persons;
    }

    /**
     * Получание размера массива объектов
     * @return - размер массива объектов
     */
    @Override
    public int getSize() {
        return size;
    }

    /**
     * Поиск объекта по заданным параметрам
     * @param comparator - компаратор, указывающий метод поиска
     * @param object - объект поиска
     * @return найденный элемент
     */
    @Override
    public Repository search(Checker<Person> comparator, Object object){
        //LOGGER.info("search");
        Repository result = new Repository();
        for(int i=0; i<persons.length;i++){
            if (comparator.check((Person) persons[i], object)){
                result.add((Person) persons[i]);
                //System.out.println("Person "+ object +" is exist" );
            }
        }
        return result;
    }

}
