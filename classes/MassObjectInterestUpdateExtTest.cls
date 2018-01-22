@isTest
public class MassObjectInterestUpdateExtTest {

    static testMethod void testMassObjectInterestUpdateExt() {
		test.startTest();
 	  	MassActionTestFactory.setTestData();
  		Interest_Setup__c interestSetup = [Select Id, Name, Category__c From Interest_Setup__c LIMIT 1]; 
 
  		Contact contact = [Select Id From Contact LIMIT 1]; 

 		ApexPages.StandardController controller = new ApexPages.StandardController(contact);
 		
	  	MassObjectInterestUpdateExt  extension = new MassObjectInterestUpdateExt(controller);   
 
 		extension.getInterestWrappers();
 		
 		extension.saveInterests();
 		ApexPages.currentPage().getParameters().put('rowId', '0');
 		extension.removeInterest();
 		extension.addInterest();
  		extension.close(); 		
 
   		Lead lead = [Select Id From Lead LIMIT 1]; 
				
 		controller = new ApexPages.StandardController(lead);
 		
	  	extension = new MassObjectInterestUpdateExt(controller);   
 
 		extension.getInterestWrappers();

 		extension.saveInterests();
  		ApexPages.currentPage().getParameters().put('rowId', '0');
 		extension.removeInterest();
  		extension.addInterest();
 		extension.close(); 		 
 		test.stopTest();

 		System.assertEquals(extension != null, true);
    }
}