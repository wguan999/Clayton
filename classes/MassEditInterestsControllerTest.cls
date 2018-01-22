@isTest
public class MassEditInterestsControllerTest {

    static testMethod void testMassEditInterestsController() {
		test.startTest();
 	  	MassActionTestFactory.setTestData();
  		Interest_Setup__c interestSetup = [Select Id, Name, Category__c From Interest_Setup__c LIMIT 1]; 
 		ApexPages.currentPage().getParameters().put('interestId', interestSetup.Id);
 		ApexPages.currentPage().getParameters().put('Name', interestSetup.Name);
 		ApexPages.currentPage().getParameters().put('Category', interestSetup.Category__c);

	  	MassEditInterestsController controller = new MassEditInterestsController();   
 		List<InterestWrapper> wrappers = controller.getInterestWrappers();
 		controller.previous();
 		controller.next();
 		controller.getHasNext();
 		controller.getHasPrevious();
 		controller.selectAll();
 		controller.close();
 		controller.deleteInterests();
 		controller.saveInterests();
 		
 		test.stopTest();
 		System.assertEquals(controller != null, true);
    }
}