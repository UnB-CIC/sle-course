module lang::fsm::Services

import lang::fsm::AbstractSyntax;

import List;

int initialStates(StateMachine sm) = size([s | State s <- sm.states, startElement(s) == 1]);
	int startElement(startState(_)) = 1;
	int startElement(state(_)) = 0;

//int initialStates(StateMachine sm){
//	int res =0;
//	top-down visit(sm.states){
//	
//		case startState(n): res= res+1;
//	}
//	return res;
//}

bool reachableState(StateMachine sm) = toSet(sm.states) == toSet([t.target | Transition t <- sm.transitions]);