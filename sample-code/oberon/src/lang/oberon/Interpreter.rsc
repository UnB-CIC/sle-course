module lang::oberon::Interpreter

import lang::oberon::AST;

import Map;
import IO;

alias Static = map[Name, Expression];

data Exception = nonDeclaredVariable(); 

public Static execute(program(vars, fns, block)) {
	return execute(block, ());
}

public Static execute(Assignment(n, e), Static s)  = s + (n : eval(e, s));  

public Static execute(WhileStmt(c, block), s1) {
	if(eval(c, s1) == BoolValue(true)) {
		Static s2 = execute(block, s1); 
	    return execute(WhileStmt(c, block), s2);
	}
	return s1; 
}

public Static execute(BlockStmt([]), s) = s; 

public Static execute(BlockStmt([c,*cs]), Static s1) { 
  Static s2 = execute(c, s1); 
  return execute(BlockStmt(cs), s2); 
}

public Static execute(Print(e), s) {
	switch(eval(e, s)) {
		case BoolValue(v): println(v);
		case IntValue(v): println(v); 
	} 
	return s; 
} 

public Expression eval(IntValue(n), Static s) = IntValue(n);

public Expression eval(BoolValue(v), Static s) = BoolValue(v);

public Expression eval(Add(lhs, rhs), Static s) {
   switch(<eval(lhs, s), eval(rhs, s)>) {
     case <IntValue(n), IntValue(m)> : return IntValue(n + m); 
     default :  throw "Invalid Expression <Add(lhs, rhs)>"; 
   }
}

public Expression eval(Lt(lhs, rhs), Static s) {
  switch(<eval(lhs, s), eval(rhs, s)>) {
     case <IntValue(n), IntValue(m)> : return BoolValue(n < m); 
     case <BoolValue(n), BoolValue(m)> : return BoolValue(n < m);
     default :  throw "Invalid Expression <Lt(lhs, rhs)>"; 
   }
}

public Expression eval(VarRef(n), Static s) {
  if(n in s) {
  	return s[n];
  }
  throw nonDeclaredVariable(); 
}

