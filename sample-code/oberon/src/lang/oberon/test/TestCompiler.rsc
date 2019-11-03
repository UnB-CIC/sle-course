module lang::oberon::\test::TestCompiler

import lang::oberon::Sample;
import lang::oberon::Compiler;

test bool testTranslateIntVar() = "int x;\n" == translateVar([var]);

test bool testTranslateBoolVar() = "bool y;\n" == translateVar([varB]);

test bool testAttrib() = "x = 0;\n" == translateStmtExpr(attrib1);
