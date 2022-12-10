package SortMethods;

import Interfaces.Comparator;
import Interfaces.InterfaceSorter;

/**
 * Сортировка вставками
 */
public class InsertionSort implements InterfaceSorter {
    public void sort(Object[] objects, Comparator comparator){
        for(int i = 1; i < objects.length; i++){
            for (int j=i; j>0 && comparator.compare(objects[j-1], objects[j]); j--){
                Object temp = objects[j];
                objects[j] = objects[j-1];
                objects[j-1] = temp;
            }
        }
    }
}
