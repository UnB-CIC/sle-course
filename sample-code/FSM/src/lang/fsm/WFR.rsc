module lang::fsm::WFR

import IO; 
import List; 
import lang::fsm::AbstractSyntax; 

data Error = moreThanOneStartState()
           | noFinalState()
           | noStartState()
           | ambiguousTransitions(list[Transition] transitions);


int startElement(startState(_)) = 1;
int startElement(state(_)) = 0;

bool singleInitialState(StateMachine sm) = 1 == size([s | State s <- sm.states, startElement(s) == 1]);
