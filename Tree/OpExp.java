package Tree;

public class OpExp extends Exp {
    public enum Op {
	IMP, EQV, OR, AND, NOT,
	LT, LE, EQ, NE, GT, GE,
	PLUS, MINUS, TIMES, DIV, UMINUS
    }
    enum LR { LEFT, RIGHT }

    static private String[] opnames = {
	" => ", " <=> ", " or ", " and ", "not ",
	"<", "<=", "=", "!=", ">", ">=",
	"+", "-", "*", "/", "-"
    };
    
    static private int[] precedence = {
	2, 2, 3, 4, 5,
	6, 6, 6, 6, 6, 6,
	7, 7, 8, 8, 9
    };
    
    private Exp left;
    private Op op;
    private Exp right;

    public OpExp(Op o, Exp r) { left = null;  op = o;  right = r; }

    public OpExp(Exp l, Op o, Exp r) { left = l;  op = o;  right = r; }

    public void print() {
	if (left != null)
	    left.print(op, LR.LEFT);
	System.out.print(opnames[op.ordinal()]);
	right.print(op, LR.RIGHT);
    }

    void print(Op parent, LR child) {
	if (precedence[parent.ordinal()] > precedence[op.ordinal()]
	    || (child == LR.RIGHT && parent == Op.MINUS && op == Op.MINUS)) {
	    System.out.print('(');
	    print();
	    System.out.print(')');
	}
	else
	    print();
    }
}
