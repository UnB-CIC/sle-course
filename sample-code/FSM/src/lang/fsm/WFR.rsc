module lang::fsm::WFR

import IO; 
import List; 
import Set;
import lang::fsm::AbstractSyntax; 

data Error = noUniqueStartState(list[State] initialStates)
           | unresolvableTargetState(list[str] noStates)
           | ambiguousTransitions(list[Transition] transitions)
           | duplicatedStateIds(list[str] duplicated)
           | unreachableStates(list[str] unreachable);


list[Error] singleInitialState(StateMachine sm) = 1 == size(startStates(sm)) ? [] :  [noUniqueStartState(startStates(sm))];

list[Error] resolvableTargetState(StateMachine sm) = (toSet([t.target.name | Transition t <- sm.transitions]) <= toSet([s.name | State s <- sm.states])) ? [] : [unresolvableTargetState(toList(toSet([t.target.name | Transition t <- sm.transitions]) - toSet([s.name | State s <- sm.states])))];

list[Error] distinctStateIds(StateMachine sm) =  size(toSet([s.name | State s <- sm.states])) == size([s.name | State s <- sm.states]) ? [] : [duplicatedStateIds([s.name | State s <- sm.states] - toList(toSet([s.name | State s <- sm.states])))];

list[Error] deterministicTransitions(StateMachine sm) = isEmpty(showAmbiguos(showListTransitions(sm))) ? [] :[ambiguousTransitions(showAmbiguos(showListTransitions(sm)))];

list[Error] reachableState(StateMachine sm) {
	list[State] initialState = startStates(sm);
	reachables(sm, initialState[0]);
	return toSet([s.name | State s <- res]) == toSet([s.name | State s <- sm.states]) ? [] : [unreachableStates([s.name | State s <- sm.states] - [s.name | State s <- res])];
}

//Help functions to identify WFR: -------------------------------------------------------------------------------------


public list[State] startStates(StateMachine sm) = [startState(n) | startState(n) <- sm.states];

public list[Transition] showAmbiguos (list[Transition] l) = isEmpty(l) ? [] :findAmbiguos(head(l),tail(l))+showAmbiguos(tail(l));
list[Transition] findAmbiguos(Transition t,list[Transition] lt) = [X | Transition X <- lt,(X.source==t.source) && (X.event==t.event)];

public list[Transition] showListTransitions(StateMachine sm) = ([t | /Transition t <- sm]);

public set[State] visited = {};
list[State] res = []; 

public void reachables(StateMachine sm, State s){
	if(!(s in visited)){
		visited += s;
		for(State target <- [ t | transition(s,e,t) <- sm.transitions]) {
		  res += target; 
		  reachables(sm, target); 
		}	
	}
}


