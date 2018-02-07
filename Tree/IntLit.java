package Tree;

public class IntLit extends Node {
    private int value;

    public IntLit(int v) { value = v; }

    public void print() {
	System.out.print(value);
    }
}
