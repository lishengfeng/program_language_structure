package Tree;

import java.util.LinkedList;

public class CallExp extends Exp {

    private Ident mId;
    private LinkedList<Exp> mLinkedList;

    public CallExp(Ident ident, LinkedList<Exp> linkedList) {
        this.mId = ident;
        this.mLinkedList = linkedList;
    }

    @Override
    public void print() {
        System.out.print(mId.name.concat("("));
        int size = mLinkedList.size();
        for (int i = 0; i < size; i++) {
            mLinkedList.get(i).print();
            if (i < size - 1) {
                System.out.print(", ");
            }
        }
        System.out.print(")");
    }

    @Override
    public Exp substitute(Ident ident, Exp exp) {
        LinkedList<Exp> newList = new LinkedList<>();
        if (mLinkedList.size() == 0) {
            return null;
        }
        for (Exp aMLinkedList : mLinkedList) {
            newList.add(aMLinkedList.substitute(ident, exp));
        }
        return new CallExp(mId, newList);
    }
}
