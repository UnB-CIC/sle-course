module lang::oberon::ConcreteSyntax

/*
	Based on https://github.com/kesarevs/oberon-antlr/blob/master/oberon/Oberon.g4
	Reference: https://inf.ethz.ch/personal/wirth/Oberon/Oberon07.Report.pdf
*/

// TODO: WS : ( ' ' | '\t' | '\r' | '\n') -> skip;
// TODO: COMMENT : '(*' .*? '*)' -> skip;

start syntax Oberon = Module? mod;

lexical PERIOD = "." ;
lexical RANGESEP = "..";
lexical SEMI = ";";
lexical UPCHAR = "^";
lexical COLON = ":";
lexical COMMA = ",";
lexical NOT = "~";

lexical UNEQUAL = "#";
lexical LESS = "\<"; // Escape tá certo?
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
//lexical ID = [A-Z]*;
//lexical ID = "I";

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
	| set_factor: Set
	| designator_factor: Designator
	| simpleExpression_factor: "(" SimpleExpression ")"
	| procedurecall_factor: ProcedureCall
	| NOT_FACTOR
	;

syntax Designator = Qualident DesignatorArgs;
syntax DesignatorArgs = "[" Explist "]" | UPCHAR; // TODO: Existe construção isArray ?

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

syntax Type = BaseTypes; // TODO: | isArr=arraytype;
syntax BaseTypes = "INTEGER" | "REAL" | "BOOLEAN";

syntax ArrayType = "ARRAY" ExplList "OF" Type;
syntax RecordType = "RECORD" ('(' Qualident ')')? FieldListSequence "END" ;
syntax PointerType = "POINTER" "TO" Type ;
syntax ProcedureType = "PROCEDURE" FormalParameters? ;

syntax FieldList = (IdentList COLON Type)?;
syntax FieldListSequence = FieldList (SEMI FieldList);

syntax FpSection = "VAR"? IdList COLON Type ;
syntax Params = FpSection (SEMI FpSection)*;
syntax FormalParameters = "(" Params? ")" (COLON Type)? ;

syntax ProcedureDeclaration = ProcedureHeading SEMI ProcedureBody ID;
syntax ProcedureHeading = "PROCEDURE" IdentDef "*"? FormalParameters?;
syntax ProcedureBody = DeclarationSequence? ("BEGIN" StatementSequence)? "END";

syntax Assignment = Designator ASSIGN Expression;

syntax WhileStatement = "WHILE" Expression "DO" StatementSequence "END";
syntax RepeatStatement = "REPEAT" StatementSequence "UNTIL" Expression;
syntax LoopStatement = "LOOP" StatementSequence "END";

syntax IfStatement = "IF" Expression "THEN" StatementSequence ("ELSIF" Expression "THEN" StatementSequence)* ("ELSE" StatementSequence)? "END";
syntax CaseStatement = "CASE" Expression "OF" CaseItem ("|" CaseItem)* ("ELSE" StatementSequence)? "END";
syntax CaseItem = CaseLabelList COLON StatementSequence;
syntax CaseLabelList = CaseLabels (COMMA CaseLabels)*;
syntax CaseLabels = Expression (RANGESEP Expression)?;

syntax Module = "MODULE" ID SEMI DeclarationSequence? ModuleDeclarations* ("BEGIN" StatementSequence)? "END" ID PERIOD ;
syntax ModuleDeclarations = ProcedureDeclaration SEMI | ForwardDeclaration SEMI;
syntax ImportList = "IMPORT" ImportItem (COMMA ImportItem)* SEMI;
syntax ImportItem = ID (ASSIGN ID)?;

syntax ForwardDeclaration = "PROCEDURE" UPCHAR? ID MULT? FormalParameters?;

syntax StatementSequence = Statement SEMI (Statement SEMI)* ;

syntax Statement = Assignment
        | ProcedureCall
        | IfStatement
        | CaseStatement
        | WhileStatement
        | RepeatStatement
        | LoopStatement
        | WithStatement 
        | "EXIT"
        | "RETURN" Expression?
        ;

syntax WithStatement = "WITH" Qualident COLON Qualident "DO" StatementSequence "END";

lexical Comment = "//" ![\n]* [\n];

lexical Spaces = [\n\r\f\t\ ]*;

layout Layout = Spaces 
              | Comment 
              ;

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