public class FutureExperiment {
    public void method1(){
        system.debug('::method1()::');
    }
    @future(callout=true)
    public static void method2(String sessionId){
        
        system.debug('::future::');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
                
        ApexLog al = [SELECT Id, StartTime FROM ApexLog /*WHERE StartTime > :Datetime.now().addMinutes(-5)*/  LIMIT 1];//WHERE Id = '07L0Y00000AOb2WUAT'];
        //EventLogFile elf = [SELECT Id FROM EventLogFile LIMIT 1];
        system.debug(al);
        request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v41.0/sobjects/ApexLog/' + al.Id + '/Body/');
        //request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v41.0/sobjects/EventLogFile/' + elf.Id + '/LogFile/');
             system.debug(request.getEndpoint());   
        request.setMethod('GET'); 
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');  
        request.setHeader('Authorization', 'OAuth ' + sessionId);//UserInfo.getSessionId());
        HttpResponse response = http.send(request);
        String szLog = response.getBody();
        system.debug('MYLOG_START:::' + szLog);
        system.debug('MYLOG_FINISH:::');
    }

}