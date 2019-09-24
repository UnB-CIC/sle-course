module lang::fsm::Parser

import ParseTree;
import IO;

import lang::fsm::ConcreteSyntax;
import lang::fsm::AbstractSyntax; 

public StateMachine parseFSM(loc file) {
 list[State] states = [];
 list[Transition] transitions = [];
 
 start[FSM] parseResult = parse(#start[FSM], file);
 
 top-down visit (parseResult) {
    case (CState)`initial state <Id id> { <CEvent* evts>}`: {
      State s = startState(unparse(id));
      states += s;
      transitions += parseEvents(s, evts);
    }
    case (CState)`state <Id id> { <CEvent* evts>}`: {
      State s = state(unparse(id));
      states += s;
      transitions += parseEvents(s, evts);	
    }
 };
 
 return fsm(states, transitions);
}

list[Transition] parseEvents(State source, CEvent* evts) {
  list[Transition] ts = [];
  top-down visit(evts) {
  	case (CEvent)`<Id e> -\> <Id target>;` : ts += transition(source, event(unparse(e)), state(unparse(target)));
  	case (CEvent)`<Id e>;` : ts += transition(source, event(unparse(e)), source);
  	case (CEvent)`<Id e> / <Id a> -\> <Id target>;` : ts += transition(source, eventWithAction(unparse(e), unparse(a)), state(unparse(target)));
  	case (CEvent)`<Id e> / <Id a>;` : ts += transition(source, eventWithAction(unparse(e), unparse(a)), source);
  }
  return ts;
}