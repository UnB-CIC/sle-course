module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Parser;
import lang::fsm::WFR;
import lang::fsm::Sample;
import Set;
import List;
import String;

test bool testSingleInitialState() = 0 == size(singleInitialState(acme)); 

test bool testResolvableTargetState() = resolvableTargetState(acme);

test bool testDistinctStates() = distinctStates(acme);

test bool testReachableState() = reachableState(acme);

test bool testDeterministicTransitions() = 0 == size(deterministicTransitions(acme));

test bool testWFRNoUniqueStartStateError() = ["Multiple start states"] == runWFR(startAcme);

// test bool testWFRNoUniqueStartStateError() = ["Ambigous transitions"] == runWFR(startAcme);