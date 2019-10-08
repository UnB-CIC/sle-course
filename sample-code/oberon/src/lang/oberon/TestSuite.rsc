module lang::oberon::TestSuite

import lang::oberon::AST;
import lang::oberon::Interpreter;

Variable var = variable("x",TInt());
Statement attrib1 = Assignment("x", IntValue(0));
Statement stmt = Print(VarRef("x"));
Expression exp = Lt(VarRef("x"),IntValue(10));
Statement attrib2 = Assignment("x",Add(VarRef("x"), IntValue(1)));
Statement whileBlk = BlockStmt([stmt, attrib2]);
Statement whileStmt = WhileStmt(exp, stmt);
Statement mainBlock = BlockStmt([attrib1, whileStmt]);

public OberonProgram prg = program([var], [], mainBlock);

Static finalMap = ("x": IntValue(10));

test bool testProgram() = finalMap == execute(prg);
