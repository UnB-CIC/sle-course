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

bool reachableState(StateMachine sm) = toSet(sm.states) == toSet([t.target | Transition t <- sm.transitions]);

bool distinctStates(StateMachine sm) =  size(toSet([s.name | State s <- sm.states])) == size([s.name | State s <- sm.states]);
