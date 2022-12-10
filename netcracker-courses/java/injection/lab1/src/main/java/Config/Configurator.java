package Config;

import Interfaces.Comparator;
import Interfaces.InterfaceSorter;
import SortMethods.*;

public class Configurator {

    //public String config;
    //private static Logger LOGGER = LogManager.getLogger();

    //private int config;
    //public static Configurator configurator;


    /**
     * Чтение типа сортировки из файла
     */
    /*public Configurator(){
        try{
            Properties prop = new Properties();
            prop.load(new FileInputStream(new File("D:\\Programming\\lab1git\\lab1\\src\\main\\resources\\config.properties")));
            config = prop.getProperty("sort");
        }
        catch (IOException e){
            System.out.println("Файл не найден");;
            LOGGER.catching(e);
        }
    }*/

    /**
     * Получение типа сортировки
     * @param config - нужный тип сортировки
     * @return - тип сортировки, который будет использоваться
     */
    /*public InterfaceSorter getSorter(String config){
        InterfaceSorter sorter = null;
        if (config.equals("bubble")){
            sorter = new BubbleSort();
        }
        else if (config.equals("insertion")){
            sorter = new InsertionSort();
        }
        return sorter;
    }*/

    @AutoInjectable
    private InterfaceSorter sorter;
    /*
    public  Object[] sort(Object[] arr, Comparator personComparator){

        return sorter.sort(arr,personComparator);
    }*/

    public void sort(Object[] arr, Comparator comparator){
        sorter.sort(arr,comparator);
    }
}
