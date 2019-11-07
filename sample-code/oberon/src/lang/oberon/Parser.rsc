module lang::oberon::Parser

import ParseTree;
import IO;
import String;

import lang::oberon::AST;
import lang::oberon::RestrictedConcreteSyntax;

public OberonProgram parseOberon(loc file) {
	list[Variable] vars = [];
	list[FDecl] fdecls = [];
	list[Statement] block = [];
	
	loc temp = |project://oberon/samples/example.ob|;
	
	start[Oberon] parseResult = parse(#start[Oberon], file);
	
	top-down visit(parseResult) {
		case (Module) `MODULE <ID id> ; <Procedures procedures> <Declarations decls> BEGIN <Statements stmts> END <ID id> .`: {
			fdecls = parseProcedures(procedures);
			vars = parseVars(decls);
			block = parseBlock(stmts);
		}
		case (Module) `MODULE <ID id> ; <Procedures procedures> BEGIN <Statements stmts> END <ID id> .`: {
			fdecls = parseProcedures(procedures);
			block = parseBlock(stmts);
		}
		case (Module) `MODULE <ID id> ; <Declarations decls> BEGIN <Statements stmts> END <ID id> .`: {
			vars = parseVars(decls);
			block = parseBlock(stmts);
		}
		case (Module) `MODULE <ID id> ; BEGIN <Statements stmts> END <ID id> .`: {
			block = parseBlock(stmts);
		}
	};
	
	return program(vars, fdecls, BlockStmt(block));
}

private list[FDecl] parseProcedures(Procedures procedures) {
	list[FDecl] decls = [];
	top-down visit(procedures) {
		case (ProcedureDeclaration) `PROCEDURE <ID idBegin> : <Type t> ( <VarList varList> ) ; BEGIN <Statements stmts> END <ID idEnd> ;`: {
			decls += [FDecl(parseReturnType(unparse(t)), unparse(idBegin), parseParams(varList), BlockStmt(parseBlock(stmts)))];
		}
		case (ProcedureDeclaration) `PROCEDURE <ID idBegin> : <Type t> ; BEGIN <Statements stmts> END <ID idEnd> ;`: {
			decls += [FDecl(parseReturnType(unparse(t)), unparse(idBegin), parseParams(varList), BlockStmt(parseBlock(stmts)))];
		}
	}
	return decls;
}

private Type parseReturnType(str t) {
	switch(t) {
		case "BOOLEAN": return TBool();
		case "INTEGER": return TInt();
		case "VOID": 	return TUndef();
	}
}

private list[Statement] parseBlock(Statements stmts) {
	top-down visit(stmts) {
		case (Assignment)`<ID id> := <ComposedExpression exp>`: {
			return [Assignment(unparse(id), parseExp(exp))];
		}
		case (PrintStatement)`PRINT <ComposedExpression exp>`: {
			return [Print(parseExp(exp))];
		}
		case (ReturnStatement)`RETURN <ComposedExpression exp>`: {
			return [Return(parseExp(exp))];
		}
		case (WhileStatement)`WHILE <ComposedExpression exp> DO <Statements s> END`: {
			return [WhileStmt(parseExp(exp), BlockStmt(parseBlock(s)))];
		}
		case (IfStatement)`IF <ComposedExpression e> THEN <Statements s> END`: {
			return [IfStmt(parseExp(e), BlockStmt(parseBlock(s)))];
		}
		case (IfStatement)`IF <ComposedExpression e> THEN <Statements s1> ELSE <Statements s2> END`: {
			return [IfElseStmt(parseExp(e), BlockStmt(parseBlock(s1)), BlockStmt(parseBlock(s2)))];
		}
		default: ;
	}
}

private Expression parseExp(ComposedExpression exp) {
	top-down visit(exp) {
		case (ComposedExpression)`<SimpleExpression s>`: {
			return parseExp(s);
		}
		case (ComposedExpression)`<SimpleExpression s1> \< <SimpleExpression s2>`: {
			return Lt(parseExp(s1), parseExp(s2));
		}
		case (ComposedExpression)`<SimpleExpression s1> \> <SimpleExpression s2>`: {
			return Gt(parseExp(s1), parseExp(s2));
		}
		case (ComposedExpression)`<SimpleExpression s1> \>= <SimpleExpression s2>`: {
			return GoEq(parseExp(s1), parseExp(s2));
		}
		case (ComposedExpression)`<SimpleExpression s1> \<= <SimpleExpression s2>`: {
			return LoEq(parseExp(s1), parseExp(s2));
		}
		case (ComposedExpression)`<SimpleExpression s1> = <SimpleExpression s2>`: {
			return Eq(parseExp(s1), parseExp(s2));
		}
		case (ComposedExpression)`<SimpleExpression s1> # <SimpleExpression s2>`: {
			return NEq(parseExp(s1), parseExp(s2));
		}
		default: ;
	}
}

private Expression parseExp(SimpleExpression exp) {
	top-down visit(exp) {
		case (SimpleExpression)`<SimpleExpression s> + <Term t>`: { 
			return Add(parseExp(s), parseExp(t));
		}
		case (SimpleExpression)`<SimpleExpression s> - <Term t>`: { 
			return Sub(parseExp(s), parseExp(t)); 
		}
		case (SimpleExpression)`<SimpleExpression s> | <Term t>`: { 
			return Or(parseExp(s), parseExp(t)); 
		}
		case (SimpleExpression)`<Term t>`: {
			return parseExp(t);
		}
		case (SimpleExpression)`- <Term t>`: {
			return Neg(parseExp(t));
		}
		default: return Undefined(); 
	}
}

private Expression parseExp(Term t) {
	top-down visit(t) {
		case (Term)`<Factor f>`: return parseExp(f);
		case (Term)`<Term t> * <Factor f>`: {
			return Mult(parseExp(t), parseExp(f));
		}
		case (Term)`<Term t> / <Factor f>`: {
			return Div(parseExp(t), parseExp(f));
		}
		case (Term)`<Term t> & <Factor f>`: {
			return And(parseExp(t), parseExp(f));
		}
	}
}

private Expression parseExp(Factor f) {
	top-down visit(f) {
		case (ProcedureCall)`<ID id> ( <Explist l> )`: return Invoke(unparse(id), parseExplist(l));
		case (ProcedureCall)`<ID id> ()`: return Invoke(unparse(id), []);
		case (ID)`<ID id>`	: 		 return VarRef(unparse(id));
		case (INT)`<INT n>`	: 		 return IntValue(toInt(unparse(n)));
		case (BOOLEAN)`<BOOLEAN b>`: return (unparse(b) == "TRUE") ? BoolValue(true) : BoolValue(false);
		case (Factor)`( <ComposedExpression e> )`: return parseExp(e);
		case (Factor)`~ <Factor f>`: return Not(parseExp(f));
	}
}

private list[Expression] parseExplist(Explist l) {
	top-down visit(l) {
		case (Explist)`<ComposedExpression e> , <Explist l1>`: {
			return parseExp(e) + parseExplist(l1);
		}
		case (Explist)`<ComposedExpression e>` : {
			return [parseExp(e)];
		}
	}
}

private list[Variable] parseVars(Declarations decls) {
	list[Variable] vars = [];
	top-down visit(decls) {
		case (VariableDeclaration) `<ID name> : INTEGER`: {
			vars += [variable(unparse(name), TInt())];
		}
		case (VariableDeclaration) `<ID name> : BOOLEAN`: {
			vars += [variable(unparse(name), TBool())];
		}
	}
	return vars;
}

private list[Parameter] parseParams(VarList vars) {
	list[Parameter] params = [];
	top-down visit(vars) {
		case (VarList) `<ID name> : INTEGER`: {
			params += [Parameter(unparse(name), TInt())];
		}
		case (VarList) `<ID name> : BOOLEAN`: {
			params += [Parameter(unparse(name), TBool())];
		}
		case (VarList) `<ID name> : INTEGER, <VarList varList>`: {
			params += [Parameter(unparse(name), TInt())] + parseParams(varList);
		}
		case (VarList) `<ID name> : BOOLEAN, <VarList varList>`: {
			params += [Parameter(unparse(name), TBool())] + parseParams(varList);
		}
	}
	return params;
}
