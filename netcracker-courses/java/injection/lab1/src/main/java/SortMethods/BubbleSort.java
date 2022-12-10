package SortMethods;

import Interfaces.Comparator;
import Interfaces.InterfaceSorter;

/**
 * Сортировка пузырьком
 */
public class BubbleSort implements InterfaceSorter {
    public void sort(Object[] objects, Comparator comparator){
        for(int i = objects.length - 1; i > 0; i--){
            for(int j = 0; j < i; j++){
                if(comparator.compare(objects[j], objects[j+1])){
                    Object temp = objects[j];
                    objects[j] = objects[j+1];
                    objects[j+1] = temp;
                }
            }
        }
    }
}
