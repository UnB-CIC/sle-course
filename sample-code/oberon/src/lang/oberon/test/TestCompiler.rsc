module lang::oberon::\test::TestCompiler

import lang::oberon::Sample;
import lang::oberon::Compiler;

test bool testTranslateVar() = "int x;\n" == translateVar([var]);
