module lang::fsm::Interpreter

import lang::fsm::WFR;
import lang::fsm::AbstractSyntax;
import List;
import IO;

public list[str] run(list[str] eventList, StateMachine sm) {
	list [str] outPut = [];
	str actualState = startStates(sm)[0].name;
	for (int n <- [0..size(eventList)]){
		outPut = outPut + findAction(eventList[n], actualState, sm);
		actualState = nextState(eventList[n], actualState, sm)[0].name;
	}
	return outPut;
}

