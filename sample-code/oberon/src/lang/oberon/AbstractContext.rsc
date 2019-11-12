module lang::oberon::AbstractContext

import lang::util::Stack; 
import lang::oberon::AST; 
import lang::oberon::Interpreter; 

alias Memory[&T] = map[Name, T];
alias Static[&T] = Memory[T];

data AbstractContext[&T] = context(map[Name, FDecl] fnDecls, Static[&T] global, Stack[Memory[&T]] heap);


public Context[&T] setGlobal(Name var, &T exp, Context[&T] context(fs, Static[&T]s, Stack[Memory[&T]] heap)) {
   s1 = s; 
   s1[var] = eval(exp,context(fs,s,heap)); 
   return context(fs, s1, heap);
}
