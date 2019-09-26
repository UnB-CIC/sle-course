module lang::fsm::Interpreter

import lang::fsm::WFR;
import lang::fsm::AbstractSyntax;
import List;

public list[str] run(list[str] stateList, StateMachine sm) {
	list [str] outPut = [];
	State actualState = startStates(sm)[0];
	for (int n <- [0..size(stateList)]){
		outPut = outPut + findAction(stateList[n], actualState, sm);
		actualState = nextState(stateList[n], actualState, sm)[0];	
	}
	return outPut;
}
