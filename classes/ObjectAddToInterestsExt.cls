public with sharing class ObjectAddToInterestsExt {
    public List<InterestWrapper> interestWrappers {get; set;}
    public ApexPages.StandardSetController controller {get; set;}
    public Boolean noSelection { get; set; }
    public ObjectAddToInterestsExt(ApexPages.StandardSetController controller) {
        this.controller = controller;
        interestWrappers = new List<InterestWrapper>();
        interestWrappers.add(new InterestWrapper(new Interest__c(), 0));
        noSelection = (controller.getSelected().size() == 0);
        if (noSelection) {
        	MessageUtil.writeInfo('Please make your selections form the list view before continue.');
        }
        
    }

    public void addInterestSetup() {
        interestWrappers.add(new InterestWrapper(new Interest__c(), interestWrappers.size()));
    }

    public void removeInterestSetup() {
        Integer rowId = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowId'));
        interestWrappers.remove(rowId);
        for (Integer index = 0; index < interestWrappers.size(); index++) {
            interestWrappers[index].rowId = index;
        }
    }
    
    public void saveInterests() {
        Set<String> interestIds = new Set<String>();
        for (InterestWrapper interestWrapper: interestWrappers) 
            interestIds.add(interestWrapper.interest.Interest_Setup__c);            
        
        boolean isLead = false;
        Set<Id> keySet = new Set<Id>();
        for (SObject obj: controller.getSelected()) {
            keySet.add(obj.Id);
 			if (obj instanceof Lead)
 				isLead = true;
        }
        Map<String, Interest__c> existingInterests = new Map<String, Interest__c>();
        for (Interest__c interest : [Select Notes__c, Name, Interest_Setup__c, Id, Degree__c, Lead__c, Contact__c, Category__c From Interest__c 
            WHERE (Lead__c In :keySet or Contact__c In :keySet) and Interest_Setup__c in : interestIds]) {
            	if (isLead)
                	existingInterests.put(String.valueOf(interest.Lead__c) + String.valueOf(interest.Interest_Setup__c), (Interest__c)interest);
                else 
                	existingInterests.put(String.valueOf(interest.Contact__c) + String.valueOf(interest.Interest_Setup__c), (Interest__c)interest);  
        }
        
        List<Interest__c> updateInterests = new List<Interest__c>();
        List<Interest__c> insertInterests = new List<Interest__c>();
        for (InterestWrapper interestWrapper: interestWrappers) {
            for (SObject obj: controller.getSelected()) { 
            	System.debug('  ' + (obj.Id + String.valueOf(interestWrapper.interest.Interest_Setup__c)));
                Interest__c interest = existingInterests.get(obj.Id + String.valueOf(interestWrapper.interest.Interest_Setup__c));
                if (interest == null) {
                    if (obj instanceof Lead)
                        interest = new Interest__c(Interest_Setup__c = interestWrapper.interest.Interest_Setup__c, Lead__c = obj.Id);
                    else
                        interest = new Interest__c(Interest_Setup__c = interestWrapper.interest.Interest_Setup__c, Contact__c = obj.Id);
                	insertInterests.add(interest);
                }
                else
                	updateInterests.add(interest);
                
                interest.Degree__c = interestWrapper.interest.Degree__c;
                interest.Notes__c = interestWrapper.interest.Notes__c;
            }
        }
        
        if (updateInterests.size() > 0)
        	update updateInterests;
        
        if (insertInterests.size() > 0)
	        insert insertInterests;
        
        String names = '';
        
        if (isLead)
            for (Lead lead : [Select Name From Lead where Id In :keySet]) 
                names += lead.Name +  ', ';
        else
            for (Contact contact : [Select Name From Contact where Id In :keySet]) 
                names += contact.Name +  ', ';
        
        if (names.length() > 2) {
            names = names.substring(0, names.length() - 2);
        }
        
        String message = 'You have added  '+ controller.getSelected().size() + ' ' + (isLead ? 'leads':'contacts')  + ' to interest. They are ' + names + '.';
        MessageUtil.writeInfo(message);
    }
}