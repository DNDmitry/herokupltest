@IsTest
global with sharing class HousingLoginControllerTest
{
    @IsTest(SeeAllData=true)
    global static void testSiteLoginController()
    {
        HousingLoginController cController = new HousingLoginController();
        cController.szUsername = 'test@salesforce.com';
        cController.szPassword = '123456';

        System.assertEquals(null, cController.login());
    }
    @IsTest(SeeAllData=true)
    global static void testUserLoginController()
    {

        HousingLoginController cController = new HousingLoginController();
        cController.szUsername = 'bla- e e 222';
        cController.szPassword = '123';

        System.assertNotEquals(null, cController.login());
    }
    @IsTest(SeeAllData=true)
    global static void testUserLoginInvalidController()
    {
        HousingLoginController cController = new HousingLoginController();
        cController.szUsername = 'Dima';
        cController.szPassword = 'bla-bla';

        System.assertEquals(null, cController.login());
    }
    @IsTest(SeeAllData=true)
    global static void testManagerLoginController()
    {
        HousingLoginController cController = new HousingLoginController();
        cController.szUsername = 'vPupWest';
        cController.szPassword = '123';

        System.assertNotEquals(null, cController.login());
    }
    @IsTest(SeeAllData=true)
    global static void testManagerLoginInvalidController()
    {
        HousingLoginController cController = new HousingLoginController();
        cController.szUsername = 'vPupWest';
        cController.szPassword = '123xxxxx';

        System.assertEquals(null, cController.login());
    }
    @IsTest(SeeAllData=true)
    global static void testRedirectToRegisterController()
    {
        HousingLoginController cController = new HousingLoginController();
        System.assertNotEquals(null, cController.redirectToRegisterPage());
    }
}