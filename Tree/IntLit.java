package Tree;

public class IntLit extends Exp {
    private int value;

    public IntLit(int v) { value = v; }

    public void print() {
	System.out.print(value);
    }

    @Override
    public Exp substitute(Ident ident, Exp exp) {
        // Do not change integer
        return this;
    }
}
