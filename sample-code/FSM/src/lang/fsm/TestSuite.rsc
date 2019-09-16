module lang::fsm::TestSuite

import lang::fsm::AbstractSyntax;
import lang::fsm::Sample;
import lang::fsm::Services;
import List;

list[Transition] testListTransitions() = showListTransitions(acme);
list[State] testListStateSource() = showListStateSource(acme);

int testQuantityStartState() = quantityStartState(testListStateSource());
int testQuantityTransitions() = quantityTransitions(testListTransitions());

list[Transition] testEquals() = listEquals(testListTransitions());