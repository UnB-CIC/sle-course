module lang::oberon::RestrictedConcreteSyntax

start syntax Oberon = Module? mod;

syntax Module = "MODULE" ID ";" "BEGIN" Statements "END" ID "."
			  > "MODULE" ID ";" Procedures "BEGIN" Statements "END" ID "."
			  > "MODULE" ID ";" Declarations "BEGIN" Statements "END" ID "."
			  > "MODULE" ID ";" Procedures Declarations "BEGIN" Statements "END" ID "."
			  ;	

syntax Procedures = ProcedureDeclaration+;

syntax Declarations = "VAR" (VariableDeclaration ";")+
					;

syntax ProcedureDeclaration = ProcedureHeading ";" ProcedureBody ID ";";
syntax ProcedureHeading = "PROCEDURE" ID ":" Type
					 	> "PROCEDURE" ID ":" Type "(" VarList ")"
					 	;
					 	
syntax VarList  = VariableDeclaration
				> VariableDeclaration "," VarList
				;
					 	
syntax ProcedureBody = "BEGIN" Statements "END"
				 	 > Declarations "BEGIN" Statements "END"
				 	 ;
					 	
syntax VariableDeclaration = ID ":" Type;

syntax Statements = (Statement ";")* ;

syntax Statement = Assignment
        | ProcedureCall
        | IfStatement
        | WhileStatement
        | ReturnStatement
        | PrintStatement
        ;

syntax Assignment = ID ":=" ComposedExpression;

syntax ReturnStatement = "RETURN" > "RETURN" ComposedExpression;

syntax PrintStatement = "PRINT" > "PRINT" ComposedExpression;

syntax WhileStatement = "WHILE" ComposedExpression "DO" Statements "END";

syntax ComposedExpression = SimpleExpression > SimpleExpression Relation SimpleExpression;
syntax SimpleExpression = Term 
						| SimpleExpression AddOperator Term
						> MINUS Term
						| MINUS SimpleExpression AddOperator Term 
						;
syntax Term = Factor > Term MulOperator Factor;

syntax Factor
	= BOOLEAN 
	| INT 
	| ProcedureCall 
	> ID \ "TRUE" \ "FALSE"
	| "(" ComposedExpression ")"
	| NOT Factor
	;
	
syntax BOOLEAN = "TRUE" | "FALSE";

lexical ID = [a-zA-Z][a-zA-Z_0-9]* \ Keywords;

lexical INT = [0-9]+;	

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
lexical AND = "&";
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
    | op: AND
    ;

syntax Explist = ComposedExpression | ComposedExpression "," Explist;

syntax ProcedureCall = ID ActualParameters;
syntax ActualParameters = "(" Explist? ")";

syntax CaseLabelList = CaseLabels (COMMA CaseLabels)* ;
syntax CaseLabels = ComposedExpression (RANGESEP ComposedExpression)?;

syntax Set = '{' CaseLabelList? '}' ;

syntax ConstantDeclaration = IdentDef EQUAL ComposedExpression;

syntax IdentDef = ID;
syntax IdentList = IdentDef (COMMA IdentDef)*;

syntax Type = BaseTypes; // TODO: | isArr=arraytype;
syntax BaseTypes = "INTEGER" | "BOOLEAN" | "VOID";

syntax ProcedureType = "PROCEDURE" FormalParameters? ;

syntax FieldList = (IdentList COLON Type)?;
syntax FieldListSequence = FieldList (SEMI FieldList);

syntax FpSection = "VAR"? IdList COLON Type ;
syntax Params = FpSection (SEMI FpSection)*;
syntax FormalParameters = "(" Params? ")" (COLON Type)? ;

syntax IfStatement = "IF" ComposedExpression "THEN" Statements "END"
				   > "IF" ComposedExpression "THEN" Statements ("ELSIF" ComposedExpression "THEN" Statements)+ "END"
				   > "IF" ComposedExpression "THEN" Statements ("ELSIF" ComposedExpression "THEN" Statements)+ "ELSE" Statements "END"
				   > "IF" ComposedExpression "THEN" Statements "ELSE" Statements "END"
				   ;

lexical Comment = "//" ![\n]* [\n];

lexical Spaces = [\n\r\f\t\ ]*;

layout Layout = Spaces 
              | Comment 
              ;

keyword Keywords
	= "BEGIN"
	| "DO"
	| "ELSE"
	| "ELSIF"
	| "END"
	| "EXIT"
	| "IF"
	| "MODULE"
	| "OF"
	| "PROCEDURE"
	| "RETURN"
	| "THEN"
	| "TO"
	| "TYPE"
	| "VAR"
	| "WHILE"
	| "TRUE"
	| "FALSE"
	| "PRINT"
	| "INTEGER"
	| "BOOLEAN"
	| "NOTHING"
	| "PRINT"
	| "VOID"
	;