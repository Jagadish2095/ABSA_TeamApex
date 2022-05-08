/**
 * @description       : ShortTermInsurancePushLead helper
 * @author            : Mbuyiseni Mbhokane
 * @group             : ZyberFox
 * @last modified on  : 05-21-2021
 * @last modified by  : Mbuyiseni Mbhokane
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   05-21-2021   Mbuyiseni Mbhokane   Initial Version
**/
({ 
    pushLeadToPortal : function(cmp, event, helper) {
        debugger;
         
        var rid = cmp.get("v.recordId");
        console.log("ShortTerm:" + rid);
        var action = cmp.get("c.PushToPortal");
        action.setParams({"opportunityId" : rid});
     
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
            var toastEvent = $A.get("e.force:showToast");
            
            if (state === "SUCCESS") { 
                cmp.set("v.initiateQuoteDone", true);
                //response payload
                console.log('response payload : '+ response.getReturnValue());
                var retunedMessage = JSON.parse(response.getReturnValue());
                console.log('Returned Response : '+ retunedMessage);
                console.log('Returned result Code : '+ retunedMessage.result[0].code);

                toastEvent.setParams({
                    
                    "message": retunedMessage.result[0].message
                });
                toastEvent.fire();
            } 
            else { 
                
                var errors = response.getError();                
                if (errors) {
                    if (errors && errors.message) {
                        // show Error message
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": errors.message
                        });
                        toastEvent.fire();
                    }
                } else {
                    // show Error message
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Unknown error"
                    });
                    toastEvent.fire();
                }
            } 
        }); 
        
        $A.enqueueAction(action); 
    },
    checkOnInitValidity: function (cmp, event, helper) {
        debugger;
        cmp.set("v.showSpinner", true);
         var action = cmp.get("c.PushToPortal"); 
        var rid = cmp.get("v.recordId");
        console.log("ShortTerm1:" + rid);
        var action = component.get("c.checkInitValidity");
        
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                
                var action = cmp.get("c.checkCASAValidity");
                action.setParams({
                    "OpportunityId": rid
                    
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var casaValidity = response.getReturnValue();
                        
                        cmp.set("v.showSpinner", true);
                        
                        var oppId = cmp.get("v.recordId");
                        var action = cmp.get("c.getCasaStatus");
                        action.setParams({
                            "OpportunityId": rid
                        });
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                var screeningStatus = response.getReturnValue();
                                if(screeningStatus == 'Continue with the process' || screeningStatus == 'Approved'){
                                    cmp.set("v.casaScreeningStatus", false);
                                    
                                    if(casaValidity == 'Valid'){
                                        if(validity == 'Valid'){
                                            cmp.set("v.showRiskScreen", false);
                                            cmp.set("v.showFinishedScreen", true);
                                            cmp.set("v.showCasaNotCompleted", false);
                                        }
                                        else{
                                            cmp.set("v.showRiskScreen", true);
                                            cmp.set("v.showFinishedScreen", false);
                                            cmp.set("v.showCasaNotCompleted", false);
                                        }
                                    }
                                    else{
                                        cmp.set("v.showRiskScreen", false);
                                        cmp.set("v.showCasaNotCompleted", true);
                                    }
                                }
                                else{
                                    cmp.set("v.showRiskScreen", false);
                                    cmp.set("v.showFinishedScreen", false);
                                    cmp.set("v.showCasaNotCompleted", false);
                                    cmp.set("v.casaScreeningStatus", true);
                                }
                            }
                            cmp.set("v.showSpinner", false);
                        });
                        $A.enqueueAction(action);
                    }
                });
                $A.enqueueAction(action);
                
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    } ,

        //CALL updateLeadDetails service
        updateLeadDetailsService :function (component, event, helper){
            debugger;
            var oppId = component.get("v.recordId");
            var accId;
            console.log('oppId : '+ oppId);
            console.log('accId : '+ accId);
            var action = component.get("c.leadDetailsUpdate");
            action.setParams({"opportunityId": oppId,
                              "accountId": accId});
            action.setCallback(this, function(response) {

                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = JSON.parse(response.getReturnValue());
                    console.log('data : '+ data);
                    console.log('response.getReturnValue() : '+ response.getReturnValue());
                    console.log('data message : '+ data.result[0].message);

                    //toast

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": data.result[0].message
                    });
                    toastEvent.fire();
                }
                else {
                    console.log("Failed with state: " + JSON.stringify(response));
                    //toast
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": JSON.stringify(response)
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        },
})