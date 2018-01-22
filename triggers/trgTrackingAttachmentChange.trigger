trigger trgTrackingAttachmentChange on Attachment (before insert) {
	List<Id> Ids = new List<Id>();
    if (Trigger.isInsert || Trigger.isUpdate)
        for (Attachment attachment: Trigger.new)
            Ids.add(attachment.ParentId);
    //Looks like delete forces a refresh out of box
    if (Trigger.isDelete)
        for (Attachment attachment: Trigger.old)
            Ids.add(attachment.ParentId);
    
    if (Ids.size() > 0) {
        List<Case> cases = [Select Id From Case where Id in :Ids];
        if (cases.size() > 0)
            for (Case aCase : cases)
            	aCase.Everfusion__PushRefreshTIme__c = System.now();
        update cases;
    }
}