module lang::fsm::Interpreter

import lang::fsm::WFR;
import lang::fsm::AbstractSyntax;
import List;

public list[str] run(list[str] l, StateMachine sm) {
	list [str] outPut = [];
	list [State] ls = startStates(sm);
	State actualState = ls[0];
	str event = head(l);
	int n = 0;
	while (n < size(l)){
		outPut = outPut + showAll(l[n], actualState, sm);
		actualState = nextState(l[n], actualState, sm)[0];
		n = n+1;
	}
	return outPut;
}
