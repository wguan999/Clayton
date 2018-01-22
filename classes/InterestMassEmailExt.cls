public with sharing class InterestMassEmailExt {
    public ApexPages.StandardSetController controller{get; set;}
 	private List<EmailTemplate> emailTemplates;
 	public Id emailTemplateId {get; set;}
    public Boolean noSelection { get; set; }
 
    public InterestMassEmailExt(ApexPages.StandardSetController controller) {
        this.controller = controller;
        emailTemplates = [SELECT Name, Description FROM EMailTemplate WHERE isActive = true];
       	noSelection = (controller.getSelected().size() == 0);
        if (noSelection) {
        	MessageUtil.writeInfo('Please make your selections form the list view before continue.');
        }
    }
    
    public List<SelectOption> getTemplates() {
    	List<SelectOption> options = new List<SelectOption>();
    	for (EmailTemplate template: emailTemplates)
            options.add(new SelectOption(template.Id,template.Name));
        
        return options;
    }
    
    public Pagereference sendEmails() {
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> leadIdSet = new Set<Id>();
        for (Interest__c interest : [Select Contact__c, Lead__c From Interest__c 
            	WHERE Id In : controller.getSelected()]) {
            if (interest.Contact__c != null && !contactIdSet.contains(interest.Contact__c)) {
	            contactIdSet.add(interest.Contact__c);
            }
            if (interest.Lead__c != null && !leadIdSet.contains(interest.Lead__c)) {
 	            leadIdSet.add(interest.Lead__c);           
            }
        }
        List<Id> idList = new List<Id>();
        Messaging.MassEmailMessage mail;
        
        if (contactIdSet.size() > 0) {
	        for (Id id: contactIdSet)
	        	idList.add(id);
	 		mail = new Messaging.MassEmailMessage();
			mail.setTargetObjectIds(idList);
			mail.setTemplateId(emailTemplateId);
			Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
        }
        
		idList.clear();
        
        if (leadIdSet.size() > 0) {
	        for (Id id: leadIdSet)
	        	idList.add(id);
	        mail = new Messaging.MassEmailMessage();
			mail.setTargetObjectIds(idList);
			mail.setTemplateId(emailTemplateId);
			Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
        }
        
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
        

        string msg = 'You have sent emails to ';
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