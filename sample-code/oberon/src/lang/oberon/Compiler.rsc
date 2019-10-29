module lang::oberon::Compiler
import lang::oberon::Sample;
import lang::oberon::AST;
import IO;
import List;

public void compile(OberonProgram p) {
	str allProgram = "int main()"+"\n"+"{"+"\n";
	
	allProgram = allProgram+translateVar(p);
	allProgram = allProgram+translateFunc(p);
	allProgram = allProgram+translateMainBlock(p);
	
  	allProgram = allProgram+"return 0;"+"\n"+"}";
  	writeFile(|home:///fileC.c|,allProgram);
}
public str translateVar(OberonProgram p){
	str tVar = "";
	for(Variable v <- p.vars) {
	  	top-down visit (v) {
	  		case variable(var,TInt()): tVar = tVar+"int "+var+";"+"\n"; 
	  		case variable(var,TBool()): tVar = tVar+"bool "+var+";"+"\n";
	  	}
  	}
  	return tVar;
}
public str translateFunc(p){
	str tFunc = "";
	println("translate here the functions!");
	return tFunc;
}
public str translateMainBlock(p){
	str tBlock = "";
	println("translate here the main block!");
	return tBlock;
}