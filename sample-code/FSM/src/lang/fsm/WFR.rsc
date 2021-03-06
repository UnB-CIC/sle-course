module lang::fsm::WFR

import IO; 
import List; 
import Set;
import lang::fsm::AbstractSyntax;
import lang::fsm::Helper; 

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

private str getErrorMessage(Error err) {
	str errorMessage;
	visit(err) {
		case noUniqueStartState(_) : errorMessage = "Multiple start states";
		case ambiguousTransitions(_) : errorMessage = "Ambigous transitions";
		case unresolvableTargetState(_) : errorMessage = "Transition without a target";
		case duplicatedStateIds(_) : errorMessage = "Duplicated State Ids";
		case unreachableStates(_) : errorMessage = "Unreachable State";
	}
	
	return errorMessage;
}

list[str] runWFR(StateMachine sm) {
	list[Error] mergeLists(list[Error] list1, list[Error] list2) { return merge(list1, list2); } 

	list[Error] errors = reducer([
		singleInitialState(sm),
		deterministicTransitions(sm),
		resolvableTargetState(sm),
		distinctStateIds(sm),
		reachableState(sm)
	], mergeLists, []);
	
	return [getErrorMessage(err) | Error err <- errors];
}
