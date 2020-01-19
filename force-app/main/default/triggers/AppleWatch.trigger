trigger AppleWatch on Opportunity (after insert, before update)
{
    if(Trigger.isInsert){
        system.debug('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
        for(Opportunity opp : Trigger.new)
        {
            Task t = new Task();
            t.Subject     =  'Apple Watch promo!';
            t.Description = 'Send them one ASAP';
            t.Priority    = 'High';
            t.WhatId      = opp.Id; 
            insert t;
        }
    }
    else{
        for(Opportunity opp : Trigger.new)
        {
            opp.StageName = 'Closed Won';
        }
    }
    
}