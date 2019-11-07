module lang::util::List

public bool and([]) = true;
public bool and([true,l*]) = and(l);
public bool and([false,l*]) = false;

