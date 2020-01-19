global with sharing class HousingRegisterController
{
    private final String szErrDifferentPasswords = 'Different passwords inputted.';
    private final String szErrEmptyFields = 'All fields must be filled.';
    private final String szErrMaskStart = 'The error is occured:';
    private final String szErrAffectedFields = 'Affected fields';
    private final String szLoginPage = '/apex/Housing_login';
    private final Housing_user__c cUser;
    public HousingRegisterController(ApexPages.StandardController stdController)
    {
        this.cUser = (Housing_user__c)stdController.getRecord();
    }
    public String redirectToHousingLoginPage {get; set;}
    public String szUsername {get; set;}
    public String szEmail {get; set;}
    public String szFirstName {get; set;}
    public String szLastName {get; set;}
    public String szStreet {get; set;}
    public String szAppartment {get; set;}
    public String szPassword {get; set;}
    public String szConfirmPassword {get; set;}

    private boolean isValidPassword()
    {
        return szPassword == szConfirmPassword;
    }

    private Boolean isValidFields()
    {
        if(szUsername == null || szEmail == null || szPassword == null || szAppartment == null || szConfirmPassword == null ||
               szStreet == null || szFirstName == null || szLastName == null)
        {
            return false;
        }
        return true;
    }

    public PageReference registerUser()
    {
        if(!isValidPassword())
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, szErrDifferentPasswords));
            return null;
        }
        if(!isValidFields())
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, szErrEmptyFields));
            return null;
        }

        cUser.Name = szUsername.trim();
        cUser.Email__c = szEmail.trim();
        cUser.Password__c = szPassword.trim();
        cUser.Appartment__c = szAppartment.trim();
        cUser.Street__c = szStreet.trim();
        cUser.First_Name__c = szFirstName.trim();
        cUser.Last_name__c = szLastName.trim();

        Database.SaveResult dbResult = Database.insert(cUser, false);
        if(!dbResult.isSuccess())
        {
            for(Database.Error dbError : dbResult.getErrors())
            {
                System.debug(szErrMaskStart);
                System.debug(dbError.getStatusCode() + ': ' + dbError.getMessage());
                System.debug(szErrAffectedFields + dbError.getFields());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,dbError.getMessage()));
            }
            return null;
        }
        return redirectToHousingLoginPage();
    }

    public PageReference redirectToHousingLoginPage()
    {
        PageReference prReference = new PageReference(szLoginPage);
        prReference.setRedirect(true);
        return prReference;
    }
}