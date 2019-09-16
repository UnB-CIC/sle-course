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

public list[Transition] listEquals (list[Transition] l) = isEmpty(l) ? [] :findEqualsC(head(l),tail(l))+listEquals(tail(l));

list[Transition] findEqualsC(Transition t,list[Transition] lt){
	return [X | Transition X <- lt,(X.source==t.source) && (X.event==t.event)];
}