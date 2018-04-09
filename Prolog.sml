(* o operator - The function composition f o g denotes the function with the property that (f o g) (x) = f(g x) *)

exception non_unifiable and occurs_check and length;
(*
- pairup ([1,2],[3,4]);
val it = [(1,3),(2,4)] : (int * int) list
- pairup ([1,2,3],[4,5]);

uncaught exception length
*)
fun pairup (nil,nil) = nil
  | pairup (a::b,c::d) = (a,c)::(pairup (b,d))
  | pairup (_) = raise length; 

(*
- top empty (Var("x",0));
val it = Var ("x",0) : Term
- top empty (Fun("f",[Var("x",0)]));
val it = Fun ("f",[Var ("x",0)]) : Term
*)
fun top S (Var v) = S v 
    | top S (x) = x;

(*
- occurs ("x",0) (Var("x",0));
val it = true : bool
- occurs ("x",0) (Fun ("f", [Var("x",1),Var("x",0)]));
val it = true : bool
*)
fun occurs v (Var w) = (v = w)
  | occurs v (Fun (F, args)) = List.exists (occurs v) args; 

type Substitution = string * int -> Term

val empty: Substitution = fn x => Var x

(*
- val xTot: Substitution = fn x => if x = ("x", 0) then Var ("t", 0) else Var x
- value xTot (Var("x", 0));
val it = Var ("t",0) : Term
The logical printing depth in SML/NJ can be altered by evaluating Control.Print.printDepth := 20; (or however much you want) in the REPL
- value xTot (Fun("f_name",[Var("x",0),Var("x",1)]));
val it = Fun ("f_name",[Var ("t",0),Var ("x",1)]) : Term
*)
fun value (S:Substitution) (Var v) = S v
  | value (S:Substitution) (Fun (f, args)) = Fun(f, map(value S) args) 


(*
- fun S v = if v = ("X",0) then Var("t2", 0) else if v = ("Z",0) then Var ("t3", 0) else Var v
- fun R v = if v = ("X", 0) then Var("t1", 0) else if v = ("Y",0) then Var("Z",0) else Var v
- comp (S,R) ("Y",0);
val it = Var ("t3",0) : Term
*)
fun comp ((S:Substitution), (R:Substitution)) : Substitution = fn v => value S (R v)
                                                        

(*
- fun R v = if v = ("X", 0) then Var("t1", 0) else if v = ("Y",0) then Var("Z",0) else Var v
- upd (("Z",0), Var("t3",0)) R;
val it = fn : Substitution
*)
fun upd(v,t) S = comp (fn w => if w = v then t else Var w, S)

(* Unification *)


fun unify ((t1,t2), S) =
    let
      val t1' = top S t1 and t2' = top S t2;
    in
      case (t1', t2') of
          (Var v, Var w) => if (v=w) then S else upd(v,t2') S
        | (Var v, _) => if occurs v t2 then raise occurs_check else upd(v,t2') S
        | (_, Var w) => if occurs w t1 then raise occurs_check else upd(w,t1') S
        | (Fun (o1, tlist1), Fun (o2, tlist2)) => if o1=o2 then foldr unify S (pairup(tlist1,tlist2)) else raise non_unifiable
        handle occurs_check => raise non_unifiable
             | length => raise non_unifiable
    end;

(*
- change[5,2] 16;
val it = [5,5,2,2,2] : int list

exception Change;
fun change _ 0 = nil
  | change nil _ = raise Change
  | change (coin::coins) amt =
    if coin > amt then change coins amt
    else
      (coin :: change (coin:: coins) (amt-coin))
      handle Change => change coins amt;
*)

fun collVar ((Var term)::terms) = ((Var term) :: collVar terms)
  | collVar ((Fun (s, nil))::terms) = (collVar terms)
  | collVar ((Fun (s, l))::terms) = (collVar l @ collVar terms)
  | collVar nil = nil
    

fun solve (y as term::terms, (Headed rule)::rules) =
    (
      (* OutLine ("rule: " ^ PrintClause (Headed rule)); *)
      let
        val (conclusion, provisos) = rule
        val S = value (unify((term, conclusion), empty))
        val oriVar = collVar y
        val res = pairup(oriVar,(map S oriVar))
      in
        (*
        OutLine ("conclusion: " ^ PrintTerm conclusion);
        OutLine ("provisos: " ^ PrintList provisos);
        OutLine ("oriVar: " ^ PrintList oriVar);
        *)
        OutSol res        
      end
      handle non_unifiable => (solve(y, rules))
    )              
  | solve (_, []) = OutLine("no impletement yet")
  | solve ([], _) = OutLine("no impletement yet")
  | solve (_, _) = OutLine("no impletement yet")

fun OutQuery ((y:Term list), l)  =
    (
      (* OutLine ("y: " ^ PrintList y ^ "\n"); *)
      solve(y, l)
    )
      

(*
val it = Headless [Var ("a",1),Var ("b",2)] : HornClause
val it = Headed (Var ("a",1),[Var (#,#),Var (#,#)]) : HornClause
- Prolog (parse "p(a,b,c).");
- Prolog (parse "p(e,d,f).");
- Prolog (parse "a(X,f(X)):-b(X).");
- parse "p(A,B,C)?";
val it = Headless [Fun ("p",[Var ("A",0),Var ("B",0),Var ("C",0)])]
  : PrologParser.result
- parse "p(a,b,c).";
val it = Headed (Fun ("p",[Fun ("a",[]),Fun ("b",[]),Fun ("c",[])]),[])
  : PrologParser.result
- !db;
val it = [Headed (Fun ("p",[Fun ("a",[]),Fun ("b",[]),Fun ("c",[])]),[])]
  : HornClause list
- !db
val it =
  [Headed (Fun ("p",[Fun ("a",[]),Fun ("b",[]),Fun ("c",[])]),[]),
   Headed (Fun ("p",[Fun ("c",[]),Fun ("d",[]),Fun ("e",[])]),[]),
   Headed
     (Fun ("a",[Var ("X",0),Fun ("f",[Var ("X",0)])]),
      [Fun ("b",[Var ("X",0)])])] : HornClause list
*)
fun Prolog (x as (Headed (Var _, _))) =
    OutLine ("Illegal clause:  " ^ PrintClause x)
  | Prolog (x as (Headless (Var _ :: _))) =
    OutLine ("Illegal clause:  " ^ PrintClause x)
  | Prolog (Headed (Fun ("init", nil),nil)) = InitDB ()
  | Prolog (x as (Headed _)) = Assert x
  | Prolog (x as Headless y) =
    (OutLine ("query:  " ^ PrintClause x);
     (* OutLine ("query not yet implemented") *)
     OutQuery (y, !db)
    )
        
