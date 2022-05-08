({
    getAppRec :function(component, event, helper) {
        var action = component.get("c.getApplicationRec");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appId = response.getReturnValue();
                console.log("appId: " + JSON.stringify(appId));
                component.set("v.appRecId", appId.Id);
                component.set("v.Parent", appId.Parent__c);
                component.set("v.Istheparentalsoaguarantor", appId.Is_the_parent_also_a_guarantor__c);
                $A.get('e.force:refreshView').fire();

            }
            else {
                
            }
        });
        
        $A.enqueueAction(action);
    },
    
    updateBorrowerInfo : function(component, event, helper) {
        
        var parentName ,regincorporationnumb,numberOfBorrowerSignatureRequired,numberOfDaysForBorrowerToAcceptOf,changeOfControlParty;
        var Parent =component.get("v.Parent"); 
        var Istheparentalsoaguarantor=component.get("v.Istheparentalsoaguarantor");
        var oppId= component.get("v.recordId");
        var recId = component.get("v.appRecId");
        console.log('oppId'+oppId);
        console.log('recId'+recId);
        
        if(component.find("parentName") == undefined){
            parentName=null;
        }else{
            parentName = component.find("parentName").get("v.value");
        }
        if(component.find("regincorporationnumb") == undefined){
            regincorporationnumb=null;
        }else{
            regincorporationnumb = component.find("regincorporationnumb").get("v.value");
        }
        if(component.find("numberOfBorrowerSignatureRequired") == undefined){
            numberOfBorrowerSignatureRequired=null;
        }else{
            numberOfBorrowerSignatureRequired = component.find("numberOfBorrowerSignatureRequired").get("v.value");
        }
        if(component.find("numberOfDaysForBorrowerToAcceptOf") == undefined){
            numberOfDaysForBorrowerToAcceptOf=null;
        }else{
            numberOfDaysForBorrowerToAcceptOf = component.find("numberOfDaysForBorrowerToAcceptOf").get("v.value");
        }
        if(component.find("changeOfControlParty") == undefined){
            changeOfControlParty=null;
        }else{
            changeOfControlParty = component.find("changeOfControlParty").get("v.value");
        }
        
        var action = component.get("c.updateBorrowerInfo");
        action.setParams({
            "oppId":oppId,
            "recId" : recId,
            "Parent" : Parent,
            "Istheparentalsoaguarantor" : Istheparentalsoaguarantor,
            "parentName" : parentName,
            "regincorporationnumb" : regincorporationnumb,
            "numberOfBorrowerSignatureRequired" : numberOfBorrowerSignatureRequired,
            "numberOfDaysForBorrowerToAcceptOf" : numberOfDaysForBorrowerToAcceptOf,
            "changeOfControlParty" : changeOfControlParty,
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var appCPFRec = response.getReturnValue();
                console.log('oppRec'+JSON.stringify(appCPFRec));
                // component.set("v.showSpinner", false);
                //this.refresh(component);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Borrower Info updated Successfully"
                });
                toastEvent.fire();
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        /* var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message": "Please select CPF Product."
                        });
                        toastEvent.fire(); */
                        
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
            // component.set("v.showSpinner", false);
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
    },
    showSpinner: function(component) {
        var spinnerMain =  component.find("Spinner");
        $A.util.removeClass(spinnerMain, "slds-hide");
    },
    
    hideSpinner : function(component) {
        var spinnerMain =  component.find("Spinner");
        $A.util.addClass(spinnerMain, "slds-hide");
    },
    
    
    
})