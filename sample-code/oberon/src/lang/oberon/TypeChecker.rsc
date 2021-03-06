module lang::oberon::TypeChecker

import lang::oberon::AST;
import lang::util::Stack;
import lang::oberon::ExecutionContext;
import lang::oberon::Interpreter;
import List;
import Map;
import IO;

public Type typeOf(IntValue(v), ctx) = TInt();

public Type typeOf(BoolValue(v), ctx) = TBool();

public Type typeOf(Undefined(), ctx) = TUndef();

public Type typeOf(Add(lhs,rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Sub(lhs,rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Mult(lhs,rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Div(lhs,rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(And(lhs,rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TBool(), TBool()> : return TBool(); 
    default :  return TError();
  }
}

public Type typeOf(Or(lhs,rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TBool(), TBool()> : return TBool(); 
    default : return TError();
  }
}

public Type typeOf(Not(exp), ctx) {
  switch(<typeOf(exp,ctx)>) {
    case <TBool()> : return TBool(); 
    default : return TError();
  }
}

public Type typeOf(Gt(lhs, rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(Lt(lhs, rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(GoEq(lhs, rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(LoEq(lhs, rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(Eq(lhs, rhs), ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(VarRef(n), ctx) {
  if(n in top(ctx.heap)) {
  	return typeOf(top(ctx.heap)[n],ctx);
  }
  else if(n in ctx.global) {
  	return typeOf(ctx.global[n],ctx);
  }
  return TError(); 
}


//Statments TypeChecker

public bool wellTyped(WhileStmt(c,stmt), ctx){
	switch(<typeOf(c,ctx)>) {
	    case <TBool()> : return wellTyped(stmt,ctx); 
	    default : return false;
    }
}

public bool wellTyped(BlockStmt(list[Statement] stmts), ctx) { 
	m = [wellTyped(s,ctx) | s <- stmts];
	println(m);
	if(false in m){
		return false;
	}
	return true;
}

public bool wellTyped(IfStmt(c,stmt), ctx){
	switch(<typeOf(c,ctx)>) {
	    case <TBool()> : return true; 
	    default : return false;
    }
}

public bool wellTyped(IfElseStmt(c,stmtThen, stmtElse), ctx){
	switch(<typeOf(c,ctx)>) {
	    case <TBool()> : return true;
	    default : return false;
    }
}


public bool wellTyped(Print(e), ctx) {
  switch(<typeOf(e, ctx)>) {
    case <TBool()>: return true;
    case <TInt()>: return true;
    default : return false;
  }
}

public bool wellTyped(Return(e), ctx) {
  switch(<typeOf(e, ctx)>) {
    case <TBool()>: return true;
    case <TInt()>: return true;
    default : return false; 
  }
}  

public bool wellTyped(Assignment(n, e), ctx){
  switch(<typeOf(VarRef(n), ctx), typeOf(e, ctx)>) {
   case <TInt(), TInt()> : return true; 
    case <TBool(), TBool()> : return true;
    case <TUndef(), TUndef()>: return true;
    default : return false; 
  }
}


public bool wellTyped(VarDecl(v), ctx) {
  switch(<v.varType,typeOf(fromVar(v), ctx)>) {
   case <TInt(), TInt()> : return true; 
    case <TBool(), TBool()> : return true;
    case <TUndef(), TUndef()>: return true;
    case <TInt(), TUndef()>: return true;
    case <TBool(), TUndef()>: return true;
    default : return false;
  }
}



