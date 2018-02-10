package Tree;

public class While extends Stmt {

    private Exp mInvariant;
    private Exp mCondition;
    private Stmt mBody;

    public While(Exp invariant, Exp condition, Stmt body) {
        this.mInvariant = invariant;
        this.mCondition = condition;
        this.mBody = body;
    }

    @Override
    public Exp wp(Exp exp) {
        // mInvariant and not condition => end statement and
        // mInvariant and condition => mInvariantStmt
        // [{pre} => ] mInvariant
        OpExp notCondition = new OpExp(OpExp.Op.NOT, mCondition);
        // invariant and not condition
        OpExp ianc = new OpExp(mInvariant, OpExp.Op.AND, notCondition);
        OpExp endExp = new OpExp(ianc, OpExp.Op.IMP, exp);
        endExp.print();
        System.out.println();

        // invariant and condition
        OpExp iac = new OpExp(mInvariant, OpExp.Op.AND, mCondition);
        OpExp bodyExp = new OpExp(iac, OpExp.Op.IMP, mBody.wp(mInvariant));
        bodyExp.print();
        System.out.println();

        // {p} => {mInvariant}
        return mInvariant;
    }
}
