({
    callExperianCheckService : function(component, event, helper) {
        console.log('Calling Experian');
        this.showSpinner(component);
        var action = component.get("c.callExperianConsumerCheckService");
        action.setParams({oppId:component.get("v.recordId") });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state==="SUCCESS"){
                //hiding the Spinner
                this.hideSpinner(component);
                var responseValue = res.getReturnValue();

                if(responseValue['error']){
                    //Apex error
                    this.fireToast('Error', 'An Apex error occurred, Please contact your System Administrator', 'error');
                    component.find("oppExperianPassedInput").set("v.value", false);
                }else if(responseValue['noContact']){
                    //No Contact
                    this.fireToast('Error', 'Unable to find the associated Contact(s) for this Opportunity\'s Account.', 'error');
                    component.find("oppExperianPassedInput").set("v.value", false);
                }else{
                    if(Array.isArray(responseValue['CreditRiskCheckList']) && responseValue['CreditRiskCheckList'].length > 0){
                        this.fireToast('Success', 'Experian Inquiry check complete', 'success');
                        component.find("oppExperianPassedInput").set("v.value", true);
                        //Hide button and Show Table
                        var experianButton = component.find("experianBtn");
                        $A.util.addClass(experianButton, 'slds-hide');
                        var experianChkbox = component.find("experianCheckboxLayoutItem");
                        $A.util.addClass(experianChkbox, 'slds-hide');
                        var cmpTarget = component.find('resultsDiv');
                        $A.util.removeClass(cmpTarget, "slds-hide");

                        component.set('v.experianData',responseValue['CreditRiskCheckList']);
                        component.set('v.creditRiskCheckEntryData',responseValue['CreditRiskCheckEntryList']);

                        component.set('v.experianFields', [
                            {label: 'DirectorName', fieldName: 'Name', type: 'text',wrapText: true},
                            {label: 'Judgements', fieldName: 'Judgements__c', type: 'Text',wrapText: true},
                            {label: 'Notices', fieldName: 'Notices__c', type: 'text',wrapText: true},
                            {label: 'Defaults', fieldName: 'Defaults__c', type: 'text',wrapText: true},
                            {label: 'ABSA Enq', fieldName: 'ABSA_Enquiries__c', type: 'text',wrapText: true},
                            {label: 'Other Enq', fieldName: 'Other_Enquiries__c', type: 'text',wrapText: true},
                            {label: 'BankAdv', fieldName: 'Bank_Adv__c', type: 'text',wrapText: true}]);

                        //Start Changes made by Himani for #W-005292
                        if(responseValue['sendforApproval']){
                            component.find("oppTrigApprovalProcessInput").set("v.value", "Experian Risk Check");
                        }
                        //End Changes made by Himani for #W-005292
                    }else{
                        this.fireToast('Error', 'Experian Inquiry check was unsuccessful. Please contact your administrator.', 'error');
                        component.find("oppExperianPassedInput").set("v.value", false);
                    }

                }
                component.find('opportunityEditForm').submit();
                component.find('opportunityForm').reloadRecord();
                $A.get('e.force:refreshView').fire(); //to refresh the cmp
            }
            else if(state==="ERROR"){
                var errors = res.getError();
                this.handleErrors(errors);
                console.log('within Error')
            }

        });
        $A.enqueueAction(action);
    },

    loadExistingExperianChecks :function(component, event, helper){
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.loadExistingExperianCheckRecordsMap");
        action.setParams({
            oppId : opportunityId
        });

        action.setCallback(this,function(res){
            var state = res.getState();
            var responseValue =  res.getReturnValue();
            var creditRiskCheckList = responseValue['CreditRiskCheckList'];
            var creditRiskCheckEntryList = responseValue['CreditRiskCheckEntryList'];

            if(state==="SUCCESS" && creditRiskCheckList.length > 0 ){
                //hiding the buttons
                var experianButton = component.find("experianBtn");
                $A.util.addClass(experianButton, 'slds-hide');
                var experianChkbox = component.find("experianCheckboxLayoutItem");
                $A.util.addClass(experianChkbox, 'slds-hide');
                var cmpTarget = component.find('resultsDiv');
                $A.util.removeClass(cmpTarget, "slds-hide");

                component.set('v.experianData',creditRiskCheckList);
                component.set('v.creditRiskCheckEntryData',creditRiskCheckEntryList);
                component.set('v.experianFields', [
                    {label: 'DirectorName', fieldName: 'Name', type: 'text',wrapText: true},
                    {label: 'Judgements', fieldName: 'Judgements__c', type: 'Text',wrapText: true},
                    {label: 'Notices', fieldName: 'Notices__c', type: 'text',wrapText: true},
                    {label: 'Defaults', fieldName: 'Defaults__c', type: 'text',wrapText: true},
                    {label: 'ABSA Enq', fieldName: 'ABSA_Enquiries__c', type: 'text',wrapText: true},
                    {label: 'Other Enq', fieldName: 'Other_Enquiries__c', type: 'text',wrapText: true},
                    {label: 'BankAdv', fieldName: 'Bank_Adv__c', type: 'text',wrapText: true}]);

            }
            else if(state==="ERROR"){
                var errors = res.getError();
                this.handleErrors(errors);
                console.log('within Error')
            }});
        $A.enqueueAction(action);
    },

    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("ltngSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("ltngSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    //function to handle Exceptions and Errors
    handleErrors : function(errors) {
        // Configure error toast
        let toastParams = {
            title: "Error",
            message: "Unknown error while Calling the Experian Service", // Default error message
            type: "error"
        };
        // Pass the error message if any
        if (errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        // Fire error toast
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
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