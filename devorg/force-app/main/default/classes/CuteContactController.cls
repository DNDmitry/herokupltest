public with sharing class CuteContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByAccount(String accountId) {
        return [SELECT Id, FirstName, Lastname, Title, Phone, Email from Contact where AccountId = :accountId];
    }

}