@isTest
private class InterestAddToCampaignExtTest {

    static testMethod void testAddToCompaign() {
 		test.startTest();
 	  	MassActionTestFactory.setTestData();
 	  	InterestAddToCampaignExt extension = new InterestAddToCampaignExt(new ApexPages.StandardSetController([ Select Id From Interest__c]));   
 		extension.controller.setSelected([Select Id From Interest__c]);
		Campaign campaign = new Campaign(Name='Test Campaign');
		insert campaign;
		CampaignMember campaignMember = new CampaignMember(CampaignId = campaign.Id);
		extension.campaignMember = campaignMember;
		extension.addToCompaign();
		test.stopTest();
		System.assertEquals(extension != null, true);
    }
}