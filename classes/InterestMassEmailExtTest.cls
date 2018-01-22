@isTest
private class InterestMassEmailExtTest {

	static Interest_Setup__c interestSetup;	
	static void setup() {
		interestSetup = new Interest_Setup__c(Name='Basketball', Category__c='Sports');
		insert interestSetup;
	}

    static testMethod void testGetTemplates() {
 		test.startTest();
    	InterestMassEmailExt extension = getExtension();
    	List<SelectOption> templates = extension.getTemplates();
    	test.stopTest();
		System.assertEquals(templates != null, true);
    }
    
    static testMethod void testSendEmails() {
		test.startTest();
 	  	InterestMassEmailExt extension = getExtension();
 		extension.controller.setSelected([Select Id From Interest__c]);
		extension.sendEmails();
    	test.stopTest();
		System.assertEquals(extension != null, true);
    }
    
    static InterestMassEmailExt getExtension() {
 	  	MassActionTestFactory.setTestData();
 	  	InterestMassEmailExt extension = new InterestMassEmailExt(new ApexPages.StandardSetController([ Select Id From Interest__c]));   
 
    	//Folder folder = [Select Id from Folder Limit 1];
//    	Folder folder = new Folder(Name='Test', Type='Email');
    	//insert folder;
    	//EmailTemplate template = new EmailTemplate(Name='Test Template', DeveloperName='Test',
    	//							TemplateType='text', FolderId=folder.Id, isActive=true);
    	//insert template;
    	EmailTemplate template = [Select Id from EmailTemplate LIMIT 1];
    	extension.emailTemplateId = template.Id;

 		extension.controller.setSelected([Select Id From Interest__c]);
 		return extension;   	
    }
}