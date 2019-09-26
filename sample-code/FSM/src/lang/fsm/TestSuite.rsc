module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Parser;
import lang::fsm::WFR;

import Set;
import List;

StateMachine acme = parseFSM(|project://FSM/samples/sample01.fsm|); 

test bool testSingleInitialState() = 0 == size(singleInitialState(acme)); 

test bool testResolvableTargetState() = 0 == size(resolvableTargetState(acme));

test bool testDistinctStates() = 0 == size(distinctStateIds(acme));

test bool testReachableState() =  0 == size(reachableState(acme));

test bool testDeterministicTransitions() = 0 == size(deterministicTransitions(acme));

