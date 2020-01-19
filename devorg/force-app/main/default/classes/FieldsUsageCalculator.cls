global with sharing class FieldsUsageCalculator implements Database.Batchable<sObject>, Database.Stateful{
    private FieldAnalysisStructure requestInfo;
    private List<String> fields;
    private Map<String, Decimal> results = new Map<String, Decimal>();
    private Integer recordCount = 0;

    public FieldsUsageCalculator(FieldAnalysisStructure requestInfo) {
        this.requestInfo = requestInfo;
        try{
            this.fields = FieldService.getNonRequiredFields(requestInfo.objectName);
        }
        catch(Exception ex){
            this.requestInfo.errorMessage = 'Cannot get fields because: ' + ex.getMessage();
            this.requestInfo.isSuccess = false;            
            throw new FieldsUsageCalculatorException(this.requestInfo.errorMessage);
        }
        
        for(String fieldName : fields){
            results.put(fieldName, 0.0);
        }
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT ' + String.join(this.fields,',') + ' FROM ' + this.requestInfo.objectName;
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> records){
        if(this.requestInfo.isSuccess){            
            for(sObject record : records){
                for(String fieldName : this.fields){
                    if(record.get(fieldName) != null){
                        results.put(fieldName, results.get(fieldName) + 1);
                    }
                }
                recordCount++;
            }                       
        }        
    }    

    global void finish(Database.BatchableContext bc){
        List<Fields_Analysis__c> historicalRecords = new List<Fields_Analysis__c>();
        
        for(String field : results.keySet()){            
            Decimal percentage = results.get(field)/recordCount * 100;            
            results.put(field, percentage.setScale(2));
            historicalRecords.add(new Fields_Analysis__c(Object_Name__c = this.requestInfo.objectName,
                                                        JobId__c = bc.getJobId(),
                                                        Field_Name__c = field,
                                                        Usage__c = percentage));
        }
        insert historicalRecords;        
        
        System.Queueable job = new FieldUsageInfoSender(requestInfo);
        System.enqueueJob(job);
        
    }    

    global class FieldsUsageCalculatorException extends Exception{}
}