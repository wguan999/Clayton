public with sharing class OpportunityVisbilityController {
  public OpportunityVisbilityController() {
   }

	public List<Opportunity> getOpportunities() {
		try {
			return [Select o.Name, o.Amount From Opportunity o where o.accountId = '001i0000002uHIk'];
		}
		catch (Exception e) {
			
			return new List<Opportunity>();
		}
    }
}