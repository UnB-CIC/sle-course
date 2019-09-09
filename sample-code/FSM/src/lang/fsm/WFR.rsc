module lang::fsm::WFR

import IO; 
import List; 
import lang::fsm::AbstractSyntax; 

data Error = moreThanOneStartState()
           | noFinalState()
           | noStartState()
           | ambiguousTransitions(list[Transition] transitions);

