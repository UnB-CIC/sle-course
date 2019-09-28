module lang::fsm::Helper

import List;
import lang::fsm::AbstractSyntax; 

//-------------------------------------------Help functions to Interpreter: --------------------------------------------
public list[Transition] showTransitionState(str s, StateMachine sm) = ([t | /Transition t <- sm,(t.source.name==s)]);

public list[str] actionTransition(str ev,Transition t) = ([a | eventWithAction(e,a) <- t, (ev==e)]);
public list[str] showOutput (str e, list[Transition] l) = isEmpty(l) ? [] :actionTransition(e, head(l))+showOutput(e,tail(l));
public list[str] findAction(str e, str s, StateMachine sm) = showOutput(e, showTransitionState(s,sm));


public list[State] filterTarget(str ev,Transition t) = ([t.target | event(e) <- t, (ev==e)])+([t.target | eventWithAction(e,a) <- t, (ev==e)]);
public list[State] filterTransition (str e, list[Transition] l) = isEmpty(l) ? [] :filterTarget(e, head(l))+filterTransition(e,tail(l));
public list[State] nextState(str e, str s, StateMachine sm) = filterTransition(e, showTransitionState(s,sm));


//--------------------------------------- Help functions to identify WFR: -------------------------------------------------------------------------------------

public list[State] startStates(StateMachine sm) = [startState(n) | startState(n) <- sm.states];

public list[Transition] showAmbiguos (list[Transition] l) = isEmpty(l) ? [] :findAmbiguos(head(l),tail(l))+showAmbiguos(tail(l));
public list[Transition] findAmbiguos(Transition t,list[Transition] lt) = [X | Transition X <- lt,(X.source==t.source) && (X.event==t.event)];

public list[Transition] showListTransitions(StateMachine sm) = ([t | /Transition t <- sm]);

public set[State] visited = {};
public list[State] res = []; 

public void reachables(StateMachine sm, State s){
	if(!(s in visited)){
		visited += s;
		for(State target <- [ t | transition(s,e,t) <- sm.transitions]) {
		  res += target; 
		  reachables(sm, target); 
		}	
	}
}

