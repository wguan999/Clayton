public with sharing class InterestCreateTaskExt {
    public ApexPages.StandardSetController controller {get; set;}
    public Task task {get; set;}
    public Boolean noSelection { get; set; }

    public InterestCreateTaskExt(ApexPages.StandardSetController controller) {
        this.controller = controller;
        task = new Task();
       	noSelection = (controller.getSelected().size() == 0);
        if (noSelection) {
        	MessageUtil.writeInfo('Please make your selections form the list view before continue.');
        }
    }

    public PageReference creatTask() {   
        List<Task> tasks = new List<Task>();
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> leadIdSet = new Set<Id>();
        for (Interest__c interest : [Select Contact__c, Lead__c From Interest__c 
            	WHERE Id In : controller.getSelected()]) {
            Task newTask = new Task();
            newTask.ActivityDate = task.ActivityDate;
            newTask.OwnerId = task.OwnerId;
            newTask.Status = task.Status;
            newTask.Subject = task.Subject;
            newTask.ReminderDateTime = task.ReminderDateTime;
            newTask.Description = task.Description;
            newTask.Priority = task.Priority;
            if (interest.Contact__c != null && !contactIdSet.contains(interest.Contact__c)) {
	            newTask.WhoId = interest.Contact__c;
	            newTask.WhatId = task.WhatId;
	            contactIdSet.add(interest.Contact__c);
            }
            if (interest.Lead__c != null && !leadIdSet.contains(interest.Lead__c)) {
	            newTask.WhoId = interest.Lead__c;
	            //newTask.WhatId = task.WhatId;
	            leadIdSet.add(interest.Lead__c);
            }
	        tasks.add(newTask);
        }
        insert tasks;

 		String contatcNames = '';
        for (Contact contact : [Select Name From Contact where Id In :contactIdSet])  {
        	contatcNames += contact.Name + ', ';
        }
        
        if (contatcNames.length() > 2) {
        	contatcNames = contatcNames.substring(0, contatcNames.length() - 2);
        }
 
  		String leadNames = '';
        for (Lead lead : [Select Name From Lead where Id In :leadIdSet])  {
        	leadNames += lead.Name + ', ';
        }
        
        if (leadNames.length() > 2) {
        	leadNames = leadNames.substring(0, leadNames.length() - 2);
        }
        

        string msg = 'You have created tasks related to ';
        if (contactIdSet.size() > 0)
        	msg += contactIdSet.size() + ' contacts ';
        if (leadIdSet.size() > 0)
        	msg += leadIdSet.size() + ' leads ';
        
        msg += '. ';
        
        if (contactIdSet.size() > 0)
        	msg += 'The contacts are ' + contatcNames + '. ';
        
        if (leadIdSet.size() > 0)
        	msg += 'The leads are ' + leadNames + '. ';
      
        
		MessageUtil.writeInfo(msg);
    	return null;
    }
}