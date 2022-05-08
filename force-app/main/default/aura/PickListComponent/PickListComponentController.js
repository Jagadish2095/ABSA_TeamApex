({
    doInit : function(component, event, helper) {
        helper.getPickListValues(component);
    },
    handleChange : function(component, event, helper) {
        var cmpEvent = component.getEvent("cmpEvent");
        cmpEvent.setParams({"selectedValue" :component.get("v.selectedValue")});
        cmpEvent.fire();
    },
    eventInpValidation : function(component, event, helper) {
        console.log('caling...........');
        var firstNameField = component.find("picklistId");
        var value = firstNameField.get("v.value");
          if(value===''||value===null || value===undefined) {
            firstNameField.showHelpMessageIfInvalid();
        }
    }
})