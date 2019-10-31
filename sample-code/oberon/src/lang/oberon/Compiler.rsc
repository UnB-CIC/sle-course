module lang::oberon::Compiler
import lang::oberon::Sample;
import lang::oberon::AST;
import IO;
import List;

public void compile(OberonProgram p) {
	str allProgram = translateVar(p);
	
	allProgram = allProgram+"int main()"+"\n"+"{"+"\n";
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
	for(FDecl fp <- p.fns) {
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
	  	tFunc = tFunc+")"+"\n"+"{";
	  	//the block is here
	  	tFunc = tFunc+"\n"+"}"+"\n";
	}
	println("translate here the block of functions!");
	return tFunc;
}
public str translateMainBlock(p){
	str tBlock = "";
	println("translate here the main block!");
	return tBlock;
}