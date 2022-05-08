({
    doInit : function(component, event, helper) {
        // eSign the doc //Story W-004373 - Tinashe Shoko - START
        
        var actions2 = [
            { label: 'Update Signatory Details', iconName: 'utility:edit', name: 'update_details' }
        ];
        component.set('v.columns2', [
            { label: 'Document Name', fieldName: 'Document_Name', type: 'text' },
            { label: 'Document Type', fieldName: 'Document_Type', type: 'text' },
            { label: 'Title', fieldName: 'Title', type: 'text' },
            { label: 'Last Name', fieldName: 'Last_Name', type: 'text' },
            { label: 'Mobile', fieldName: 'Mobile_Phone', type: 'text' },
            { label: 'Email', fieldName: 'Email', type: 'text' },
            { label: 'Order', fieldName: 'Order', type: 'number' },
            { label: 'Method', fieldName: 'Method', type: 'text' },
            { label: 'Role', fieldName: 'Role', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions2 } }
        ]);

        component.set('v.impressionRequestColumns', [
            { label: 'Request No.', fieldName: 'linkName', type: 'url', typeAttributes: { label: { fieldName: 'Name' }} },
            { label: 'Document Name', fieldName: 'Document_Name__c', type: 'text' },
            { label: 'User', fieldName: 'Created_By_Name__c', type: 'text' },
            { label: 'Status', fieldName: 'Status__c', type: 'text' },
            { label: 'Date Submitted', fieldName: 'CreatedDate', type: 'date', typeAttributes: {day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true} }
        ]);
        // eSign the doc //Story W-004373 - Tinashe Shoko - END
        helper.getObjectDataJS(component);
       },

    // PJAIN: 20200509
    // Below method is called when the Generate Application button is clicked.
    // cmpFormStatus for each component is reset to unknown and it submits the
    // parent form and fires the saveFormMethod for each child component.
    // Each component sets the cmpFormStatus to either valid or invalid.
    // If cmpFormStatus is not set by all components within the timeout duration,
    // then the saving is abandoned and an error message is shown to the user.
    handleGenerateMerchantApplicationBtn: function(component, event, helper) {

        // Do not proceed if Parent Form is not valid
        if (!helper.validateParentForm(component)) {
            helper.fireToast('Error!', 'PCI DSS & Consent checkboxes should be checked before generating the Merchant Application', 'error');
            return;
        }

        helper.showSpinner(component);
        // Set cmpFormStatus to 'unknown' so that the component can update
        // it to 'valid' or 'invalid'
        component.set('v.cmpFormStatus_Parent', 'unknown');
        component.set('v.toastMessage', null);
        component.find('merchantPCIDSSForm').submit();

        var componentLabels = component.get('v.componentLabels');

        for (var key in componentLabels) {
            // Set cmpFormStatus to 'unknown' so that the child component can update
            // it to 'valid' or 'invalid'
            component.set('v.cmpFormStatus_' + key, 'unknown');

            // Fire the saveFormMethod for each child component
            var childComponent = component.find(key);
            childComponent.saveFormMethod();
        }

        // Cancel the already running wait cycle
        if (component.get('v.waitCycleId')) {
            clearTimeout(component.get('v.waitCycleId'));
        }

        // Timeout duration for waiting for saving all child components
        var timeoutDuration = 15000; // 15 seconds

        var timeoutId = setTimeout($A.getCallback(function() {

            // If still in wait cycle after timeout duration, then stop the wait cycle and
            // show error to the user. This is a safety net to prevent waiting endlessly.
            if (component.get('v.waitCycleId')) {
                helper.hideSpinner(component);
                // Stop the wait cycle
                component.set('v.waitCycleId', null);
                helper.fireToast('Error!', 'Timeout occurred while saving Application. Either try again or please contact the administrator.', 'error');
                return;
            }
        }), timeoutDuration);

        // Start the wait cycle
        component.set('v.waitCycleId', timeoutId);
    },

    // PJAIN: 20200509
    // Below method ensures that application generation waits for the saveFormMethod operation
    // to be  processed by all components. This method is needed because the save operation
    // runs asynchronously. This method is called when cmpFormStatus is updated for any component.
    // Processing happens only when in wait cycle AND all components have set the cmpFormStatus
    // attribute to either valid or invalid. Once the conditions are met, either the application
    // is generated or message with invalid component names is shown.
    handleCmpFormStatusChange : function(component, event, helper) {

        // If not in wait cycle, then exit the function and stop processing
        if (!component.get('v.waitCycleId')) {
            return;
        }

        var cmpFormStatus_Parent = component.get('v.cmpFormStatus_Parent');
        var invalidSections = '';
        var bulletString = '•	';

        if (cmpFormStatus_Parent === 'unknown') {
            // If the parent form has not been saved yet, then exit the function and stop processing
            return;
        } else if (cmpFormStatus_Parent === 'invalid') {
            invalidSections += bulletString + 'PCI DSS & Consent' + '\n';
        }

        var componentLabels = component.get('v.componentLabels');

        for (var key in componentLabels) {
            var cmpFormStatus_Child = component.get('v.cmpFormStatus_' + key);

            if (cmpFormStatus_Child === 'unknown') {
                // If the child form has not been saved yet, then exit the function and stop processing
                return;
            } else if (cmpFormStatus_Child === 'invalid') {
                invalidSections += bulletString + componentLabels[key] + '\n';
            }
        }

        // If the control comes here that means that all components have completed the
        // save operation. So the processing can continue. Stop the running wait cycle
        // and reset waitCycleId attribute, so that the method is not executed when any
        // component is saved.
        clearTimeout(component.get('v.waitCycleId'));
        component.set('v.waitCycleId', null);

        if($A.util.isEmpty(invalidSections)) {
            // Check for rejected approvals if all is fine.
            helper.checkRejectedApprovals(component);//Himani:W-005547
        } else {
            //ERROR
            helper.hideSpinner(component);
            var message = 'Please complete the following sections before trying to Generate the Application: ' + '\n' + invalidSections;
            helper.fireStickyToast('Error', message, 'error');
        }
    },

    handleLoad : function(component, event, helper){
        var applicationStatusField = component.find("applicationStatusField").get("v.value");
        component.set('v.applicationStatus', applicationStatusField);

        var qaStatusField = component.find("qaStatusField").get("v.value");
        component.set('v.qaStatus', qaStatusField);

        if(applicationStatusField !== 'Pending'){
            helper.setNoActions(component);
        }else{
            helper.setAllActions(component);
        }

        var applicationGenerationDate = component.find("applicationGenerationDateField").get("v.value");

        if(!$A.util.isEmpty(applicationGenerationDate)){
            component.set("v.isFormReadOnly", true);
            helper.mapFieldsToDatatable(component);
        }
    },

    handleSuccess : function(component, event, helper){
        component.set('v.cmpFormStatus_Parent', 'valid');

        var toastMessage = component.get('v.toastMessage');
        if (!$A.util.isEmpty(toastMessage)) {
            helper.fireToast('Success!', toastMessage, 'success');
        }
    },

    handleError : function(component, event, helper){
        component.set('v.cmpFormStatus_Parent', 'invalid');
        component.set("v.errorMessage", "Record error: " + JSON.stringify(event.getParams()));
        helper.fireToast('Error!', 'PCI DSS & Consent: There has been an error saving the data.', 'error');
    },

    handleOppError : function(component, event, helper){
        component.set("v.errorMessage", "Record error: " + JSON.stringify(event.getParams()));
        helper.fireToast('Error!', 'Error saving Opportunity.', 'error');
    },

    handleRowAction : function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'accept':
                helper.acceptApplication(component, event, helper);
                break;
            case 'reject':
                helper.openRejectApplicationModal(component);
                break;
            case 'revise':
                //The reviseApplication function is called within this function if success
                helper.outdateAppDocumentStatus(component, event, helper);//D Booysen: 2020/08/07 - W-005541
                break;
            case 'esign':
                // esign the doc //Story W-004373 - Tinashe Shoko
                helper.checkIfDocumentRestricted(component, event, helper, 'sign', '');
                break;
            case 'download':
                // esign the doc //Story W-004373 - Tinashe Shoko
                helper.getDocName(component);
                break;
            case 'email':
                // esign the doc //Story W-004373 - Tinashe Shoko
                helper.emailSharing(component);
            case 'doNothing':
                // DO NOTHING - NO FURTHER ACTION NEEDED
                break;
        }
    },

    handleSubmitForQABtn : function (component, event, helper) {
        // helper.submitForQA(component, event, helper);
        helper.checkMandatoryDocuments(component, event, helper);
    },

    //W-005082 JQUEV
    handleLossReasonDialogYes : function(component, event, helper) {

        var inputField = component.find("oppLossReason");
        var inputFieldValue = Array.isArray(inputField) ? inputField[0].get("v.value") : inputField.get("v.value");

        if(inputFieldValue){
            //Valid
            component.set('v.toastMessage', 'Application rejected successfully');
            component.set('v.applicationStatus', 'Declined');
            component.find("applicationStatusField").set("v.value", 'Declined');
            component.find("merchantPCIDSSForm").submit();

            //Updates Opportunity StageName to Close Lost and the Loss_Reason_Type__c to Customer declined Proposal
            component.find("opportunityForm").submit();
            helper.mapFieldsToDatatable(component);
            helper.closeRejectApplicationModal(component);
        }else{
            //Invalid
            var errorMsg = component.find('oppLossReasonErrorMsg');
            $A.util.removeClass(errorMsg,'slds-hide');
        }
    },

    //W-005082 JQUEV
    handleLossReasonDialogNo : function(component, event, helper) {
        //Resets the values that were set when the Modal was opened
        component.find("oppStageName").reset();
        component.find("oppLossReasonType").reset();
        component.find("oppLossReason").set("v.required", false);
        component.find("oppLossReason").reset();
        helper.closeRejectApplicationModal(component);
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationId = event.getParam("applicationId");
        var applicationProductMerchantId = event.getParam("applicationProductMerchantId");
        if (!$A.util.isEmpty(applicationId) && !$A.util.isEmpty(applicationProductMerchantId)) {
            component.set("v.applicationProductMerchantId", applicationProductMerchantId);
            component.set("v.applicationId", applicationId);
            component.set("v.errorMessage", "");

            if (component.get("v.applicationRecordTypeId") && component.get("v.opportunityRecordTypeId")) {
                console.log('MerchantApplicationParent.handleApplicationEvent.applicationId: ' + applicationId);
                console.log('MerchantApplicationParent.handleApplicationEvent.applicationProductMerchantId: ' + applicationProductMerchantId);
                console.log('MerchantApplicationParent.handleApplicationEvent.applicationRecordTypeId: ' + component.get("v.applicationRecordTypeId"));
                console.log('MerchantApplicationParent.handleApplicationEvent.opportunityRecordTypeId: ' + component.get("v.opportunityRecordTypeId"));
            } else {
                helper.getObjectDataJS(component);
            }
        } else {
            component.set("v.errorMessage", "The Quote must be accepted before filling out the Application form.");
        }
    },

    // PJAIN: 20200630
    opportunityRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var approvalStatus = component.get("v.opportunityRecord.Approval_Status__c");
            if (approvalStatus === "Pending") {
                component.set("v.isApprovalPending", true);
            } else {
                component.set("v.isApprovalPending", false);
            }
        } else if(eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            var changedFields = eventParams.changedFields
            if (changedFields) {
                var approvalStatusChanged = changedFields.Approval_Status__c;
                if (approvalStatusChanged) {
                    if (approvalStatusChanged.value === "Pending") {
                        component.set("v.isApprovalPending", true);
                    } else {
                        component.set("v.isApprovalPending", false);
                    }
                }
            }
        }
    },

    // PJAIN: 20200610
    applicationRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            var changedFields = eventParams.changedFields;
            var applicationGenerationDate = changedFields.Application_Generation_Date__c;
            if (applicationGenerationDate) {
                helper.resetFieldValue(component);
                $A.enqueueAction(component.get('c.handleLoad'));
            }
        }
    },

    // esign the doc //Story W-004373 - Tinashe Shoko
    handleRowActionSignatory: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'update_details':
                var row = event.getParam('row');
                if (row.Role == 'Client') {
                    component.set("v.signatoryId", row.Id);
                    helper.fetchAllClientEmailsSignature(component);
                    helper.getMobile(component);
                    helper.fetchMethodPickListVal(component, 'Preferred_Method__c', row);
                    component.set("v.showSignatoryUpdatePanel", true);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "Only 'Client' values can be overridden.",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                break;
        }
    },

    closeConfirmation: function(component, event, helper) {
        component.set("v.showESignaturePanel", false);
    },

    confrimAndClose: function(component, event, helper) {
        component.set("v.showESignaturePanel", false);
    },

    sendForSignature: function(component, event, helper) {
        //var draftValues = event.getParam('draftValues');
        //helper.sendForSignature(component, JSON.stringify(draftValues));
        helper.checkIfDocumentRestricted(component, event, helper, 'sendForSignature', JSON.stringify(component.get("v.signatoriesOutput")));
    },

    confrimAndCloseSignatory: function(component, event, helper) {
        component.set("v.updateSignatoryError", false);
        var checkCmp = component.find("completedCheckboxEmail");
        if(checkCmp.get("v.value") == true) {
            if(component.get("v.alternativeEmail") == '') {
                component.set("v.updateSignatoryError", true);

                var toastEvent2 = $A.get("e.force:showToast");
                toastEvent2.setParams ({
                    "title": "Error!",
                    "message": "Use Alternative Email for E-Signature? checkbox is selected, please capture Alternative Email.",
                    "type": "error"
                });
                toastEvent2.fire();
            } else {
                component.set("v.selectedEmailSignatory", component.get("v.alternativeEmail"));
            }
        } else if (component.get("v.selectedEmail") != 'Choose one...') {
            component.set("v.selectedEmailSignatory", component.get("v.selectedEmail"));
        }

        checkCmp = component.find("completedCheckboxMobile");
        if(checkCmp.get("v.value") == true) {
            if(component.get("v.alternativeMobile") == '') {
                component.set("v.updateSignatoryError", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams ({
                    "title": "Error!",
                    "message": "Use Alternative Mobile for E-Signature? checkbox is selected, please capture Alternative Mobile.",
                    "type": "error"
                });
                toastEvent.fire();
            } else {
                component.set("v.selectedMobileSignatory", component.get("v.alternativeMobile"));
            }
        } else if (component.get("v.selectedMobile") != '') {
            component.set("v.selectedMobileSignatory", component.get("v.selectedMobile"));
        }

        if (!component.get("v.updateSignatoryError")) {
            component.set("v.showSignatoryUpdatePanel", false);
            helper.updateSignatories(component, JSON.stringify(component.get("v.signatoriesOutput")));
            helper.refreshSignatories(component); // added to refresh signatory list data, email was not displaying - Tinashe 21-05-2020
        }
    },

    onPicklistMethodChange: function(component, event, helper) {
        component.set("v.selectedMethod", event.getSource().get("v.value"));
    },

    closeConfirmationSignatory: function(component, event, helper) {
        component.set("v.showSignatoryUpdatePanel", false);
    },

    refreshSignatories: function(component, event, helper) {
        component.set("v.isButtonSignatureDisabled", false);
        helper.refreshSignatories(component);
    },

    refreshDocuments: function(component, event, helper) {
        helper.fetchData(component);
        helper.refresh(component);
    },

    onCompletedCheckEmail: function(component, event) {
        var checkCmp = component.find("completedCheckboxEmail");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true){
            component.find("emailSelect").set("v.disabled", true);
            component.set("v.showAlternativeEmail", true);
        }
        else{
            component.find("emailSelect").set("v.disabled", false);
            component.set("v.showAlternativeEmail", false);
        }
    },

    onCompletedCheckMobile: function(component, event) {
        var checkCmp = component.find("completedCheckboxMobile");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true) {
            component.find("mobileSelect").set("v.disabled", true);
            component.set("v.showAlternativeMobile", true);
        }
        else {
            component.find("mobileSelect").set("v.disabled", false);
            component.set("v.showAlternativeMobile", false);
        }
    },

    onPicklistEmailChangeSharing: function(component, event, helper) {
        component.set("v.selectedEmailSharing", event.getSource().get("v.value"));
    },

    onPicklistEmailChangeSignature: function(component, event, helper) {
        component.set("v.selectedEmail", event.getSource().get("v.value"));
    },

    onCompletedCheckEmailSharing: function(component, event, helper) {
        var checkCmp = component.find("completedCheckboxEmailSharing");
        component.set("v.isCompleted", checkCmp.get("v.value"));
        if(checkCmp.get("v.value") == true) {
            component.find("emailSelectSharing").set("v.disabled", true);
            component.set("v.showAlternativeEmailSharing", true);
        }
        else {
            component.find("emailSelectSharing").set("v.disabled", false);
            component.set("v.showAlternativeEmailSharing", false);
        }
    },
    // esign the doc //Story W-004373 - Tinashe Shoko - END

    // Added By Himani W-005304
    handleStatusChange : function (component, event, helper) {
        if(event.getParam("status") === "FINISHED_SCREEN") {
            // Get the output variables and iterate over them
            var outputVariables = event.getParam("outputVariables");
            var currentOutputVariable;
            for(var i = 0; i < outputVariables.length; i++) {
                currentOutputVariable = outputVariables[i];
                if(currentOutputVariable.name === "CaseCreationMessage") {
                    if (currentOutputVariable.value) {
                        helper.fireToast("Success!", currentOutputVariable.value, "success");
                        $A.get('e.force:refreshView').fire();
                    }
                }
                if(currentOutputVariable.name === "ExistingQACaseFound") {
                    if (currentOutputVariable.value) {
                        helper.fireToast("Success!", currentOutputVariable.value, "success");
                        $A.get('e.force:refreshView').fire();
                    }
                }
            }
        }
    }
})