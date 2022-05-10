({  
    doInit: function(component, event, helper) {
        helper.checkIfCIFExists(component);
   	},
    
    createOrUpdate: function(component, event, helper) {
        helper.createOrUpdate(component);
   	},
})