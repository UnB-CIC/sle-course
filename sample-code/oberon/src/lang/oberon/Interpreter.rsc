module lang::oberon::Interpreter

import lang::oberon::AST;
import Map;

alias Static = map[Name, Expression];

public Static execute(OberonProgram prg) {
	return ("x":IntValue(10));
}