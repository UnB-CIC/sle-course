module lang::oberon::\test::TestConcreteSyntax

import lang::oberon::RestrictedConcreteSyntax; 

import ParseTree;
import IO;


test bool testExpression() {
   try {
    boolTrue = parse(#Expression, "true"); 
    boolFalse = parse(#Expression, "false"); 
    int10 = parse(#Expression, "10"); 
    variable = parse(#Expression, "x"); 
   	return true; 
   }
   catch: return false; 	
}

test bool testAddExpression() {
   try {
    simpleAdd = parse(#Expression, "2 + x"); 
    complexAdd = parse(#Expression, "2 + x + 3"); 
    complexAddSub = parse(#Expression, "2 - 3 + 5"); 
    return true; 
   }
   catch e: {
    println(e); 
    return false; 
  } 	
}

test bool testInvokeExpression() {
  try {
    simpleInvoke = parse(#Expression, "readValue()"); 
    complexInvoke = parse(#Expression, "2 + (x * inc(z))"); 
    return true; 
   }
   catch e: {
    println(e); 
    return false; 
  }
}



test bool testIfStatment() {
  try {
    ifStmt = parse(#Statement, "IF TRUE THEN x := 10; END");
    return true; 
  }
  catch e: {
    println(e); 
    return false; 
  } 
}

test bool testIfElseStatment() {
  try {
    ifStmt = parse(#Statement, "IF TRUE THEN x := 10; ELSE y := 20; z := 100; END");
    return true; 
  }
  catch e: {
    println(e); 
    return false; 
  } 
}

test bool testWhileStatment() {
  try {
    ifStmt = parse(#Statement, "WHILE TRUE DO z := 100; END");
    return true; 
  }
  catch e: {
    println(e); 
    return false; 
  } 
}

test bool testReturnStatment() {
  try {
    r1 = parse(#Statement, "RETURN 100;");
    r2 = parse(#Statement, "RETURN;");
    return true; 
  }
  catch e: {
    println(e); 
    return false; 
  } 
}


test bool testPrintStatment() {
  try {
    p1 = parse(#Statement, "PRINT 100;");
    p2 = parse(#Statement, "PRINT;");
    return true; 
  }
  catch e: {
    println(e); 
    return false; 
  } 
}

test bool testVarDeclStatement() {
  try {
    decl1 = parse(#Statement, "VAR x : INTEGER;");
    decl2 = parse(#Statement, "VAR x : INTEGER := 10;");
    return true; 
  }
  catch e: {
    println(e); 
    return false; 
  } 	
}


// PROCEDURE inc(x : INTEGER) : INTEGER VAR x : INTEGER := 1; BEGIN x := x + z; RETURN x; END inc;
test bool testProcedureDecl() {
	try {
		str procedure = "PROCEDURE inc(x : INTEGER) : INTEGER 
		                '  VAR z : INTEGER := 1; 
		                'BEGIN
		                '   x := x + z; 
		                '   RETURN x; 
		                'END inc;";  
		f = parse(#ProcedureDeclaration, procedure); 
		return true;
	}
	catch e: {
   	  println(e); 
      return false; 
  }
}
