({
    checkOnInitValidity: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkInitValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                console.log("validity " + validity);
                
                if(validity == 'Valid'){
                    component.set("v.showSubmitScreen", true);
                    component.set("v.showInvalidScreen", false);
                }
                else{
                    component.set("v.showSubmitScreen", false);
                    component.set("v.showInvalidScreen", true);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            //component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    priValidity: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkPRIValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                if(validity == 'Valid'){
                    if(component.get("v.isDirectDelivery") == false)
                    	component.set("v.showPRIButton", false);
        			component.set("v.showValidateButton", false);
                    component.set("v.showSubmitButton", true);
                }
                else{
                    if(component.get("v.isDirectDelivery") == false)
                    	component.set("v.showPRIButton", true);
        			component.set("v.showValidateButton", false);
                    component.set("v.showSubmitButton", true);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkWBIFErrors: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getWBIFErrors");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.opportunity", response.getReturnValue());
                if(component.get("v.opportunity.RecordType.Name") == 'Direct Delivery Sales Opportunity')
                    component.set("v.isDirectDelivery", true);
                
                if(component.get("v.opportunity.WBIF_Submit_Message__c") != null){
                    var message = component.get("v.opportunity.WBIF_Submit_Message__c");
                    if(message.includes('Submit_OK_BackOffice')){
                        component.set("v.submittedToBackOffice", true);
                    }
                }

                var policyNumber = component.get("v.opportunity.WBIF_Policy_Number__c");
                if(policyNumber != null){
                    component.set("v.submittedToBackOffice", false);
                    component.set("v.opportunity.WBIF_Submit_Message__c", '');
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkUltimateProtector: function (component)
    {
        component.set("v.showSpinner", true);
        var isInvalid = component.get("v.showInvalidScreen");
        console.log('isInvalid',isInvalid);
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkUltimateProtectorStatus");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS" && isInvalid === false)
            {
                if(response.getReturnValue() === true)
                {
                    component.set("v.showUltimateProtector", true);
                    component.set("v.showSubmitButton", false);
                    component.set("v.showValidateButton", true);
                }
                else
                {
                    component.set("v.showUltimateProtector", false);
                    component.set("v.showSubmitButton", true);
                    component.set("v.showValidateButton", false);
                }
                this.checkOnInitValidity(component);
            	this.checkWBIFErrors(component);
                component.set("v.showSubmitScreen", true);
            }
            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    validate: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.validateWibf");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                console.log("Response " + response.getReturnValue());
                
                if(response.getReturnValue() == 'WBIF Success'){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "WBIF Validation Successfully Completed.",
                        "type":"success"
                    });
                    toastEvent.fire();                    
                    this.priValidity(component);
                }
                else
                {
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": response.getReturnValue(),
                        "type":"error"
                    });
                    toastEvent.fire();
                    //window.location.reload();
                    //$A.get('e.force:refreshView').fire();
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
            
            this.checkOnInitValidity(component);
            this.checkWBIFErrors(component);
            //var a = component.get('c.doInit');
        	//$A.enqueueAction(a);
        });
        $A.enqueueAction(action);
    },
    
    getPriNumber: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.retrievePriNumber");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'PRI Success'){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "PRI Validation Successfully Completed.",
                        "type":"success"
                    });
                    toastEvent.fire();
                    
                    component.set("v.showPRIButton", false);
        			component.set("v.showValidateButton", false);
                    component.set("v.showSubmitButton", true);
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": response.getReturnValue(),
                        "type":"error"
                    });
                    toastEvent.fire();
                } 
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);           
        });
        $A.enqueueAction(action);
    },
    
    submit: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var hasUltimateProtector = component.get("v.showUltimateProtector");

        if(hasUltimateProtector === true)
        {
            var action = component.get("c.submitWibf");
            action.setParams({
                "oppId": oppId
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    
                    if(response.getReturnValue() == 'WBIF Success'){
                        // show success notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "WBIF Validation Successfully Completed.",
                            "type":"success"
                        });
                        toastEvent.fire();
                        
                        if(component.get("v.opportunity.WBIF_Submit_Message__c") != null){
                            var message = component.get("v.opportunity.WBIF_Submit_Message__c");
                            if(message.includes('Submit_OK_BackOffice')){
                                component.set("v.submittedToBackOffice", true);
                            }
                        }
                        
                        component.set("v.showRiskScreen", false);
                        component.set("v.showValidateButton", false);
                    }
                    else
                    {
                        //show error notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": response.getReturnValue(),
                            "type":"error"
                        });
                        toastEvent.fire();
                    }
                }
                else {
                    console.log("Failed with state: " + state);
                }
                component.set("v.showSpinner", false);
                
                var a = component.get('c.doInit');
                $A.enqueueAction(a);
            });
            $A.enqueueAction(action);
        }
        else
        {
            var action = component.get("c.updateOpportunityStatus");
            action.setParams({
                "oppId": oppId
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    
                    if(response.getReturnValue() == true){
                        // show success notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Opportunity has been updated",
                            "type":"success"
                        });
                        toastEvent.fire();
                        
                        component.set("v.showSubmitButton", false);
                    }
                    else
                    {
                        //show error notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": response.getReturnValue(),
                            "type":"error"
                        });
                        toastEvent.fire();
                    }
                }
                else {
                    console.log("Failed with state: " + state);
                }
                component.set("v.showSpinner", false);
                
                this.checkOnInitValidity(component);
            	this.checkWBIFErrors(component);
            });
            $A.enqueueAction(action);
        }       
    },
})