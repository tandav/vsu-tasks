package Car;


public class Car {
    private int id;
    private String model;
    private String colour;

    public Car(int id, String model, String colour){
        this.id=id;
        this.model=model;
        this.colour=colour;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getColour() {
        return colour;
    }

    public void setColour(String colour) {
        this.colour = colour;
    }


}
