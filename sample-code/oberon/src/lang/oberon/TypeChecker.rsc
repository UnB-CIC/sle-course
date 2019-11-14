module lang::oberon::TypeChecker

import lang::oberon::AST;
import lang::util::Stack;
import lang::oberon::Context;
import lang::oberon::Interpreter;
import List;
import Map;
import IO;

/**
 * The function typeOf returns the type of an 
 * expression in a given type context. 
 */ 

public Type typeOf(IntValue(v), Context[Type] ctx) = TInt();

public Type typeOf(BoolValue(v), Context[Type] ctx) = TBool();

public Type typeOf(Undefined(), Context[Type] ctx) = TUndef();

public Type typeOf(Add(lhs,rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Sub(lhs,rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Mult(lhs,rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(Div(lhs,rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type typeOf(And(lhs,rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TBool(), TBool()> : return TBool(); 
    default :  return TError();
  }
}

public Type typeOf(Or(lhs,rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TBool(), TBool()> : return TBool(); 
    default : return TError();
  }
}

public Type typeOf(Not(exp), Context[Type] ctx) {
  switch(typeOf(exp, ctx)) {
    case TBool() : return TBool(); 
    default : return TError();
  }
}

public Type typeOf(Gt(lhs, rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(Lt(lhs, rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(GoEq(lhs, rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(LoEq(lhs, rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(Eq(lhs, rhs), Context[Type] ctx) {
  switch(<typeOf(lhs, ctx), typeOf(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type typeOf(VarRef(n), Context[Type] ctx) {
  if(n in top(ctx.heap)) {
  	return top(ctx.heap)[n];
  }
  else if(n in ctx.global) {
  	return ctx.global[n];
  }
  return TError(); 
}

public Type typeOf(Invoke(n, args), Context[Type] ctx) {
   FDecl f = lookup(n, ctx.fnDecls);
   if(size(args) != size(f.args)) {
      return TError();
   }
   else if(and([a.pmtType == typeOf(b, ctx) | <a, b> <- zip(f.args, args)])) {
   	 return f.returnType; 
   }
   return TError();
}

//// Definition of well typed rules for statements


public Context[Type] wellTyped(BlockStmt([]), Context[Type] ctx) = ctx; 

public Context[Type] wellTyped(BlockStmt([s, ss*]), Context[Type] ctx1) {
  ctx2 = wellTyped(s, ctx1); 
  return wellTyped(BlockStmt(ss), ctx2); 
} 

public Context[Type] wellTyped(IfStmt(c,stmt), Context[Type] ctx){
  switch(typeOf(c,ctx)) {
    case TBool() : return wellTyped(stmt, ctx); 
	default : throw "Expecting a boolean type. Though <c> if of type <typeOf(c,ctx)> ";
  }
}

public Context[Type] wellTyped(IfElseStmt(c, stmtThen, stmtElse), Context[Type] ctx) {
  switch(typeOf(c,ctx)) {
    case TBool() : {
	  ctx2 = wellTyped(stmtThen, ctx); 
	  ctx2 = wellTyped(stmtElse, ctx);
	  return ctx;
    }
    default : throw "Expecting a boolean type. Though <c> if of type <typeOf(c,ctx)> ";
  }
}

public Context[Type] wellTyped(Print(e), Context[Type] ctx) {
  switch(typeOf(e, ctx)) {
    case TError(): throw "Expecting a valid type. Though <e> is of type <typeOf(e,ctx)> ";
    default : return ctx;
  }
}

public Context[Type] wellTyped(Return(e), Context[Type] ctx) {
  switch(typeOf(e, ctx)) {
    case TError(): throw "Expecting a valid type. Though <e> is of type <typeOf(e,ctx)> ";
    default : { 
      return ctx;
    }
  }
}  

bool match(Type varType, Type expType) {
  return expType != TError() && varType == expType;  
}

public Context[Type] wellTyped(Assignment(n, e), Context[Type] ctx){
  tVar = typeOf(VarRef(n), ctx);
  tExp = typeOf(e, ctx);
  if(match(tVar, tExp)) {
     if(n in top(ctx.heap)) {
  		return setLocal(n, tExp, ctx);
     }
     else if(n in ctx.global) {
  	   return setGlobal(n, tExp, ctx);
    }
  }	
  throw "TODO: fix error message";
}


public Context[Type] wellTyped(WhileStmt(c,stmt), Context[Type] ctx){
  switch(typeOf(c,ctx)) {
    case TBool() : return wellTyped(stmt,ctx); 
	default : throw "Expecting a boolean type. Though <c> if of type <typeOf(c,ctx)> ";
  }
}
