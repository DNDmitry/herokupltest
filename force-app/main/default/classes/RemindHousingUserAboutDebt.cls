global class RemindHousingUserAboutDebt implements Schedulable
{
  global void execute(SchedulableContext ctx)
    {
        List<Housing_user__c> lUsers = [SELECT Id, Email__c, First_Name__c, Last_name__c, Debet_Account__c, (select CreatedDate from Housing_payments__r) 
                                        FROM Housing_user__c
                                        WHERE Debet_Account__c < 0
                                        ORDER BY Debet_Account__c];
        system.debug(lUsers[0]);
        if(lUsers.size() > 0)
        {
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(Housing_user__c item : lUsers)
            {
                system.debug(item);
                if(item.CreatedDate < (system.now()-30))
                {
                    String szBody = 'Hello, ' + item.First_Name__c + '! <br> ';
                    szBody += 'Please note that your balance is:';
                    szBody += '<br>';
                    szBody += item.Debet_Account__c;
                    szBody += '<br>';
                    szBody += 'Please pay it as soon as possible! <br>';
                    szBody += 'With kind regards.';
                    HousingMessager.sendMessage(szBody, 'Attention!', item.Email__c);
                }
            }
        }
        
    }

}