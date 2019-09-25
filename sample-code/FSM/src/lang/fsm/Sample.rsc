module lang::fsm::Sample

import lang::fsm::AbstractSyntax;

//State bug = startState("Bug");
public State locked = startState("Locked");
public State initial = startState("Initial");
public State unlocked = state("Unlocked");
public State unlocked2 = state("Unlocked");
public State exception = state("Exception");

//Event forceBug = event("Force Bug");
public Event mute = event("Mute");
public Event pass = event("Pass");
public Event release = event("Release");
public Event ticketCollet = eventWithAction("Ticket","Collet");
public Event ticketEject = eventWithAction("Ticket","Eject");
public Event passAlarm = eventWithAction("Pass","Alarm");

//Transition transForceBug_b_u = transition(bug,forceBug,unlocked);
Transition transTicketCollet_l_u = transition(locked,ticketCollet,unlocked);
Transition transTicketEject_u_u = transition(unlocked,ticketEject,unlocked);
Transition transPass_u_l = transition(unlocked,pass,locked);
Transition transPassAlarm_l_e = transition(locked,passAlarm,exception);
public Transition transRelease_e_l = transition(exception,release,locked);
public Transition transTicketEject_e_e = transition(exception,ticketEject,exception);
Transition transMute_e_e = transition(exception,mute,exception);
Transition transPass_e_e = transition(exception,pass,exception);
//ambiguos transition
Transition transPass_e_u = transition(exception,pass,unlocked);

public StateMachine acme = fsm([locked, unlocked, exception],
								[transTicketCollet_l_u,transTicketEject_u_u,transPass_u_l,transPassAlarm_l_e,
								transRelease_e_l,transPass_e_u,transTicketEject_e_e,transMute_e_e]);
 
 
public StateMachine failedAcme = fsm([locked, unlocked,unlocked2, exception],
								[transTicketCollet_l_u,transTicketEject_u_u,transPassAlarm_l_e,
								transRelease_e_l,transPass_e_u,transTicketEject_e_e,transMute_e_e,transPass_e_u]);
								
public StateMachine startAcme = fsm([locked, unlocked,initial, exception],
								[transTicketCollet_l_u,transTicketEject_u_u,transPassAlarm_l_e,
								transRelease_e_l,transPass_e_u,transTicketEject_e_e,transMute_e_e]);	

public StateMachine noStartAcme = fsm([unlocked, exception],
								[transTicketCollet_l_u,transTicketEject_u_u,transPassAlarm_l_e,
								transRelease_e_l,transPass_e_u,transTicketEject_e_e,transMute_e_e]);	
								
public list[str] input = ["Ticket","Ticket","Pass","Pass","Ticket","Mute","Release"];
public list[str] output = ["Collet","Eject","Alarm","Eject"];