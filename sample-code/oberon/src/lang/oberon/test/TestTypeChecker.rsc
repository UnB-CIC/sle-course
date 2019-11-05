module lang::oberon::\test::TestTypeChecker

import lang::oberon::AST;
import lang::oberon::TypeChecker;
import lang::oberon::Interpreter;
import lang::util::Stack;
import lang::oberon::ExecutionContext;

Variable var = variable("x",TInt());
Statement attrib1 = Assignment("x", IntValue(0));
Statement stmt = Print(VarRef("x"));
Expression exp = Lt(VarRef("x"),IntValue(10));
Statement attrib2 = Assignment("x",Invoke("inc", [VarRef("x")]));
Statement whileBlk = BlockStmt([stmt, attrib2]);
Statement whileStmt = WhileStmt(exp,whileBlk);
Statement mainBlock = BlockStmt([attrib1, whileStmt]);
Expression undefined = Undefined();



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

test bool testWellTypedWhileStmt() = TBool() == wellTyped(WhileStmt(BoolValue(true),attrib1),emptyContext);

test bool testWellTypedIfStmt() = TBool() == wellTyped(IfStmt(BoolValue(true),attrib2),emptyContext);

test bool testWellTypedIfElseStmt() = TBool() == wellTyped(IfElseStmt(BoolValue(true),attrib1,attrib2),emptyContext);

test bool testWellTypedPrintStmt() = TInt() == wellTyped(Print(IntValue(10)),emptyContext);

test bool testWellTypedReturnStmt() = TInt() == wellTyped(Return(IntValue(10)),emptyContext);

test bool testWellTypedAssignmentStmt() = TUndef() == wellTyped(Assignment("w",undefined),emptyContext);

//test bool testWellTypedVarDeclStmt() = TUndef() == wellTyped(VarDecl(var),emptyContext);

