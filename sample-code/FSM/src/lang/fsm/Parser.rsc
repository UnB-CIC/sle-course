module lang::fsm::Parser

import ParseTree;
import IO;

import lang::fsm::ConcreteSyntax;
import lang::fsm::AbstractSyntax; 

list[State] states = [];
list[Transition] transitions = [];
 
public StateMachine parseFSM(loc file) {	 
 states = [];	
 transitions = [];
 
 map[State s, CEvent* evts] acc = (); 
 	 
 start[FSM] parseResult = parse(#start[FSM], file);
 
 top-down visit (parseResult) {
    case (CState)`initial state <Id id> { <CEvent* evts>}`: {
      State s = startState(unparse(id));
      states += s;
      acc[s] = evts; 
    }
    case (CState)`state <Id id> { <CEvent* evts>}`: {
      State s = state(unparse(id));
      states += s;
      acc[s] = evts; 	
    } 
 };
  
 for(State s <- acc) {
   transitions += parseEvents(s, acc[s]);
 }
 
 return fsm(states, transitions);
}

list[Transition] parseEvents(State source, CEvent* evts) {
  list[Transition] ts = [];
  top-down visit(evts) {
  	case (CEvent)`<Id e> -\> <Id target>;` : ts += transition(source, event(unparse(e)), findState(unparse(target)));
  	case (CEvent)`<Id e>;` : ts += transition(source, event(unparse(e)), source);
  	case (CEvent)`<Id e> / <Id a> -\> <Id target>;` : ts += transition(source, eventWithAction(unparse(e), unparse(a)), findState(unparse(target)));
  	case (CEvent)`<Id e> / <Id a>;` : ts += transition(source, eventWithAction(unparse(e), unparse(a)), source);
  }
  return ts;
}

State findState(str id) {
   for(State s <- states) {		
        switch(s) {
			case state(id)  : return state(id);  
			case startState(id) : return startState(id);   
		}	
	}
	return state(id);
}