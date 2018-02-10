package Tree;

public class Skip extends Stmt {
    @Override
    public Exp wp(Exp exp) {
        return exp;
    }
}
