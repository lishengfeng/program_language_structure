(* Unification *)

exception non_unifiable;

(* o operator - The function composition f o g denotes the function with the property that (f o g) (x) = f(g x) *)

type Substitution = string * int -> Term

val empty: Substitution = fn x => Var x

fun value (S:Substitution) (Var v) = S v
  | value (S:Substitution) (Fun (f, args)) = Fun(f, map(value S) args) 

(*
val xTot: Substitution = fn x => if x = ("x", 0) then Var ("t", 0) else Var x
value xTot (Var("x", 0));
:val it = Var ("t",0) : Term
The logical printing depth in SML/NJ can be altered by evaluating Control.Print.printDepth := 20; (or however much you want) in the REPL
value xTot (Fun("f_name",[Var("x",0),Var("x",1)]));
:val it = Fun ("f_name",[Var ("t",0),Var ("x",1)]) : Term
*)

fun comp ((S:Substitution), (R:Substitution)) : Substitution = fn v => value S (R v)
                                                        
(*
fun S v = if v = ("X",0) then Var("t2", 0) else if v = ("Z",0) then Var ("t3", 0) else Var v
fun R v = if v = ("X", 0) then Var("t1", 0) else if v = ("Y",0) then Var("Z",0) else Var v
comp (S,R) ("Y",0);
val it = Var ("t3",0) : Term
*)

fun upd(v,t) S = comp (fn w => if w = v then t else Var w, S)
(*
fun R v = if v = ("X", 0) then Var("t1", 0) else if v = ("Y",0) then Var("Z",0) else Var v
upd (("Z",0), Var("t3",0)) R;
:val it = fn : Substitution
*)

exception Change;
fun change _ 0 = nil
  | change nil _ = raise Change
  | change (coin::coins) amt =
    if coin > amt then change coins amt
    else
      (coin :: change (coin:: coins) (amt-coin))
      handle Change => change coins amt;
(*
change[5,2] 16;
:val it = [5,5,2,2,2] : int list
*)

fun Prolog (x as (Headed (Var _, _))) =
    OutLine ("Illegal clause:  " ^ PrintClause x)
  | Prolog (x as (Headless (Var _ :: _))) =
    OutLine ("Illegal clause:  " ^ PrintClause x)
  | Prolog (Headed (Fun ("init", nil),nil)) = InitDB ()
  | Prolog (x as (Headed _)) = Assert x
  | Prolog (x as Headless y) =
    (OutLine ("query:  " ^ PrintClause x);
     OutLine ("query not yet implemented")
     (* OutQuery (y, !db) *)
    )
        
