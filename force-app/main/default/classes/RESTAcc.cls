@RestResource(urlMapping='/AddNewAccViaRest/*')
global with sharing class RESTAcc
{
    @HttpPost
    global static Id setRecord()
    {
        RestRequest req = RestContext.request;
        String accName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account newAcc = new Account(Name=accName);
        insert newAcc;
        return newAcc.Id;
    }
}