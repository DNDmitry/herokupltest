trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    Set<Id> asyncApexJobIds = new Set<Id>();
    for(BatchApexErrorEvent evt:Trigger.new){
        asyncApexJobIds.add(evt.AsyncApexJobId);
    }
    
    Map<Id,AsyncApexJob> jobs = new Map<Id,AsyncApexJob>(
        [SELECT id, ApexClass.Name FROM AsyncApexJob WHERE Id IN :asyncApexJobIds AND ApexClass.Name = 'BatchLeadConvert']
    );
    
    List<BatchLeadConvertErrors__c> errors = new List<BatchLeadConvertErrors__c>();
    for(BatchApexErrorEvent event : Trigger.New){
        if(jobs.keySet().contains(event.AsyncApexJobId)){
            errors.add(new BatchLeadConvertErrors__c(AsyncApexJobId__c = event.AsyncApexJobId, 
                                                     Records__c=event.JobScope,
                                                     StackTrace__c=event.StackTrace));
        }        
    }
    upsert errors;
}