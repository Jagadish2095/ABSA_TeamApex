({
    doInit: function(component, event, helper){
        helper.doInit_Helper(component, event);
    },
    
    addPickListValue: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.selectedValue", selectedValues);
    },
    
    handleSubmit: function(component, event, helper){
        helper.doSubmitData(component, event);
    }
})