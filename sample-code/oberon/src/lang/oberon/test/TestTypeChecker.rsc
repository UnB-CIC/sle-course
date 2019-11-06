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

public Context testContext =  context((), ("x" : IntValue(10)), empty());

public Context emptyContext =  context((), (), empty());

test bool testTypeOfAddExp() = TInt() == typeOf(Add(IntValue(10), IntValue(7)), emptyContext);

test bool testTypeOfSubExp() = TInt() == typeOf(Sub(IntValue(10), IntValue(7)), emptyContext);

test bool testTypeOfMultExp() = TInt() == typeOf(Mult(IntValue(10), IntValue(7)), emptyContext);

test bool testTypeOfDivExp() = TInt() == typeOf(Div(IntValue(14), IntValue(7)), emptyContext);

test bool testTypeOfAndExp() = TBool() == typeOf(And(BoolValue(true), BoolValue(false)), emptyContext);

test bool testTypeOfOrExp() = TBool() == typeOf(Or(BoolValue(true), BoolValue(false)), emptyContext);

test bool testTypeOfNotExp() = TBool() == typeOf(Not(BoolValue(true)), emptyContext);

test bool testTypeOfGtExp() = TBool() == typeOf(Gt(BoolValue(true), BoolValue(false)), emptyContext);

test bool testTypeOfLtExp() = TBool() == typeOf(Lt(BoolValue(true), BoolValue(false)), emptyContext);

test bool testTypeOfGoEqExp() = TBool() == typeOf(GoEq(BoolValue(true), BoolValue(false)), emptyContext);

test bool testTypeOfLoEqExp() = TBool() == typeOf(LoEq(BoolValue(true), BoolValue(false)), emptyContext);

test bool testTypeOfEqExp() = TBool() == typeOf(Eq(BoolValue(true), BoolValue(false)), emptyContext);

test bool testTypeOfVarRefExp() = TInt() == typeOf(VarRef("x"), testContext);


//Statments tests

test bool testWellTypedWhileStmt() = true == wellTyped(WhileStmt(exp,stmt),testContext);

test bool testWellTypedIfStmt() = true == wellTyped(IfStmt(BoolValue(true),attrib2),emptyContext);

test bool testWellTypedIfElseStmt() = true == wellTyped(IfElseStmt(BoolValue(true),attrib1,attrib2),emptyContext);

test bool testWellTypedPrintStmt() = true == wellTyped(Print(IntValue(10)),emptyContext);

test bool testWellTypedReturnStmt() = true == wellTyped(Return(IntValue(10)),emptyContext);

test bool testWellTypedAssignmentStmt() = true == wellTyped(Assignment("w",undefined),emptyContext);

test bool testWellTypedBlockStmt() = true == wellTyped(BlockStmt([stmt, attrib1]),testContext);



