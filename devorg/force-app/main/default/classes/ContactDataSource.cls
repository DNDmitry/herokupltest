global with sharing class ContactDataSource implements IDataSource  {
   public List<SObject> getSourceObjects() {
       return [Select Id, Name From Contact LIMIT 30];
   }
}