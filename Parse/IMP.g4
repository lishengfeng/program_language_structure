grammar IMP;

@header {
    package Parse;
    import Tree.*;
    import java.util.LinkedList;
}

program
    : pre=assertion stmtlist=statementlist post=assertion
		{
            Exp exp = new OpExp($pre.tree, OpExp.Op.IMP, $stmtlist.stmt.wp($post.tree));
            exp.print();
            System.out.println();
		}
    ;

statementlist returns [Stmt stmt]
    : s=statement
        {
            $stmt=$s.stmt;
        }
    | s=statement ';' stmtList=statementlist
        {
            $stmt=new StmtList($s.stmt, $stmtList.stmt);
        }
    ;

statement returns [Stmt stmt]
    : 'skip'
        {
            $stmt = new Skip();
        }
    | i=id ':=' a=arithexp
        {
            $stmt = new Assign($i.name, $a.tree);
        }
    | 'begin' statementlist 'end'
        {
            $stmt = $statementlist.stmt;
        }
    | 'if' b=boolterm 'then' s1=statement 'else' s2=statement
        {
            $stmt = new If($b.tree, $s1.stmt, $s2.stmt);
        }
    | assertion 'while' boolterm 'do' statement
        {
            $stmt = new While($assertion.tree, $boolterm.tree, $statement.stmt);
        }
    | 'assert' assertion
        {
            $stmt = new Assert($assertion.tree);
        }
    ;

assertion returns [Exp tree]
    : '{' t=boolexp '}'
		{ $tree = $t.tree; }
    ;

boolexp returns [Exp tree]
    : t=boolterm
		{ $tree = $t.tree; }
    | bt=boolterm '=>' bt2=boolterm
		{
            $tree = new OpExp($bt.tree, OpExp.Op.IMP, $bt2.tree);
        }
    | bt=boolterm '<=>' bt2=boolterm
		{
            $tree = new OpExp($bt.tree, OpExp.Op.EQV, $bt2.tree);
        }
    ;

boolterm returns [Exp tree]
    : t=boolterm2
		{ $tree = $t.tree; }
    | bt=boolterm 'or' bt2=boolterm2
		{
            $tree = new OpExp($bt.tree, OpExp.Op.OR, $bt2.tree);
        }
    ;

boolterm2 returns [Exp tree]
    : t=boolfactor
		{ $tree = $t.tree; }
    | bt=boolterm2 'and' bf=boolfactor
		{
            $tree = new OpExp($bt.tree, OpExp.Op.AND, $bf.tree);
        }
    ;

boolfactor returns [Exp tree]
    : 'true'
        {
            $tree = new BoolLit(true);
        }
    | 'false'
        {
            $tree = new BoolLit(false);
        }
    | compexp
		{ $tree = $compexp.tree; }
    | 'forall' id '.' boolexp
        {
            $tree = new QuantExp($id.name, QuantExp.Quantum.ALL, $boolexp.tree);
        }
    | 'exists' id '.' boolexp
        {
            $tree = new QuantExp($id.name, QuantExp.Quantum.EXISTS, $boolexp.tree);
        }
    | 'not' boolfactor
        {
            $tree = new OpExp(OpExp.Op.NOT, $boolfactor.tree);
        }
    | '(' t=boolexp ')'
		{ $tree = $t.tree; }
    ;

compexp returns [Exp tree]
    : t1=arithexp '<' t2=arithexp
		{ $tree = new OpExp($t1.tree, OpExp.Op.LT, $t2.tree); }
    | t1=arithexp '<=' t2=arithexp
		{ $tree = new OpExp($t1.tree, OpExp.Op.LE, $t2.tree); }
    | t1=arithexp '=' t2=arithexp
		{ $tree = new OpExp($t1.tree, OpExp.Op.EQ, $t2.tree); }
    | t1=arithexp '!=' t2=arithexp
		{ $tree = new OpExp($t1.tree, OpExp.Op.NE, $t2.tree); }
    | t1=arithexp '>=' t2=arithexp
		{ $tree = new OpExp($t1.tree, OpExp.Op.GE, $t2.tree); }
    | t1=arithexp '>' t2=arithexp
		{ $tree = new OpExp($t1.tree, OpExp.Op.GT, $t2.tree); }
    ;

arithexp returns [Exp tree]
    : t=arithterm
		{ $tree = $t.tree; }
    | t1=arithexp '+' t2=arithterm
		{ $tree = new OpExp($t1.tree, OpExp.Op.PLUS, $t2.tree); }
    | t1=arithexp '-' t2=arithterm
		{ $tree = new OpExp($t1.tree, OpExp.Op.MINUS, $t2.tree); }
    ;

arithterm returns [Exp tree]
    : t=arithfactor
		{ $tree = $t.tree; }
    | t1=arithterm '*' t2=arithfactor
		{ $tree = new OpExp($t1.tree, OpExp.Op.TIMES, $t2.tree); }
    | t1=arithterm '/' t2=arithfactor
		{ $tree = new OpExp($t1.tree, OpExp.Op.DIV, $t2.tree); }
    ;

arithfactor returns [Exp tree]
    : id
		{ $tree = $id.name; }
    | integer
		{ $tree = $integer.value; }
    | '-' arithfactor
        {
            $tree = new OpExp(OpExp.Op.UMINUS, $arithfactor.tree);
        }
    | '(' t=arithexp ')'
		{ $tree = $t.tree; }
    | id '(' arithexplist ')'
        {
            $tree = new CallExp($id.name, $arithexplist.list);
        }
    ;

arithexplist returns [LinkedList list]
    : arithexp
        {
            $list = new LinkedList<Exp>();
            $list.addFirst($arithexp.tree);
        }
    | arithexp ',' arithexplist
        {
            $list = $arithexplist.list;
            $list.addFirst($arithexp.tree);
        }
    ;

id returns [Ident name]
    : IDENT
		{ $name = new Ident($IDENT.text); }
    ;

integer returns [IntLit value]
    : INT
		{ $value = new IntLit(Integer.parseInt($INT.text)); }
    ;


IDENT
    : [A-Za-z][A-Za-z0-9_]*
    ;

INT
    : [0]|[1-9][0-9]*
    ;

WS
    : [ \r\n\t] -> skip
    ;
