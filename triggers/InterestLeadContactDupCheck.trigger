trigger InterestLeadContactDupCheck on Interest__c (before insert) {
	
	Boolean hasError;
	for (Interest__c interest : trigger.new) {
		if (interest.Contact__c == null && interest.Lead__c == null)
			interest.addError('Please choose a contact or a lead.');		
		if (interest.Contact__c != null && interest.Lead__c != null)
			interest.addError('You can not choose both contact and lead.');
			
		List<Interest__c> existingInterests;
		if (interest.Contact__c == null)
			existingInterests = [SELECT Name FROM Interest__c 
										WHERE Lead__c = :interest.Lead__c AND Interest_Setup__c = :interest.Interest_Setup__c];
		else
			existingInterests = [SELECT Name FROM Interest__c 
										WHERE Contact__c = :interest.Contact__c AND Interest_Setup__c = :interest.Interest_Setup__c];
		
		if (existingInterests.size() > 0)
			interest.addError('Interest exists.');			
	}
}