({
    myAction : function(component, event, helper) {
        
    },
    doInit:function(component, event, helper) {
        helper.checkAccountValid(component,event);
        helper.getOpportunityDetails(component,event);
        helper.getOpportunitypartyDetails(component,event);
    },

    priNumber: function(component, event, helper) {
        helper.getPriNumber(component,event);
    },
    
    sendToPortal: function(component, event, helper) {
        helper.sendToPortal(component);
    },
    
    showPRI: function(component, event, helper) {
        component.set("v.showPRI",true); 
    },
    handleChangeNext :function(component,event,helper){
        
        var LabelName = event.getSource().get("v.label");
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        if(quoteOutcome == '' || quoteOutcome == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "please select Quote Outcome.",
                "type":"error"
            });
            toastEvent.fire();
            return null;
        }
        else{
            if(LabelName == 'Quote'){
                helper.saveOppPartyData(component,event,helper); 
            }else{
                var actionClicked = event.getSource().getLocalId();
                // Call that action
                var navigate = component.getEvent("navigateFlowEvent");
                navigate.setParam("action", actionClicked);
                navigate.setParam("outcome", component.get("v.quoteStatus"));
                navigate.fire();
            }
        }  
    },
    
})