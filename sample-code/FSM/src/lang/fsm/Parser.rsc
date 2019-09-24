module lang::fsm::Parser

import ParseTree;
import IO;

import lang::fsm::ConcreteSyntax;
import lang::fsm::AbstractSyntax; 

public StateMachine parseFSM(str f) {
 loc file = |file:///| + f;
 list[State] states = [];
 list[Transition] transitions = [];
 
 start[FSM] parseResult = parse(#start[FSM], file);
 
 top-down visit (parseResult) {
    case (CState)`initial state <Id id> { <CEvent* evts>}`: {
      states += startState(unparse(id));
      transitions += parseEvents(id, evts);
    }
    case (CState)`state <Id id> { <CEvent* evts>}`: {
      states += state(unparse(id));
      transitions += parseEvents(id, evts);	
    }
 };
 
 return fsm(states, transitions);
}

list[Transition] parseEvents(Id source, CEvent* evts) {
  list[Transition] ts = [];
  top-down visit(evts) {
  	case (CEvent)`<Id e> -\> <Id target>;` : ts += transition(unparse(source), event(unparse(e)), unparse(target));
  	case (CEvent)`<Id e>;` : ts += transition(unparse(source), event(unparse(e)), unparse(source));
  	case (CEvent)`<Id e> / <Id a> -\> <Id target>;` : ts += transition(unparse(source), eventWithAction(unparse(e), unparse(a)), unparse(target));
  	case (CEvent)`<Id e> / <Id a>;` : ts += transition(unparse(source), eventWithAction(unparse(e), unparse(a)), unparse(source));
  }
  return ts;
}