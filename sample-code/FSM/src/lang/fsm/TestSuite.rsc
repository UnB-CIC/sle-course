module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Sample;
import lang::fsm::Services;
import lang::fsm::WFR;
import Set;
import List;


test bool testSingleInitialState() = true == singleInitialState(acme); 
test bool testMultipleInitialState() = false == singleInitialState(acme); 

test bool testReachableState() = reachableState(acme);
test bool testUnreachableState() = false == reachableState(acme);

test bool testDistinctStates() = distinctStates(acme);
test bool testDuplicatedStates() = false == distinctStates(acme);

//list[Transition] testShowAmbiguos() = showAmbiguos(acme);