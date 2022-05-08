({
	getOppId : function(component) {	
       /*
        var action = cmp.get("c.getOppId");        
        action.setParams({"caseId" : cmp.get('v.recordId')});
        
        action.setCallback(this, function(response) {
              var state = response.getState(); 
              var result = JSON.stringify(response.getReturnValue());
              //alert ('Result ## : ' + result);
              if (cmp.isValid() && state === "SUCCESS"){
                 cmp.set("v.oppId", response.getReturnValue()); 
              }            
         });   
        $A.enqueueAction(action);  
       */ 
       // component.set("v.showSpinner",true);  
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
                component.set("v.loadTable",true);
              //  $A.get('e.force:refreshView').fire();
          // helper.fetchApplications(component, event, helper);     
            }else 
            {
                console.log ('error');
            }
           //  component.set("v.showSpinner",false); 
        });
       
        $A.enqueueAction(action);
      //  $A.get('e.force:refreshView').fire();
	},
   
    
})