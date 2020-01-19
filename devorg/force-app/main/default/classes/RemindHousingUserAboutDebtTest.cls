@isTest
private class RemindHousingUserAboutDebtTest
{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @isTest(SeeAllData=true)
    private static void testScheduledJob()
    {

        Housing_user__c[] cUser = [SELECT Id, Debet_Account__c, Email__c
                                   FROM Housing_user__c
                                   WHERE Email__c = 'dp090292pda@gmail.com'
                                   LIMIT 1];
        cUser[0].Debet_Account__c = -1000.00;
        update cUser;
        system.debug(cUser);
        Integer mails = Limits.getEmailInvocations();
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
                                       CRON_EXP,
                                       new RemindHousingUserAboutDebt());
        // Verify the scheduled job has not run yet.
        system.assert(mails == Limits.getEmailInvocations());
        Test.stopTest();

    }
}