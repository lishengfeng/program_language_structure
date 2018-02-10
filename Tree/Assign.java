package Tree;

public class Assign extends Stmt {

    private Ident mIdent;
    private Exp mExp;

    public Assign(Ident ident, Exp exp) {
        this.mIdent = ident;
        this.mExp = exp;
    }
    @Override
    public Exp wp(Exp exp) {
        return exp.substitute(mIdent, mExp);
    }
}
