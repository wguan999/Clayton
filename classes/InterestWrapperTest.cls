@isTest
private class InterestWrapperTest {

	static Lead lead;
	static Contact contact;
	static Interest_Setup__c interestSetup;
	static Interest__c interest;
	
	static void setup() {
		interestSetup = new Interest_Setup__c(Name='Basketball', Category__c='Sports');
		insert interestSetup;
		contact = new Contact(LastName='ContactName');
		insert contact;
		lead = new Lead(LastName='LeadName', Company='Company', Status='Open - Not Contacted');
		insert lead;
	
		interest = new Interest__c(Contact__c = contact.Id, Interest_Setup__c = interestSetup.Id);
	}

    static testMethod void testDefaultConstructor() {
    	InterestWrapper wrapper = new InterestWrapper(interest);
    	System.AssertEquals(wrapper.interest, interest);
   		System.AssertEquals(wrapper.selected, false);
   		System.AssertEquals(wrapper.changed, false);
    	
    }

    static testMethod void testConstructorWithRowId() {
    	InterestWrapper wrapper = new InterestWrapper(interest, 100);
    	System.AssertEquals(wrapper.interest, interest);
   		System.AssertEquals(wrapper.selected, false);
   		System.AssertEquals(wrapper.changed, false);
   		System.AssertEquals(wrapper.rowId, 100);
   	
    }
}