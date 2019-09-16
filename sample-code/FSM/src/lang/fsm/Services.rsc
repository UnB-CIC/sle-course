module lang::fsm::Services

import lang::fsm::AbstractSyntax;
import List;

//bool singleInitialState(StateMachine sm) = 1 == size([s | /State() s <- sm.states]);


int initialStates(StateMachine sm){
	int res =0;
	top-down visit(sm.states){
	
		case startState(n): res= res+1;
	}
	return res;
}