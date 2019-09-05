/**
 * The cool test stuf of Rascal... 
 */
module sle::companies::TestSuite

import sle::companies::DataModel;
import sle::companies::Sample;
import sle::companies::Services;

test bool testTotal() = 111000.0 == totalSalary(genCom);

test bool testIncrease() = 122100.0 == totalSalary(increaseSalary(0.1, genCom));