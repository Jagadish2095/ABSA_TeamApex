({
    //Method that Calls the TransUniuon Service and created Credit_Risk_Check__c and Credit_Risk_Check_Entry__c objects and launches an approval process if needed
    callTransUnionCheckService : function(component, event, helper) {
        console.log('Calling TransUnion');
        this.showSpinner(component);
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.callTransUnionConsumerCheckService");
        action.setParams({
            oppId : opportunityId
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state==="SUCCESS"){
                //hiding the Spinner
                this.hideSpinner(component); //hide the spinner
                var responseValue = res.getReturnValue();

                if(responseValue['error']){
                    //Apex error
                    this.fireToast('Error', 'An Apex error occurred, Please contact your System Administrator', 'error');
                    component.find("oppTransunionPassedInput").set("v.value", false);
                }else if(responseValue['noContact']){
                    //No Contact
                    this.fireToast('Error', 'Unable to find the associated Contact(s) for this Opportunity\'s Account.', 'error');
                    component.find("oppTransunionPassedInput").set("v.value", false);
                }else{
                    if(Array.isArray(responseValue['CreditRiskCheckList']) && responseValue['CreditRiskCheckList'].length > 0){
                        //Success
                        this.fireToast('Success', 'Transunion Inquiry check complete', 'success');
                        component.find("oppTransunionPassedInput").set("v.value", true);
                        //Hide Button and show Table
                        var transUBtn = component.find("transUnionBtn");
                        $A.util.addClass(transUBtn, 'slds-hide');
                        var transUcheckbox = component.find("transUnionCheckboxLayout");
                        $A.util.addClass(transUcheckbox, 'slds-hide');
                        var tablediv = component.find('container');
                        $A.util.removeClass(tablediv, "slds-hide");

                        //Set Response Values
                        component.set('v.creditRiskCheckData', responseValue['CreditRiskCheckList']);
                        component.set('v.creditRiskCheckEntryData', responseValue['CreditRiskCheckEntryList']);

                        component.set('v.creditRiskCheckFields', [
                            {label: 'DirectorName', fieldName: 'Name', type: 'text',wrapText: true},
                            {label: 'Judgements', fieldName: 'Judgements__c', type: 'Text',wrapText: true},
                            {label: 'Notices', fieldName: 'Notices__c', type: 'text', wrapText: true},
                            {label: 'Total Enq', fieldName: 'ABSA_Enquiries__c', type: 'text', wrapText: true},
                            {label: 'Total Adv', fieldName: 'Bank_Adv__c', type: 'text', wrapText: true}]);

                        //Start Changes made by Himani for #W-005293
                        if(responseValue['sendforApproval']){
                            //Update Values
                            component.find("oppTrigApprovalProcessInput").set("v.value", "TransUnion Risk Check");
                        }
                    }else{
                        //No Records were returned
                        this.fireToast('Error', 'Transunion Inquiry check was unsuccessful. Please contact your administrator.', 'error');
                        component.find("oppTransunionPassedInput").set("v.value", false);
                    }

                }
                component.find('opportunityEditForm').submit();
                //End Changes made by Himani for #W-005293

                //Reload form and cmp
                component.find('opportunityForm').reloadRecord();
                $A.get('e.force:refreshView').fire(); //to refresh the cmp

            }else if(state==="ERROR"){
                this.hideSpinner(component); //hide the spinner
                var errors = res.getError();
                this.handleErrors(errors);
            }
        });
        $A.enqueueAction(action);
    },

    //init method to load the existing Credit_Risk_Check__c and Credit_Risk_Check_Entry__c objects
    loadExistingTransUnionChecks :function(component, event, helper){
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.loadExistingTransUnionCheckRecordMap");
        action.setParams({
            oppId : opportunityId
        });

        action.setCallback(this,function(res){
            var state = res.getState();
            var responseValue =  res.getReturnValue();

            if(state==="SUCCESS" && responseValue['CreditRiskCheckList'].length > 0 ){
                //hiding the button and checkbox
                var transUBtn = component.find("transUnionBtn");
                $A.util.addClass(transUBtn, 'slds-hide');
                var transUcheckbox = component.find("transUnionCheckboxLayout");
                $A.util.addClass(transUcheckbox, 'slds-hide');
                var tablediv = component.find('container');
                $A.util.removeClass(tablediv, "slds-hide");
                //Set Response Values
                component.set('v.creditRiskCheckData', responseValue['CreditRiskCheckList']);
                component.set('v.creditRiskCheckEntryData', responseValue['CreditRiskCheckEntryList']);
                component.set('v.creditRiskCheckFields', [
                    {label: 'DirectorName', fieldName: 'Name', type: 'text',wrapText: true},
                    {label: 'Judgements', fieldName: 'Judgements__c', type: 'Text',wrapText: true},
                    {label: 'Notices', fieldName: 'Notices__c', type: 'text', wrapText: true},
                    {label: 'Total Enq', fieldName: 'ABSA_Enquiries__c', type: 'text', wrapText: true},
                    {label: 'Total Adv', fieldName: 'Bank_Adv__c', type: 'text', wrapText: true}]);

            }else if(state==="ERROR"){
                var errors = res.getError();
                this.handleErrors(errors);
                console.log('Error: ' + errors);
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
        var message = "Unknown error while Calling the TransUnion Service"; // Default error message
        // Pass the error message if any
        if (errors && Array.isArray(errors) && errors.length > 0) {
            message = errors[0].message;
            console.log('Error: ' + message);
        }
        // Fire error toast
        this.fireToast('Error', message, 'error');
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