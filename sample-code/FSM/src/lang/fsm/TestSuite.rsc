module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Parser;
import lang::fsm::WFR;
import Set;
import List;

StateMachine acme = parseFSM(|project://sle/samples/sample01.fsm|); 

test bool testSingleInitialState() = true == singleInitialState(acme); 
test bool testMultipleInitialState() = false == singleInitialState(acme); 

test bool testResolvableTargetState() = resolvableTargetState(acme);
test bool testUnresolvableTargetState() = false == resolvableTargetState(acme);

test bool testDistinctStates() = distinctStates(acme);
test bool testDuplicatedStates() = false == distinctStates(acme);

test bool testReachableState() = reachableState(acme);
test bool testUnreachableState() = false == reachableState(acme);

test bool testDeterministicTransitions() = deterministicTransitions(acme);
test bool testIndeterministicTransitions() = false == deterministicTransitions(acme);

