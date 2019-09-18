module lang::fsm::WFR

import IO; 
import List; 
import Set;
import lang::fsm::AbstractSyntax; 

data Error = moreThanOneStartState()
           | noFinalState()
           | noStartState()
           | ambiguousTransitions(list[Transition] transitions);


int startElement(startState(_)) = 1;
int startElement(state(_)) = 0;

bool singleInitialState(StateMachine sm) = 1 == size([s | State s <- sm.states, startElement(s) == 1]);

bool resolvableTargetState(StateMachine sm) = toSet([t.target | Transition t <- sm.transitions]) <= toSet(sm.states);

bool distinctStates(StateMachine sm) =  size(toSet([s.name | State s <- sm.states])) == size([s.name | State s <- sm.states]);


public set[State] visited = {};
list[State] reachables(StateMachine sm, State s){
	if( s in visited){
		return [];
	} else {
		visited += s;
		return [*reachables(sm, t.target) | Transition t <- sm.transitions, t.source == s];
	}
}

bool reachableState(StateMachine sm) {
	list[State] initialState = [s | State s <- sm.states, startElement(s) == 1];
	
	return toSet(reachables(sm, initialState[0])) == toSet(sm.states);
}