module lang::fsm::WFR

import IO; 
import List; 
import Set;
import lang::fsm::AbstractSyntax; 

data Error = moreThanOneStartState()
           | noFinalState()
           | noStartState()
           | ambiguousTransitions(list[Transition] transitions);


bool singleInitialState(StateMachine sm) = 1 == size([s | State s <- sm.states, startElement(s) == 1]);

bool resolvableTargetState(StateMachine sm) = toSet([t.target | Transition t <- sm.transitions]) <= toSet(sm.states);

bool distinctStates(StateMachine sm) =  size(toSet([s.name | State s <- sm.states])) == size([s.name | State s <- sm.states]);

bool deterministicTransitions(StateMachine sm) = showAmbiguos(showListTransitions(sm))==[];

bool reachableState(StateMachine sm) {
	list[State] initialState = [s | State s <- sm.states, startElement(s) == 1];
	
	return toSet(reachables(sm, initialState[0])) == toSet(sm.states);
}

//Help functions to identify WFR: 

int startElement(startState(_)) = 1;
int startElement(state(_)) = 0;

public list[Transition] showAmbiguos (list[Transition] l) = isEmpty(l) ? [] :findAmbiguos(head(l),tail(l))+showAmbiguos(tail(l));
list[Transition] findAmbiguos(Transition t,list[Transition] lt) = [X | Transition X <- lt,(X.source==t.source) && (X.event==t.event)];

public list[Transition] showListTransitions(StateMachine sm) = ([t | /Transition t <- sm]);

public set[State] visited = {};
list[State] reachables(StateMachine sm, State s){
	if( s in visited){
		return [];
	} else {
		visited += s;
		return [*reachables(sm, t.target) | Transition t <- sm.transitions, t.source == s];
	}
}

