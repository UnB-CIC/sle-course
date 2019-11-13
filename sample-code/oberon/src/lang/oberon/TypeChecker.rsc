module lang::oberon::TypeChecker

import lang::oberon::AST;
import lang::util::Stack;
import lang::oberon::ExecutionContext;
import lang::oberon::Interpreter;
import lang::util::List;
import List;
import Map;
import IO;



public Type typeOf(IntValue(v), Context ctx) = TInt();

public Type typeOf(BoolValue(v), Context ctx) = TBool();

public Type typeOf(Undefined(), Context ctx) = TUndef();

public Type typeOf(Add(lhs,rhs), Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Sub(lhs,rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Mult(lhs,rhs), Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Div(lhs,rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(And(lhs,rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TBool(), TBool()> : return TBool(); 
    default :  return TError();
  }
}

public Type typeOf(Or(lhs,rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TBool(), TBool()> : return TBool(); 
    default : return TError();
  }
}

public Type typeOf(Not(exp),Context ctx) {
  switch(<typeOf(exp,ctx)>) {
    case <TBool()> : return TBool(); 
    default : return TError();
  }
}

public Type typeOf(Gt(lhs, rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(Lt(lhs, rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(GoEq(lhs, rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(LoEq(lhs, rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(Eq(lhs, rhs),Context ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(VarRef(n),Context ctx) {
  if(n in top(ctx.heap)) {
  	return typeOf(top(ctx.heap)[n],ctx);
  }
  else if(n in ctx.global) {
  	return typeOf(ctx.global[n],ctx);
  }
  return TError(); 
}


//Statments TypeChecker

public bool wellTyped(WhileStmt(c,stmt),Context ctx){
	switch(<typeOf(c,ctx)>) {
	    case <TBool()> : return wellTyped(stmt,ctx); 
	    default : return false;
    }
}

public bool wellTyped(BlockStmt(list[Statement] stmts), Context ctx) = (true|wellTyped(s, ctx) && it |s <- stmts);
//and([wellTyped(s,ctx) | s <- stmts]);


public bool wellTyped(IfStmt(c,stmt),Context ctx){
	switch(<typeOf(c,ctx)>) {
	    case <TBool()> : return true; 
	    default : return false;
    }
}

public bool wellTyped(IfElseStmt(c,stmtThen, stmtElse),Context ctx){
	switch(<typeOf(c,ctx)>) {
	    case <TBool()> : return true;
	    default : return false;
    }
}


public bool wellTyped(Print(e),Context ctx) {
  switch(<typeOf(e, ctx)>) {
    case <TBool()>: return true;
    case <TInt()>: return true;
    default : return false;
  }
}

public bool wellTyped(Return(e),Context ctx) {
  switch(<typeOf(e, ctx)>) {
    case <TBool()>: return true;
    case <TInt()>: return true;
    default : return false; 
  }
}  

public bool wellTyped(Assignment(n, e),Context ctx){
  switch(<typeOf(VarRef(n), ctx), typeOf(e, ctx)>) {
   case <TInt(), TInt()> : return true; 
    case <TBool(), TBool()> : return true;
    case <TUndef(), TUndef()>: return true;
    default : return false; 
  }
}


public bool wellTyped(VarDecl(v),Context ctx) {
  switch(<v.varType,typeOf(fromVar(v), ctx)>) {
   case <TInt(), TInt()> : return true; 
    case <TBool(), TBool()> : return true;
    case <TUndef(), TUndef()>: return true;
    case <TInt(), TUndef()>: return true;
    case <TBool(), TUndef()>: return true;
    default : return false;
  }
}

//public bool wellTyped(Parameters(list[Parameter] pmts),Context ctx) = (true|wellTyped(p, ctx) && it |p <- pmts);

public bool wellTyped(Parameter(n,t),Context ctx) {
	switch(t){
	case TBool(): return true;
    case TInt(): return true;
    default : return false; 

	}
}

public bool wellTyped(pmts, Context ctx) = (true| wellTyped(p, ctx) && it | p <- pmts);


public bool wellTyped(FDecl(t, n, args, block), Context ctx) {
	return wellTyped(t, ctx) && wellTyped(args, ctx) && wellTyped(block, ctx); 
}

public bool wellTyped(TInt(), Context ctx)   = true;
public bool wellTyped(TBool(), Context ctx)  = true;
public bool wellTyped(TUndef(), Context ctx) = true;
public bool wellTyped(TError(), Context ctx) = false; 


//public bool wellTyped(OberonProgram(list[Variable] vars, list[FDecl] fns, Statement block)){
//	switch(<wellTyped(FDecl(rt),ctx), wellTyped(a,ctx), wellTyped(b,ctx)>) {
//	    case <TBool(), true, true> : return true; 
//	    case <TInt(), true, true> : return true; 
//	    default : return false;
//    }
//}

//public Expression eval(Invoke(n, pmts), Context ctx){
//  FDecl f = lookup(n, ctx.fnDecls);
//  ctx = notifyInvoke((a.pmtName : eval(b, ctx) | <a,b> <- zip(f.args, pmts)), ctx);
//  ctx = execute(f.block, ctx);
//  exp = top(ctx.heap)["return"];
//  ctx = notifyReturn(ctx);
//  return exp;
//}

