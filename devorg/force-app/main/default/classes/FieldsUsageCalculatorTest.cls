@isTest
private with sharing class FieldsUsageCalculatorTest {
    @testSetup
    private static void initData() {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 4; i++){
            accounts.add(new Account(Name = 'Blah'+i, Site = 'https://google.com'));
        }
        insert accounts;
    }

    @isTest
    private static void testAccountsHaveOneHundredPercentFieldUsage(){
        FieldAnalysisStructure structureForRequest = new FieldAnalysisStructure();
		structureForRequest.objectName = 'Account';
        structureForRequest.endpointForResponse = 'https://google.com';
		String myJSON = JSON.serialize(structureForRequest);		

        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + 'services/apexrest/fieldsUsage';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(myJSON);
		
        RestContext.request = request;
        Test.startTest();
		Id jobId = WebServiceForFieldAnalysis.getFieldsUsageByAnObject();
        Test.stopTest();

        Fields_Analysis__c result = [SELECT Usage__c, Field_Name__c 
                                    FROM Fields_Analysis__c 
                                    WHERE JobId__c = :jobId AND Field_Name__c = 'site' LIMIT 1];
        system.assertEquals(result.Usage__c, 100.0);        
    }
    
    @isTest
    private static void testErrorCaseWithWrongObjectName(){
        FieldAnalysisStructure structureForRequest = new FieldAnalysisStructure();
		structureForRequest.objectName = 'Acc';
        structureForRequest.endpointForResponse = 'https://google.com';
		String myJSON = JSON.serialize(structureForRequest);		

        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + 'services/apexrest/fieldsUsage';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(myJSON);
		
        RestContext.request = request;
        Test.startTest();
        Id jobId;
        try{
            jobId = WebServiceForFieldAnalysis.getFieldsUsageByAnObject();
        }
        catch(Exception ex){
            system.assert(ex.getMessage().contains('Cannot get fields because'));
        }		
        Test.stopTest();      	
    }

    @isTest
    private static void testAccountsNoUsedField(){
        FieldAnalysisStructure structureForRequest = new FieldAnalysisStructure();
		structureForRequest.objectName = 'Account';
        structureForRequest.endpointForResponse = 'https://google.com';
		String myJSON = JSON.serialize(structureForRequest);		

        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + 'services/apexrest/fieldsUsage';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(myJSON);
		
        RestContext.request = request;
        Test.startTest();
		Id jobId = WebServiceForFieldAnalysis.getFieldsUsageByAnObject();
        Test.stopTest();

        Fields_Analysis__c result = [SELECT Usage__c, Field_Name__c 
                                    FROM Fields_Analysis__c 
                                    WHERE JobId__c = :jobId AND Field_Name__c = 'industry' LIMIT 1];
        system.assertEquals(result.Usage__c, 0.0);        
    }
}