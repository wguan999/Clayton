public with sharing class OpportunityVisibilityExtension {
    private ApexPages.StandardController controller;

    public OpportunityVisibilityExtension(ApexPages.StandardController controller) {
        this.controller = controller;
    }

	public List<Opportunity> getOpportunities() {
		List<Opportunity> opportunities;
		//try {
		//	opportunities = [Select o.Name, o.Amount From Opportunity o where o.accountId = :controller.getRecord().Id];
		//}
		//catch (Exception e) {
		 	User u = new User(Alias = 'WGuan', Email='wguan@everfusion.com', UserName='wguan@everfusion.com');
      		System.runAs(u){
				opportunities= [Select o.Name From Opportunity o where o.accountId = :controller.getRecord().Id];
      		}
		//}
		return opportunities;
    }
}