package Tree;

public class Ident extends Exp {
    String name;

    public Ident(String n) { name = n; }

    public void print() {
	System.out.print(name);
    }

    @Override
    public Exp substitute(Ident ident, Exp exp) {
        // Only when the ident is the same, swap the value
        // Otherwise x+y=1 will into something like 1+1=1
        if (name.equals(ident.name)) {
            return exp;
        } else {
            return this;
        }
    }
}
