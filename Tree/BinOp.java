package Tree;

public class BinOp extends Node {
    public enum Op {
	IMP, EQV, OR, AND,
	LT, LE, EQ, NE, GT, GE,
	PLUS, MINUS, TIMES, DIV
    }

    static private String[] opnames = {
	" => ", " <=> ", " or ", " and ",
	"<", "<=", "=", "!=", ">", ">=",
	"+", "-", "*", "/"
    };
    
    static private int[] precedence = {
	2, 2, 3, 4,
	6, 6, 6, 6, 6, 6,
	7, 7, 8, 8
    };
    
    private Node left;
    private Op op;
    private Node right;

    public BinOp(Node l, Op o, Node r) { left = l;  op = o;  right = r; }

    public void print() {
	left.print(precedence[op.ordinal()]);
	System.out.print(opnames[op.ordinal()]);
	right.print(precedence[op.ordinal()]);
    }

    public void print(int parent) {
	if (parent > precedence[op.ordinal()]) {
	    System.out.print('(');
	    print();
	    System.out.print(')');
	}
	else
	    print();
    }
}
