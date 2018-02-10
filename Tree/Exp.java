package Tree;

public abstract class Exp {
    abstract public void print();
    void print(OpExp.Op parent, OpExp.LR child) { print(); };
}
