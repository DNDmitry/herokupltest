public class HelloWorld 
{
	public void sayYou()
    {
        system.debug('You');
    }

    public void sayMe()
    {
        system.debug('Me');
    }

    public void toAdd(Integer arg1, Integer arg2)
    {
        Invoice__c obj = new Invoice__c();
        obj.experimental_number_field__c = 1;
        obj.my_text_field__c = 'aaaaaa';
    }

}