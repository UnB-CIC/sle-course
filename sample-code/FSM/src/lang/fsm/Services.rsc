module lang::fsm::Services

import lang::fsm::AbstractSyntax;

import List;

int initialStates(StateMachine sm) = size([s | State s <- sm.states, startElement(s) == 1]);
	int startElement(startState(_)) = 1;
	int startElement(state(_)) = 0;

/**
 * finds and show all the Transition.
 */
public list[Transition] showListTransitions(StateMachine sm) = ([t | /Transition t <- sm]);

bool reachableState(StateMachine sm) = toSet(sm.states) == toSet([t.target | Transition t <- sm.transitions]);

public list[Transition] showAmbiguos (list[Transition] l) = isEmpty(l) ? [] :findAmbiguos(head(l),tail(l))+showAmbiguos(tail(l));
list[Transition] findAmbiguos(Transition t,list[Transition] lt) = [X | Transition X <- lt,(X.source==t.source) && (X.event==t.event)];