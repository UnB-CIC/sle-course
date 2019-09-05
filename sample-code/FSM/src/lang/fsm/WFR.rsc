module lang::fsm::WFR

import IO; 
import List; 
import lang::fsm::AST; 


data Error = moreThanOneStartState()
           | noFinalState()
           | noStartState()
           | ambiguousTransitions(list[Transition] transitions);

// TODO:  
 // no transtition to start state
 // no transition from final state          
 
 
public list[Error] wfr(StateMachine m) = wfrNoStartState(m.states); 

private list[Error] wfrNoStartState([]) = [noStartState()];
private list[Error] wfrNoStartState([startState(), _]) = [];
private list[Error] wfrNoStartState([_, *L]) = wfrNoStartState(L); 

//
//private list[Error] wfrNoStartState(list[State] states) { 
//	switch (states) {
//		case [] : return [noStartState()]; 
//		case [startState(), _] : return [];
//		case [_, *L] : return wfrNoStartState(L);  
//	};
//} 

private list[Error] wfrMoreThanOneStartState(list[State] states, int accumulator = 0) { 
	total = countNumberOfStartStates(states);
	if(total > 1) return [moreThanOneStartState()]; 
	return []; 	
}

private int countNumberOfStartStates(list[State] states) = size([startState() | /startState() <- states]);

//
// another option using a visitor (visit construct)
//
 
//private int countNumberOfStartStates(list[State] states) {
//	total = 0; 
//	
//	visit(states) {
//		case startState(): total = total + 1; 
//	}
//	
//	return total; 
//}

test bool noStartStateTest() {
	s1 = state("pending"); 
	s2 = state("active"); 
	s3 = finalState(); 
	
	t1 = transition("confirm", s1, s2); 
	t2 = transition("delivery", s2, s3); 
	
	m = fsm([s1, s2, s3], [t1, t2]); 
	
	e1 = noStartState(); 
	
	
	return wfr(m) == [e1];
}

test bool moreThanOneStartStateTest() {
	start1 = startState(); 
	start2 = startState(); 
	
	m = fsm([start1, start2], []); 
	

	return wfrMoreThanOneStartState(m.states) == [moreThanOneStartState()];
}