module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Sample;
import lang::fsm::Services;
import List;

test bool testSingleInitialState() = 1 == initialStates(acme); 

test bool testMultipleInitialState() = 1 != initialStates(acme); 

test bool testReachableState() = reachableState(acme);
test bool testUnreachableState() = false == reachableState(acme);
