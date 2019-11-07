module lang::oberon::ExecutionContext

import lang::util::Stack;
import lang::oberon::AST;
import lang::oberon::Interpreter; 

alias Memory = map[Name, Expression];
alias Static = Memory;

data Context = context(map[Name, FDecl] fnDecls, Static global, Stack[Memory] heap);

data Exception = nonDeclaredVariable(); 

Context initContext() =  context((), (), empty());

public Context notifyInvoke(context(fs, s, heap)) = context(fs, s, push((), heap));
public Context notifyInvoke(Memory m, context(fs, s, heap)) = context(fs, s, push(m, heap)); 

public Context notifyReturn(context(fs, s, empty())) = context(fs, s, empty());
public Context notifyReturn(context(fs, s, push(h, t))) = context(fs, s, t);

public Context declareFunction(FDecl f, context(fs, s, heap)) { 
  if(f.name in fs) { 
    throw "Function <f.name> already declared"; 
  } 
  return context((f.name: f) + fs, s, heap); 
}

public Context setGlobal(Name var, Expression exp, context(fs, s, heap)) {
   s1 = s; 
   s1[var] = eval(exp,context(fs,s,heap)); 
   return context(fs, s1, heap);
}

public Context setLocal(Name var, Expression exp, context(fs, s, heap)) {
   current = top(heap);
   current[var] = eval(exp,context(fs,s,heap)); 
   <h, t> = pop(heap);
   return context(fs, s, push(current, t));      
}

public Memory top(Stack[Memory] heap) {
  switch(peek(heap)) {
    case just(m) : return m; 
    default: return ();
  }
}
