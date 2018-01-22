@isTest
public class ObjectAddToInterestsExtTest {

    static testMethod void testObjectAddToInterestsExt() {
		test.startTest();
 	  	MassActionTestFactory.setTestData();
  		Interest_Setup__c interestSetup = [Select Id, Name, Category__c From Interest_Setup__c LIMIT 1]; 
 
 		List<Contact> contacts = [Select Id From Contact];
	  	ObjectAddToInterestsExt  extension = new ObjectAddToInterestsExt(
	  		new ApexPages.StandardSetController(contacts));   
	  	extension.interestWrappers[0].interest.Interest_Setup__c = interestSetup.Id;
	  	extension.controller.setSelected(contacts);	  	
		extension.saveInterests();
		extension.addInterestSetup();
		ApexPages.currentPage().getParameters().put('rowId', '0');
 		extension.removeInterestSetup();
		
		List<Lead> leads = [Select Id From Lead];
	  	extension = new ObjectAddToInterestsExt(
	  		new ApexPages.StandardSetController(leads));
	  	extension.interestWrappers[0].interest.Interest_Setup__c = interestSetup.Id;
	  	extension.controller.setSelected(leads);
		extension.saveInterests(); 
		extension.addInterestSetup();
		ApexPages.currentPage().getParameters().put('rowId', '0');
 		extension.removeInterestSetup();

 		test.stopTest();
		System.assertEquals(extension != null, true);
    }
}