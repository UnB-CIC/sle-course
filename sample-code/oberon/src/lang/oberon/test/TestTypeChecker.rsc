module lang::oberon::\test::TestTypeChecker

import lang::oberon::AST;
import lang::oberon::TypeChecker;
import lang::oberon::Interpreter;
import lang::util::Stack;
import lang::oberon::Context;

import IO;

Expression returnExp = Add(VarRef("z"), IntValue(1));
Statement retStmt = Return(returnExp);
FDecl f = FDecl(TInt(), "inc", [Parameter("z", TInt())], retStmt); 

Variable var = variable("x",TInt());
Statement attrib1 = Assignment("x", IntValue(0));
Statement stmt = Print(VarRef("x"));
Expression exp = Lt(VarRef("x"),IntValue(10));
Statement ret = Return(VarRef("x")); 
Statement attrib2 = Assignment("x",Invoke("inc", [VarRef("x")]));
Statement whileBlk = BlockStmt([stmt, attrib2]);
Statement whileStmt = WhileStmt(exp,whileBlk);
Statement mainBlock = BlockStmt([attrib1, whileStmt]);
Expression undefined = Undefined();

public Context[Type] testContext =  context(("inc": f), ("x" : TInt()), empty());

public Context[Type] emptyContext =  context((), (), empty());

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

//test bool testWellTypedWhileStmt() { 
//  try {
//    wellTyped(WhileStmt(exp,stmt),testContext);
//    return true;
//  }
//  catch e: {
//    println(e); 
//    return false;
//  } 
//}


//test bool testWellTypedIfStmt() { 
//  try { 
//    wellTyped(IfStmt(BoolValue(true),attrib2),emptyContext);
//    return true;
//  } 
//  catch e: {
//    println(e); 
//    return false; 
//  }    
//}

test bool testWellTypedIfElseStmt() = 
  testContext ==  wellTyped(IfElseStmt(BoolValue(true),attrib1,attrib2),testContext);


//
//test bool testWellTypedPrintStmt() = true == wellTyped(Print(IntValue(10)),emptyContext);
//
//test bool testWellTypedReturnStmt() = true == wellTyped(Return(IntValue(10)),emptyContext);
//
//test bool testWellTypedAssignmentStmt() = true == wellTyped(attrib1,testContext);
//
//test bool testWellTypedBlockStmt() = false == wellTyped(BlockStmt([stmt, Assignment("x", BoolValue(true))]),testContext);
//
//test bool testWellTypedVarDeclStmt() = true == wellTyped(VarDecl(var),emptyContext);



