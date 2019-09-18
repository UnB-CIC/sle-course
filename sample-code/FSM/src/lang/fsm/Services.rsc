module lang::fsm::Services

import lang::fsm::AbstractSyntax;
import Set;
import List;
import IO;

@doc { To test, use: https://dreampuf.github.io/GraphvizOnline}
public str toDot(StateMachine fsm) {
	str g = "digraph g{ \n";
	
	top-down visit(fsm){
		case startState(str name): g = g + "<name> [label=\"<name>\"]\n";
		case state(str name): g = g + "<name> [label=\"<name>\"]\n";
		case transition(State source, Event event, State target): g = g + "<source.name> -\> <target.name> [label = \"<event.evt>\"]\n";
	}
	
	g = g + "}\n";
	println(g);
	return "";
	
}

bool deterministicTransitions(StateMachine sm) = showAmbiguos(showListTransitions(sm))==[];
public list[Transition] showAmbiguos (list[Transition] l) = isEmpty(l) ? [] :findAmbiguos(head(l),tail(l))+showAmbiguos(tail(l));
list[Transition] findAmbiguos(Transition t,list[Transition] lt) = [X | Transition X <- lt,(X.source==t.source) && (X.event==t.event)];
/**
 * finds and show all the Transition.
 */
public list[Transition] showListTransitions(StateMachine sm) = ([t | /Transition t <- sm]);

