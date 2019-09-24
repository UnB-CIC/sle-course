module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
//import lang::fsm::Sample;
import lang::fsm::Parser;
import lang::fsm::Services;
import Set;
import List;

StateMachine acme = parseFSM(|project://sle/samples/sample01.fsm|); 

test bool testSingleInitialState() = 1 == initialStates(acme); 
test bool testMultipleInitialState() = 1 != initialStates(acme); 

test bool testReachableState() = reachableState(acme);
test bool testUnreachableState() = false == reachableState(acme);

test bool testDistinctStates() = distinctStates(acme);
test bool testDuplicatedStates() = false == distinctStates(acme);

//list[Transition] testShowAmbiguos() = showAmbiguos(acme);