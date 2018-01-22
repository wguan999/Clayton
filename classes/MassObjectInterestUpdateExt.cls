public with sharing class MassObjectInterestUpdateExt {

    private ApexPages.StandardController controller;
 
    protected List<InterestWrapper> interestWrappers = new List<InterestWrapper>();
    
    public MassObjectInterestUpdateExt(ApexPages.StandardController controller) {
        this.controller = controller;
        loadInterests();
    }
    
    private void loadInterests() {
        List<Interest__c> interests;
        if (controller.getRecord() instanceof Lead)
        	interests = [Select Notes__c, Name, Interest_Setup__c, Id, Degree__c, Lead__c, Category__c From Interest__c WHERE Lead__c = :controller.getRecord().Id];
        else
			interests = [Select Notes__c, Name, Interest_Setup__c, Id, Degree__c, Contact__c, Category__c From Interest__c WHERE Contact__c = :controller.getRecord().Id];        
        
        interestWrappers.clear();
        for (Integer index = 0; index < interests.size(); index++){
        	System.debug('load: ' + interests[index].Interest_Setup__c);
            interestWrappers.add(new InterestWrapper(interests[index], index));
        }
    }    
 
    public List<InterestWrapper> getInterestWrappers() {
        return interestWrappers;
    }
    
    public void addInterest() {
    	if (controller.getRecord() instanceof Lead)
    		interestWrappers.add(new InterestWrapper(new Interest__c(Lead__c = controller.getRecord().Id), interestWrappers.size()));
    	else 
    	   	interestWrappers.add(new InterestWrapper(new Interest__c(Contact__c = controller.getRecord().Id), interestWrappers.size()));
    		
    }

    public void removeInterest() {
        Integer rowId = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowId'));
        if (interestWrappers[rowId].interest.Id != null) {
            delete interestWrappers[rowId].interest; 
        }
        
        interestWrappers.remove(rowId);
        for (Integer index = 0; index < interestWrappers.size(); index++) {
            interestWrappers[index].rowId = index;
        }
        
    }
    
    public void saveInterests() {
        List<Interest__c> interests = new List<Interest__c>();
        
        Set<String> interestNameSet = new Set<String>();		
        for (InterestWrapper interestWrapper : interestWrappers) {
            interests.add(interestWrapper.interest);
        	System.debug('load: ' + interestWrapper.interest.Interest_Setup__c);
             if (interestNameSet.contains(interestWrapper.interest.Interest_Setup__c)) {
            	Interest_Setup__c setup = [SELECT Name FROM Interest_Setup__c where ID = :interestWrapper.interest.Interest_Setup__c limit 1];
            	MessageUtil.writeInfo(setup.Name + ' is duplicated. Save aborted.');
            	return;
            }
            interestNameSet.add(interestWrapper.interest.Interest_Setup__c);
        }
        
        if (interests.size() > 0) {
	        upsert interests;
	        MessageUtil.writeInfo('Interests are saved.');
        }
        loadInterests();
    }

    public PageReference close() {
    	return new PageReference('/' + controller.getRecord().Id);
    	
    }
}