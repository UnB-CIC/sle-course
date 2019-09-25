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

//---------------------------------------------
public list[Transition] showTransitionState(State s, StateMachine sm) = ([t | /Transition t <- sm,(t.source==s)]);

public list[str] actionTransition(str ev,Transition t) = ([a | eventWithAction(e,a) <- t, (ev==e)]);
public list[str] showOutput (str e, list[Transition] l) = isEmpty(l) ? [] :actionTransition(e, head(l))+showOutput(e,tail(l));
public list[str] showAll(str e, State s, StateMachine sm) = showOutput(e, showTransitionState(s,sm));


public list[State] filterTarget(str ev,Transition t) = ([t.target | event(e) <- t, (ev==e)])+([t.target | eventWithAction(e,a) <- t, (ev==e)]);
public list[State] filterTransition (str e, list[Transition] l) = isEmpty(l) ? [] :filterTarget(e, head(l))+filterTransition(e,tail(l));
public list[State] nextState(str e, State s, StateMachine sm) = filterTransition(e, showTransitionState(s,sm));


//---------------------------------------
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

