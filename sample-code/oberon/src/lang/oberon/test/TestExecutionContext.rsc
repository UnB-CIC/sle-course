module lang::oberon::\test::TestExecutionContext

import lang::util::Stack;

import lang::oberon::AST; 
import lang::oberon::Context;


// setup
Expression returnExp = Add(VarRef("z"), IntValue(1));
Statement retStmt = Return(returnExp);
FDecl f = FDecl(TInt(), "inc", [Parameter("z", TInt())], retStmt); 

Context[Expression] ctx1 = setLocal("x", IntValue(5), notifyInvoke(initContext()));
Context[Expression] ctx2 = context((), (), push((), push(("x": IntValue(5)), empty())));
Context[Expression] ctx3 = context((), ("x" : IntValue(10)), push((), push(("x": IntValue(5)), empty())));
Context[Expression] ctx4 = context((), (), push(("x": IntValue(10)), empty()));

test bool testInitContext() = context((), (), empty()) == initContext();

test bool testDeclareFunction() = context((f.name:f), (), empty()) == declareFunction(f, initContext()); 

test bool testNotifyInvoke1() = context((), (), push((), empty())) == notifyInvoke(initContext()); 

test bool testNotifyInvoke2() = ctx2 == notifyInvoke(ctx1);  
  
test bool testNotifyReturn() = ctx1 == notifyReturn(ctx2);  

test bool testSetGlobal() = ctx3 == setGlobal("x", IntValue(10), ctx2);
 
test bool testSetLocal() = ctx4 == setLocal("x", IntValue(10), initContext());