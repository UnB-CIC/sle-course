module lang::oberon::TestSuite

import lang::oberon::AST;
import lang::oberon::Interpreter;
import lang::util::Stack;

Variable var = variable("x",TInt());
Statement attrib1 = Assignment("x", IntValue(0));
Statement stmt = Print(VarRef("x"));
Expression exp = Lt(VarRef("x"),IntValue(10));
Statement attrib2 = Assignment("x",Invoke("inc", [VarRef("x")]));
Statement whileBlk = BlockStmt([stmt, attrib2]);
Statement whileStmt = WhileStmt(exp,whileBlk);
Statement mainBlock = BlockStmt([attrib1, whileStmt]);

// inc(x : int) { return x + 1; }

Expression returnExp = Add(VarRef("z"), IntValue(1));
Statement retStmt = Return(returnExp);
FDecl f = FDecl("inc", [Parameter("z", TInt())], retStmt); 

public OberonProgram prg = program([var], [f], mainBlock);

Context finalMap = context([], ("x": IntValue(10)), empty());

test bool testProgram() = finalMap == execute(prg);

test bool testEvalAddExp() = IntValue(10) == eval(Add(IntValue(3), IntValue(7)), context([], (), empty()));

test bool testEvalIntValue() = IntValue(10) == eval(IntValue(10), context([], (), empty()));

test bool testEvalBoolValue() = BoolValue(true) == eval(BoolValue(true), context([], (), empty()));

Context ctx = context([], ("x" : IntValue(10), "y" : BoolValue(true), "z" : IntValue(100)), empty());

Context expected = context([], ("x" : IntValue(30), "y" : BoolValue(true), "z" : IntValue(100)), empty());

test bool testValidVariable() = IntValue(100) == eval(VarRef("z"), ctx); 

test bool testExecuteAssignment() = expected == execute(Assignment("x", IntValue(30)), ctx);

//test bool testInvalidVariable() {
//	try {
//		eval(VarRef("a", static));     // it should throw exception
//		return false; 
//	}
//	catch nonDeclaredVariable(): return true; 
//}



