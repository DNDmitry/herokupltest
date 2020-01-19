@isTest
private class FieldUsageInfoSenderTest{
    @isTest
    static void shouldBeAbleToGetData(){
        FieldAnalysisStructure requestInfo = new FieldAnalysisStructure();
        requestInfo.objectName = 'Account';
        requestInfo.endpointForResponse = 'https://google.com';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FieldUsageInfoMock());
        System.Queueable job = new FieldUsageInfoSender(requestInfo);
        System.enqueueJob(job);
        Test.stopTest();
    }
}