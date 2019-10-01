module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Parser;
import lang::fsm::WFR;
import lang::fsm::Interpreter;


import Set;
import List;
import IO;

public list[str] input = ["ticket","ticket","pass","pass","ticket","mute","release"];
public list[str] output = ["collect","eject","alarm","eject"];


StateMachine acme = parseFSM(|project://FSM/samples/sample01.fsm|); 

test bool testSingleInitialState() = 0 == size(singleInitialState(acme)); 

test bool testResolvableTargetState() = 0 == size(resolvableTargetState(acme));

test bool testDistinctStates() = 0 == size(distinctStateIds(acme));

test bool testReachableState() =  0 == size(reachableState(acme));

test bool testDeterministicTransitions() = 0 == size(deterministicTransitions(acme));


test bool testRun() = output == run(acme, input);

StateMachine duplicatedStartAcme = parseFSM(|project://FSM/samples/duplicatedStartAcme.fsm|); 
test bool testWFRNoUniqueStartStateError() = ["Multiple start states", "Unreachable State"] == runWFR(duplicatedStartAcme);

StateMachine duplicatedEventsAcme = parseFSM(|project://FSM/samples/duplicatedEventsAcme.fsm|); 
test bool testWFRNoDuplicatedEvents() = ["Ambigous transitions"] == runWFR(duplicatedEventsAcme);

StateMachine trasitionWithoutAValidTargetAcme = parseFSM(|project://FSM/samples/trasitionWithoutAValidTargetAcme.fsm|); 
test bool testWFRNoTransitionWihtoutATarget() = ["Transition without a target"] == runWFR(trasitionWithoutAValidTargetAcme);

StateMachine duplicatedStateAcme = parseFSM(|project://FSM/samples/duplicatedStateAcme.fsm|); 
test bool testWFRDuplicatedStateIds() = ["Duplicated State Ids"] == runWFR(duplicatedStateAcme);

StateMachine unreachableStateAcme = parseFSM(|project://FSM/samples/unreachableStateAcme.fsm|); 
test bool testWFRStatesUnreachable() = ["Unreachable State"] == runWFR(unreachableStateAcme);

