@isTest
private  class InterestLeadContactDupCheckTest {
	
	static Lead lead;
	static Contact contact;
	static Interest_Setup__c interestSetup;
	
	static void setup() {
		interestSetup = new Interest_Setup__c(Name='Basketball', Category__c='Sports');
		insert interestSetup;
		contact = new Contact(LastName='ContactName');
		insert contact;
		lead = new Lead(LastName='LeadName', Company='Company', Status='Open - Not Contacted');
		insert lead;
	}
	
	static testMethod void testLeadNotNullContactNotNull(){
		test.startTest();
		setup();
		List<Interest__c> interests = new List<Interest__c>();
		interests.add(
			 new Interest__c(Contact__c = contact.Id, Interest_Setup__c = interestSetup.Id,
						Lead__c = lead.Id));

		for (Interest__c interest: interests) {
			try {
				insert interest;
			}
			catch (Exception e) {
				Boolean expectedExceptionThrown =  e.getMessage().contains('You can not choose both contact and lead.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
		}		
		test.stopTest();
		
	}

	static testMethod void testLeadNullContactNull(){
		test.startTest();
		setup();
		List<Interest__c> interests = new List<Interest__c>();
		interests.add(
			 new Interest__c(Contact__c = null, Interest_Setup__c = interestSetup.Id,
						Lead__c = null));

		for (Interest__c interest: interests) {
			try {
				insert interest;
			}
			catch (Exception e) {
				Boolean expectedExceptionThrown =  e.getMessage().contains('Please choose a contact or a lead.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
		}		
		test.stopTest();
		
	}

	static testMethod void testInterestExist(){
		test.startTest();
		setup();
		List<Interest__c> interests = new List<Interest__c>();
		interests.add(
			 new Interest__c(Contact__c = contact.Id, Interest_Setup__c = interestSetup.Id,
						Lead__c = null));

		interests.add(
			 new Interest__c(Contact__c = contact.Id, Interest_Setup__c = interestSetup.Id,
						Lead__c = null));

		for (Interest__c interest: interests) {
			try {
				insert interest;
			}
			catch (Exception e) {
				Boolean expectedExceptionThrown =  e.getMessage().contains('Interest exists.');
				System.AssertEquals(expectedExceptionThrown, true);
			}
		}		
		test.stopTest();
		
	}
}