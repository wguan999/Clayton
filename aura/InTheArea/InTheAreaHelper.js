({
    getLocalList: function(component, recID) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, "slds-hide");
        var objectType = component.get("v.sObjectName");      
        var searchTerm = component.find("searchTerm").get("v.value");
        if (searchTerm == null) {
            searchTerm = component.get("v.defaultSearch");
        }
        searchTerm = encodeURI(searchTerm);
        if (recID) {
            var action = component.get("c.getListByAddress");
            action.setParams({
                "recordId": recID,
                "objectType": objectType,
                "searchQuery": searchTerm
            });
        } else {
            var location = component.get("v.location");
            var action = component.get("c.getLocal");
            action.setParams({
                "searchTerm": searchTerm,
                "lat": location.coords.latitude,
                "lon": location.coords.longitude
            });
        }
        action.setCallback(this, function(response) {
            this.doLayout(response, component);
        });
        $A.enqueueAction(action);
    },
    
    doLayout: function(response, component) {
        var data = JSON.parse(response.getReturnValue());
        var warning = component.find('warning');
        if (data.error) {
            component.set("v.errorMessage", data.error);            
            $A.util.removeClass(warning, 'slds-hide');
        } else {
            $A.util.addClass(warning, 'slds-hide');
        }
        
        component.set("v.restaurantList", data.bizArray);
        console.log("The Data: ", data);
    }
})