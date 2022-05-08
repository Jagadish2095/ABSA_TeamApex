({
    helperMethod: function () {
    },

    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    //Lightning toastie
    getToast: function (title, msg, type) {

        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type": type
        });

        return toastEvent;
    },

    getOpportunityDetails: function (component, event) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.OpportunityFromFlow");
        var action = component.get("c.fetchOpportunityRecord");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (a) {
            var state = a.getState();

            if (state === "SUCCESS") {
                var resp = a.getReturnValue();
                console.log('resp',resp);
                if (resp[0].Person_Account_Age__c < 18)
                    component.set("v.showInvalidScreen", true);
                if (resp[0].DD_PhotoFinishSelected__c == 'Yes') {//resp[0].DD_PhotoFinishSelected__c &&
                    if (resp[0].Absa_Staff_Member__c == false) {
                        component.set("v.PhotoFinishPremium", resp[0].Photo_Finish_Premium__c);
                    } else {
                        component.set("v.StaffPhotoFinishPremium", resp[0].Photo_Finish_Premium__c);
                    }
                    component.set("v.showPhotoFields", true);
                }
                component.set("v.opportunityDetailsDummy", resp);
                component.set("v.opportunityDetails", resp[0]);
                this.getOpportunitypartyDetails(component, event);
                if (resp[0].Outstanding_Capital__c != undefined && resp[0].Outstanding_Capital__c != null)
                    this.getPlanPremiumMatrices(component, resp[0].Outstanding_Capital__c, 'Extended Cover', resp[0]);
                //component.set("v.showSpinner",false);                
            }
        });
        $A.enqueueAction(action);
    },

    getPlanPremiumMatrices: function (component, marketValue, recordType, oppDetails) {

        component.set('v.showSpinner', true);
        var oppId = component.get("v.OpportunityFromFlow");
        console.log('oppDetails', oppDetails);
        var range;
        var lowestRange;
        var highestRange;
        if (marketValue < 100000)
            range = 5000;
        else
            range = 10000;
        if (marketValue < 10000) {
            lowestRange = 0;
            highestRange = 10000;
        }
        else if(marketValue % range == 0) {   
            	if(marketValue < 100000)
                    lowestRange = Number(marketValue - 5000) + 1;
            	else
                   lowestRange = Number(marketValue - 10000) + 1; 
            	   highestRange = Number(marketValue - (marketValue % range));
        }
        else{
              lowestRange = Number(marketValue - (marketValue % range)) + 1;
           	  highestRange = Number((marketValue + range) - (marketValue % range));
              highestRange = highestRange.toFixed(0);
        }
        console.log('lowestRange', lowestRange);
        console.log('highestRange', highestRange);
        var action = component.get('c.getPricingMatrix');
        action.setParams({
            oppId: oppId,
            lowestRange: lowestRange,
            highestRange: highestRange,
            recordType: recordType
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === 'SUCCESS') {
                var pricingMatrix = a.getReturnValue();
                console.log('pricingMatrix', pricingMatrix);
                for (var k in pricingMatrix) {
                    if (recordType == 'Extended Cover') {
                        if (k == 'Without_Additional_Cover_Premium__c')
                            component.set('v.WithoutAdditionalCoverPremium', pricingMatrix.Without_Additional_Cover_Premium__c);
                        if (k == 'Without_Additional_Cover_Commission__c')
                            component.set('v.WithoutAdditionalCoverCommission', pricingMatrix.Without_Additional_Cover_Commission__c);
                        if (k == 'With_Additional_Cover_Premium__c')
                            component.set('v.WithAdditionalCoverPremium', pricingMatrix.With_Additional_Cover_Premium__c);
                        if (k == 'With_Additional_Cover_Commission__c')
                            component.set('v.WithAdditionalCoverCommission', pricingMatrix.With_Additional_Cover_Commission__c);
                        if (k == 'Staff_Without_Additional_Cover__c')
                            component.set('v.StaffWithoutAdditionalCoverPremium', pricingMatrix.Staff_Without_Additional_Cover__c);
                        if (k == 'Staff_With_Additional_Cover__c')
                            component.set('v.StaffWithAdditionalCoverPremium', pricingMatrix.Staff_With_Additional_Cover__c);
                        if (k == 'Staff_Photo_Finish_Premium__c')
                            component.set('v.StaffPhotoFinishPremium', pricingMatrix.Staff_Photo_Finish_Premium__c);
                        if (k == 'Photo_Finish_Premium__c')
                            component.set('v.PhotoFinishPremium', pricingMatrix.Photo_Finish_Premium__c);
                    }
                }
            }
            if (oppDetails.Absa_Staff_Member__c == true) {
                component.set('v.WithoutAdditionalCoverCommission', 0.0);
                component.set('v.WithAdditionalCoverCommission', 0.0);

            }
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    },

    saveOppPartyData: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var opportunityNewData = component.get("v.opportunityDetails");
        var OppPrtyDetailsExisting = component.get("v.OppPrtyDetailsExisting");//using for updating the saame party if exists for the second time

        var comision;
        var premium;
        // Added by Poulami to update quote status
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        var quoteOutcomeReason = component.find('Quote_Outcome_Reason__c').get("v.value");
        var quoteStatus;
        if (quoteOutcome == 'Client Interested')
            quoteStatus = 'Accepted';
        else if (quoteOutcome == 'Client Not Interested')
            quoteStatus = 'Rejected';
        else if (quoteOutcome == 'Client Not Insurable' || quoteOutcome == 'Duplicate Quote')
            quoteStatus = 'Denied';
        else
            quoteStatus = 'Draft';
        component.set('v.quoteStatus', quoteStatus);
        if (opportunityNewData.DD_Additional_Cover_Selected__c == 'Yes') {
            if (opportunityNewData.Absa_Staff_Member__c == false) {
                opportunityNewData.Commission__c = component.get("v.WithAdditionalCoverCommission");
                opportunityNewData.DD_Premium__c = component.get("v.WithAdditionalCoverPremium");
                comision = component.get("v.WithAdditionalCoverCommission");
                premium = component.get("v.WithAdditionalCoverPremium");
            } else {
                opportunityNewData.Commission__c = component.get("v.WithAdditionalCoverCommission");
                opportunityNewData.DD_Premium__c = component.get("v.StaffWithAdditionalCoverPremium");
                comision = component.get("v.WithAdditionalCoverCommission");
                premium = component.get("v.StaffWithAdditionalCoverPremium");
            }
        } else if (opportunityNewData.DD_Additional_Cover_Selected__c == 'No') {
            if (opportunityNewData.Absa_Staff_Member__c == false) {
                opportunityNewData.Commission__c = component.get("v.WithoutAdditionalCoverCommission");
                opportunityNewData.DD_Premium__c = component.get("v.WithoutAdditionalCoverPremium");
                comision = component.get("v.WithoutAdditionalCoverCommission");
                premium = component.get("v.WithoutAdditionalCoverPremium");
            } else {
                opportunityNewData.Commission__c = component.get("v.WithoutAdditionalCoverCommission");
                opportunityNewData.DD_Premium__c = component.get("v.StaffWithoutAdditionalCoverPremium");
                comision = component.get("v.WithoutAdditionalCoverCommission");
                premium = component.get("v.StaffWithoutAdditionalCoverPremium");
            }
        }
        if (opportunityNewData.DD_PhotoFinishSelected__c == 'Yes') {
            if (opportunityNewData.Absa_Staff_Member__c == false) {
                opportunityNewData.Photo_Finish_Premium__c = component.get("v.PhotoFinishPremium");
            } else {
                opportunityNewData.Photo_Finish_Premium__c = component.get("v.StaffPhotoFinishPremium");
            }
        }
        //creating main member for extended cover
        var mainMemCreation = {};
        var partyList = [];
        mainMemCreation.Name = opportunityNewData.Person_Account_Last_Name__c;
        mainMemCreation.DD_Cross_Sell_Product_Member_Type__c = 'Extended Cover';
        mainMemCreation.First_Name__c = opportunityNewData.Person_Account_Last_Name__c;
        mainMemCreation.Premium = premium;
        mainMemCreation.Opportunity__c = component.get("v.OpportunityFromFlow");
        if (OppPrtyDetailsExisting.length > 0) {
            for (var j = 0; j < OppPrtyDetailsExisting.length; j++) {
                mainMemCreation.Id = OppPrtyDetailsExisting[j].Id;
            }
        }
        partyList.push(mainMemCreation);// fromation of opportunity party creation end

        var newlst = [];
        var partylst = [];
        for (var j = 0; j < partyList.length; j++) {
            if (partyList[j].hasOwnProperty('Premium')) {
                partylst.push({
                    Name: partyList[j].Name,
                    // lastName: partyList[j].Last_Name__c,
                    premium: partyList[j].Premium,
                    sumInsured: component.get("v.opportunityDetails").Outstanding_Capital__c
                });
                delete partyList[j].Premium;
            }

        }//for loop ends
        if (partyList.length > 0) {
            var action = component.get("c.insertOppPartyData");
            action.setParams({
                "oppPartyList": partyList
            });
            action.setCallback(this, function (a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    var oppParties = a.getReturnValue();
                    var action2 = component.get('c.createDDQuote');
                    for (var i = 0; i < oppParties.length; i++) {
                        for (var j = 0; j < partylst.length; j++) {
                            if ((oppParties[i].Name == partylst[j].Name))
                                newlst.push({
                                    Name: 'Extended Cover',
                                    premium: partylst[j].premium,
                                    SumInsured: partylst[j].sumInsured,
                                    OppPartyId: oppParties[i].Id
                                });
                        }
                    }//outer For ends
                    console.log('opportunityNewDatasavee###', opportunityNewData);
                    action2.setParams({
                        oppId: component.get('v.OpportunityFromFlow'),
                        totalPremium: '',
                        product: 'Extended Cover',
                        lineItems: JSON.stringify(newlst),
                        partyType: 'Extended Cover',
                        oppData: opportunityNewData,
                        quoteStatus: quoteStatus
                    });

                    action2.setCallback(this, function (a) {
                        var state = a.getState();
                        if (state === 'SUCCESS') {
                            // show success notification
                            component.set("v.showSpinner", false);
                            var toastEvent = $A.get('e.force:showToast');
                            toastEvent.setParams({
                                title: 'Success!',
                                message: 'Quote Successfully Created',
                                type: 'success'
                            });
                            toastEvent.fire();
                            var editQuote = component.get("v.showQuoteEdit");
                            if (editQuote == true) {
                                //showQuoteEditEvent
                                component.set("v.updateQuoteScreenClose", false);

                            } else {
                                //added
                                var actionClicked = event.getSource().getLocalId();
                                // Call that action
                                var navigate = component.getEvent("navigateFlowEvent");
                                navigate.setParam("action", actionClicked);
                                navigate.setParam("outcome", component.get("v.quoteStatus"));
                                navigate.fire();
                            }
                        }
                        else {
                            // show error notification
                            component.set("v.showSpinner", false);
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
                    $A.enqueueAction(action2);
                }//frst success ends
                else {
                    component.set("v.showSpinner", false);
                    console.log('Error ' + JSON.stringify(a.getError()));
                }
            });
            $A.enqueueAction(action);
        }

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
                    "productName": 'Extended Cover'
                });
                action2.setCallback(this, function (res) {
                    var state1 = res.getState();
                    if (state1 === 'SUCCESS') {
                        var quoteData = res.getReturnValue();
                        

                        if (quoteData != null && quoteData.length > 0) {
                            oppdetails.Quote_Outcome__c = quoteData[0].Quote.Quote_Outcome__c;//addedd by pranv 19022021
                            oppdetails.Quote_Outcome_Reason__c = quoteData[0].Quote.Quote_Outcome_Reason__c;//addedd by pranv 19022021
                            quotestatus = quoteData[0].Quote.Status;//addedd by pranv 19022021
                        component.set("v.quoteStatus",quotestatus);//aded by prnav 19022021
							 component.set("v.opportunityDetails" ,oppdetails);//aded by prnav 19022021
                            component.set("v.isQuoteDone", true);
                            component.set("v.showEditButton", true);
                            component.set("v.readOnlyFields", true);
                            component.set("v.showSpinner", false);
                        } else {
                            component.set("v.isQuoteDone", false);
                            component.set("v.showSpinner", false);
                            component.set("v.readOnlyFields", false);
                            component.set("v.showEditButton", false);
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