module lang::oberon::\test::TestInterpreter

import lang::oberon::AST;
import lang::oberon::Interpreter;
import lang::util::Stack;
import lang::oberon::ExecutionContext;

import IO;

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

public Context emptyContext =  context((), (), empty());

public Context finalContext = context((f.name:f), ("x": IntValue(10)), empty());

public Context ctx = context((), ("x" : IntValue(10), "y" : BoolValue(true), "z" : IntValue(100)), empty());

public Context expected = context((), ("x" : IntValue(30), "y" : BoolValue(true), "z" : IntValue(100)), empty());

public OberonProgram prg = program([var], [f], mainBlock);

//TODO 
test bool testProgram() = finalContext == execute(prg);

test bool testEvalAddExp() = IntValue(10) == eval(Add(IntValue(3), IntValue(7)), emptyContext);

test bool testEvalSubExp() = IntValue(4) == eval(Sub(IntValue(7), IntValue(3)), emptyContext);

test bool testEvalMultExp() = IntValue(21) == eval(Mult(IntValue(3), IntValue(7)), emptyContext);

test bool testEvalDivExp() = IntValue(3) == eval(Div(IntValue(21), IntValue(7)), emptyContext);

test bool testEvalAndExp() = BoolValue(false) == eval(And(BoolValue(false),VarRef("y")), ctx);

test bool testEvalAndExp() = BoolValue(true) == eval(Or(BoolValue(false),VarRef("y")), ctx);

test bool testEvalNotExp() = BoolValue(false) == eval(Not(VarRef("y")), ctx);

test bool testEvalIntValue() = IntValue(10) == eval(IntValue(10), context((), (), empty()));

test bool testEvalBoolValue() = BoolValue(true) == eval(BoolValue(true), emptyContext);

test bool testValidVariable() = IntValue(100) == eval(VarRef("z"), ctx); 

test bool testValidGt() = BoolValue(false) == eval(Gt(VarRef("x"),VarRef("z")),ctx);

test bool testValidLt() = BoolValue(true) == eval(Lt(VarRef("x"),VarRef("z")),ctx);

test bool testValidGoEq() = BoolValue(true) == eval(GoEq(VarRef("x"),IntValue(5)),ctx);

test bool testValidLoEq() = BoolValue(true) == eval(LoEq(VarRef("x"),IntValue(15)),ctx);

test bool testExecuteAssignment() = expected == execute(Assignment("x", IntValue(30)), ctx);

test bool testExecuteIfStmt() = expected == execute(IfStmt(Lt(VarRef("x"),IntValue(30)),Assignment("x", Add(VarRef("x"), IntValue(20)))), ctx);

test bool testExecuteIfElseStmt() = expected == execute(IfElseStmt(BoolValue(true),Assignment("x", IntValue(30)), Print(VarRef("x"))), ctx);