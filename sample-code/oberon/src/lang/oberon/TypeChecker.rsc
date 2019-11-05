module lang::oberon::TypeChecker

import lang::oberon::AST;

//public Type wellTyped(Expression exp, Context ctx)

public Type wellTyped(IntValue(v), ctx) = TInt();

public Type wellTyped(BoolValue(v), ctx) = TBool();

public Type wellTyped(Undefined(), ctx) = TUndef();

public Type wellTyped(Add(lhs,rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type wellTyped(Sub(lhs,rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type wellTyped(Mult(lhs,rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type wellTyped(Div(lhs,rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TInt(); 
    default :  return TError();
  }
}

public Type wellTyped(And(lhs,rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TBool(), TBool()> : return TBool(); 
    default :  return TError();
  }
}

public Type wellTyped(Or(lhs,rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TBool(), TBool()> : return TBool(); 
    default : return TError();
  }
}

public Type wellTyped(Not(exp), ctx) {
  switch(<wellTyped(exp,ctx)>) {
    case <TBool()> : return TBool(); 
    default : return TError();
  }
}

public Type wellTyped(Gt(lhs, rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type wellTyped(Lt(lhs, rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type wellTyped(GoEq(lhs, rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type wellTyped(LoEq(lhs, rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

public Type wellTyped(Eq(lhs, rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

//Statments TypeChecker

public Type wellTyped(WhileStmt(c,stmt), ctx){
	switch(<wellTyped(c,ctx)>) {
	    case <TBool()> : return TBool(); 
	    default : return TError();
    }
}

public Type wellTyped(IfStmt(c,stmt), ctx){
	switch(<wellTyped(c,ctx)>) {
	    case <TBool()> : return TBool(); 
	    default : return TError();
    }
}


public Type wellTyped(IfElseStmt(c,stmtThen, stmtElse), ctx){
	switch(<wellTyped(c,ctx)>) {
	    case <TBool()> : return TBool(); 
	    default : return TError();
    }
}


public Type wellTyped(Print(e), ctx) {
  switch(<wellTyped(e, ctx)>) {
    case <TBool()>: return TBool();
    case <TInt()>: return TInt();
    default : return TError(); 
  }
}

public Type wellTyped(Return(e), ctx) {
  switch(<wellTyped(e, ctx)>) {
    case <TBool()>: return TBool();
    case <TInt()>: return TInt();
    default : return TError(); 
  }
}  

public Type wellTyped(Assignment(n, e), ctx){
  switch(<wellTyped(e, ctx)>) {
    case <TBool()>: return TBool();
    case <TInt()>: return TInt();
    case <TUndef()>: return TUndef();
    default : return TError(); 
  }
}

//public Type wellTyped(VarDecl(v), ctx){
//  switch(<wellTyped(v, ctx)>) {
// 	case <TBool()>: return TBool();
//    case <TInt()>: return TInt();
//    case <TUndef()>: return TUndef();
//    default : return TError(); 
//  }
//}



