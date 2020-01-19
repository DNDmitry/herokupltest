global with sharing class CaseService {
    global static void closeCases(Set<Id> caseIds, String closeReason){
        List<Case> casesToClose = [SELECT Id, Status, Reason 
                                   FROM Case
                                   WHERE Id IN :caseIds];
        for(Case c : casesToClose){
            c.Status = 'Closed';
            c.Reason = closeReason;
        }
        SavePoint sp = Database.setSavePoint();
        try {
            update casesToClose;
        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        }
    }
    public class CaseServiceException extends Exception {} 
}