@isTest
private with sharing class HousingInvoiceCalculationTest
{
    @isTest(SeeAllData=true)
    private static void calculateDebtAmountTest()
    {
        /*Housing_user__c[] lUsers = [select Id, Email__c, Debet_Account__c, Region__c, Meter_reading_electricity__c,
                                           Meter_reading_gas__c, Meter_reading_water__c
                                    from Housing_user__c
                                    limit 1];

        system.assertNotEquals(null, HousingInvoiceCalculation.calculateDebtAmount(lUsers[0], 2.0, 2.0, 2.0, 2.0, 2.0, 2.0));*/
    }
    @isTest
    private static void calculateElectricityAmountTest()
    {
        system.assertEquals(4, HousingInvoiceCalculation.calculateElectricityAmount(2.0, 2.0));
    }
    @isTest
    private static void calculateWaterAmountTest()
    {
        system.assertEquals(4, HousingInvoiceCalculation.calculateWaterAmount(2.0, 2.0));
    }
    @isTest
    private static void calculateGasAmountTest()
    {
        system.assertEquals(4, HousingInvoiceCalculation.calculateGasAmount(2.0, 2.0));
    }
    @isTest
    private static void changeUserDebtAfterPaymentTest()
    {
        system.assertEquals(4, HousingInvoiceCalculation.changeUserDebtAfterPayment(2.0, 2.0));
    }
    @isTest(SeeAllData=true)
    private static void redactDebtAmountTest()
    {
        /*Housing_user__c cRedactUser = [SELECT Id, Email__c, Debet_Account__c, Meter_reading_electricity__c, Meter_reading_water__c, Meter_reading_gas__c
        FROM Housing_user__c
        LIMIT 1];
        HousingInvoiceCalculation.redactDebtAmount(cRedactUser, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0);*/
    }

}