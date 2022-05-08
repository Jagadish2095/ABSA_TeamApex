({
    getApplication: function(component) {
        var opportunityId  = component.get("v.recordId");
        
        var action = component.get("c.getApplicationProductCredit");
        action.setParams({
            "opportunityId" : opportunityId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if(responseValue !== null)
                {
                    
                    var apcOppId = responseValue.Opportunity__c; 
                    var apcId = responseValue.Id; 
                    component.set("v.apcId", responseValue.Id); 
                    
                    if(responseValue != null && responseValue.Id != null){
                        component.set("v.applicationId", responseValue.Id);
                        component.set('v.isHide', false); 
                    }
                    else
                    {
                        component.set('v.isHide', true); 
                    }
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    //update NCA Section
    updateNCA : function(component, event, helper) {
        
        var opportunityId  = component.get("v.recordId");
        var action = component.get("c.updateNCAsection");
        
        action.setParams({ 
            "creditAgreement" : component.find("creditAgreement").get("v.value"),
            "numberOfTrustees" : component.find("numberOfTrustees").get("v.value"),
            "anyJuristicTrustee" : component.find("anyJuristicTrustee").get("v.value"),
            "annualTurnover" : component.find("annualTurnover").get("v.value"),
            "assetValue" : component.find("assetValue").get("v.value"),
            "clientState" : component.find("clientState").get("v.value"),
            "underExistingFranchise" : component.find("underExistingFranchise").get("v.value"),
            "partOfEnterpriseDevFund" : component.find("partOfEnterpriseDevFund").get("v.value"),
            "opportunityId" : opportunityId});  
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                if(response ==='SUCCESS'){
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "Record updated Successfully" 
                    });
                    toastEvent.fire();
                }
                else
                {
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": "Failed to update record!"
                    });
                    toastEvent.fire();
                }
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }else{
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }
})