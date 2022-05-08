({
    doInit: function(component, event, helper){
        helper.doInit_helper(component, event);
    },
    
    addPickListValue: function (c, e, h) {
        var selectedValues = e.getParam("value");
        c.set("v.selectedValue", selectedValues);
    },
    
    handleSubmit: function(component, event, helper){
        helper.handleSubmit_helper(component, event);
    }
})