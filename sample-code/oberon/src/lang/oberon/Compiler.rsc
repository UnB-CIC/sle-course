module lang::oberon::Compiler
import lang::oberon::Sample;
import lang::oberon::AST;
import IO;
import List;

public void compile(OberonProgram p) {
	str allProgram = translateVar(p.vars);
	
	allProgram = allProgram+translateFunc(p.fns);
	allProgram = allProgram+"int main()\n{\n";
	allProgram = allProgram+translateMainBlock(p.block);
	println(p.block);
	
  	allProgram = allProgram+"\n}";
  	writeFile(|home:///fileC.c|,allProgram);
}

public str translateMainBlock(Statement block){
	str tBlock = "";
	tBlock = translateBlock(block);
	return tBlock;
}

private str translateBlock(list[Statement] block) = ("" | it + translateStmtExpr(s) | s <- block);
private str translateBlock(Statement block) = translateStmtExpr(block);

private str translateStmtExpr(stmt){
	switch(stmt) {
		case Print(r): return "print(<translateStmtExpr(r)>);\n";
		case Assignment(n,v): return "<n> = <translateStmtExpr(v)>;\n";
		case Return(r): return "return <translateStmtExpr(r)>;\n";
		case BlockStmt(s): return ("" | it + translateStmtExpr(x) | x <- s);
		case WhileStmt(e, b): return "while (<translateStmtExpr(e)>) {\n<translateStmtExpr(b)>\n}\n";
		
		case IntValue(i): return "<i>";
		case Invoke(f,p): return "<f>(<("" | it + translateStmtExpr(e) | Expression e <- p)>);\n";
		case VarRef(v): return "<v>";
		case Lt(lhs,rhs): return "<translateStmtExpr(lhs)> \< <translateStmtExpr(rhs)>";
		case Add(lhs,rhs): return "<translateStmtExpr(lhs)> + <translateStmtExpr(rhs)>";
		default: throw "Translation for expression <stmt> not implemented";
	}
}

public str translateVar(list[Variable] vars){
	str tVar = "";
	for(Variable v <- vars) {
	  	top-down visit (v) {
	  		case variable(var,TInt()): tVar = tVar+"int "+var+";"+"\n"; 
	  		case variable(var,TBool()): tVar = tVar+"bool "+var+";"+"\n";
	  	}
  	}
  	return tVar;
}


public str translateFunc(list[FDecl] fns){
	str tFunc = "";
	for(FDecl fp <- fns) {
	  	top-down visit (fp) {
	  		case FDecl(TInt(),nF,_,_): tFunc = tFunc+"int "+nF+"(";
	  		case FDecl(TBool(),nF,_,_): tFunc = tFunc+"bool "+nF+"(";
	  	}
	  	for (Parameter pF <-fp.args){
	  		if((indexOf(fp.args,pF))>0)
	  			tFunc = tFunc+",";
	  		top-down visit (pF) {
	  			case Parameter(nP,TInt()): tFunc = tFunc+"int "+nP;
	  			case Parameter(nP,TBool()): tFunc = tFunc+"bool "+nP;
	  		}
	  	}
	  	tFunc = tFunc+")"+"\n"+"{\n";
	  	tFunc = tFunc + translateBlock(fp.block);
	  	tFunc = tFunc+"\n"+"}"+"\n";
	}
	
	return tFunc;
}
