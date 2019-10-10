module lang::oberon::TestSuite

import lang::oberon::AST;
import lang::oberon::Interpreter;

Variable var = variable("x",TInt());
Statement attrib1 = Assignment("x", IntValue(0));
Statement stmt = Print(VarRef("x"));
Expression exp = Lt(VarRef("x"),IntValue(10));
Statement attrib2 = Assignment("x",Add(VarRef("x"), IntValue(1)));
Statement whileBlk = BlockStmt([stmt, attrib2]);
Statement whileStmt = WhileStmt(exp,whileBlk);
Statement mainBlock = BlockStmt([attrib1, whileStmt]);

public OberonProgram prg = program([var], [], mainBlock);

Static finalMap = ("x": IntValue(10));

test bool testProgram() = finalMap == execute(prg);


test bool testEvalAddExp() = IntValue(10) == eval(Add(IntValue(3), IntValue(7)), ());

test bool testEvalIntValue() = IntValue(10) == eval(IntValue(10), ());

test bool testEvalBoolValue() = BoolValue(true) == eval(BoolValue(true), ());

Static static = ("x" : IntValue(10), "y" : BoolValue(true), "z" : IntValue(100));

Static expected = ("x" : IntValue(30), "y" : BoolValue(true), "z" : IntValue(100));

test bool testValidVariable() = IntValue(100) == eval(VarRef("z"), static); 

test bool testExecuteAssignment() = expected == execute(Assignment("x", IntValue(30)), static);

//test bool testInvalidVariable() {
//	try {
//		eval(VarRef("a", static));     // it should throw exception
//		return false; 
//	}
//	catch nonDeclaredVariable(): return true; 
//}



