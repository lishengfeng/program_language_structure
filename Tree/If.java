package Tree;

public class If extends Stmt {

    private Exp mCondition;
    private Stmt mThenStmt;
    private Stmt mElseStmt;

    public If(Exp condition, Stmt thenStmt, Stmt elseStmt) {
        this.mCondition = condition;
        this.mThenStmt = thenStmt;
        this.mElseStmt = elseStmt;
    }

    @Override
    public Exp wp(Exp exp) {
        // if mCondition then mThenStmt else mElseStmt
        // [{pre} => ](mCondition => mThenStmtExp) and (!mCondition =>
        // mElseStmtExp}
        OpExp notCondition = new OpExp(OpExp.Op.NOT, mCondition);
        OpExp elseExp = new OpExp(notCondition, OpExp.Op.IMP, mElseStmt.wp(exp));
        OpExp thenExp = new OpExp(mCondition, OpExp.Op.IMP, mThenStmt.wp(exp));
        OpExp wholeExp = new OpExp(thenExp, OpExp.Op.AND, elseExp);
        return wholeExp;
    }
}
