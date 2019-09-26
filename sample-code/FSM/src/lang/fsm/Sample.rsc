module lang::fsm::Sample

import lang::fsm::AbstractSyntax;

//State bug = startState("Bug");
State locked = startState("Locked");
State initial = startState("Initial");
State unlocked = state("Unlocked");
State unlocked2 = state("Unlocked");
State exception = state("Exception");
State unreachableState = state("Unreachable");

//Event forceBug = event("Force Bug");
Event mute = event("Mute");
Event pass = event("Pass");
Event release = event("Release");
Event ticketCollet = eventWithAction("Ticket","Collet");
Event ticketEject = eventWithAction("Ticket","Eject");
Event passAlarm = eventWithAction("Pass","Alarm");

//Transition transForceBug_b_u = transition(bug,forceBug,unlocked);
Transition transTicketCollet_l_u = transition(locked,ticketCollet,unlocked);
Transition transTicketEject_u_u = transition(unlocked,ticketEject,unlocked);
Transition transPass_u_l = transition(unlocked,pass,locked);
Transition transPassAlarm_l_e = transition(locked,passAlarm,exception);
Transition transRelease_e_l = transition(exception,release,locked);
Transition transTicketEject_e_e = transition(exception,ticketEject,exception);
Transition transMute_e_e = transition(exception,mute,exception);
Transition duplicated_transMute_e_e = transition(exception,mute,exception);
Transition transPass_e_e = transition(exception,pass,exception);
//ambiguos transition
Transition transPass_e_u = transition(exception,pass,unlocked);
Transition unreachableState_transTicketCollet_l_u = transition(locked,ticketCollet, unreachableState);

public StateMachine acme = fsm([locked, unlocked, exception],
								[transTicketCollet_l_u,transTicketEject_u_u,transPassAlarm_l_e,
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

public StateMachine duplicatedEventsAcme = fsm([locked, unlocked, exception],
								[transTicketCollet_l_u,transTicketEject_u_u,transPassAlarm_l_e,
								transRelease_e_l,transPass_e_u,transTicketEject_e_e,transMute_e_e, duplicated_transMute_e_e]);
 			
 			
public StateMachine trasitionWithoutATargetAcme = fsm([locked, unlocked, exception],
								[transTicketCollet_l_u,transTicketEject_u_u,transPassAlarm_l_e,
								transRelease_e_l,transPass_e_u,transTicketEject_e_e,transMute_e_e, unreachableState_transTicketCollet_l_u]);
 					
