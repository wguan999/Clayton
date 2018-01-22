public with sharing class InterestAddToCampaignExt {    
    public ApexPages.StandardSetController controller {get; set;}
    public CampaignMember campaignMember {get; set;}
    public Boolean overwrite {get; set;}
    public Boolean noSelection { get; set; }

    public InterestAddToCampaignExt(ApexPages.StandardSetController controller) {
        this.controller = controller;
        campaignMember = new CampaignMember();
       	noSelection = (controller.getSelected().size() == 0);
        if (noSelection) {
        	MessageUtil.writeInfo('Please make your selections form the list view before continue.');
        }
    }

    public PageReference addToCompaign() {   
        Map<Id, CampaignMember> contactMemberMap = new Map<Id, CampaignMember>();
        Map<Id, CampaignMember> leadMemberMap = new Map<Id, CampaignMember>();
        for (Interest__c interest : [Select Notes__c, Name, Interest_Setup__c, Id, Degree__c, Contact__c, Lead__c, Category__c From Interest__c 
            WHERE Id In : controller.getSelected()]) {
            CampaignMember member = new CampaignMember(); 
            member.CampaignId = campaignMember.CampaignId;
            member.Status = campaignMember.Status;
            if (interest.Contact__c != null && !contactMemberMap.keySet().contains(interest.Contact__c)) {
                member.ContactId = interest.Contact__c;
                contactMemberMap.put(interest.Contact__c, member);
            }
             if (interest.Lead__c != null && !leadMemberMap.keySet().contains(interest.Lead__c)) {
                member.LeadId = interest.Lead__c;
                leadMemberMap.put(interest.Lead__c, member);
            }
        }

        for (CampaignMember member : [Select Status, ContactId From CampaignMember 
            WHERE ContactId In : contactMemberMap.keySet() and CampaignId = :campaignMember.CampaignId]) {
                CampaignMember updateMember = contactMemberMap.get(member.ContactId);
                updateMember.Id = member.Id;
                if (!overwrite)
                    updateMember.Status = member.Status;
        }
 
        for (CampaignMember member : [Select Status, LeadId From CampaignMember 
            WHERE LeadId In : leadMemberMap.keySet() and CampaignId = :campaignMember.CampaignId]) {
                CampaignMember updateMember = leadMemberMap.get(member.LeadId);
                updateMember.Id = member.Id;
                if (!overwrite)
                    updateMember.Status = member.Status;
        }
 
 		String contatcNames = '';
        for (Contact contact : [Select Name From Contact where Id In :contactMemberMap.keySet()])  {
        	contatcNames += contact.Name + ', ';
        }
        
        if (contatcNames.length() > 2) {
        	contatcNames = contatcNames.substring(0, contatcNames.length() - 2);
        }
 
  		String leadNames = '';
        for (Lead lead : [Select Name From Lead where Id In :leadMemberMap.keySet()])  {
        	leadNames += lead.Name + ', ';
        }
        
        if (leadNames.length() > 2) {
        	leadNames = leadNames.substring(0, leadNames.length() - 2);
        }
        
        upsert contactMemberMap.values();
        upsert leadMemberMap.values();
        string msg = 'You have added ';
        if (contactMemberMap.size() > 0)
        	msg += contactMemberMap.size() + ' contacts ';
        if (leadMemberMap.size() > 0)
        	msg += leadMemberMap.size() + ' leads ';
        
        msg += ' to the campaign. ';
        
        if (contactMemberMap.size() > 0)
        	msg += 'The contacts are ' + contatcNames + '. ';
        
        if (leadMemberMap.size() > 0)
        	msg += 'The leads are ' + leadNames + '. ';
      
        MessageUtil.writeInfo(msg);
        return null;
    }
}