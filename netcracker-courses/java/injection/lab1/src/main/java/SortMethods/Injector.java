package SortMethods;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.Properties;

public class Injector {

    private Properties properties;

    public Injector() {
        this.properties = new Properties();

        FileInputStream inputStream = null;
        try {
            inputStream = new FileInputStream("/Users/tandav/Documents/netcracker-courses/java/injection/lab1/src/main/resources/config.properties");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        try {
            if (inputStream != null) {
                properties.load(inputStream);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    public <T> T inject(T object) {
        for (Field field : object.getClass().getDeclaredFields()){
            field.setAccessible(true);

            if (field.isAnnotationPresent(AutoInjectable.class)){
                try {
                    String typeName = field.getType().getName();
                    String implementationType = properties.getProperty(typeName);
                    Object implementationObject = Class.forName(implementationType).newInstance();
                    field.set(object, implementationObject);
                } catch (ClassNotFoundException | IllegalAccessException | InstantiationException e) {
                    e.printStackTrace();
                }
            }
        }

        return object;
    }
}
