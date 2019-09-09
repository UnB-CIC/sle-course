module lang::fsm::AbstractSyntax

data StateMachine 
  = fsm(list[State] states, list[Transition] transitions);

data State 
  = state(str name)
  | startState(str name)
  ;
           
data Transition 
  = transition(str source, Event event, str target);
  
data Event 
  = event(str evt)
  | eventWithAction(str evt, str action)
  ;