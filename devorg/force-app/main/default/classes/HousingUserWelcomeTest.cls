@isTest
private with sharing class HousingUserWelcomeTest
{
    @isTest
    private static void userWelcomeTest()
    {
        Housing_user__c cUser = new Housing_user__c(/*Username__c = 'test', Email__c = 'test@test.com',
                Password__c = 'test', Appartment__c = '2', City__c = 'Donetsk',*/
                Street__c = 'test, 2', /*Region__c = 'East',*/ First_Name__c = 'test',
                Last_name__c = 'test');
        insert cUser;
        System.assert(Limits.getEmailInvocations()==1);
    }

}