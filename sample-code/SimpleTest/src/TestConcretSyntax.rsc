module TestConcretSyntax

import ParseTree;
import lang::java::\syntax::Java18; 

str sample1 = "while (condition) x++;";
str sample2 = "while( condition ) x++;";
str expected = "while(condition) x = x + 1;";

Statement transform(Statement s) =
  top-down visit(s) {
    case (Statement)`while(<Expression c>) x++;` => (Statement)`while(<Expression c>) x = x+1;`
  };
  
test bool tc01() {
  s1 = parse(#Statement, sample1); 
  s2 = parse(#Statement, expected); 
  
  return s2 == transform(s1);
}

test bool tc01() {
  s1 = parse(#Statement, sample2); 
  s2 = parse(#Statement, expected); 
  
  return s2 == transform(s1);
}

