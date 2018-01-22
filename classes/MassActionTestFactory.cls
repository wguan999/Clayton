public class MassActionTestFactory {
   public static void setTestData() {
		Interest_Setup__c interestSetup = new Interest_Setup__c(Name='Basketball', Category__c='Sports');
		insert interestSetup;
	
    	Lead lead1 = new Lead(FirstName='First1', LastName='Lead', Company='Company', 
    					Status='Open - Not Contacted', Email='test1@email.com');
    	insert lead1;
    	Lead lead2 = new Lead(FirstName='First2', LastName='Lead', Company='Company', 
    					Status='Open - Not Contacted', Email='test2@email.com');
    	insert lead2;
    	
    	insert new Interest__c(Lead__c = lead1.Id, Interest_Setup__c = interestSetup.Id);
    	
    	insert new Interest__c(Lead__c = lead2.Id, Interest_Setup__c = interestSetup.Id);

    	Contact contact1 = new Contact(FirstName='First1', LastName='Contact', Email='test1@email.com');
    	insert contact1;
    	Contact contact2 = new Contact(FirstName='First2', LastName='Contact', Email='test2@email.com');
    	insert contact2;
    	
    	insert new Interest__c(Contact__c = contact1.Id, Interest_Setup__c = interestSetup.Id);
     	
    	insert new Interest__c(Contact__c = contact2.Id, Interest_Setup__c = interestSetup.Id);
		
     }
}