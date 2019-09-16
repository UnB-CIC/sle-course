module lang::fsm::Services

import lang::fsm::AbstractSyntax;
import List;

/**
 * finds and show all the Transition.
 */
public list[Transition] showListTransitions(StateMachine sm) = ([t | /Transition t <- sm]);
/**
 * finds and show all the distinct Source State.
 */
public list[State] showListStateSource (StateMachine sm) = dup([t.source | /Transition t <- sm]);
/**
 * finds quantity of Start State.
 */
int startElement(startState(_)) = 1;
int startElement(state(_)) = 0;
public int quantityStartState (list[State] ls) = isEmpty(ls) ? 0 : startElement(head(ls))+quantityStartState(tail(ls));
/**
 * finds quantity of Transitions.
 */
int element(transition(_,_,_)) = 1;
public int quantityTransitions (list[Transition] lt) = isEmpty(lt) ? 0 : element(head(lt))+quantityTransitions(tail(lt));

/*list[int] findEquals(int t,list[int] li){
	list[int] resp = [];
	int i = 0;
	while (i<size(li)){
		if (t == li[i]){
			resp = resp+t;
		}
		i=i+1;
	}
	return resp;
}

public list[int] listEquals (list[int] l) = isEmpty(l) ? [] :findEquals(head(l),tail(l))+listEquals(tail(l));
*/
list[Transition] findEquals(Transition t,list[Transition] lt){
	list[Transition] resp = [];
	int i = 0;
	while (i<size(lt)){
		if (t.source == lt[i].source){
			if (t.event == lt[i].event){
				resp = resp+t;
			}
		}
		i=i+1;
	}
	return resp;
}
public list[Transition] listEquals (list[Transition] l) = isEmpty(l) ? [] :findEquals(head(l),tail(l))+listEquals(tail(l));



