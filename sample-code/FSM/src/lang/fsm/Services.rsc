module lang::fsm::Services

import lang::fsm::AbstractSyntax;
import Set;
import List;
import IO;


//int initialStates(StateMachine sm){
//	int res =0;
//	top-down visit(sm.states){
//	
//		case startState(n): res= res+1;
//	}
//	return res;
//}

bool reachableState(StateMachine sm) = toSet(sm.states) == toSet([t.target | Transition t <- sm.transitions]);

bool distinctStates(StateMachine sm) =  size(toSet([s.name | State s <- sm.states])) == size([s.name | State s <- sm.states]);


public list[Transition] listEquals (list[Transition] l) = isEmpty(l) ? [] :findEqualsC(head(l),tail(l))+listEquals(tail(l));

list[Transition] findEqualsC(Transition t,list[Transition] lt){
	return [X | Transition X <- lt,(X.source==t.source) && (X.event==t.event)];
}

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