({
    
    doInit : function(component, event, helper) {
        
        helper.setTobFields(component, event, helper);
        
        //check if already sent for pricing approval 
        var action =  component.get("c.isPricingApproval");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results is pricing---'+JSON.stringify(results));
                if(results){
                   component.set("v.isReferred",true);
                    component.set("v.processId",results);
                }
                
               
            }else{
                var errors = response.getError();
                console.log('results is pricing---'+state); 
                console.log('error---'+JSON.stringify(errors));
            }
            component.set("v.showSpinner",false); 
        });
        $A.enqueueAction(action);
        //load pricing
        
        var action = component.get("c.getproductPricing");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---'+JSON.stringify(results));
                component.set("v.pricingList",results);
                
            }
        });
        $A.enqueueAction(action);
        
        
    },
    ReferPricing : function(component, event, helper) {
        
        //save editing pricing 
        component.find('priceEdit').forEach(form=>{form.submit();
                                                   
                                                  }); //submit pricing edition
                                                   
                                                   
                                                   
                                                   component.set("v.isReferred",true);                                        
                                                   var action = component.get("c.submitApprovalProcess");
                                                   action.setParams({
                                                   "oppId": component.get("v.recordId")
                                                  });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.find('notifLib').showToast({
                    "title": "Pricing !",
                    "message": "Referred for Pricing Adjusment!",
                    "variant": "success"
                });
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
        
         //check if already sent for pricing approval 
        var action =  component.get("c.isPricingApproval");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---'+JSON.stringify(results));
                if(results){
                   component.set("v.isReferred",true);
                    component.set("v.processId",results);
                }
                
               
            }
            component.set("v.showSpinner",false); 
        });
        $A.enqueueAction(action);
        
        
    },
    
    submitPricingBack : function(component, event, helper) {
        
        //save editing pricing 
        component.find('priceEdit').forEach(form=>{form.submit();
                                                   
                                                  }); //submit pricing edition
                                                   
                                                   
                                                   
                                                   var action = component.get("c.submitPricing");
                                                   action.setParams({
                                                   "oppId": component.get("v.recordId")
                                                  });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log("results--"+results);
                var mapres = results;
                var redirect = true;
                if(results === "You have not made a decision for all pricing adjustments."){ 
                    
                    redirect= false;
                }
                
                if(redirect){
                    component.find('notifLib').showToast({
                        "title": "Pricing !",
                        "message": results,
                        "variant": "success"
                    });
                    
                   
                    var proId = component.get("v.processId");
                     console.log('v.processId===='+proId);
                    var navEvt = $A.get("e.force:navigateToSObject"); //redirect to approval process
                    navEvt.setParams({
                        "recordId": proId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();  
                }else{
                    component.find('notifLib').showToast({
                        "title": "Pricing !",
                        "message": results,
                        "variant": "error"
                    }); 
                }
                
                
                
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
        
        
        
    },
    
   /* declinePricing : function(component, event, helper) {
        
        
        
        
        var action = component.get("c.rejectApprovalProcessForPricing");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.find('notifLib').showToast({
                    "title": "Pricing !",
                    "message": "Rejected Pricing Adjustment!",
                    "variant": "success"
                });
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
        
        
    },*/
    
})