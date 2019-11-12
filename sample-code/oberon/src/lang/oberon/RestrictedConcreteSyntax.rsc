module lang::oberon::RestrictedConcreteSyntax

start syntax Oberon = Module? mod;

syntax Module = "MODULE" Identifier ";" Procedures? Declarations? "BEGIN" Statements "END" Identifier "."
			  ;			

syntax Procedures = ProcedureDeclaration+;

syntax Declarations = "VAR" VariableDeclaration+
					;

syntax ProcedureDeclaration = "PROCEDURE" Identifier "(" FormalArgs ")" (":" Type)? ProcedureBody Identifier ";";
					 	
syntax FormalArgs = {("VAR"? Identifier ":" Type) ","}*; 
					 	
					 	
syntax ProcedureBody = Declarations? "BEGIN" Statements "END"
				 	 ;
					 	
syntax VariableDeclaration = Identifier ":" Type (":=" Expression )? ";";

syntax Statements = Statement* ;

syntax Statement = Assignment
                 | IfStatement
                 | IfElseStatement
                 | PrintStatement
                 | ReturnStatement
                 | VarDeclStatement   
                 | WhileStatement         
                 ;

syntax Assignment = Identifier ":=" Expression ";";

syntax IfStatement = "IF" Expression "THEN" Statements "END";

syntax IfElseStatement = "IF" Expression "THEN" Statements "ELSE" Statements "END";

syntax PrintStatement = "PRINT" Expression? ";";
 
syntax ReturnStatement = "RETURN" Expression? ";" ;

syntax VarDeclStatement = "VAR" VariableDeclaration;
 
syntax WhileStatement = "WHILE" Expression "DO" Statements "END";

syntax Expression = BOOLEAN
                  | INT 
                  | Identifier
                  | Identifier "(" ExpressionList ")" 
                  | "~" Expression
                  | "-" Expression
                  > left ( Expression "*" Expression 
                         | Expression "/" Expression 
                         | left Expression "&" Expression
                         )
                  > left ( Expression "+" Expression 
                         | Expression "-" Expression 
                         | Expression "|" Expression
                         )                   
                  > left ( Expression "=" Expression 
                         | Expression "#" Expression 
                         | Expression "\>" Expression 
                         | Expression "\<" Expression 
                         | Expression "\>=" Expression 
                         | Expression "\<=" Expression
                         ) 
                  | "(" Expression ")" ;
	
syntax ExpressionList = {Expression ","}* ;
	
lexical Identifier = ([a-zA-Z][a-zA-Z_0-9]*) \KeywordSet;

syntax BOOLEAN = "TRUE" | "FALSE";

lexical INT = [1-9][0-9]*;	

syntax Type = "INTEGER" | "BOOLEAN" ;


lexical Comment = "//" ![\n]* [\n];

lexical Spaces = [\n\r\f\t\ ]*;

layout Layout = Spaces 
              | Comment 
              ;

keyword KeywordSet
	= "BEGIN"
	| "ELSE"
	| "END"
	| "IF"
	| "MODULE"
	| "PROCEDURE"
	| "RETURN"
	| "THEN"
	| "TO"
	| "TYPE"
	| "VAR"
	| "WHILE"
	| "PRINT"
	| "VOID"
	| "TRUE"
	| "FALSE"
	;