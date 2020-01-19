@RestResource(urlMapping='/fieldsUsage')
global with sharing class WebServiceForFieldAnalysis {

    @HttpPost
    global static Id getFieldsUsageByAnObject()
    {
        RestRequest req = RestContext.request;
        FieldAnalysisStructure requestInfo;
        requestInfo = (FieldAnalysisStructure) JSON.deserialize(req.requestBody.toString(), FieldAnalysisStructure.class);
        FieldsUsageCalculator bc = new FieldsUsageCalculator(requestInfo);
        Id jobId;
        try{
            jobId = database.executeBatch(bc);
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }        
        return jobId;
    }
}