package repositories;

public interface Repository<T> {
    public void add(T t);
    public void delete(int index);
    public T get(int index);
}