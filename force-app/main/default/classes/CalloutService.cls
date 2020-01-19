public with sharing class CalloutService {
    @future(callout=true)
    public static void sendFieldUsageInfo(String jsonStruct){
        FieldAnalysisStructure struct = (FieldAnalysisStructure) JSON.deserialize(jsonStruct, FieldAnalysisStructure.class);

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(struct.endpointForResponse);
        req.setMethod('POST');
        req.setBody(JSON.serialize(struct));
           
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){
            res = h.send(req);
        }
        
    }
}