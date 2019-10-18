module lang::oberon::Interpreter

import lang::oberon::AST;

import Map;
import IO;
import List;

import lang::util::Stack;

alias Memory = map[Name, Expression];
alias Static = Memory;

data Context = context(list[FDecl] fns, Static global, Stack[Memory] heap);

data Exception = nonDeclaredVariable(); 

Memory top(Stack[Memory] heap) {
  switch(peek(heap)) {
    case just(m) : return m; 
    default: return ();
  }
}

private Expression fromVar(Variable v) {
  switch(v) {
    case variableInit(v, _, val) : return val; 
    default: return Undefined(); 
  }
}

private Static initGlobal(list[Variable] vars) = (v.name : fromVar(v) | v <- vars);


public Context execute(program(vars, fns, block)) = execute(block, context(fns, initGlobal(vars), empty()));

public Context execute(Assignment(n, e), ctx) {
	if(n in top(ctx.heap)) {
		Memory mem = top(ctx.heap); 
		mem[n] = eval(e, ctx); 
	}
	else if (n in ctx.global) {
		ctx.global[n] = eval(e, ctx);  
	}
	else {
		throw "Variable <n> has not been declared"; 
	}
	//top-down visitor(ctx.heap) {
	//	case Name n => ctx.heap[n] = eval(e, ctx); 
	//}
	// TODO: throws an exception????
	return ctx; 
}

public Context execute(Return(e), Context ctx){
	mem = top(ctx.heap);
	mem["return"] = eval(e, ctx);
    pop(ctx.heap);
    ctx.heap = push(mem, ctx.heap);
    return ctx;
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
  Context ctx2 = execute(c, ctx1); 
  //TODO: interromper a execucao quando o 
  // c for um return.
  return execute(BlockStmt(cs), ctx2); 
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

public Expression eval(VarRef(n), Context ctx) {
  if(n in top(ctx.heap)) {
  	return top(ctx.heap)[n];
  }
  else if (n in ctx.global) {
  	return ctx.global[n];
  }
  throw nonDeclaredVariable(); 
}

public FDecl lookup(Name n, list[FDecl] decls){
	switch([ f | f <- decls , f.name == n]){
		case []: throw "Function <n> not declared.";
		case [f]: return f;
		default: throw "Function <n> has more than one declaration."; 
	}
}

public Expression eval(Invoke(n, pmts), Context ctx){
	FDecl f = lookup(n, ctx.fns);
	ctx.heap = push((a.pmtName:eval(b, ctx) | <a,b> <- zip(f.args, pmts)), ctx.heap);
	try { 
	  ctx = execute(f.block, ctx);
	  exp = top(ctx.heap)["return"];
	  <v, s> = pop(ctx.heap);
	  ctx.heap = s;  	
	  return exp;
	} 
	catch e: println(e); return IntValue(10);
}

