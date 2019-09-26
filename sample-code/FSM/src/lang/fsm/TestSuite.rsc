module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Parser;
import lang::fsm::WFR;
import lang::fsm::Sample;
import Set;
import List;
import String;
import IO;

test bool testSingleInitialState() = 0 == size(singleInitialState(acme)); 

test bool testResolvableTargetState() = 0 == size(resolvableTargetState(acme));

test bool testDistinctStates() = 0 == size(distinctStateIds(acme));

test bool testReachableState() =  0 == size(reachableState(acme));

test bool testDeterministicTransitions() = 0 == size(deterministicTransitions(acme));

test bool testWFRNoUniqueStartStateError() = ["Multiple start states"] == runWFR(startAcme);

test bool testWFRNoDuplicatedEvents() = ["Ambigous transitions"] == runWFR(duplicatedEventsAcme);

test bool testWFRNoTransitionWihtoutATarget() = ["Transition without a target"] == runWFR(trasitionWithoutATargetAcme);

test bool testWFRDuplicatedStateIds() = ["Duplicated State Ids"] == runWFR(duplicatedStatesAcme);

test bool testWFRStatesUnreachable() = ["Unreachable State"] == runWFR(unreachableStateAcme);