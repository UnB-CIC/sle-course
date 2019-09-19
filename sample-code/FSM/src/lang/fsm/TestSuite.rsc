module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Sample;
import lang::fsm::WFR;
import Set;
import List;

test bool testSingleInitialState() = 0 == size(singleInitialState(acme)); 

test bool testResolvableTargetState() = resolvableTargetState(acme);

test bool testDistinctStates() = distinctStates(acme);

test bool testReachableState() = reachableState(acme);

test bool testDeterministicTransitions() = 0 == size(deterministicTransitions(acme));

