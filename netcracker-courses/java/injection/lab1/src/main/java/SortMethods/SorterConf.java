package SortMethods;

import Interfaces.Comparator;
import Interfaces.InterfaceSorter;

public class SorterConf {

    @AutoInjectable
    private InterfaceSorter sorter;

    public void sort(Object[] arr, Comparator comparator){
        sorter.sort(arr,comparator);
    }

}
