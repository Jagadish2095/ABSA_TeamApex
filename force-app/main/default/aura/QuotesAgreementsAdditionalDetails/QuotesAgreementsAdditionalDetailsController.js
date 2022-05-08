({
    doInit: function (component, event, helper) {
        helper.initPickLisOptions(component);
    },
    
    calculate : function(component, event, helper) {
       // alert('Service Call'); 
       helper.calculate(component,event,helper);
    },
})