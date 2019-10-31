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

public Type wellTyped(LoEq(lhs, rhs), ctx) {
  switch(<wellTyped(lhs, ctx), wellTyped(rhs, ctx)>) {
    case <TInt(), TInt()> : return TBool(); 
    case <TBool(), TBool()> : return TBool();
    default : return TError(); 
  }
}

