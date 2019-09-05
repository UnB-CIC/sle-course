/**
 * The declaration of the 101companies domain model. Actually, 
 * there is a slight modification of the original 101companies 
 * domain model. 
 *
 * @see: R. Lammel and S. P. Jones. Scrap Your Boilerplate:
 *   A Practical Design Pattern for Generic Programming. TLDI 2003.
 *   online: https://www.microsoft.com/en-us/research/wp-content/uploads/2003/01/hmap.pdf
 */
module sle::companies::DataModel

data Company = company(str name, list[Department] deps);

data Department = department(str name, Manager mgr, list[Department] subdeps,list[Employee] emps);

data Employee = employee(str name, Salary salary);

alias Manager = Employee; 

alias Salary = real;
