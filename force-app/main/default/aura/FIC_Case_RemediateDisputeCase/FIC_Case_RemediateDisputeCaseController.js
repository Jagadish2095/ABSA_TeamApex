({
    doInit :function(component,event,helper) {
        helper.getCase(component,event,helper)
    },

     onRefreshView :function(component,event,helper) {
        helper.getCase(component,event,helper)
    },
    
    closeRemediateModal: function(component,event,helper) {
        component.set("v.openRemediate", false);
    },
    openRemediateModal: function(component,event,helper) {
        component.set("v.openRemediate", true);
    },
    
    handleRemediateButton :function(component,event,helper) {
        helper.handleRemediate(component,event,helper);
        component.set("v.openRemediate", false);
    },
        
    closeDisputeModal : function(component,event,helper) {
        component.set("v.openDispute", false);
    },    
    openDisputeModal : function(component,event,helper) {
        component.set("v.openDispute", true);
    },    
   
    handleDisputeButton : function(component,event,helper) {
         helper.handleDispute(component,event,helper);
     },     
})