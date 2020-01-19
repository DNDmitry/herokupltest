@isTest
private with sharing class HousingUserControllerTest
{
    @testSetup
    private static void setup()
    {
        Housing_user__c hu = new Housing_user__c(Name = 'TestName',
                                                 Email__c = 'test@force.com',
                                                 Appartment__c = '1',
                                                 City__c = 'Donetsk',
                                                 Region__c = 'East',
                                                 Street__c = 'Str 1110',
                                                 First_Name__c = 'Name',
                                                 Last_Name__c = 'Last');
        insert hu;
    }
    @isTest
    private static void testPutNewMeterReadingsUser()
    {
        Housing_user__c cUser = [select Id from Housing_user__c where Name = 'TestName' limit 1];
        system.debug(cUser.Id);
        String szUserId = cUser.Id;
        HousingUserController cController = new HousingUserController();
        cController.cUser = cController.getHousingUser(szUserId);
        cController.getRates();
        cController.initMeterReadingValues();
        cController.szElectricity = '25';
        cController.szWater = '25';
        cController.szGas = '25';
        test.startTest();
        system.assertEquals(null, cController.putMeterReadingValues());
        test.stopTest();
    }
    @isTest
    private static void testGetPaymentHistoryUser()
    {
        Housing_user__c cUser = [select Id from Housing_user__c where Name = 'TestName' limit 1];
        system.debug(cUser.Id);
        String szUserId = cUser.Id;
        HousingUserController cController = new HousingUserController();
        cController.cUser = cController.getHousingUser(szUserId);
        cController.getRates();
        cController.szPayment = '20';
        cController.makePayment();
        List<HousingUserController.DisplayPaymentHistory> lHistory= cController.getPaymentHistory();
        test.startTest();
        system.assert(lHistory.size() > 0);
        system.assertNotEquals(0, lHistory.get(0).dDisplayAmount);
        system.assertNotEquals(null, lHistory.get(0).dtDisplayDateTime);
        test.stopTest();
    }
    @isTest
    private static void testChangeAdressUser()
    {

        Housing_user__c cUser = [select Id from Housing_user__c where Name = 'TestName' limit 1];
        system.debug(cUser.Id);
        String szUserId = cUser.Id;
        HousingUserController cController = new HousingUserController();
        cController.cUser = cController.getHousingUser(szUserId);
        cController.getRates();
        cController.szPayment = '20';
        cController.makePayment();
        test.startTest();
        system.assertEquals(null, cController.changeAddressStart());
        system.assertEquals(true, cController.bChangeAddressVisible);

        cController.cUser.Debet_Account__c = -1;

        system.assertEquals(null, cController.changeAddressStart());

        cController.szAppartment = '5';
        cController.szCity = 'Lugansk';
        cController.szRegion = 'East';
        cController.szStreet = 'Str Lenina, 20';

        system.assertEquals(null, cController.changeAddressFinish());
        test.stopTest();
    }
    @isTest
    private static void testMessagingUser()
    {
        Housing_user__c cUser = [select Id from Housing_user__c where Name = 'TestName' limit 1];
        system.debug(cUser.Id);
        String szUserId = cUser.Id;
        HousingUserController cController = new HousingUserController();
        cController.cUser = cController.getHousingUser(szUserId);
        cController.getRates();
        cController.sendEmailToManager();
        test.startTest();
        system.assertEquals(true, cController.bNewMessageVisible);

        test.stopTest();
    }
}