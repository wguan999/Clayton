@isTest
public class InterestCreateTaskExtTest {

    static testMethod void testCreateTask() {
 		test.startTest();
 	  	MassActionTestFactory.setTestData();
 	  	InterestCreateTaskExt extension = new InterestCreateTaskExt(new ApexPages.StandardSetController([ Select Id From Interest__c]));   
 		extension.controller.setSelected([Select Id From Interest__c]);
		Campaign campaign = new Campaign(Name='Test Campaign');
		insert campaign;
		
		Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
		//User user = [Select Id From User Where ProfileId = profile.Id Limit 1];
      	/*
      	User user = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      		LocaleSidKey='en_US', ProfileId = profile.Id, 
      		TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
      		*/
      	User user = [Select Id From User Where isActive = true Limit 1];
		//insert user;
		
		Task task = new Task(Subject = 'Test', WhatId = campaign.Id, OwnerId = user.Id,
						Status='Not Started', Priority='Normal');
		extension.task = task;

		extension.creatTask();
		test.stopTest();
    }
}