module lang::fsm::Interpreter

import lang::fsm::Helper;
import lang::fsm::AbstractSyntax;
import List;
import IO;

public list[str] run(StateMachine sm, list[str] eventList) =
  [s | s<- executeAll(sm, startStates(sm)[0], eventList), s != ""];


list[str] executeAll(StateMachine sm, State source, list[str] evts) {
	switch(evts) {
		case [] : return []; 
		case [e,es*] : {
			tuple[State next, str action] res = execute(sm, source, e);
			return (res.action + executeAll(sm, res.next, es)); 
		}
	}
}

tuple[State, str] execute(StateMachine sm, State source, str evt) {
	for(Transition t <- sm.transitions) {
		switch(t) {
			case transition(source, event(evt), target): return <target, "">; 
			case transition(source, eventWithAction(evt, act), target): return <target, act>; 
		}
	}
	throw "coult not find a valid event"; 
} 

