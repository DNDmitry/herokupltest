public with sharing class FieldUsageInfoSender implements System.Queueable, Database.AllowsCallouts{

    private FieldAnalysisStructure struct;

    public FieldUsageInfoSender(FieldAnalysisStructure struct){
        this.struct = struct;
    }
    
    public void execute(System.QueueableContext context){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.struct.endpointForResponse);
        req.setMethod('POST');
        req.setBody(JSON.serialize(this.struct));
           
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){
            res = h.send(req);
        }
        
    }
}