@isTest
private class AppleWatchTest
{	
	@isTest
	static void createOpportunity()
	{
		Test.startTest();
		Opportunity opp = new Opportunity();

		opp.Name      = 'ImFrom sublime!';
		opp.StageName = 'Prospecting';
		opp.CloseDate = system.today();

		insert opp;
        
        Opportunity opp1 = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        opp1.StageName = 'Closed Lost';
        update opp1;

		Test.stopTest();
        Opportunity opp2 = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        system.assertEquals(opp2.StageName, 'Closed Won');
	}
}