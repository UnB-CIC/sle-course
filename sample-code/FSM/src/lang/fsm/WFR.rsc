module lang::fsm::WFR

import IO; 
import List; 
import Set;
import lang::fsm::AbstractSyntax; 

data Error = noUniqueStartState(list[State] initialStates)
           | unresolvableTargetState()
           | ambiguousTransitions(list[Transition] transitions)
           | unreachableStates();


list[Error] singleInitialState(StateMachine sm) = 1 == size(startStates(sm)) ? [] :  [noUniqueStartState(startStates(sm))];

bool resolvableTargetState(StateMachine sm) = toSet([t.target | Transition t <- sm.transitions]) == toSet(sm.states);

bool distinctStates(StateMachine sm) =  size(toSet([s.name | State s <- sm.states])) == size([s.name | State s <- sm.states]);

list[Error] deterministicTransitions(StateMachine sm) = isEmpty(showAmbiguos(showListTransitions(sm))) ? [] :[ambiguousTransitions(showAmbiguos(showListTransitions(sm)))];

public set[State] visited = {};
list[State] res = []; 

bool reachableState(StateMachine sm) {
	list[State] initialState = startStates(sm);
	reachables(sm, initialState[0]);
	return toSet(res) == toSet(sm.states);
}

//Help functions to identify WFR: -------------------------------------------------------------------------------------


list[State] startStates(StateMachine sm) = [startState(n) | startState(n) <- sm.states];

public list[Transition] showAmbiguos (list[Transition] l) = isEmpty(l) ? [] :findAmbiguos(head(l),tail(l))+showAmbiguos(tail(l));
list[Transition] findAmbiguos(Transition t,list[Transition] lt) = [X | Transition X <- lt,(X.source==t.source) && (X.event==t.event)];

public list[Transition] showListTransitions(StateMachine sm) = ([t | /Transition t <- sm]);

public void reachables(StateMachine sm, State s){
	if(!(s in visited)){
		visited += s;
		for(State target <- [ t | transition(s,e,t) <- sm.transitions]) {
		  res += target; 
		  reachables(sm, target); 
		}	
	}
}

private str getErrorMessage(Error err) {
	str errorMessage;
	visit(err) {
		case noUniqueStartState(_) : errorMessage = "Multiple start states";
	}
	
	return errorMessage;
}

list[str] runWFR(StateMachine sm) {
	list[Error] errors = singleInitialState(sm);
	return [getErrorMessage(err) | Error err <- errors ];
}
