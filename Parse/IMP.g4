grammar IMP;

@header {
    package Parse;
    import Tree.*;
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
    | 'if' boolterm 'then' statement 'else' statement
    | assertion 'while' boolterm 'do' statement
    | 'assert' assertion
    ;

assertion returns [Exp tree]
    : '{' t=boolexp '}'
		{ $tree = $t.tree; }
    ;

boolexp returns [Exp tree]
    : t=boolterm
		{ $tree = $t.tree; }
    | boolterm '=>' boolterm
    | boolterm '<=>' boolterm
    ;

boolterm returns [Exp tree]
    : t=boolterm2
		{ $tree = $t.tree; }
    | boolterm 'or' boolterm2
    ;

boolterm2 returns [Exp tree]
    : t=boolfactor
		{ $tree = $t.tree; }
    | boolterm2 'and' boolfactor
    ;

boolfactor returns [Exp tree]
    : 'true'
    | 'false'
    | compexp
		{ $tree = $compexp.tree; }
    | 'forall' id '.' boolexp
    | 'exists' id '.' boolexp
    | 'not' boolfactor
    | '(' t=boolexp ')'
		{ $tree = $t.tree; }
    ;

compexp returns [Exp tree]
    : arithexp '<' arithexp
    | arithexp '<=' arithexp
    | t1=arithexp '=' t2=arithexp
		{ $tree = new OpExp($t1.tree, OpExp.Op.EQ, $t2.tree); }
    | arithexp '!=' arithexp
    | arithexp '>=' arithexp
    | arithexp '>' arithexp
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
    | '(' t=arithexp ')'
		{ $tree = $t.tree; }
    | id '(' arithexplist ')'
    ;

arithexplist
    : arithexp
    | arithexp ',' arithexplist
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
