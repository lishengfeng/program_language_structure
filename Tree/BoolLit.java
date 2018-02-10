package Tree;

public class BoolLit extends Exp {
    private boolean value;

    public BoolLit(boolean v) {
        this.value = v;
    }

    @Override
    public void print() {
        System.out.print(value ? "true" : "false");
    }

    @Override
    public Exp substitute(Ident ident, Exp exp) {
        return this;
    }
}
