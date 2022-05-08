({
    /*@ Author: Tinashe M Shoko
 	**@ Date: 03/04/2020
 	**@ Description: Method to fetch the linked Application Product Merchant Id
    ** associated with the Opportunity*/
    fetchOpportunityLineItemId: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getOpportunityProduct");
        action.setParams({
            "oppId": recordId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    component.set("v.opportunityProductId", responseValue.Id);
                    component.set('v.isButtonActive',false);
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                console.log('Callback to fetchOpportunityLineItemId Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
            } else {
                console.log('Callback to fetchOpportunityLineItemId Failed.');
                component.set('v.isButtonActive',true);
            }
        });
        $A.enqueueAction(action);
    },

    fetchAccountContactRelation: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getAccountContactRelation");
        action.setParams({
            "oppId": recordId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = JSON.parse(response.getReturnValue());
                component.set("v.opportunityProductList", JSON.parse(response.getReturnValue()));
                if (responseValue != null) {
                    var options = [];
                    var emailMap = new Map();
                    var mobileMap = new Map();
                    var salutationMap = new Map();
                    for (var i = 0; i<responseValue.length; i++){
                        if (responseValue[i].roles != null) {
                            if ((responseValue[i].roles.indexOf('Individual with Authority to Act') > -1)
                               || (responseValue[i].roles.indexOf('Managing Director') > -1)
                               || (responseValue[i].roles.indexOf('Shareholder/Controller') > -1)) {
                                // changed to use Initials and LastName by Tinashe for story 4546
                                if (responseValue[i].initials != null) {
                                    options.push({Id: responseValue[i].id, Salutation: responseValue[i].salutation, Name: responseValue[i].initials + ' ' + responseValue[i].lastName, MobilePhone: responseValue[i].mobilePhone, Roles: responseValue[i].roles});
                                } else {
                                    options.push({Id: responseValue[i].id, Salutation: responseValue[i].salutation, Name: responseValue[i].lastName, MobilePhone: responseValue[i].mobilePhone,Roles: responseValue[i].roles});
                                }
                                emailMap.set(responseValue[i].id, responseValue[i].email);
                                mobileMap.set(responseValue[i].id, responseValue[i].mobilePhone);
                                salutationMap.set(responseValue[i].id, responseValue[i].salutation);
                            }
                        }
                    }
                    
                    if (options == null) {
                        component.set('v.optionsNotEmpty',false);
                    } else {
                        component.set('v.optionsNotEmpty',true);
                        component.set("v.options", options);
                        component.set("v.emailMap", emailMap);
                        component.set("v.mobileMap", mobileMap);
                        component.set("v.salutationMap", salutationMap);
                        component.set('v.isButtonActive',false);
                    }
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                console.log('Callback to getAccountContactRelation Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
                component.set('v.optionsNotEmpty',false);
            } else {
                console.log('Callback to getAccountContactRelation Failed.');
                component.set('v.isButtonActive',true);
                component.set('v.optionsNotEmpty',false);
            }
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