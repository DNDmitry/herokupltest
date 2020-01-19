public class HousingMessager 
{
    public static void sendMessage(String szBody, String szSubject, String szSendFrom, String szEmail)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> lSendTo = new List<String>();
        lSendTo.add(szEmail);
        mail.setToAddresses(lSendTo);
        mail.setSenderDisplayName('Housing Corp.');
        mail.setSubject(szSubject);
        mail.setInReplyTo(szSendFrom);
        mail.setHtmlBody(szBody);
        mails.add(mail);
       // Messaging.sendEmail(mails);
    }
    public static void sendMessage(String szBody, String szSubject, String szEmail)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> lSendTo = new List<String>();
        lSendTo.add(szEmail);
        mail.setToAddresses(lSendTo);
        mail.setSenderDisplayName('Housing Corp.');
        mail.setSubject(szSubject);
        mail.setHtmlBody(szBody);
        mails.add(mail);
       // Messaging.sendEmail(mails);
    }
    
	
}