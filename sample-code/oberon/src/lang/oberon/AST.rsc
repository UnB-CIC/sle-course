module lang::oberon::AST

alias Name = str;
alias FormalArgs = list[Parameter]; 
alias Args = list[Expression];

data OberonProgram = program(list[Variable] vars, list[FDecl] fns, Statement block);

data Type = TInt()
          | TBool()     
		  ;
data Variable = variable(Name name, Type varType); 

data Expression = VarRef(Name name) 
                | IntValue(int val)
                | BoolValue(bool val)
                | And(Expression lhs,Expression rhs)
                | Add(Expression lhs, Expression rhs)
                | Not(Expression exp)
                ;
                
data Statement = Assignment(Name var, Expression exp)
               | VarDecl(Variable v)
               | IfStmt(Expression condition, Statement stmtThen)
               | IfElseStmt(Expression condition, Statement stmtThen, Statement stmtElse)
               | WhileStmt(Expression condition, Statement stmt)
               | BlockStmt(list[Statement] stmts)
               | Invoke(Name name, Args pmts)
               ;

data Parameter = Parameter(Name pmtName, Type pmtType);

data FDecl = FDecl(Name name, FormalArgs args, Statement block)
           ;