({
    doInit : function(component, event, helper) {
        var mydate = component.get("v.expense.Everfusion__Date__c");
        if(mydate){
            component.set("v.formatdate", new Date(mydate));
        }
    },
})