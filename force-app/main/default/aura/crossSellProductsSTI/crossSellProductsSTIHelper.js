({
	helperMethod : function() {
		
	},
    checkAccountValid: function (component,event) {
		component.set('v.showSpinner', true);
		var oppId = component.get("v.OpportunityFromFlow");//component.get('v.recordId');
		var action = component.get('c.casaCheck');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function (response) {
			var state = response;
			var result = response.getReturnValue();
			if (result == 'Valid') {
				component.set('v.accountNotValid', false);
			} else {
				component.set('v.accountInValidReason', result);
				component.set('v.accountNotValid', true);
                component.set('v.showSpinner', false);
				//component.set("v.showUpScreen", false);
				//component.set("v.showErrorScreen", false);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
    
    updatePolicyDetails: function (component,event) {
		component.set('v.showSpinner', true);
        var opprec = component.get("v.opportunityDetails");
		var oppId = component.get("v.OpportunityFromFlow");
		var action = component.get('c.updateOpportunity');
		action.setParams({
            opprecord: opprec,
			oppId: oppId
		});
		action.setCallback(this, function (response) {
			var state = response;
			var result = response.getReturnValue();
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
    
    getPriNumber: function (component,event) {
        component.set("v.showSpinner", true);
        var opprec = component.get("v.opportunityDetails");
        var oppId = component.get("v.OpportunityFromFlow");
        var action = component.get("c.retrievePriNumber");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() != null){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "PRI Validation Successfully Completed.",
                        "type":"success"
                    });
                    toastEvent.fire();
                    this.updatePolicyDetails(component,event);
					$A.get('e.force:refreshView').fire(); 
                    component.find("GetPRIButton").set('v.disabled',true);
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error while creating PRI.",
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
    
    sendToPortal: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.OpportunityFromFlow");
        var action = component.get("c.pushToPortal");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response.getReturnValue()',response.getReturnValue());
                var portalMessage = response.getReturnValue();
                if(portalMessage.includes('0000') || portalMessage.includes('200') ){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Push to Portal Successfully Completed.",
                        "type":"success"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Push to Portal Failed.",
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
    
    saveOppPartyData : function (component,event,helper) {
        component.set("v.showSpinner",true);
        
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        var quoteOutcomeReason = component.find('Quote_Outcome_Reason__c').get("v.value");
        
        var quoteStatus ;
        if (quoteOutcome == 'Client Interested')
            quoteStatus = 'Accepted';
        else if (quoteOutcome == 'Client Not Interested')
            quoteStatus = 'Rejected';
        else if(quoteOutcome == 'Client Not Insurable' || quoteOutcome == 'Duplicate Quote') 
            quoteStatus = 'Denied';
        else
            quoteStatus = 'Draft';
        component.set('v.quoteStatus', quoteStatus);
        var newlst = [];
        newlst.push({
            Name: 'STI',
            premium: 0,
            SumInsured: 0,
            OppPartyId : ''
    });//dummy data for quote creation
        var action = component.get('c.createDDQuote');
        action.setParams({
            oppId: component.get('v.OpportunityFromFlow'),
            totalPremium: '',
            product: 'STI',
            lineItems: JSON.stringify(newlst),
            partyType: 'STI',
            oppData : component.get("v.opportunityDetails"),//added newly
            quoteStatus :quoteStatus
            
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === 'SUCCESS') {
                component.set("v.showSpinner",false);
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                title: 'Success!',
                message: 'Quote Successfully Created',
                type: 'success'
                });
                toastEvent.fire();
            //added
            //
            var editQuote=component.get("v.showQuoteEdit");
                if(editQuote ==true){
                    //showQuoteEditEvent
                    component.set("v.updateQuoteScreenClose",false);// this for summary page edit currently not build the connection
                    
                }else{
                    var actionClicked = event.getSource().getLocalId();
                    console.log('actionClicked',actionClicked);
                    if(actionClicked != undefined && actionClicked != ''){
                    	// Call that action
                    	var navigate = component.getEvent("navigateFlowEvent");
                    	navigate.setParam("action", actionClicked);
                    	navigate.setParam("outcome", quoteStatus);
                    	navigate.fire();
                    }
                }
            } else {
                // show error notification
                console.log('error '+ a.getError());
                console.log('error '+ JSON.stringify(a.getError()));
                component.set("v.showSpinner",false);
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Error creating new quote. Please try again!',
                    type: 'error',
                    mode: 'sticky'
                });
                toastEvent.fire();
            }
        $A.get('e.force:refreshView').fire();
    });
    $A.enqueueAction(action);
    },
    
    getOpportunityDetails :function(component,event) {
       component.set("v.showSpinner",true);
        var oppId = component.get("v.OpportunityFromFlow");
        var action = component.get("c.fetchOpportunityRecord");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a){
		var state = a.getState();
            if (state === "SUCCESS") {
                var resp =a.getReturnValue();
                console.log('resp[0]',resp[0]);
                component.set("v.opportunityDetails", resp[0]);
                if(resp[0].PRI_Number__c != undefined && resp[0].PRI_Number__c != '' && resp[0].PRI_Number__c != 'Invalid')
                    component.set("v.isButtonDisabled",true);
            }
            else{
                component.set("v.showSpinner",false);
            }            
        });
         $A.enqueueAction(action);
    },

    getOpportunitypartyDetails: function (component, event) {
        var oppdetails = component.get("v.opportunityDetails");
        var quotestatus;
        component.set("v.showSpinner", true);
        var oppId = component.get("v.OpportunityFromFlow");
        console.log('oppId', oppId);
        var action = component.get("c.getPartyData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            console.log('state ' + state)
            if (state === "SUCCESS") {
                var oppPartyData = res.getReturnValue();
                component.set("v.OppPrtyDetailsExisting", oppPartyData);

                var action2 = component.get("c.getQuoteLineItemsDataByProduct");
                action2.setParams({
                    "oppId": oppId,
                    "productName": 'STI'
                });
                action2.setCallback(this, function (res) {
                    var state1 = res.getState();
                    if (state1 === 'SUCCESS') {
                        var quoteData = res.getReturnValue();
                        

                        if (quoteData != null && quoteData.length > 0) {
                            oppdetails.Quote_Outcome__c = quoteData[0].Quote.Quote_Outcome__c;//addedd by pranv 19022021
                            oppdetails.Quote_Outcome_Reason__c = quoteData[0].Quote.Quote_Outcome_Reason__c;//addedd by pranv 19022021
                            quotestatus = quoteData[0].Quote.Status;
                        	component.set("v.quoteStatus",quotestatus);
							component.set("v.opportunityDetails" ,oppdetails);
                            component.set("v.isQuoteDone", true);
                            component.set("v.showSpinner", false);
                        } else {
                            component.set("v.isQuoteDone", false);
                            component.set("v.showSpinner", false);
                        }
                    }
                    else {

                        component.set("v.showSpinner", false);
                    }

                });
                $A.enqueueAction(action2);
            }
            else {
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
})