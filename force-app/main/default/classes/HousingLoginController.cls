global with sharing class HousingLoginController 
{
    private final String szErrorInvalidPassoword = 'Invalid password.';
    private final String szErrorInvalidUsername = 'Invalid username.';
    private final String szPageUser = '/apex/Housing_user';
    private final String szPageRegistration = '/apex/Housing_register';

    public String redirectToRegisterPage { get; set; }
    public String login { get; set; }
    public HousingLoginController() {}
    public String szUsername {get; set;}
    public String szPassword {get; set;}
    public PageReference login()
    {
        Housing_user__c[] cUser = [select Id, Name, Password__c
                                   from Housing_user__c
                                   where Name = :szUsername
                                   limit 1];
        if(cUser.size() > 0)
        {
            if(cUser[0].Password__c != szPassword)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, szErrorInvalidPassoword));
                return null;
            }
            PageReference prReference = new PageReference(szPageUser);
            prReference.getParameters().put('UserId', cUser[0].Id);
            prReference.setRedirect(true);
            return prReference;
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, szErrorInvalidUsername));
            return null;
        }
    }    
    public PageReference redirectToRegisterPage() 
    {        
        PageReference prReference = new PageReference(szPageRegistration);
        prReference.setRedirect(true);
        return prReference;
    }
}