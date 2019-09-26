module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Parser;
import lang::fsm::WFR;
import lang::fsm::Interpreter;

import Set;
import List;

public list[str] input = ["ticket","ticket","pass","pass","ticket","mute","release"];
public list[str] output = ["collect","eject","alarm","eject"];

StateMachine acme = parseFSM(|project://FSM/samples/sample01.fsm|); 

test bool testSingleInitialState() = 0 == size(singleInitialState(acme)); 

test bool testResolvableTargetState() = 0 == size(resolvableTargetState(acme));

test bool testDistinctStates() = 0 == size(distinctStateIds(acme));

test bool testReachableState() =  0 == size(reachableState(acme));

test bool testDeterministicTransitions() = 0 == size(deterministicTransitions(acme));

test bool testRun() = output == run(input,acme);