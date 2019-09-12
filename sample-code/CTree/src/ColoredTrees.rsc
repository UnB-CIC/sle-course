module ColoredTrees

data CTree = leaf(int N)
           | red(CTree left, CTree right)
           | black(CTree left, CTree right)
           ;
    
     
int elements(leaf(_)) = 1;
int elements(red(l, r)) = 1 + elements(l) + elements(r);
int elements(black(l, r)) = 1 + elements(l) + elements(r);
     
//int elements(CTree tree) { 
//	int res = 0;
//	switch(tree) {
//		case leaf(n): res = 1; 
//		case red(l, r): res = 1 + elements(l) + elements(r);
//		case black(l, r):  res = 1 + elements(l) + elements(r);
//	}
//	return res; 	
//}

int sumTree(CTree tree) {
 	int res = 0;  
  	top-down visit (tree) {
  		case leaf(n): res = res + n; 
  	}
  	return res;	 
}

CTree increment(CTree tree) =
  top-down visit (tree) {
    case leaf(n) => leaf(n + 1)
  };	

data CTree = green(CTree l, CTree r); 
	
CTree changeFirstBlack(CTree tree) {
  return top-down-break visit (tree) {
    case black(CTree l, CTree r) => green(l, r)
  };
}

str export(CTree t) {
 str g = "digraph g { \n"; 
 int id = 0; 
 map[CTree, str] decls = ();

 // print the nodes  
 top-down visit(t) {
    case red(l, r) :
 	{ 
 	   id = id + 1; 
 	   g += "  n<id> [label = \"\" shape = circle fillcolor = red style = filled]\n";
 	   decls += (red(l,r) : "n<id>"); 	    
 	}
 	case black(l, r) :
 	{ 
 	   id = id + 1; 
 	   g += "  n<id> [label = \"\" shape = circle fillcolor = black style = filled]\n";
 	   decls += (black(l,r) : "n<id>"); 	    
 	}
 	case leaf(n) : 
 	{
 	   id = id + 1; 
 	   g = g + "  n<id> [label = <n>] \n";
 	   decls += (leaf(n) : "n<id>");
 	}
 };

 // print the edges
 top-down visit(t) {
    case red(l, r) : { 
      g += "  <decls[red(l,r)]> -\> <decls[l]> \n";
      g += "  <decls[red(l,r)]> -\> <decls[r]> \n";
    }
    case black(l, r) : { 
      g += "  <decls[black(l,r)]> -\> <decls[l]> \n";
      g += "  <decls[black(l,r)]> -\> <decls[r]> \n";
    }
 }
 
 g += "}"; 
  
 return g; 
}
  

CTree sample() = red(black(leaf(1), black(leaf(2), leaf(3))),
                     black(leaf(4), leaf(5))); 
                     
                     
            