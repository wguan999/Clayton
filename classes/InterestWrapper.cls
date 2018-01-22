public class InterestWrapper {
	public Interest__c interest {get; set;}
	public Integer rowId {get; set;}
	public Boolean changed {get; set;}
	public Boolean selected {get; set;}
	
	public InterestWrapper(Interest__c interest) {
		this.interest = interest;
		selected = false;
		changed = false;
	}

	public InterestWrapper(Interest__c interest, Integer rowId) {
		this.interest = interest;
		this.rowId = rowId;
		selected = false;
		changed = false;
	}
}