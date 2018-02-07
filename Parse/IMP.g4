grammar IMP;

@header {
    package Parse;
    import Tree.*;
}

program
    : pre=assertion statementlist post=assertion
		{
		    // FIXME: Print verification condition instead
		    $pre.tree.print();   System.out.println();
		    $post.tree.print();  System.out.println();
		}
    ;

statementlist
    : statement
    | statementlist ';' statement
    ;

statement
    : 'skip'
    | id ':=' arithexp
    | 'begin' statementlist 'end'
    | 'if' boolterm 'then' statement 'else' statement
    | assertion 'while' boolterm 'do' statement
		{ /* Print verification conditions */ }
    | 'assert' assertion
		{ /* Print verification condition */ }
    ;

assertion returns [Node tree]
    : '{' t=quantexp '}'
		{ $tree = $t.tree; }
    ;

quantexp returns [Node tree]
    : t=boolexp
		{ $tree = $t.tree; }
    | 'forall' id '.' boolexp
    | 'exists' id '.' boolexp
    ;

boolexp returns [Node tree]
    : t=boolterm
		{ $tree = $t.tree; }
    | boolterm '=>' boolterm
    | boolterm '<=>' boolterm
    ;

boolterm returns [Node tree]
    : t=boolterm2
		{ $tree = $t.tree; }
    | boolterm 'or' boolterm2
    ;

boolterm2 returns [Node tree]
    : t=boolfactor
		{ $tree = $t.tree; }
    | boolterm2 'and' boolfactor
    ;

boolfactor returns [Node tree]
    : 'true'
    | 'false'
    | compexp
		{ $tree = $compexp.tree; }
    | 'not' quantexp
    | '(' quantexp ')'
		{ $tree = $quantexp.tree; }
    ;

compexp returns [Node tree]
    : arithexp '<' arithexp
    | arithexp '<=' arithexp
    | t1=arithexp '=' t2=arithexp
		{ $tree = new BinOp($t1.tree, BinOp.Op.EQ, $t2.tree); }
    | arithexp '!=' arithexp
    | arithexp '>=' arithexp
    | arithexp '>' arithexp
    ;

arithexp returns [Node tree]
    : t=arithterm
		{ $tree = $t.tree; }
    | t1=arithexp '+' t2=arithterm
		{ $tree = new BinOp($t1.tree, BinOp.Op.PLUS, $t2.tree); }
    | t1=arithexp '-' t2=arithterm
		{ $tree = new BinOp($t1.tree, BinOp.Op.MINUS, $t2.tree); }
    ;

arithterm returns [Node tree]
    : t=arithfactor
		{ $tree = $t.tree; }
    | t1=arithterm '*' t2=arithfactor
		{ $tree = new BinOp($t1.tree, BinOp.Op.TIMES, $t2.tree); }
    | t1=arithterm '/' t2=arithfactor
		{ $tree = new BinOp($t1.tree, BinOp.Op.DIV, $t2.tree); }
    ;

arithfactor returns [Node tree]
    : id
		{ $tree = $id.name; }
    | integer
		{ $tree = $integer.value; }
    | '-' arithexp
    | '(' t=arithexp ')'
		{ $tree = $t.tree; }
    | id '(' arithexplist ')'
    ;

arithexplist
    : arithexp
    | arithexplist ',' arithexp
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
