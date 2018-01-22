public with sharing class MassEditInterestsController {

	private List<InterestWrapper> interestWrappers = new List<InterestWrapper>();
	private ApexPages.StandardSetController controller {get; set;}
	private Map<String, InterestWrapper> visitedInterests = new Map<String, InterestWrapper>();
	public Boolean selectAllCheckbox {get; set;}
	public Interest_Setup__c interestSetup {get; set;}
	public String updatedInterestId {get; set;}
	
	public MassEditInterestsController() {
		interestSetup = new Interest_Setup__c(Id = ApexPages.currentPage().getParameters().get('interestId'),
			Name = ApexPages.currentPage().getParameters().get('Name'),
			Category__c = ApexPages.currentPage().getParameters().get('Category'));
		setController();	
	}

	public void setController() {
		visitedInterests.clear();
		controller = new ApexPages.StandardSetController(Database.getQueryLocator(
			[Select Notes__c, Name, Interest_Setup__c, Id, Degree__c, Contact__c, Lead__c, Category__c From Interest__c 
			 WHERE Interest_Setup__c = :interestSetup.Id ORDER BY Contact__c]));
		controller.setPageSize(15);
		
	}

	public List<InterestWrapper> getInterestWrappers() {
		for (InterestWrapper wrapper:interestWrappers)
			visitedInterests.put(wrapper.interest.Id, wrapper);
		interestWrappers.clear();
		selectAllCheckbox = true;
		for (SObject interest : controller.getRecords()) {
			Interest__c orgInterest = (Interest__c)interest;
			
			InterestWrapper wrapper = visitedInterests.get(orgInterest.Id);	
			
			if (wrapper == null) {
				Interest__c clonedInterest = new Interest__c(Id=orgInterest.Id, 
						Interest_Setup__c = orgInterest.Interest_Setup__c, Contact__c = orgInterest.Contact__c,
						Lead__c = orgInterest.Lead__c,
						Degree__c = orgInterest.Degree__c, Notes__c = orgInterest.Notes__c);
				wrapper = new InterestWrapper(clonedInterest);
			}	
			
			if (wrapper.selected == false && selectAllCheckbox == true)
				selectAllCheckbox = false;	
			
			interestWrappers.add(wrapper);		
		}
		return interestWrappers;		
	}

	public PageReference previous()
	{
		if (controller.getHasPrevious())
			controller.previous();
		return null;
	}
	
	public PageReference next()
	{
		if (controller.getHasNext())
			controller.next();
		return null;
	}

	public Boolean getHasNext() {
		return controller.getHasNext();
	}
	
	public Boolean getHasPrevious() {
		return controller.getHasPrevious();
	}
	
	public PageReference selectAll(){
 		for (InterestWrapper interestWrapper : interestWrappers)
			interestWrapper.selected = selectAllCheckbox;
  		return null; 
 	}

	public PageReference close() {
		return new PageReference('/' + interestSetup.Id);
	}

	public void deleteInterests() {
		List<Interest__c> interests = new List<Interest__c>();
		for (InterestWrapper wrapper:visitedInterests.values())
				if (wrapper.selected)
					interests.add(wrapper.interest);			
		
		if (interests.size() > 0) {
			delete interests;
			MessageUtil.writeInfo('Interests Deleted.');
		}
		setController();			
	}

	public void saveInterests() {
		List<Interest__c> interests = new List<Interest__c>();
		for (InterestWrapper wrapper:visitedInterests.values())
			if (wrapper.changed)
				interests.add(wrapper.interest);			
		if (interests.size() > 0) {
			update interests;
			MessageUtil.writeInfo('Interests saved.');
		}		
	}

}