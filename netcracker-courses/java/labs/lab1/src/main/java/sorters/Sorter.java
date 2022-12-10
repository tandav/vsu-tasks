package sorters;
import java.util.Comparator;

public interface Sorter<T> {
    void sort(T[] array, Comparator comparator);
}
