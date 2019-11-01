module lang::oberon::\test::TestInterpreter

import lang::oberon::AST;
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

// inc(x : int) { return x + 1; }

Expression returnExp = Add(VarRef("z"), IntValue(1));
Statement retStmt = Return(returnExp);
FDecl f = FDecl("inc", [Parameter("z", TInt())], retStmt);

public Context finalContext = context((f.name:f), ("x": IntValue(10)), empty());

public Context ctx = context((), ("x" : IntValue(10), "y" : BoolValue(true), "z" : IntValue(100)), empty());

public Context expected = context((), ("x" : IntValue(30), "y" : BoolValue(true), "z" : IntValue(100)), empty());

public OberonProgram prg = program([var], [f], mainBlock);

test bool testProgram() = finalContext == execute(prg);

test bool testEvalAddExp() = IntValue(10) == eval(Add(IntValue(3), IntValue(7)), context((), (), empty()));

test bool testEvalIntValue() = IntValue(10) == eval(IntValue(10), context((), (), empty()));

test bool testEvalBoolValue() = BoolValue(true) == eval(BoolValue(true), context((), (), empty()));

test bool testValidVariable() = IntValue(100) == eval(VarRef("z"), ctx); 

test bool testExecuteAssignment() = expected == execute(Assignment("x", IntValue(30)), ctx);