({
    doSomething : function(component, event, helper) {
        let selected = component.find("Selection").get("v.value");
        console.log(selected);
        var opportunityId = component.get("v.recordId");        
        component.set("v.opportunityId", opportunityId);
        component.set("v.selectedSalesTool", selected);
    }
})