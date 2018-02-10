package Tree;

public class StmtList extends Stmt {

    private Stmt mStmt1;
    private Stmt mStmt2;

    public StmtList(Stmt stmt1, Stmt stmt2) {
        this.mStmt1 = stmt1;
        this.mStmt2 = stmt2;
    }

    @Override
    public Exp wp(Exp exp) {
        return mStmt1.wp(mStmt2.wp(exp));
    }
}
