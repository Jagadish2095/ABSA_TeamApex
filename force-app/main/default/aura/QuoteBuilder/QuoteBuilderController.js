({
	doInit : function(component, event, helper) {
        // esign the doc //Story W-004373 - Tinashe Shoko - START
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
        // esign the doc //Story W-004373 - Tinashe Shoko - END
        helper.setNoActions(component);

        if (component.get("v.recordId")) {
            helper.getQuoteBuilderData(component, event, helper);
        }

        if(component.get("v.quoteType") == component.get("v.merchantOnboarding")){
            component.set("v.saveOnlyUpdatedData", true);
        }else{
            component.set("v.saveOnlyUpdatedData", false);
        }
	},

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'revise':
                helper.reviseQuote(component, helper);
                break;
            case 'accept':
                helper.acceptQuote(component, event, helper);
                break;
            case 'reject':
                helper.openRejectQuoteModal(component, helper);
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

    handleReviseQuote: function(component, event, helper) {
        helper.reviseQuote(component, helper);
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

    handleOppSuccess : function(component, event, helper){
        helper.hideSpinner(component);
    },

    handleOppError : function(component, event, helper){
        var componentName = 'MerchantQuoteBuilder';
        console.error(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.hideSpinner(component);
        helper.fireToast('Error!', 'Error saving Opportunity.', 'error');
    },

    //JQUEV 20200813
    //Method calculates the Total based on Quantity and Price
    calculateTotals : function(component, helper) {
        //*** Was unable to call the helper method as the function has no context of the helper as it was specified during field creation */
        //var monthlyTotal = helper.calculateTotals(component);

        var rentalAmountMdt, quantity, rentalAmount, monthlyTotal;
        var bean = component.get("v.pricingBean");
        var metadataNameToValueMap = component.get("v.metadataNameToValueMap");

        //For Each Metadata Record
        bean.fieldVisibilityMdtList.forEach(function (item) {
            var additionalAttributes = JSON.parse(item.Additional_Attributes__c);
            if(additionalAttributes.fieldAPIName == "Quantity"){
				quantity = metadataNameToValueMap[item.DeveloperName];
			}
			if(additionalAttributes.fieldAPIName == "UnitPrice"){
				rentalAmount = metadataNameToValueMap[item.DeveloperName];
			}
            if(item.Field_Name__c == "monthlyRental"){
                rentalAmountMdt = item;
            }
        });
		if(!$A.util.isEmpty(quantity) && !$A.util.isEmpty(rentalAmount) && !$A.util.isEmpty(rentalAmountMdt)){
            monthlyTotal = quantity * rentalAmount;
            metadataNameToValueMap[rentalAmountMdt.DeveloperName] = monthlyTotal;
            component.set("v.metadataNameToValueMap", metadataNameToValueMap);
        }
    },

    //Reset Pricing START
    handleResetPricing : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },

    handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);

        if (component.get("v.recordId")) {
            helper.getQuoteBuilderData(component, event, helper);
        }
    },

    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
    //Reset Pricing END

    //W-005082 JQUEV
    handleLossReasonDialogYes : function(component, event, helper) {

        var inputField = component.find("oppLossReason");
        var inputFieldValue = Array.isArray(inputField) ? inputField[0].get("v.value") : inputField.get("v.value");

        if(inputFieldValue){
            //Valid
            component.find("oppQuoteStatus").set("v.value", 'Declined');
            component.set("v.pricingBean.quoteStatus", "Declined");
            //Updates Opportunity StageName to Close Lost and the Loss_Reason_Type__c to Customer declined Proposal
            component.find("opportunityForm").submit();
            helper.mapFieldsToDataTable(component, helper, JSON.stringify(component.get("v.pricingBean")));
            //helper.closeRejectQuoteModal(component);
            helper.closeModal(component, "lossReasonModal");
            helper.fireToast("Success", "Quote rejected successfully", "success");
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
        //helper.closeRejectQuoteModal(component);
        helper.closeModal(component, "lossReasonModal");
    },

    handleGenerateQuote : function(component, event, helper) {
        if(helper.allFieldsValid(component, true)){
            helper.generateMerchantQuote(component, helper);
        } else {
            component.set('v.isFormReadOnly', false);
            helper.fireToast("Validation Error", "Required Fields are missing, please see errors on page.", "error");
        }
    },

    handleApplicationEvent : function(component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        var opportunityProductId = event.getParam("opportunityProductId");
        if(!$A.util.isEmpty(opportunityProductId)){
            //Used for Merchant Class
            component.set("v.opportunityLineItemId", opportunityProductId);
            // Condition to not handle self raised event
            if (sourceComponent != "MerchantQuoteBuilder") {
                helper.getQuoteBuilderData(component, event, helper);
            }
        }
    },

    handleFranchiseSelected : function(component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        // Condition to not handle self raised event
        if (sourceComponent != "MerchantQuoteBuilder") {
            helper.getQuoteBuilderData(component, event, helper);
        }
    },

    // PJAIN: 20200630
    opportunityRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            //Check if High Risk MCC Check has passed
            var riskChecksPassed = component.get("v.opportunityRecord.Merchant_High_Risk_MCC_Passed__c");
            var quoteDate = component.get("v.opportunityRecord.Quote_Generation_Date__c");
            console.log("riskChecksPassed: " + riskChecksPassed + " quoteDate: " + quoteDate);
            if(!riskChecksPassed && component.get("v.quoteType") == component.get("v.merchantOnboarding")){
                helper.showError(component, "Please complete all the Risk Checks on the previous tab before working on the Quote. ");
                component.set("v.isFormReadOnly", true);
                //remove the ability to do actions on the quote
                helper.setNoActions(component);
            }else if(quoteDate != null){
                component.set("v.isFormReadOnly", true);
            }else{
                component.set("v.isFormReadOnly", false);
            }

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

    //W-005082 JQUEV
    //Open the Product Select Confirmation Modal
    openProductSelectConfirmModal: function(component, event, helper) {
        helper.openModal(component, "ProductSelectConfirmModal");
    },

    //W-005082 JQUEV
    //Close the Product Select Confirmation Modal
    closeProductSelectConfirmModal : function(component, event, helper){
        var respBean = component.get('v.pricingBean');
        //Reset the picklist value to the current selected product
        if(respBean != null && respBean.productName != null){
            component.find("productSelect").set("v.value", respBean.productName);
        }else{
            //Reset value to --None--
            component.find("productSelect").set("v.value", "");
        }
        helper.closeModal(component, "ProductSelectConfirmModal");
    },

    //W-005082 JQUEV
    //Close the Product Select Confirmation Modal
    //Change the selected Product
    handleProductSelectConfirmModalYes : function(component, event, helper){
        helper.closeModal(component, "ProductSelectConfirmModal");
        helper.changeSelectedProduct(component, event, helper, component.find("productSelect").get("v.value"));
    },

    //W-004117 JQUEV
    //Open the Toggle Details Confirmation Modal If we are collapsing the detailed section.
    //Else if we are expanding the detailed section, then just create the new UI
    openToggleDetailsConfirmModal: function(component, event, helper) {
        if(!component.get("v.showDetailedSection")){
            helper.openModal(component, "ToggleDetailsConfirmModal");
        }else{
            helper.createAllUI(component, helper, component.get("v.pricingBean"), component.get("v.showDetailedSection"));
        }
    },

    //W-004117 JQUEV
    //Close the Toggle Details Confirmation Modal
    //Reset Toggle button
    closeToggleDetailsConfirmModal : function(component, event, helper){
        helper.closeModal(component, "ToggleDetailsConfirmModal");
        if(component.get("v.showDetailedSection")){
            component.set("v.showDetailedSection", false);
        }else{
            component.set("v.showDetailedSection", true);
        }
    },

    //W-004117 JQUEV
    //Close the Toggle Details Confirmation Modal
    //Create UI
    handleToggleDetailsConfirmModalYes : function(component, event, helper){
        helper.closeModal(component, "ToggleDetailsConfirmModal");
        helper.createAllUI(component, helper, component.get("v.pricingBean"), component.get("v.showDetailedSection"));
    }
})