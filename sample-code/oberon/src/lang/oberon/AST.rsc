module lang::oberon::AST

alias Name = str;
alias FormalArgs = list[Parameter]; 
alias Args = list[Expression];

data OberonProgram = program(list[Variable] vars, list[FDecl] fns, Statement block);

data Type = TInt()
          | TBool()     
          | TUndef()
          | TError()
		  ;

data Variable = variable(Name name, Type varType)
              | variableInit(Name name, Type varType, Expression exp);  

data Expression = VarRef(Name name) 
                | IntValue(int ival)
                | BoolValue(bool bval)
                | Undefined()
                | Add(Expression lhs, Expression rhs)
                | Sub(Expression lhs, Expression rhs)
                | Mult(Expression lhs, Expression rhs)
                | Div(Expression lhs, Expression rhs)
                | And(Expression lhs,Expression rhs)
                | Or(Expression lhs, Expression rhs)
                | Not(Expression exp)
                | Gt(Expression lhs,Expression rhs)
                | Lt(Expression lhs,Expression rhs)
                | GoEq(Expression lhs,Expression rhs)
				| LoEq(Expression lhs,Expression rhs)
				| Eq(Expression lhs,Expression rhs)
				| Invoke(Name name, Args pmts)
                ;
                
data Statement = Assignment(Name var, Expression exp)
               | VarDecl(Variable v)
               | IfStmt(Expression condition, Statement stmtThen)
               | IfElseStmt(Expression condition, Statement stmtThen, Statement stmtElse)
               | WhileStmt(Expression condition, Statement stmt)
               | BlockStmt(list[Statement] stmts)
               | Print(Expression exp)
               | Return(Expression exp)
               ;

data Parameter = Parameter(Name pmtName, Type pmtType);

data FDecl = FDecl(Type returnType, Name name, FormalArgs args, Statement block)
           ;