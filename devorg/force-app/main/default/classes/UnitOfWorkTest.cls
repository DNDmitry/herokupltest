@isTest
public class UnitOfWorkTest {
    @TestSetup
    static void initData(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Account.SObjectType, Contact.SObjectType, Note.SObjectType
                    }
        );
        for (Integer i=0 ; i<100 ; i++) {
        Account a = new Account(Name= 'Test' + i);
        uow.registerNew(a);

        for (Integer j=0 ; j<5 ; j++) {
            Contact c = new Contact(LastName = 'Test'+i + ' ' +j);
            uow.registerNew(c, Contact.AccountId, a);

            Note n = new Note(Body='Test '+i + '' + j, Title='Test'+i+j);
            uow.registerRelationship(n, Note.ParentId, a);            
            uow.registerNew(n, Note.ParentId, c);
        }
    }
        uow.commitWork();   
    }
    
	@isTest
    static void challengeComplete(){
        System.assertEquals(100, [Select Id from Account].size());
        System.assertEquals(500, [Select Id from Contact].size());
        System.assertEquals(500, [Select Id from Note].size());
    }
}