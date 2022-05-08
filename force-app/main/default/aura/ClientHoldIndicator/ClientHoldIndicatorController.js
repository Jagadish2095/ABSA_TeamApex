({
    //Initiation of component
    initComp: function(component, event, helper) {
        //Get Client Hold Record Types with Status 
        helper.getClientHoldsWithStatus(component);
    },
    
})