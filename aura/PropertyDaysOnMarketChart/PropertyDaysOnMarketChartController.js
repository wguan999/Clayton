({
	recordUpdated : function(component, event, helper) {
		var changeType = event.getParams().changeType;
        if (changeType === "LOADED" || changeType === "CHANGED") { 
			helper.calculateDaysOnMarket(component);
        }		
	},
    
   	recordChangeHandler : function(component, event) {
        var id = event.getParam("recordId");
        component.set("v.recordId", id);
        var service = component.find("service");
        service.reloadRecord();
	}
    
})