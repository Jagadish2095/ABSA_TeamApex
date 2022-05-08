({
    myAction : function(component, event, helper) {

    },

    doInit : function(component, event, helper) {
        component.set("v.OppPrtyDetailsExisting",{})
        helper.getOpportunityDetails(component,event);
    },
    
    showPhotoFields :function(component, event, helper) {
        var selectedVal= event.getSource().get("v.value") ;
        if(selectedVal =='Yes'){
            component.set("v.showPhotoFields",true);
        }else{
            component.set("v.showPhotoFields",false);
        }
    },
    
    
    handleEdit :  function(component, event, helper) {
        component.set("v.isQuoteDone",false);
         component.set("v.showEditButton",false);
         component.set("v.readOnlyFields",false); 
    },

    handleCancel : function(component, event, helper) {
        component.set("v.isQuoteDone",true);
         component.set("v.showEditButton",true);
         component.set("v.readOnlyFields",true); 
    },

    handleChangeNext :function(component,event,helper){
     
        var LabelName = event.getSource().get("v.label");
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        if(quoteOutcome == '' || quoteOutcome == null){
            var toastEvent = helper.getToast("Error", "Please select Quote Outcome.", "error");
                toastEvent.fire();
                return null;
        }
        else{
        	if(LabelName == 'Quote'){
            var  opportunityNewData = component.get("v.opportunityDetails");
            if(component.get("v.showInvalidScreen") == true){
            	var toastEvent = helper.getToast("Error", "Main Member Age should be greater than 18.", "error");
                toastEvent.fire();
                return null;
        	}
            if(quoteOutcome == 'Client Interested' && (opportunityNewData.DD_Additional_Cover_Selected__c ==undefined || opportunityNewData.DD_Additional_Cover_Selected__c =='')){
            	var toastEvent = helper.getToast("Error", "Please select the interest of Cover.", "error");
                toastEvent.fire();
                return null;
            }
            else
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
    handleChangePrev : function(component,event,helper){
        var actionClicked = event.getSource().getLocalId();
            // Call that action
            var navigate = component.getEvent("navigateFlowEvent");
            navigate.setParam("action", actionClicked);
            navigate.fire();
 },
})