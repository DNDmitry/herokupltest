public with sharing class NewestContactByAccount {
    @AuraEnabled(cacheable=true)
    public static Contact getLastContact(String accId) {
        return [SELECT Id, Name ,Email, Phone, CreatedDate from Contact where AccountId = :accId ORDER BY CreatedDate DESC LIMIT 1];
    }
}