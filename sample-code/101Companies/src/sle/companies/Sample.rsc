/**
 * A sample of the 101companies domain model. Note, it 
 * is a slight modification from the initial sample in the 
 * SYB paper.  
 *
 * @see: R. Lammel and S. P. Jones. Scrap Your Boilerplate:
 *   A Practical Design Pattern for Generic Programming. TLDI 2003.
 *   online: https://www.microsoft.com/en-us/research/wp-content/uploads/2003/01/hmap.pdf
 */
module sle::companies::Sample

import sle::companies::DataModel;

Employee ralf = employee("Ralf",8000.0);
Employee joost = employee("Joost",1000.0);
Employee marlow = employee("Marlow",2000.0);
Employee blair = employee("Blair",100000.0);

Department research = department("Research",ralf,[],[joost,marlow]);
Department strategy = department("Strategy",blair,[],[]);

public Company genCom = company("GenCom",[research, strategy]);
