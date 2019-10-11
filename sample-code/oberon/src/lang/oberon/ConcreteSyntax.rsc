module lang::oberon::ConcreteSyntax

/*
	Based on https://github.com/kesarevs/oberon-antlr/blob/master/oberon/Oberon.g4
	Reference: https://inf.ethz.ch/personal/wirth/Oberon/Oberon07.Report.pdf
*/

syntax Factor
	= int_factor: INT
	| real_factor: REAL
	| boolean_factor: Boolean
	| string_factor: STRING
	| nil_type: NIL
	// | set_factor:
	// | designator_factor:
	// | simpleExpression_factor
	// | procedurecall_factor
	| NOT_FACTOR
	;

// Factors
lexical INT = [0-9]+ ;
lexical REAL = [0-9]+[.][0-9]+ ;
lexical STRING = [\"]*[\"];
syntax NOT_FACTOR = "~" Factor;
syntax NIL = "NIL";
syntax Boolean
 	= "TRUE"
  	| "FALSE"
  	;

// syntax Statment = IfStatement;


keyword Keywords
	= "ARRAY"
	| "BEGIN"
	| "CASE"
	| "CONST"
	| "DO"
	| "ELSE"
	| "ELSIF"
	| "END"
	| "EXIT"
	| "IF"
	| "IMPORT"
	| "LOOP"
	| "MODULE"
	| "NIL"
	| "OF"
	| "POINTER"
	| "PROCEDURE"
	| "RECORD"
	| "REPEAT"
	| "RETURN"
	| "THEN"
	| "TO"
	| "TYPE"
	| "UNTIL"
	| "VAR"
	| "WHILE"
	| "WITH"
	| "TRUE"
	| "FALSE"
	| "PRINT"
	| "INTEGER"
	| "REAL"
	| "BOOLEAN";