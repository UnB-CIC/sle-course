module lang::oberon::util::Stack

import lang::oberon::util::Maybe; 

data Stack[&T] = empty()
               | push(&T v, Stack[&T] s);
           
int size(empty()) = 0;
int size(push(v,r)) = 1 + size(r); 

tuple[Maybe, Stack] pop(empty()) = <nothing(), empty()>;
tuple[Maybe, Stack] pop(push(v, r)) = <just(v), r>;

Stack stack = push(1,push(2,empty()));

test bool emptySizeTest() = 0 == size(empty());
test bool sizeTest() = 2 == size(stack);

test bool emptyPopTest() = <nothing(), empty()> == pop(empty());
test bool popTest() = <just(1), push(2, empty())> == pop(stack);