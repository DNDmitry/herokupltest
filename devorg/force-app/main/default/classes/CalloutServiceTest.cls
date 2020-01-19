@isTest
private class CalloutServiceTest{
    @isTest
    static void shouldBeAbleToGetData(){
        FieldAnalysisStructure requestInfo = new FieldAnalysisStructure();
        requestInfo.objectName = 'Account';
        requestInfo.endpointForResponse = 'https://google.com';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FieldUsageInfoMock());
        HttpResponse res = CalloutService.sendFieldUsageInfo(requestInfo);
        Test.stopTest();
    }
}