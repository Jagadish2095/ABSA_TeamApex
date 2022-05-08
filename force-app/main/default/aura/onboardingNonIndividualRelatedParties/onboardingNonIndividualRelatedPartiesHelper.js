({
    
    //Function to Call Experian Service 
    callExperianService : function(component, event, helper){
        this.showSpinner(component);
        var action = component.get("c.callExperianHandler");
        var regNumber = component.find("regNumberC").get("v.value");
        action.setParams({"registrationNumber" : regNumber});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(respObj.statusCode==200 && respObj.message==null){
                    component.set('v.experianResponse',respObj);
                    var CompanyDetailsObj = respObj.companyDownload.results.kreditSearchFile.companyDetails;
                    component.set('v.companyDetails',CompanyDetailsObj);
                    component.set("v.isExperianModalOpen",true);  
                    
                    //Added by Diksha for W-4484 complex onboarding
                    if(CompanyDetailsObj!=undefined && CompanyDetailsObj!='' && CompanyDetailsObj!=null ){
                        if($A.get("$Label.c.Entity_Type_Status_To_Proceed").includes(CompanyDetailsObj.status)){
                            
                        }
                        else{
                            let button =component.find('correctInfo');  
                            button.set('v.disabled',true);
                        }
                    }
                    
                    
                } else if(respObj.statusCode > 399 || respObj.statusCode < 500){
                    var message = respObj.message;
                    var toastEvent = helper.getToast("Error", message, "error");
                    toastEvent.fire();
                } else{
                    var message = "We cannot complete the request now, please try again if error persist contact administrator."
                    var toastEvent = helper.getToast("Error", message, "error");
                    toastEvent.fire();
                }
                this.hideSpinner(component);
            } else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
                helper.hideSpinner(component);
            } else {
                var errors = response.getError();
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
                helper.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },
    
    getToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        return toastEvent;
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    //Function to Create Business Prospect Account
    CreateBusinessAccount : function(component, event, helper){
        this.showSpinner(component);
        var experianObj = component.get('v.experianResponse');
        var action = component.get("c.CreateBusinessProspect");
        var accountId = component.get('v.accrecordId');
        action.setParams({
            "experianData2" : JSON.stringify(experianObj),
            "accRecordId" : accountId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var message = '';
            if (state == "SUCCESS") {
                var accountRec = response.getReturnValue();
                component.set('v.accountRecordId',accountRec.Id);
                component.set('v.clientType',accountRec.Client_Type__c);
                component.set('v.highIndustryValue',accountRec.The_Client_is_involved_in_High_Risk_Indu__c);                
                
                component.set("v.isExperianModalOpen",false);
                component.set("v.showLimitedAccountInfoModal", true);
                component.set("v.goldenSourceConsentGiven", true);
                $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
                this.hideSpinner(component);
                
                setTimeout($A.getCallback(function() {
                    component.set("v.activeSections", component.get('v.defaultActiveSections'));
                }));
            } else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
                helper.hideSpinner(component);
            } else {
                var errors = response.getError();
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
                helper.hideSpinner(component);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    populateBusinessProspectRecordTypeId: function(component) {
        var action = component.get("c.getAccountRecordTypeId");
        action.setParams({
            "recordTypeName": "Prospect"
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set('v.businessProspectRecordTypeId',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 16/07/2020****************************************
 	****************@ Work Id: W-004945***************************************
 	***@ Description: Method Added by chandra to calculate controlling perct*/
    
     calculateControllingPercentageAccAccRel: function (component, event, helper) {
        
        var rolesValue = component.find('roles').get('v.value');
        var shareholdingpercentage = component.find('shareholdingpercentage').get('v.value');
        var finservacct = component.find('finservacct').get('v.value');
        var finServRelatedAccount = component.find('finServRelatedAccount').get('v.value');
        var finServRole = component.find('finServRole').get('v.value');
        var primaryEntityId = component.find('primaryEntityId').get('v.value');
        var parentRelationshipId = component.find('parentRelationshipId').get('v.value');
        
        if(shareholdingpercentage == null || shareholdingpercentage == undefined || shareholdingpercentage == '') {
            shareholdingpercentage = 0;
        }
        console.log(rolesValue+' : '+shareholdingpercentage+' : '+finservacct+' : '+finServRelatedAccount+' : '+finServRole+' : '+primaryEntityId)
        component.set('v.showSpinner', true);
   
        var action = component.get("c.calculateControllingPercentageforAccAccRel");
        action.setParams({
            "rolesValue": rolesValue,
            "shareholdingpercentage": shareholdingpercentage,
            "finservacct": finservacct,
            "finServRelatedAccount": finServRelatedAccount,
            "finServRole": finServRole,
            "primaryEntityId": primaryEntityId,
            "parentRelationshipId": parentRelationshipId,
            "clientType": component.get("v.accountRecord.Client_Type__c")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var retVal = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log('Record updated successfully');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success",
                    "message": "The record has been Created successfully."
                });
                toastEvent.fire();
               component.set('v.showSpinner', false);

               component.find("popuplib").notifyClose();
                
            }
            else {
                console.log("Failed with state: " + state);
                var errors = response.getError();
                var toast = helper.getToast("Error", errors, "error");
                toast.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
        showPrivateCompanyValidation : function(component, event, helper){
        var message = "You are only allowed to Onboard Pty Ltd,CC,trust as Related Party";
        var toastEvent = helper.getToast("Error", message, "error");
        toastEvent.fire();
    }

    
})