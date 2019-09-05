module lang::fsm::AST

data StateMachine = fsm(list[State] states, list[Transition] transitions);

data State = state(str name)
           | startState()
           | finalState();
           
data Transition = transition(str evt, State source, State target); 
       