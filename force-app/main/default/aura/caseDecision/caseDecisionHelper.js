({
    // function automatic called by aura:waiting event
    showSpinner: function (component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event
    hideSpinner: function (component, event, helper) {
        // add slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    getApplicationProductData: function (component, event, helper) {
        
        var caseProductId = component.get("v.caseProductId");
        
        var action = component.get("c.fetchProductInfo");
     
        action.setParams({
            "caseProductId": caseProductId
        });
        action.setCallback(this, function (response) {
            console.log(response.getState());
            if (response.getState() == "SUCCESS") {
                var data;
                var responseValue = response.getReturnValue();
                console.log('responseValue====='+responseValue);
                if (responseValue !== null) {
                    component.set("v.isReducingType", responseValue);
                  } 
            }
        });
        $A.enqueueAction(action);

    },
    getQueueMembers : function (component, event, helper) {
        var caseId = component.get("v.recordId");
        var action = component.get("c.getQueueMembers");
     
        action.setParams({
            "caseId": caseId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var data;
                var responseValue = response.getReturnValue();
                console.log('responseValue====='+responseValue.Product__c);
                if (responseValue !== null) {
                    var caseStatus;
                    component.set("v.caseStatus", responseValue.Status);
                    caseStatus =  responseValue.Status;
                    component.set("v.responseValue", responseValue);
                    component.set("v.caseProduct",responseValue.Product__c);
                    component.set("v.caseProductId",responseValue.Application_Product_Id__c);
                    component.set("v.accntNu",responseValue.Account_Number__c);
                    if(responseValue.Product__c=='Overdraft'){
                    helper.getApplicationProductData(component, event, helper);
                    }
                }
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    insertDecisionHistory : function (component, event, helper) {
        this.showSpinner(component);
        var caseId = component.get("v.recordId"); 
        
        
        var details = component.find("details");
        details = Array.isArray(details) ? details[0].get("v.value") : details.get("v.value");
       
        var approver = component.find("approver");
        approver = Array.isArray(approver) ? approver[0].get("v.value") : approver.get("v.value");
        
        
        var acctnumber = component.find("accountNum");
        acctnumber = Array.isArray(acctnumber) ? acctnumber[0].get("v.value") : acctnumber.get("v.value");
        
        var reasons = JSON.stringify(component.get("v.selectedMandatedOfficialsList"));
        console.log('resonss--'+reasons);
        //acctnumber = acctnumber.get("v.value");
        
        var isreducingtype = component.get("v.isReducingType");
        if(isreducingtype){
         this.showToast("error","Error!","Overdraft limit was not successfully loaded. Please load the Overdraft reducing limit via the BDP system.");   
         var decisionAction = component.get("c.createDecisionHistory");
                   
                    
                    decisionAction.setParams({
                        "selectedOption" : component.find("selectedOption").get("v.value"),
                        "details" : details,
                        "comments" : component.find("comments").get("v.value"),
                        "approver" : approver,
                        "mbp304o" : null,
                        "caseId": caseId,
                        "acctNumber" : acctnumber,
                        "reasonsRejected":reasons
                    });
                    
                    decisionAction.setCallback(this, function (decisionResponse) {
                    	var decisionState = decisionResponse.getState();
                        
                        if (decisionState === "SUCCESS") {
                            if(String(decisionResponse.getReturnValue()).toUpperCase() == 'SUCCESS'){
                                this.showToast("success","Success!",'Decision History Record Added Successfully');
                                component.set("v.showSpinner", false);
                            } else {
                                this.showToast("error","Error!",decisionResponse.getReturnValue());
                                component.set("v.showSpinner", false);
                            }
                            
                        } else {
                            var errors = decisionResponse.getError();
                            component.set("v.showSpinner", false);
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    this.showToast("error","Error!",errors[0].message);
                                }
                            }
                        }
                    });
                    $A.enqueueAction(decisionAction);
                    this.hideSpinner(component);
        }
        else{
        var caseProduct = component.get("v.caseProduct");
        var MandateNum; 
        var MandateNumVal;
            if(caseProduct=='Overdraft'){
              MandateNum =  component.find('MandateNum');
              MandateNumVal = MandateNum.get("v.value");
            }
        var action = component.get("c.checkproductInfo");
        action.setParams({
            "caseId": caseId,
            "mandatenumber":MandateNumVal
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            
            if (state === "SUCCESS") {
                if(!String(response.getReturnValue()).includes('Error')){
        			var decisionAction = component.get("c.createDecisionHistory");
                    var mbp304o = response.getReturnValue();
                    var str='';
                    var detailsString;
                    for(var i in details ){
                        detailsString=details[i]+','+str;
                        str=details[i];
                    }
                    decisionAction.setParams({
                        "selectedOption" : component.find("selectedOption").get("v.value"),
                        "details" : detailsString,
                        "comments" : component.find("comments").get("v.value"),
                        "approver" : approver,
                        "mbp304o" : mbp304o,
                        "caseId": caseId,
                        "acctNumber" : component.find("accountNum").get("v.value"),
                        "reasonsRejected":reasons
                    });
                    
                    decisionAction.setCallback(this, function (decisionResponse) {
                    	var decisionState = decisionResponse.getState();
                        
                        if (decisionState === "SUCCESS") {
                            if(String(decisionResponse.getReturnValue()).toUpperCase() == 'SUCCESS'){
                                this.showToast("success","Success!",'Record Added Successfully');
                            } else {
                                this.showToast("error","Error!",decisionResponse.getReturnValue());
                            }
                        } else {
                            var errors = decisionResponse.getError();
                            component.set("v.showSpinner", false);
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    this.showToast("error","Error!",errors[0].message);
                                }
                            }
                        }
                    });
                    $A.enqueueAction(decisionAction);
                } else {
                    this.showToast("error","Error!", response.getReturnValue());
                }
            } else {
                var errors = response.getError();
                component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("error","Error!",errors[0].message);
                    }
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        }},
    
    showToast : function(type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire(); 
    }
})