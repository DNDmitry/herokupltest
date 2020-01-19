public class MessageMaker
{
    @AuraEnabled(cacheable=true)
    public static String getHelloMessage(String accId)
    {
        return [SELECT Id, Name FROM Contact WHERE AccountId = :accId ORDER BY CreatedDate DESC LIMIT 1].Name;
    }
    
}