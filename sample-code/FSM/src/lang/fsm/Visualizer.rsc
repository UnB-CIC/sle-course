module lang::fsm::Visualization

import lang::fsm::AbstractSyntax;
import IO;
import Exception;

@doc { To test, use: https://dreampuf.github.io/GraphvizOnline}
public void toDot(StateMachine fsm) {
	str g = "digraph g{ \n";
	
	top-down visit(fsm){
		case startState(str name): g = g + "<name> [label=\"<name>\"]\n";
		case state(str name): g = g + "<name> [label=\"<name>\"]\n";
		case transition(State source, Event event, State target): try g = g + "<source.name> -\> <target.name> [label = \"<event.evt>/<event.action>\"]\n"; catch: g = g + "<source.name> -\> <target.name> [label = \"<event.evt>\"]\n";  
	}
	
	g = g + "}\n";
	println(g);
	writeFile(|project://FSM/samples/graph.dot|, g);	
}