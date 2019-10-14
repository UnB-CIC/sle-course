module lang::oberon::ConcreteSyntax

/*
	Based on https://github.com/kesarevs/oberon-antlr/blob/master/oberon/Oberon.g4
	Reference: https://inf.ethz.ch/personal/wirth/Oberon/Oberon07.Report.pdf
*/

lexical PERIOD = "." ;
lexical RANGESEP = "..";
lexical SEMI = ";";
lexical UPCHAR = "^";
lexical COLON = ":";
lexical COMMA = ",";
lexical NOT = "~";

lexical UNEQUAL = "#";
lexical LESS = "\<"; // Escape
lexical GREATER = "\>";  // Escape
lexical LESSOREQ = "\<=";  // Escape
lexical GREATEROREQ = "\>=";  // Escape
lexical IN = "IN";
lexical EQUAL = "=";

lexical ASSIGN = ":=";
lexical DIV = "DIV" ;
lexical DIVISION = "/";
lexical ET = "&";
lexical MINUS = "-";
lexical MOD = "MOD";
lexical MULT = "*";
lexical OR = "|";
lexical PLUS = "+";

syntax AddOperator
	= op: PLUS
    | op: MINUS 
    | op: OR
    ;
            
syntax Relation
	= op: EQUAL 
    | op: UNEQUAL 
    | op: LESS 
    | op: GREATER 
    | op: LESSOREQ 
    | op: GREATEROREQ 
    | op: IN
    ;
    
syntax MulOperator
	= op: MULT 
    | op: DIVISION
    | op: DIV 
    | op: MOD 
    | op: ET
    ;

lexical ID = [a-zA-Z][a-zA-Z_0-9]*;

// Factors
lexical INT = [0-9]+ ;
lexical REAL = [0-9]+[.][0-9]+ ;
lexical STRING = [\"]*[\"];
syntax NOT_FACTOR = NOT Factor;
syntax NIL = "NIL";
syntax Boolean
 	= "TRUE"
  	| "FALSE"
  	;

syntax Factor
	= int_factor: INT
	| real_factor: REAL
	| boolean_factor: Boolean
	| string_factor: STRING
	| nil_type: NIL
	| set_factor: SET
	| designator_factor: Designator
	| simpleExpression_factor: "(" SimpleExpression ")"
	| procedurecall_factor: ProcedureCall
	| NOT_FACTOR
	;

syntax Designator = Qualident DesignatorArgs;
syntax DesignatorArgs = "[" Explist "]" | UPCHAR; // Existe construção isArray ?

lexical Qualident = (ID '.')* ID;

syntax Explist = Expression (COMMA Expression)*;

syntax Expression = SimpleExpression (Relation SimpleExpression)?;
syntax SimpleExpression = MINUS? Term (AddOperator Term)*;
syntax Term = Factor (MulOperator Factor)*;

syntax ProcedureCall = ID ActualParameters;
syntax ActualParameters = "(" Explist? ")";

syntax CaseLabelList = CaseLabels (COMMA CaseLabels)* ;
syntax CaseLabels = Expression (RANGESEP Expression)?;

syntax Set = '{' CaseLabelList? '}' ;

syntax DeclarationSequence = DeclarationOptions+;
syntax DeclarationOptions = "CONST" (ConstantDeclaration SEMI)* | "VAR" (VariableDeclaration SEMI)*;

syntax VariableDeclaration = IdentList COLON Type;
syntax ConstantDeclaration = IdentDef EQUAL Expression;

syntax IdentDef = ID;
syntax IdentList = IdentDef (COMMA IdentDef)*;

syntax Type = BaseTypes; // | isArr=arraytype;
syntax BaseTypes = "INTEGER" | "REAL" | "BOOLEAN";

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