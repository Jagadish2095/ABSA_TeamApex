({
	//get makertingconsent Picklist Value for credit
	getMarkgConsCreditPicklist: function(component, event) {
        var action = component.get("c.getCreditConsent");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

				result = Object.values(result);
				//remove Picklist values we dont need from result
                var result2 = result.filter(function (e) {return e != "Mail" && e != "Phone" && e != "Voice Recording";});//credit Voice Recording

                var consentMap = [];
                for(var key in result2){
                    consentMap.push({label: result2[key], value: result2[key]});
                }
				component.set("v.consentMap", consentMap);
				component.set("v.hasMarketingList1", true);

            }
        });
        $A.enqueueAction(action);
	},

    getMarkgConsNonCreditPicklist: function(component, event) {
        var action = component.get("c.getNonCreditConsent");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

				result = Object.values(result);
				//remove Picklist values we dont need from result
                var result4 = result.filter(function (r) {return r != "Mail" && r != "Phone"  && r != "Call" && r != "Telephone";});//Non credit

                var consentMap2 = [];
                for(var key in result4){
                    consentMap2.push({label: result4[key], value: result4[key]});
                }
                component.set("v.consentMap2", consentMap2);
				component.set("v.hasMarketingList2", true);

            }
        });
        $A.enqueueAction(action);
    },
    getContactDetails: function(component, event, helper){
        var recordId = component.get("v.recordId");
        var action = component.get("c.getContactDetails");
            action.setParams({
                recordId: recordId
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var contactDetails = JSON.parse(response.getReturnValue());
                    component.set("v.emailAddress", contactDetails.email);
                    component.set("v.cellphone", contactDetails.cellphone);
                    component.set("v.alternativeNumber", contactDetails.alternativeNumber);
                } else if(state === "ERROR"){
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message){
                            component.find('branchFlowFooter').set('v.heading', 'Failed to get contact details');
                            component.find('branchFlowFooter').set('v.message', errors[0].message);
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                        else{
                            component.find('branchFlowFooter').set('v.heading', 'Failed to get contact details');
                            component.find('branchFlowFooter').set('v.message', 'unknown error');
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                    }
                }
                else if(state === "INCOMPLETE"){
                    component.find('branchFlowFooter').set('v.heading', 'Failed to get contact details');
                    component.find('branchFlowFooter').set('v.message', 'Incomplete action. The server might be down or the client might be offline.');
                    component.find('branchFlowFooter').set('v.showDialog', true);
                }
            });
        $A.enqueueAction(action);
    },
    onSubmit: function(component, event, helper) {
        return new Promise(function(resolve, reject) {
            component.set("v.showSpinner", true);
            var oppId = component.get("v.opportunityId");
            var recordId = component.get("v.recordId");
            var digitalBankingInd = component.get("v.digitalBankingInd");
            var notifyMeInd = component.get("v.notifyMeInd");
            var eStatementInd = component.get("v.eStatementInd");
            var rewardsInd = component.get("v.rewardsInd");
            var yesNoProductGroup ='';//Non credit
            var yesNoCreditGroup = '';//Credit 
            if(component.find('newProductsRadioGroup')!= undefined )//Non credit
            {
                yesNoProductGroup = component.find('newProductsRadioGroup').get('v.value');//Non credit
            }
             if(component.find('qualifyFutureRadioGroup')!= undefined )//Credit
            {
                 yesNoCreditGroup = component.find('qualifyFutureRadioGroup').get('v.value');//Credit
            }
             if(component.find('AnswerNoCheckBoxGroup') != undefined || component.find('AnswerNoCheckBoxGroup') != null )
            {
             if (yesNoProductGroup == "no") {
                var answerFirstQuestion = component.find('AnswerNoCheckBoxGroup').get('v.value');
             }
            }
            if(component.find('AnswerYesCheckBoxGroup') != undefined || component.find('AnswerYesCheckBoxGroup') != null )
            {
            if (yesNoCreditGroup == "yes") {
                var answerSecondQuestion = component.find('AnswerYesCheckBoxGroup').get('v.value');
            }
           }
            
            var marConObj = {
                oppId : oppId,
                recordId : recordId,
                digitalBankingInd : digitalBankingInd,
                notifyMeInd : notifyMeInd,
                eStatementInd : eStatementInd,
                rewardsInd: rewardsInd,
                yesNoProductGroup : yesNoProductGroup,
                yesNoCreditGroup : yesNoCreditGroup,
                answerFirstQuestion : answerFirstQuestion,
                answerSecondQuestion : answerSecondQuestion
            }

            var action = component.get("c.updateMarketConsent");
            action.setParams({
                marConObj:  JSON.stringify(marConObj)
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if (result == 'Success') {
                        resolve('Continue');
                    } else {
                        component.find('branchFlowFooter').set('v.heading', 'Failed to update contact details');
                        component.find('branchFlowFooter').set('v.message', result);
                        component.find('branchFlowFooter').set('v.showDialog', true);
                }
                component.set("v.showSpinner", false);
                } else if(state === "ERROR"){
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message){
                            component.find('branchFlowFooter').set('v.heading', 'Failed to update marketing consent');
                            component.find('branchFlowFooter').set('v.message', errors[0].message);
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                        else{
                            component.find('branchFlowFooter').set('v.heading', 'Failed to update marketing consent');
                            component.find('branchFlowFooter').set('v.message', 'unknown error');
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                    }
                }
                else if(state === "INCOMPLETE"){
                    component.find('branchFlowFooter').set('v.heading', 'Failed to update marketing consent');
                    component.find('branchFlowFooter').set('v.message', 'Incomplete action. The server might be down or the client might be offline.');
                    component.find('branchFlowFooter').set('v.showDialog', true);
                }
                component.set("v.showSpinner", false);
                reject('Failed');
            });
            $A.enqueueAction(action);
        })

    },
    updateCIF: function(component, event, helper) {
        return new Promise(function(resolve, reject) {
            component.set("v.showSpinner", true);
            var recordId = component.get("v.recordId");
            var oppId = component.get("v.opportunityId");

            var action = component.get("c.updateCIFRecord");
            action.setParams({
                "recordId":  recordId,
                "oppId": oppId
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if (result == 'Success') {
                        resolve('Continue');
                    } else {
                        component.find('branchFlowFooter').set('v.heading', 'Failed to update contact details');
                        component.find('branchFlowFooter').set('v.message', result);
                        component.find('branchFlowFooter').set('v.showDialog', true);
                    }
                    component.set("v.showSpinner", false);
                } else if(state === "ERROR"){
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message){
                            component.find('branchFlowFooter').set('v.heading', 'Failed to update marketing consent');
                            component.find('branchFlowFooter').set('v.message', errors[0].message);
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                        else{
                            component.find('branchFlowFooter').set('v.heading', 'Failed to update marketing consent');
                            component.find('branchFlowFooter').set('v.message', 'unknown error');
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                    }
                }
                else if(state === "INCOMPLETE"){
                    component.find('branchFlowFooter').set('v.heading', 'Failed to update marketing consent');
                    component.find('branchFlowFooter').set('v.message', 'Incomplete action. The server might be down or the client might be offline.');
                    component.find('branchFlowFooter').set('v.showDialog', true);
                }
                component.set("v.showSpinner", false);
                reject('Failed');
            });
            $A.enqueueAction(action);
        })
    },
    checkMarketingConsentSelected: function(component) {
        var allValid = true;
        var initialAnswerIdval = component.get("v.initialAnswerId");

        if(initialAnswerIdval != 'SAVINGS_OR_INVESTMENT')
        {
        var newProductsRadioGroup = component.find('newProductsRadioGroup');
        if (newProductsRadioGroup.get('v.value') == "") {
            newProductsRadioGroup.showHelpMessageIfInvalid();
            allValid = false;
        }
        var qualifyFutureRadioGroup = component.find('qualifyFutureRadioGroup');
        if (qualifyFutureRadioGroup.get('v.value') == "") {
            qualifyFutureRadioGroup.showHelpMessageIfInvalid();
            allValid = false;
        }
        }
        return allValid;
    }
})