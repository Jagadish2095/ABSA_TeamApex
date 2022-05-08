({

    	myAction : function(component, event, helper) {
		
	},
    
      doInit : function(component,event,helper){ 
        component.set("v.showSpinner",true);  
        var caseId  = component.get("v.recordId ");
        
         console.log('caseId@@@ '+caseId);
        
        var action = component.get("c.getApplicationId");
        action.setParams({"caseId" : caseId});
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            var applicationId = response.getReturnValue();
            
            if (state == "SUCCESS")
            {                   
           var recId = applicationId.Id;
           var appId = applicationId.Application_Product_CAF__c;
           var oppId = applicationId.OpportunityId;
           
           component.set("v.recId",recId);
           component.set("v.appId",appId);
           component.set("v.oppId",oppId);
           console.log('recId: '+component.get("v.recId"));
           console.log('appId: '+component.get("v.appId"));
           console.log('oppId: '+component.get("v.oppId"));
           helper.fetchApplications(component, event, helper);     
            }else 
            {
                console.log ('error');
            }
             component.set("v.showSpinner",false); 
        });
      // $A.get('e.force:refreshView').fire();
        $A.enqueueAction(action);
    },
  
    handleOnSubmit: function (component, event, helper) {
        component.set("v.showSpinner",true);
    },
    handleOnload: function (component, event, helper) {
        var fields = event.getParams('recordUi').recordUi.record.fields;
        component.set("v.fieldsData",fields);
         console.log('recId:OnL '+component.get("v.recId"));
         console.log('appId:OnL '+component.get("v.appId"));
         console.log('oppId:OnL '+component.get("v.oppId"));
    },
    handleSuccess: function (component, event, helper) {
        console.log('inHandleOn');
        var appId = component.get("v.appId");
         helper.fetchApplications(component, event, helper);
        helper.updateApplicationsTable(component, event, helper);
        helper.fetchApplicationToView(component, event, helper,appId);
        //helper.move2NextOppStage(component, event, helper, "Sanctioning");
        component.set("v.showSpinner",false);    
        helper.successMsg(component,'Application saved successfully');
        
        
    },
})