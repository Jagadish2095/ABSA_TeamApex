({
    doInit : function(component, event, helper) {
        //load fulfillment history
        console.log("in the init of covid fulfilment");
        
        var action = component.get("c.fetchcaseHistory");
        action.setParams({
            oppId: component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('return value--',returnValue);
                component.set("v.caseHistoryList",returnValue);
            }else{
                console.log("failed with status:",response.getReturnValue());
            }
            
        });
        $A.enqueueAction(action);    
        
    },
    goDocumentsTab :function(component, event, helper){
        // var pageReference = { "type": "standard__navItemPage", "attributes": { "apiName": "Documents"  }};// replace with the API name of your custom tab } }; 
        /* var recordId = component.get("v.recordId");
        var pageReference ={    
            "type": "standard__recordPage",
            "attributes": {
                "recordId": recordId,
                "objectApiName": "Opportunity",
                "actionName": "view"
            }
        } ;     
        component.set("v.pageReference", pageReference); 
        var navService = component.find("navId"); 
        var pageReference = component.get("v.pageReference"); 
        alert(JSON.stringify(pageReference)); 
        event.preventDefault(); 
        navService.navigate(pageReference); */
        
        var recordId = component.get("v.recordId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId ,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    showButton:function(component, event, helper) {
        //hide button after submission
        var buttonValue= component.get("v.hideFulfilmentButton");
        component.set("v.hideFulfilmentButton",!buttonValue);
        
    },  
    submitFulfilment : function(component, event, helper) {
        //hide button after submission
        component.set("v.hideFulfilmentButton",true);
        component.find('EditOpp').submit();
        //create case after submission to fulfilment
        var action = component.get("c.createCasefulfilment");
        action.setParams({
            oppId: component.get("v.recordId"),
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Submitted for fulfilment successfully!",
                    "type": "success",
                    "duration": 1500
                });
                toastEvent.fire();
                //component.set("v.caseHistoryList",returnValue);
            }
            
        });
        $A.enqueueAction(action);    
        $A.get("e.force:refreshView").fire();
        
    }
})