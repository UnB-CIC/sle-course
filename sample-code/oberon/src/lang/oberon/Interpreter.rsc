module lang::oberon::Interpreter

import lang::oberon::AST;

import Map;
import IO;
import List;

import lang::util::Stack;
import lang::oberon::Context; 


public Expression fromVar(Variable v) {
  switch(v) {
    case variableInit(n, _, val) : return val; 
    default: return Undefined(); 
  }
}

private map[Name,Expression] initGlobal(list[Variable] vars) = (v.name : fromVar(v) | v <- vars);
private map[str, FDecl] initFunctionDeclarations(list[FDecl] fs) = (f.name : f | f <- fs);  

public Context[Expression] execute(program(vars, fns, block)) = 
  execute(block, context(initFunctionDeclarations(fns), initGlobal(vars), empty()));

public Context[Expression] execute(Assignment(n, e), ctx) {
	if(n in top(ctx.heap)) {
		return setLocal(n, eval(e, ctx), ctx); 
	}
	else if (n in ctx.global) {
		return setGlobal(n, eval(e, ctx), ctx);   
	}
	else {
		throw "Variable <n> has not been declared"; 
	}
}

public Context[Expression] execute(Return(e), Context[Expression] ctx){
	return setLocal("return", e, ctx); 
}  

public Context[Expression] execute(WhileStmt(c, block), Context[Expression] ctx1) {
	if(eval(c, ctx1) == BoolValue(true)) {
		Context ctx2 = execute(block, ctx1); 
	    return execute(WhileStmt(c, block), ctx2);
	}
	return ctx1; 
}

public Context[Expression] execute(IfStmt(c, block), Context[Expression] ctx) {
	if(eval(c, ctx) == BoolValue(true)) {
		ctx = execute(block, ctx); 
	}
	return ctx; 
}

public Context[Expression] execute(IfElseStmt(c, stmtIf,stmtElse), Context[Expression] ctx) {
	if(eval(c, ctx) == BoolValue(true)) {
		ctx = execute(stmtIf, ctx); 
	}
	else{
		ctx = execute(stmtElse, ctx); 
	}
	return ctx; 
}

public Context[Expression] execute(BlockStmt([]), Context[Expression] ctx) = ctx; 

public Context[Expression] execute(BlockStmt([c,*cs]), Context[Expression] ctx1) { 
  switch(c) {
    case Return(e) : return execute(f); 
    default: { 
       Context ctx2 = execute(c, ctx1); 
       return execute(BlockStmt(cs), ctx2); 
    }
  }
}

public Context[Expression] execute(Print(e), Context[Expression] ctx) {
  switch(eval(e, ctx)) {
    case BoolValue(v): println(v);
    case IntValue(v): println(v); 
  } 
  return ctx; 
} 

public Expression eval(IntValue(n), _) = IntValue(n);

public Expression eval(BoolValue(v), _) = BoolValue(v);

public Expression eval(Add(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return IntValue(n + m); 
    default :  throw "Invalid Expression <Add(lhs, rhs)>"; 
  }
}

public Expression eval(Sub(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return IntValue(n - m); 
    default :  throw "Invalid Expression <Sub(lhs, rhs)>"; 
  }
}

public Expression eval(Mult(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return IntValue(n * m); 
    default :  throw "Invalid Expression <Mult(lhs, rhs)>"; 
  }
}

public Expression eval(Div(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return IntValue(n / m); 
    default :  throw "Invalid Expression <Div(lhs, rhs)>"; 
  }
}

public Expression eval(And(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <BoolValue(n), BoolValue(m)> : return BoolValue(n && m); 
    default :  throw "Invalid Expression <And(lhs, rhs)>"; 
  }
}

public Expression eval(Or(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <BoolValue(n), BoolValue(m)> : return BoolValue(n || m); 
    default :  throw "Invalid Expression <Or(lhs, rhs)>"; 
  }
}

public Expression eval(Not(exp), Context[Expression] ctx) {
  switch(<eval(exp, ctx)>) {
    case <BoolValue(n)> : return BoolValue(!n); 
    default :  throw "Invalid Expression <Not(exp)>"; 
  }
}

public Expression eval(Gt(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return BoolValue(n > m); 
    case <BoolValue(n), BoolValue(m)> : return BoolValue(n > m);
    default :  throw "Invalid Expression <Gt(lhs, rhs)>"; 
  }
}

public Expression eval(Lt(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return BoolValue(n < m); 
    case <BoolValue(n), BoolValue(m)> : return BoolValue(n < m);
    default :  throw "Invalid Expression <Lt(lhs, rhs)>"; 
  }
}

public Expression eval(GoEq(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return BoolValue(n >= m); 
    case <BoolValue(n), BoolValue(m)> : return BoolValue(n >= m);
    default :  throw "Invalid Expression <GoEq(lhs, rhs)>"; 
  }
}

public Expression eval(LoEq(lhs, rhs), Context[Expression] ctx) {
  switch(<eval(lhs, ctx), eval(rhs, ctx)>) {
    case <IntValue(n), IntValue(m)> : return BoolValue(n <= m); 
    case <BoolValue(n), BoolValue(m)> : return BoolValue(n <= m);
    default :  throw "Invalid Expression <LoEq(lhs, rhs)>"; 
  }
}

public Expression eval(VarRef(n), Context[Expression] ctx) {
  if(n in top(ctx.heap)) {
  	return top(ctx.heap)[n];
  }
  else if(n in ctx.global) {
  	return ctx.global[n];
  }
  throw nonDeclaredVariable(); 
}

public FDecl lookup(Name n, map[str,FDecl] decls){
  if(n in decls) {
     return decls[n];
  }
  throw "Function <n> has not been declared"; 
}

public Expression eval(Invoke(n, pmts), Context[Expression] ctx){
  FDecl f = lookup(n, ctx.fnDecls);
  ctx = notifyInvoke((a.pmtName : eval(b, ctx) | <a,b> <- zip(f.args, pmts)), ctx);
  ctx = execute(f.block, ctx);
  exp = top(ctx.heap)["return"];
  ctx = notifyReturn(ctx);
  return exp;
}

