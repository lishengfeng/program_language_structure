package Tree;

public abstract class Stmt {

    Stmt() {
    }

    // The weakest(liberal pre-condition traversal
    public abstract Exp wp(Exp exp);
}
