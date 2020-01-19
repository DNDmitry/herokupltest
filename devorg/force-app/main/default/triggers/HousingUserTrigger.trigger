trigger HousingUserTrigger on Housing_user__c (before update)
{
    System.debug('::DEBUG:: OOOOOOOOOOOOOOOOOOOOOOOOOOO');
    //BankAccountTriggerHandler handler = new BankAccountTriggerHandler();
    if (Trigger.isBefore)
    {
        if (Trigger.isUpdate)
        {
            try
            {
                System.debug('::DEBUG:: TRRRUUUUEEE');
                //handler.onBeforeUpdate(Trigger.new);
            }
            catch (Exception ex)
            {
                System.debug('::DEBUG:: EEEEEEEEXCEPTION');
                //NotificationService.sendExceptionToAdmin(ex.objectId, ex.message);
            }
        }
    }
}