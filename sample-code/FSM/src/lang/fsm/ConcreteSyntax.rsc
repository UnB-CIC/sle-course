module lang::fsm::ConcreteSyntax

start syntax FSM = CState* states;

syntax CState 
  = initialState: "initial" "state" Id "{" CEvent* "}"
  | basicState: "state" Id "{" CEvent* "}"
  ;

syntax CEvent 
  = basicEvent: Id ("-\>" Id)? ";"
  | actionEvent: Id "/" Id ("-\>" Id)? ";"
  ; 

lexical Id = [a-zA-Z][_a-zA-Z0-9]*; 

lexical Comment = "//" ![\n]* [\n];

lexical Spaces = [\n\r\f\t\ ]*;

layout Layout = Spaces 
              | Comment 
              ; 

keyword Keywords = "state" | "initial" ;


