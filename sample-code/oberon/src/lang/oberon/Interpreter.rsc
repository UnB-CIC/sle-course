module lang::oberon::Interpreter

import lang::oberon::AST;

import Map;
import IO;
import List;

import lang::util::Stack;
import lang::oberon::ExecutionContext; 


private Expression fromVar(Variable v) {
  switch(v) {
    case variableInit(v, _, val) : return val; 
    default: return Undefined(); 
  }
}

private Static initGlobal(list[Variable] vars) = (v.name : fromVar(v) | v <- vars);
private map[str, FDecl] initFunctionDeclarations(list[FDecl] fs) = (f.name : f | f <- fs);  

public Context execute(program(vars, fns, block)) = 
  execute(block, context(initFunctionDeclarations(fns), initGlobal(vars), empty()));

public Context execute(Assignment(n, e), ctx) {
	if(n in top(ctx.heap)) {
		return setLocal(n, e, ctx); 
	}
	else if (n in ctx.global) {
		return setGlobal(n, e, ctx);   
	}
	else {
		throw "Variable <n> has not been declared"; 
	}
}

public Context execute(Return(e), Context ctx){
	return setLocal("return", e, ctx); 
}  

public Context execute(WhileStmt(c, block), Context ctx1) {
	if(eval(c, ctx1) == BoolValue(true)) {
		Context ctx2 = execute(block, ctx1); 
	    return execute(WhileStmt(c, block), ctx2);
	}
	return ctx1; 
}

public Context execute(BlockStmt([]), Context ctx) = ctx; 

public Context execute(BlockStmt([c,*cs]), Context ctx1) { 
  switch(c) {
    case Return(e) : return execute(f); 
    default: { 
       Context ctx2 = execute(c, ctx1); 
       return execute(BlockStmt(cs), ctx2); 
    }
  }
}

public Context execute(Print(e), Context ctx) {
  switch(eval(e, ctx)) {
    case BoolValue(v): println(v);
    case IntValue(v): println(v); 
  } 
  return ctx; 
} 

public Expression eval(IntValue(n), _) = IntValue(n);

public Expression eval(BoolValue(v), _) = BoolValue(v);

public Expression eval(Add(lhs, rhs), Context ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return IntValue(n + m); 
    default :  throw "Invalid Expression <Add(lhs, rhs)>"; 
  }
}

public Expression eval(Lt(lhs, rhs), Context ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return BoolValue(n < m); 
    case <BoolValue(n), BoolValue(m)> : return BoolValue(n < m);
    default :  throw "Invalid Expression <Lt(lhs, rhs)>"; 
  }
}

public Expression eval(Gt(lhs, rhs), Context ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return BoolValue(n > m); 
    case <BoolValue(n), BoolValue(m)> : return BoolValue(n > m);
    default :  throw "Invalid Expression <Lt(lhs, rhs)>"; 
  }
}

public Expression eval(VarRef(n), Context ctx) {
  if(n in top(ctx.heap)) {
  	return top(ctx.heap)[n];
  }
  else if(n in ctx.global) {
  	return ctx.global[n];
  }
  throw nonDeclaredVariable(); 
}

public FDecl lookup(Name n, list[FDecl] decls){
  if(n in ctx.fnDecls) {
     return ctx.fnDecls[n];
  }
  throw "Function <n> has not been declared"; 
}

public Expression eval(Invoke(n, pmts), Context ctx){
  FDecl f = lookup(n, ctx.fns);
  ctx = notifyInvoke((a.pmtName : eval(b, ctx) | <a,b> <- zip(f.args, pmts)), ctx);
  ctx = execute(f.block, ctx);
  exp = top(ctx.heap)["return"];
  ctx = notifyReturn(ctx);
  return exp;
}

