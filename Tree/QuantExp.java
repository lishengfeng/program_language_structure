package Tree;

public class QuantExp extends Exp {

    private Ident mId;
    private Exp mBoolExp;
    private Quantum mQuantum;

    public enum Quantum {
        ALL, EXISTS
    }

    private static final String[] Q_NAMES = {
            "forall", "exists"
    };

    public QuantExp(Ident ident, Quantum quantum, Exp exp) {
        this.mId = ident;
        this.mQuantum = quantum;
        this.mBoolExp = exp;
        // Add $ prefix
        // only if name not start with "$"
        // otherwise when calling substitute it will new QuantExp and
        // add one more "$"
        if (!mId.getName().startsWith("$")) {
            this.mId.setName("$".concat(mId.getName()));
            this.mBoolExp.substitute(ident, mId);
        }
    }

    @Override
    public void print() {
        StringBuilder sb = new StringBuilder(Q_NAMES[mQuantum.ordinal()]);
        sb.append(" ").append(mId.name).append(".");
        System.out.print(sb.toString());
        mBoolExp.print();
    }

    @Override
    public Exp substitute(Ident ident, Exp exp) {
        return new QuantExp(mId, mQuantum, mBoolExp.substitute(ident, exp));
    }
}
