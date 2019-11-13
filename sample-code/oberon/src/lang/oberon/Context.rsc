module lang::oberon::Context

import lang::util::Stack;
import lang::oberon::AST;
import lang::oberon::Interpreter; 

data Context[&T] = context(map[Name, FDecl] fnDecls, map[Name, &T] global, Stack[map[Name,&T]] heap);

data Exception = nonDeclaredVariable(); 

Context[&T] initContext() =  context((), (), empty());

public Context[&T] notifyInvoke(context(fs, s, heap)) = context(fs, s, push((), heap));
public Context[&T] notifyInvoke(map[Name,&T] m, context(fs, s, heap)) = context(fs, s, push(m, heap)); 

public Context[&T] notifyReturn(context(fs, s, empty())) = context(fs, s, empty());
public Context[&T] notifyReturn(context(fs, s, push(h, t))) = context(fs, s, t);

public Context[&T] declareFunction(FDecl f, context(fs, s, heap)) { 
  if(f.name in fs) { 
    throw "Function <f.name> already declared"; 
  } 
  return context((f.name: f) + fs, s, heap); 
}

public Context[&T] setGlobal(Name var, &T v, context(fs, s, heap)) {
   s1 = s; 
   s1[var] = v; 
   return context(fs, s1, heap);
}

public Context[&T] setLocal(Name var, &T v, context(fs, s, heap)) {
   current = top(heap);
   current[var] = v; 
   <h, t> = pop(heap);
   return context(fs, s, push(current, t));      
}

public map[Name, &T] top(Stack[map[Name, &T]] heap) {
  switch(peek(heap)) {
    case just(m) : return m; 
    default: return ();
  }
}
