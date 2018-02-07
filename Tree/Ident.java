package Tree;

public class Ident extends Node {
    private String name;

    public Ident(String n) { name = n; }

    public void print() {
	System.out.print(name);
    }
}
