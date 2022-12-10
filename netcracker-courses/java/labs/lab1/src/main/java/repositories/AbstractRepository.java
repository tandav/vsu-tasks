package repositories;
import sorters.BubbleSorter;
import sorters.Sorter;
import java.lang.reflect.Array;
import java.util.Arrays;

/**
 * abstract class for repository
 * @param <T> class of elements in the repo
 */
public abstract class AbstractRepository<T> implements Repository<T> {
    private int numberOfElements = 0;
    private T[] repo;


    /**
     * Constructor
     * @param elementType type of elements to store in repo
     * @param initialLength initial length of repo
     */
    public AbstractRepository(Class<T> elementType, int initialLength) {
        T[] tempRepo = (T[]) Array.newInstance(elementType, initialLength);
        this.repo = tempRepo;
    }


    /**
     * Constructor with initial length = 16
     * @param elementType type of elements to store in repo
     */
    public AbstractRepository(Class<T> elementType) {
        this(elementType, 16);
    }


    /**
     * add an element to repository
     * @param element an element to be added
     */
    public void add(T element) {
        if (this.numberOfElements == this.repo.length)
            this.expand();
        this.repo[numberOfElements] = element;
        this.numberOfElements += 1;
    }


    /**
     * deletes an element from repo by given index
     * @param index an index of element to be deleted
     */
    public void delete(int index) {
        if (index < this.repo.length) {
            System.arraycopy(this.repo, index + 1, this.repo, index, this.repo.length - 1 - index);
            this.repo[this.repo.length - 1] = null;
            this.numberOfElements--;
        }
        else {
            System.out.println("index is outside of repository length"); // TODO: use logger
        }
    }


    /**
     *
     * @param index
     * @return element of repo by given index
     */
    public T get(int index) {
        if (index < this.repo.length) {
            return (T) this.repo[index];
            // return this.repo[index]; // TODO: try this line
        } else {
            System.out.println("This index bigger than repository capacity");
            return null;
        }
    }


    /**
     * expands repo when it is full
     */
    private void expand() {
        this.repo = Arrays.copyOf(this.repo, this.repo.length * 2);
    }

}
