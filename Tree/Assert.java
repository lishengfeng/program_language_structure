package Tree;

public class Assert extends Stmt {

    private Exp mAssert;

    public Assert(Exp anAssert) {
        this.mAssert = anAssert;
    }

    @Override
    public Exp wp(Exp exp) {
        Exp assertExp = new OpExp(mAssert, OpExp.Op.IMP, exp);
        assertExp.print();
        System.out.println();
        return mAssert;
    }
}
