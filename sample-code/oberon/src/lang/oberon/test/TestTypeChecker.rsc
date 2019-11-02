module lang::oberon::\test::TestTypeChecker

import lang::oberon::AST;
import lang::oberon::TypeChecker;
import lang::oberon::Interpreter;
import lang::util::Stack;
import lang::oberon::ExecutionContext;

public Context emptyContext =  context((), (), empty());

test bool testWellTypedAddExp() = TInt() == wellTyped(Add(IntValue(10), IntValue(7)), emptyContext);

test bool testWellTypedSubExp() = TInt() == wellTyped(Sub(IntValue(10), IntValue(7)), emptyContext);

test bool testWellTypedMultExp() = TInt() == wellTyped(Mult(IntValue(10), IntValue(7)), emptyContext);

test bool testWellTypedDivExp() = TInt() == wellTyped(Div(IntValue(14), IntValue(7)), emptyContext);

test bool testWellTypedAndExp() = TBool() == wellTyped(And(BoolValue(true), BoolValue(false)), emptyContext);

test bool testWellTypedOrExp() = TBool() == wellTyped(Or(BoolValue(true), BoolValue(false)), emptyContext);

test bool testWellTypedNotExp() = TBool() == wellTyped(Not(BoolValue(true)), emptyContext);

test bool testWellTypedGtExp() = TBool() == wellTyped(Gt(BoolValue(true), BoolValue(false)), emptyContext);

test bool testWellTypedLtExp() = TBool() == wellTyped(Lt(BoolValue(true), BoolValue(false)), emptyContext);

test bool testWellTypedGoEqExp() = TBool() == wellTyped(GoEq(BoolValue(true), BoolValue(false)), emptyContext);

test bool testWellTypedLoEqExp() = TBool() == wellTyped(LoEq(BoolValue(true), BoolValue(false)), emptyContext);

test bool testWellTypedEqExp() = TBool() == wellTyped(Eq(BoolValue(true), BoolValue(false)), emptyContext);