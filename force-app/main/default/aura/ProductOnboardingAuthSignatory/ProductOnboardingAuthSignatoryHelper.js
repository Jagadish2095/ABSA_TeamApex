({
    /*@ Author: Tinashe M Shoko
 	**@ Date: 03/04/2020
 	**@ Description: Method to fetch the linked Application Product merchant Id 
    ** associated with the Opportuity*/
 /*   fetchApplicationProductMerchantId: function(component, event, helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getApplicationProductMerchant");
        action.setParams({
            "oppId": recordid
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    component.set("v.applicationProductMerchantId", responseValue.Id);
                    component.set('v.isButtonActive',false);
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                console.log('Callback to getApplicationProductMerchant Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
            } else {
                console.log('Callback to getApplicationProductMerchant Failed.');
                component.set('v.isButtonActive',true);
            }
        });
        $A.enqueueAction(action);
    },*/
    fetchAccountContactRelation: function(component, event, helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getAccountContactRelation");
        action.setParams({
            "oppId": recordid
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.appProdMerchList", response.getReturnValue());
                var parentAccountRecord  = component.get("v.parentAccountRecord");
                var options = [];
                var emailMap = new Map();
                var mobileMap = new Map();
                if (responseValue != null) {
                    if(component.get("v.productOnboardingROA") == false){
                        if (parentAccountRecord != null && parentAccountRecord.Client_Type__c.toLowerCase().includes("sole")) {
							options.push({ Id: parentAccountRecord.Id, Name: parentAccountRecord.Name, Roles: parentAccountRecord.Client_Type__c });
							emailMap.set(parentAccountRecord.Id, parentAccountRecord.parentAccountRecord);
							mobileMap.set(parentAccountRecord.Id, parentAccountRecord.PersonMobilePhone);
						}
                        for (var i = 0; i<responseValue.length; i++){
                            if (responseValue[i].Roles != null) {
                                if (
									responseValue[i].Roles.indexOf("Individual with Authority to Act") > -1 ||
									responseValue[i].Roles.indexOf("Managing Director") > -1 ||
									responseValue[i].Roles.indexOf("Shareholder/Controller") > -1 ||
									(responseValue[i].Roles.includes("Operators on primary accounts") &&
									parentAccountRecord != null && parentAccountRecord.Client_Type__c != null && parentAccountRecord.Client_Type__c.toLowerCase().includes("sole"))
								) {
									options.push({ Id: responseValue[i].Id, Name: responseValue[i].Contact.Name, Roles: responseValue[i].Roles });
									emailMap.set(responseValue[i].Id, responseValue[i].Contact.Email);
									mobileMap.set(responseValue[i].Id, responseValue[i].Contact.MobilePhone);
								}
                            }
                        }
                    }
                    else{
                        if(parentAccountRecord != null && parentAccountRecord.Client_Type__c != null && (parentAccountRecord.Client_Type__c.includes('Individual') || parentAccountRecord.Client_Type__c.includes('Sole'))){
                            options.push({Id: parentAccountRecord.Id, Name: parentAccountRecord.Name, Roles: parentAccountRecord.Client_Type__c});
                            emailMap.set(parentAccountRecord.Id, parentAccountRecord.parentAccountRecord);
                            mobileMap.set(parentAccountRecord.Id, parentAccountRecord.PersonMobilePhone);
                        }
                        for (var i = 0; i<responseValue.length; i++){
                            if (responseValue[i].Roles != null) {
                                if ((responseValue[i].Roles.indexOf('Individual with Authority to Act') > -1)) {
                                    options.push({Id: responseValue[i].Id, Name: responseValue[i].Contact.Name, Roles: responseValue[i].Roles});
                                    emailMap.set(responseValue[i].Id, responseValue[i].Contact.Email);
                                    mobileMap.set(responseValue[i].Id, responseValue[i].Contact.MobilePhone);
                                }
                            }
                        }
                    }
                }
                else{
                    if((parentAccountRecord != null && parentAccountRecord.Client_Type__c != null && (parentAccountRecord.Client_Type__c.includes('Individual') || parentAccountRecord.Client_Type__c.includes('Sole')) && component.get("v.productOnboardingROA") == true ) ||
                      (parentAccountRecord != null && parentAccountRecord.Client_Type__c.includes('Sole') && component.get("v.productOnboardingROA") == false)) {
                        options.push({Id: parentAccountRecord.Id, Name: parentAccountRecord.Name, Roles: parentAccountRecord.Client_Type__c});
                        emailMap.set(parentAccountRecord.Id, parentAccountRecord.parentAccountRecord);
                        mobileMap.set(parentAccountRecord.Id, parentAccountRecord.PersonMobilePhone);
                    }
                }
                component.set("v.options", options);
                component.set("v.emailMap", emailMap);
                component.set("v.mobileMap", mobileMap);
                component.set('v.isButtonActive',false);
                if (options == null) {
                    component.set('v.optionsNotEmpty',false);
                } else {
                    component.set('v.optionsNotEmpty',true);
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                console.log('Callback to getApplicationProductMerchant Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
                component.set('v.optionsNotEmpty',false);
            } else {
                console.log('Callback to getApplicationProductMerchant Failed.');
                component.set('v.isButtonActive',true);
                component.set('v.optionsNotEmpty',false);
            }
        });
        $A.enqueueAction(action);
    },
    
        /*@ Author: Saurabh
 	**@ Date: 12/05/2020
 	**@ Description: Method to fetch the linked Oppotunity Product Records 
    ** associated with the Opportuity*/
    
    loadOppProductRecords: function(component, event, helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getOppProductRecords");
        action.setParams({
            "oppId": recordid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    component.set("v.opportunityProductMap", responseValue);
                    var arrayOfMapKeys = [];
                    for (var key in responseValue ){
                    arrayOfMapKeys.push(key); 
                    console.log('keys of map'+arrayOfMapKeys);
                   }
                   component.set('v.nameOfProductsAdded',arrayOfMapKeys);
                    
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                console.log('Callback to getApplicationProductMerchant Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
            } else {
                console.log('Callback to getApplicationProductMerchant Failed.');
                
            }
        });
        $A.enqueueAction(action);
    },
    
        
        /*@ Author: Saurabh
 	**@ Date: 12/05/2020
 	**@ Description: Method to fetch the Added Signatory for Product Records 
    ** associated with the Opportuity*/
    
    loadExistingProductSignatoryRecords: function(component, event, helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getProductSignatoryRecords");
        var oppAccId = component.get("v.productOnboardingROA") == true ? recordid : component.get("v.parentAccountRecord").Id;
        action.setParams({
            "oppAccId": oppAccId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.isButtonActive',true);
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    component.set("v.existingSignatorylist", responseValue);

                }
                else{
                    component.set("v.existingSignatorylist", null);
}
            } else if(state === "ERROR"){
                var errors = response.getError();
                console.log('Callback to getApplicationProductMerchant Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
            } else {
                console.log('Callback to getApplicationProductMerchant Failed.');

            }
        });
        $A.enqueueAction(action);
    },
 
    /*@ Author: Saurabh
 	**@ Date: 12/05/2020
 	**@ Description: Method to fetch the parent Account
    ** associated with the Opportuity*/
    
    loadparentAccountRecord: function(component, event, helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getAccountRecordforOpp");
        action.setParams({
            "oppId": recordid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    component.set("v.parentAccountRecord", responseValue);
                    
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                console.log('Callback to getApplicationProductMerchant Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
            } else {
                console.log('Callback to getApplicationProductMerchant Failed.');
                
            }
        this.loadExistingProductSignatoryRecords(component, event, helper); //Load Existing Signatory
        this.fetchAccountContactRelation(component, event, helper);
        });
        $A.enqueueAction(action);
    },

    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})