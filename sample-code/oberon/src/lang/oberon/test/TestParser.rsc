module lang::oberon::\test::TestParser

import lang::oberon::Parser;
import lang::oberon::AST;
import lang::oberon::RestrictedConcreteSyntax;

OberonProgram prg = program(
  [variable(
      "x",
      TInt())],
  [],
  BlockStmt([Assignment(
        "x",
        Add(
          Add(
            Sub(
              IntValue(0),
              Mult(
                VarRef("x"),
                VarRef("y"))),
            BoolValue(false)),
          Invoke(
            "z",
            [
              VarRef("x"),
              VarRef("y")
            ])))]));

test bool testParser() = prg == parseOberon(|project://oberon/samples/example.ob|);