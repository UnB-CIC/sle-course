/**
 * The implementation of the functions that query or manipulate 
 * the 101companies domain model. 
 *
 * @see: R. Lammel and S. P. Jones. Scrap Your Boilerplate:
 *   A Practical Design Pattern for Generic Programming. TLDI 2003.
 *   online: https://www.microsoft.com/en-us/research/wp-content/uploads/2003/01/hmap.pdf
 */

module sle::companies::Services

import sle::companies::DataModel;
import sle::lib::\list;
import List;

/**
 * computes the total salaries of a company
 */ 
public real totalSalary(Company c) = sum([s | /Salary s <- c]);

/**
 * finds the highest Salary of a company.
 */
public real highestSalary(Company c) = max([s | /Salary s <- c]); 

/**
 * "increases" all salaries of a company. the question is, 
 * how that is possible in the current Brazilian moment?  
 */ 
public Company increaseSalary(real inc, Company company) =
  top-down visit(company){
	 case Salary salary => salary + (salary * inc) // this is really cool.
  };
  
  
public num avgSalary(Company company) = avg([s | /Salary s <- company]);

public set[str] setEmployeeNames(Company c) = ({e.name | /Employee e<- c});

//---------------------- Alternative Implementations ----------------------

// This is a more "imperative" version of 
// totalSalary 

//public real totalSalary(Company company){
//	real total = 0.0;
//	top-down visit(company){
//		case Salary salary : total += salary;
//	}
//	return total;
//}


// this is a more "imperative" version of 
// findHighestSalary

//public real findHighestSalary(Company company){
//	  real wage = 0.0;
//	  top-down visit(company){
//		 case Salary salary: if( salary > wage ) wage = salary;
//	  }
//	  return wage;
//  }
