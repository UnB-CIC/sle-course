module lang::util::Maybe

data Maybe[&T] = nothing()
		       | just(&T v);
		       
bool isJust(nothing()) = false; 
bool isJust(just(_)) = true; 

Maybe[&K] apply(&K (&T) fn, empty()) = empty();
Maybe[&K] apply(&K (&T) fn, just(v)) = just(fn(v));