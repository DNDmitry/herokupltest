trigger HousingUserWelcome on Housing_user__c (before insert)
{    
    for(Housing_user__c item : Trigger.new)
    {       
        String szBody = 'Welcome ' + item.First_Name__c + ', ';
        szBody += 'Thank you for registration!';
        szBody += '<br>';
        szBody += 'Your login: ' + item.Name + '<br>';
        szBody += 'Your password: ' + item.Password__c + '<br>';
        szBody += '<br>';
        szBody += 'With kind regards, Housing team.';
       // HousingMessager.sendMessage(szBody, 'Welcome!', item.Email__c);
        
    }
   
}