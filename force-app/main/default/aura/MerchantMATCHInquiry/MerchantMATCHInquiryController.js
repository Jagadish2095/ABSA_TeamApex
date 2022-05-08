({
    //TdB - Fetch existing Merchant Match Check Records
    doInit : function(component, event, helper) {

        //Fetch existing Merchant Records
        var action = component.get("c.getMerchantRiskCheckRecords");

        action.setParams({
            "oppId" : component.get('v.recordId')
        });

        action.setCallback(this,function(res){
            var state = res.getState();

            if(state == "SUCCESS"){

                var matchRiskData = res.getReturnValue();

                component.set("v.existingMatchData", matchRiskData);
                var dataTable = [];

                component.set('v.matchFields', [
                    {label: 'Date', fieldName: 'AddedOnDate', type: 'text', wrapText: true},
                    {label: 'Business Name', fieldName: 'BusinessName', type: 'Text', wrapText: true},
                    {label: 'City', fieldName: 'City', type: 'text', wrapText: true},
                    {label: 'Country', fieldName: 'Country', type: 'text', wrapText: true},
                    {label: 'Match Result', fieldName: 'ResultType', type: 'text', wrapText: true},
                    {label: 'Termination Reason Code', fieldName: 'TerminationReasonCode', type: 'text', wrapText: true},
                    {label: 'Response Code', fieldName: 'ResponseCode', type: 'text', wrapText: true}]);

                //Merchant Match
                for (var item in matchRiskData){

                    var addedOnDateVal = "N/A";
                    var terminationReasonCodeVal = "N/A";

                    //Display N/A for nul values
                    if(matchRiskData[item].Date_Added_On__c != null) {
                        addedOnDateVal = matchRiskData[item].Date_Added_On__c;
                    }

                    //Display N/A for nul values
                    if(matchRiskData[item].Termination_Reason_Code__c != null) {
                        terminationReasonCodeVal = matchRiskData[item].Termination_Reason_Code__c;
                    }

                    var matchResultValues = {
                        AddedOnDate : addedOnDateVal,
                        BusinessName : matchRiskData[item].Business_Name__c,
                        City : matchRiskData[item].City__c,
                        Country : matchRiskData[item].Country__c,
                        ResultType : matchRiskData[item].Match_Type__c,
                        TerminationReasonCode : terminationReasonCodeVal,
                        ResponseCode : matchRiskData[item].Response_Code__c,
                        Operator : matchRiskData[item].CreatedBy.Name,
                        CreatedDate : matchRiskData[item].CreatedDate};

                    dataTable.push(matchResultValues);
                    component.set('v.matchResponseBeanString', JSON.stringify(matchRiskData[item].JSON_Response__c));
                    component.set('v.matchRequestBeanString', JSON.stringify(matchRiskData[item].JSON_Request__c));
                }

                component.set("v.matchData",dataTable);

                if(!component.get("v.opportunityRecord.Merchant_Match_Inquiry_Passed__c") && component.get("v.opportunityRecord.Approval_Status__c") == null){
                    //Hide results
                    component.set('v.showMatchRiskTable',false);
                }else{
                    //Show results
                    component.set('v.showMatchRiskTable',true);
                }

            } else if (state == "ERROR"){
                var errors = res.getError();
                //Show error
                helper.fireToast('Match Risk Error', 'Error occurred while trying to retrieve Merchant Risk Checks ', 'Error');
                component.set("v.errorMessage", "Match Risk Error: [" + JSON.stringify(errors) + "]. ");
                console.log("Match Risk Error: [" + JSON.stringify(errors) + "]. ");
            }else{
                helper.fireToast('Match Risk Error', 'Error occurred while trying to retrieve Merchant Risk Checks ', 'Error');
                console.log("Match Risk Error: Error occurred while trying to retrieve Merchant Risk Checks ");
                component.set("v.errorMessage", "Match Risk Error: Error occurred while trying to retrieve Merchant Risk Checks ");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    showButtonMATCH : function(component, event, helper){
        var mtchBtn= component.find("MATCHbtn");
        if(event.getSource().get("v.checked")){
            $A.util.removeClass(mtchBtn, 'slds-hide');
        }else{
            $A.util.addClass(mtchBtn, 'slds-hide');
        }
    },

    newPopup : function(component, event, helper){
        var cmpTarget = component.find('termsAndConsModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },

    closeNewModal : function(component, event, helper){
        var cmpTarget = component.find('termsAndConsModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

    callMatchRiskService : function(component, event, helper){
        helper.callMerchantMatchService(component, event, helper);
    },

    closeMatchResponseJsonModal : function(component, event, helper){
        var cmpTarget = component.find('matchResponseJSONModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

    openMatchResponseJsonModal : function(component, event, helper){
        helper.getInquiryData(component, event, helper);
        helper.formatMatchReport(component, event, helper);
        var cmpTarget = component.find('matchResponseJSONModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },
})