@IsTest
private with sharing class HousingManagerControllerTest
{/*
    private static HousingManagerController initManager()
    {
        Housing_user__c hm = [select Id from Housing_user__c ];
        system.debug(hm);
        ApexPages.currentPage().getParameters().put('housingManagerId', hm.Id);
        HousingManagerController cController = new HousingManagerController();
        return cController;
    }
    @isTest(SeeAllData=true)
    private static void testPutNewRatesHousingManager()
    {
        test.startTest();
        HousingManagerController cController = initManager();
        cController.szElectricity = '25';
        cController.szWater = '25';
        cController.szGas = '25';
        system.assertEquals(null, cController.putNewRates());
        test.stopTest();
    }
    @isTest(SeeAllData=true)
    private static void testPaginationHousingManager()
    {
        test.startTest();
        HousingManagerController cController = initManager();
        cController.goToPrevPage();
        cController.nBookmark = 49;
        cController.goToPrevPage();

        cController.goToNextPage();
        cController.nBookmark = [SELECT COUNT() FROM Housing_user__c WHERE Region__c = 'West'] - 51;
        cController.goToNextPage();
        test.stopTest();
    }
    @isTest(SeeAllData=true)
    private static void testGettingUsersManager()
    {
        test.startTest();
        HousingManagerController cController = initManager();
        system.assertNotEquals(null, cController.getUsers());
        List<HousingManagerController.DisplayUsers> lUsers = cController.getUsers();
        system.assertNotEquals(0, lUsers.get(0).szDisplayDebetAcc);
        system.assertNotEquals(null, lUsers.get(0).szDisplayStreet);
        system.assertNotEquals(null, lUsers.get(0).szDisplayEmail);
        system.assertNotEquals(null, lUsers.get(0).szDisplayCity);
        system.assertNotEquals(0, lUsers.get(0).dDisplayElectricity);
        system.assertNotEquals(0, lUsers.get(0).dDisplayWater);
        system.assertNotEquals(0, lUsers.get(0).dDisplayGas);
        system.assertNotEquals(null, lUsers.get(0).szDisplayFirstName);
        system.assertNotEquals(null, lUsers.get(0).szDisplayLastName);
        system.assertNotEquals(null, lUsers.get(0).szDisplayAppartment);
        test.stopTest();
    }
    @isTest(SeeAllData=true)
    private static void testGettingRatesManager()
    {
        test.startTest();
        HousingManagerController cController = initManager();
        system.assertNotEquals(null, cController.getRates());
        cController.initRatesChanging();
        test.stopTest();
    }
    @isTest(SeeAllData=true)
    private static void testFilteredUsersManager()
    {
        test.startTest();
        HousingManagerController cController = initManager();
        cController.initiateFilter();
        cController.szFilterCity = 'Donetsk';
        system.assertNotEquals(null, cController.getFilteredUsers());
        cController.szFilterEmail = '';
        system.assertNotEquals(null, cController.getFilteredUsers());
        cController.filterUsers();
        cController.resetFilter();
        test.stopTest();
    }*/

}