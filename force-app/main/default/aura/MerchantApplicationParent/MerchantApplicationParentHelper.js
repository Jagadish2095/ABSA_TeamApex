({
    getObjectDataJS: function(component) {
        var action = component.get("c.getObjectData");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();

                if(responseValue != null){

                    var applicationId = responseValue['applicationId'];
                    var opportunityLineItemId = responseValue['opportunityLineItemId'];
                    var opportunityLineItemProductName = responseValue['opportunityLineItemProductName'];//Added By Himani: 20205553
                    var applicationProductMerchantId = responseValue['applicationProductMerchantId'];
                    var applicationRecordTypeId = responseValue['applicationRecordTypeId'];
                    var opportunityRecordTypeId = responseValue['opportunityRecordTypeId'];

                    component.set("{!v.applicationId}", applicationId);
                    component.set("{!v.opportunityLineItemId}", opportunityLineItemId);
                    component.set("{!v.opportunityLineItemProductName}", opportunityLineItemProductName);//Added By Himani: 20205553
                    component.set("{!v.applicationProductMerchantId}", applicationProductMerchantId);
                    component.set("{!v.applicationRecordTypeId}", applicationRecordTypeId);
                    component.set("{!v.opportunityRecordTypeId}", opportunityRecordTypeId);

                    console.log('MerchantApplicationParent.getObjectDataJS.applicationId: ' + applicationId);
                    console.log('MerchantApplicationParent.getObjectDataJS.opportunityLineItemId: ' + opportunityLineItemId);
                    //console.log('MerchantApplicationParent.getObjectDataJS.opportunityLineItemProductName: ' + opportunityLineItemProductName);
                    console.log('MerchantApplicationParent.getObjectDataJS.applicationProductMerchantId: ' + applicationProductMerchantId);
                    //console.log('MerchantApplicationParent.getObjectDataJS.applicationRecordTypeId: ' + applicationRecordTypeId);
                    //console.log('MerchantApplicationParent.getObjectDataJS.opportunityRecordTypeId: ' + opportunityRecordTypeId);
                }

                if($A.util.isEmpty(responseValue['applicationId'])){
                    component.set("{!v.errorMessage}", "The Quote must be accepted before filling out the Application form.");
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    // PJAIN: 20200510
    // Check if all checkboxes have been checked or not
    validateParentForm: function(component) {

        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");

        for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {

            var inputField = component.find(arrayAuraIdsToBeValidated[i]);
            var inputFieldValue = Array.isArray(inputField) ? inputField[0].get("v.value") : inputField.get("v.value");

            if(!inputFieldValue){
                return false;
            }
        }
        return true;
    },

    // Added by Himani:W-005547
    checkRejectedApprovals : function (component) {
        var action = component.get("c.checkApprovals");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue) {
                    this.hideSpinner(component);
                    this.fireStickyToast('Error!', responseValue, 'error');
                    }
                else {
                    if(component.get("v.opportunityLineItemProductName") == 'E-Commerce'){
                        this.generateMerchantApplication(component, $A.get("$Label.c.Merchant_Application_Agreement_E_Commerce_5122_Template_Name"));
                        this.generateMerchantApplication(component, $A.get("$Label.c.Merchant_Application_Agreement_E_Commerce_4492_Template_Name"));
                    }else{
                        this.generateMerchantApplication(component, $A.get("$Label.c.Merchant_Application_Document_Template_Name"));
                    }
                }
                /*
                if (responseValue) {
                    this.generateMerchantApplication(component);
                }*/
            } else if(response.getState() === "ERROR"){
                this.hideSpinner(component);
                var errors = response.getError();
                component.set("v.errorMessage", "getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                this.hideSpinner(component);
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    // PJAIN: 20200724
    // D BOOYSEN: 2020/08/18 - W-004984 and W-004857
    generateMerchantApplication: function(component, docType) {

        var opportunityId = component.get("v.recordId");
        var opportunityLineItemId = component.get("v.opportunityLineItemId");
        var applicationId = component.get("v.applicationId");
        var applicationProductMerchantId = component.get("v.applicationProductMerchantId");

        // Generates Application Number
        var appNumberField = component.find("applicationNumberField");
        var applicationNumber = appNumberField.get("v.value");
        if ($A.util.isEmpty(applicationNumber)) {
            applicationNumber = component.get("v.recordId").substring(0, 15).toUpperCase() + '-A1';
        } else {
            var appNumberIncrement = parseInt(applicationNumber.substring(17)) + 1;
            if (isNaN(appNumberIncrement)) {
                applicationNumber = component.get("v.recordId").substring(0, 15).toUpperCase() + '-A1';
            } else {
                applicationNumber = applicationNumber.substring(0, 15).toUpperCase() + '-A' + appNumberIncrement;
            }
        }

        if (applicationNumber && opportunityId && opportunityLineItemId && applicationId && applicationProductMerchantId) {
            var idsMap = new Map();
            idsMap['inputType'] = 'idValues';
            idsMap['applicationNumber'] = applicationNumber;
            idsMap['opportunityId'] = opportunityId;
            idsMap['opportunityLineItemId'] = opportunityLineItemId;
            idsMap['applicationId'] = applicationId;
            idsMap['applicationProductMerchantId'] = applicationProductMerchantId;

            var action = component.get("c.generateMerchantApplicationDocument");
            action.setParams({
                "idsMap": idsMap,
                "templateName" : docType
            });
            action.setCallback(this, function(response) {
                if (response.getState() == "SUCCESS") {
                    var responseValue = response.getReturnValue();
                    if (responseValue === 'success') {
                        //Set Application Number and Application Generation Date
                        appNumberField.set("v.value", applicationNumber);
                        var appGenerationDateField = component.find("applicationGenerationDateField");
                        var currentDatetime = new Date().toISOString();
                        appGenerationDateField.set("v.value", currentDatetime);
                        component.set('v.toastMessage', 'Application document generated successfully');

                        //Save Application Record
                        component.find("merchantPCIDSSForm").submit();
                        this.mapFieldsToDatatable(component);
                    } else {
                        component.set("v.errorMessage", "MerchantApplicationParentHelper.generateMerchantApplication: Service response error: [" + responseValue + "]. ");
                    }
                } else if(response.getState() === "ERROR"){
                    var errors = response.getError();
                    component.set("v.errorMessage", "MerchantApplicationParentHelper.generateMerchantApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
                } else {
                    component.set("v.errorMessage", "MerchantApplicationParentHelper.generateMerchantApplication: Apex error. ");
                }
                this.hideSpinner(component);
            });
            $A.enqueueAction(action);
        } else {
            this.hideSpinner(component);
            component.set("v.errorMessage", "Application document cannot be generated. Required field(s) missing. The values are [applicationNumber]:[" + applicationNumber + "], [opportunityId]:[" + opportunityId + "], [opportunityLineItemId]:[" + opportunityLineItemId + "], [applicationId]:[" + applicationId + "], [applicationProductMerchantId]:[" + applicationProductMerchantId + "]");
        }
    },

    reviseApplication: function(component, event, helper) {
        //Make form Editable
        component.set('v.isFormReadOnly', false);
        component.set('v.toastMessage', 'Application revised successfully');

        //nullify Application Generation Date & Application Correctness Consent checkbox
        component.find("applicationGenerationDateField").set("v.value", null);
        component.find("applicationCorrectnessConsent").set("v.value", false);
        component.find("merchantPCIDSSForm").submit();
    },

    acceptApplication: function(component, event, helper) {
        var qaStatusField = component.find("qaStatusField").get("v.value");
        component.set('v.qaStatus', qaStatusField);

        component.set('v.toastMessage', 'Application accepted successfully');
        component.set('v.applicationStatus', 'Accepted');
        component.find("applicationStatusField").set("v.value", 'Accepted');
        component.find("merchantPCIDSSForm").submit();

        // Update Opportunity Stage and Loss Reason using recordEditForm
        component.find("oppStageName").set("v.value", "Fulfill Product");
        //Save Opportunity Record
        component.find("opportunityForm").submit();
    },

    //Himani Joshi: 20200720: #W-005298
    checkMandatoryDocuments : function (component, event, helper) {
        var action = component.get("c.getUploadedAndMandatoryDocuments");
        console.log("opportunityLineItemProductName"+component.get("v.opportunityLineItemProductName"));
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "entityType": component.get("v.opportunityRecord.Entity_Type__c"),
            "productName" : component.get("v.opportunityLineItemProductName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseMap = response.getReturnValue();
                var uploadedDocuments = responseMap['uploadedDocuments'];
                var mandatoryDocuments = responseMap['mandatoryDocuments'];
                console.log("mandatoryDocuments"+mandatoryDocuments);
                var uploadedDocumentsSet = new Set();
                var uploadedSignedDocumentsSet = new Set();
                var bulletString = '•	';
                var missingMandatoryDocuments = '';
                var missingMandatoryDocumentsForEsigning = '';

                for (var i in uploadedDocuments) {
                    uploadedDocumentsSet.add(uploadedDocuments[i].Type__c);
                    if(uploadedDocuments[i].Document_Status__c === "Signed" || uploadedDocuments[i].Document_Status__c === "Signed Manually") {
                        uploadedSignedDocumentsSet.add(uploadedDocuments[i].Type__c);
                    }
                }

                for (var i in mandatoryDocuments) {
                    console.log("mandatoryDocuments[i].Type__c"+mandatoryDocuments[i].Type__c);
                    if (!uploadedDocumentsSet.has(mandatoryDocuments[i].Type__c)) {
                        missingMandatoryDocuments += bulletString + mandatoryDocuments[i].Type__c + '\n';
                    } else if (mandatoryDocuments[i].Signature_Required__c) {
                        if (!uploadedSignedDocumentsSet.has(mandatoryDocuments[i].Type__c)) {
                            missingMandatoryDocumentsForEsigning += bulletString + mandatoryDocuments[i].Type__c + '\n';
                        }
                    }
                }

                if (!$A.util.isEmpty(missingMandatoryDocuments)) {
                    this.fireStickyToast('Error!', 'The following mandatory documents are missing:' + '\n' + missingMandatoryDocuments, 'error');
                    return;
                } else if (!$A.util.isEmpty(missingMandatoryDocumentsForEsigning)) {
                    this.fireStickyToast('Error!', 'The following mandatory documents have not been signed. Please e-sign or manually sign these documents:' + '\n' + missingMandatoryDocumentsForEsigning, 'error');
                    return;
                } else {
                    this.submitForQA(component);
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "checkMandatoryDocuments: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "checkMandatoryDocuments: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    // PJAIN: 20200714: W-005081
    submitForQA : function (component) {
        var currentUserId = $A.get("$SObjectType.CurrentUser.Id");
        var currentDateTime = new Date().toISOString();
        component.set('v.qaStatus', 'Pending');
        component.find("qaStatusField").set("v.value", 'Pending');
        component.find("qaStatusUpdatedByField").set("v.value", currentUserId);
        component.find("qaStatusUpdatedOnField").set("v.value", currentDateTime);
        component.find("merchantPCIDSSForm").submit();
        this.handleCreateCase(component);
    },

    //W-005082 JQUEV
    openRejectApplicationModal: function(component) {

        //Pre set the close loss values in order to populate the Loss Reason dependent picklist
        component.find("oppStageName").set("v.value", "Closed Lost");
        component.find("oppLossReasonType").set("v.value", "Customer declined Proposal");
        //Set Loss Reason to Required
        component.find("oppLossReason").set("v.required", true);

        var cmpTarget = component.find('lossReasonModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },

    //W-005082 JQUEV
    closeRejectApplicationModal : function(component){
        var cmpTarget = component.find('lossReasonModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

    setAllActions: function(component) {
        var actions = [
            { label: 'Revise', name: 'revise' },
            { label: 'Accept', name: 'accept' },
            { label: 'Reject', name: 'reject' }
            //{ label: 'Email', name: 'email' }, //Story W-004373 - Tinashe Shoko
            //{ label: 'Download', name: 'download' }, //Story W-004373 - Tinashe Shoko
            //{ label: 'E-Sign', name: 'esign' } //Story W-004373 - Tinashe Shoko
        ];
        this.setColumns(component, actions);
    },

    setNoActions: function(component) {
        var actions = [
            { label: 'Action already performed', name: 'doNothing' }
        ];
        this.setColumns(component, actions);
    },

    setColumns: function(component, actions) {
        component.set('v.columns', [
            {label: 'Application Number', fieldName: 'appNumber', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'},
            {label: 'Date', fieldName: 'date', type: 'date', typeAttributes: {
                day: 'numeric',
                month: 'numeric',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: false
            }},
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);
    },

    // PJAIN: 20200610: Added common code to a method
    mapFieldsToDatatable : function (component) {
        //Map fields to Datatable
        var data = [{
            appNumber: component.find("applicationNumberField").get("v.value"),
            status: component.find("applicationStatusField").get("v.value"),
            date: component.find("applicationGenerationDateField").get("v.value")
        }];
        component.set("v.data", data);
    },

    showSpinner: function(component) {
        component.set("v.isSpinner",true);
    },

    hideSpinner: function(component) {
        component.set("v.isSpinner",false);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 05/05/2020
 	**@ Description: Method that resets the value of an inputField to the original (database value)
     **               This would work if the field is an Array (multiple fields with the same id) of fields or just a single field element*/
    resetFieldValue : function(component){

        let fields = component.get("v.resetFieldsList");
        for(var i = 0; i<fields.length; i++){
            var thisField = component.find(fields[i]);
            var isFieldArray = Array.isArray(thisField);

            if(isFieldArray){
                thisField.forEach(function(field) {
                    if(field){
                        field.reset();
                    }
                });
            }else{
                if(thisField){
                    thisField.reset();
                }
            }
        }
    },

    //Fire Sticky Lightning toast
    fireStickyToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "mode":"sticky",
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    },

    //Fire Lightning toast
    fireToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    },

    // esign the doc //Story W-004373 - Tinashe Shoko - START
    fetchSignatories: function (component) {
        //component.set("v.showSpinner", true);
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.getSignatoriesData");
        action.setParams({
            "opportunityId" : opportunityId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.signatoriesOutput", data);
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Mobile_Phone == '' || data[i].Email == '' || data[i].Title == '') {
                        // Tinashe - further coding downstream will fail if any one of these values is null
                        component.set("v.isButtonSignatureDisabled", true);
                    }  else {
                        if (component.get("v.isButtonSignatureDisabled") != true) {
                            component.set("v.isButtonSignatureDisabled", false);
                        }
                    }
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            //component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    ////Story W-004373 - Tinashe Shoko
    checkIfDocumentRestricted : function(component, event, helper, method, signatories){
        var opportunityId = component.get("v.recordId");
        var respBean = component.get('v.pricingBean');

        var action = component.get("c.documentRestricted");
        action.setParams({
            "opportunityId" : opportunityId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                if(response.getReturnValue()) {
                    component.set("v.inProgressOrSignedRequestExists", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Error!",
                        "message": "This document cannot be submitted to Impression for E-Signature.",
                        "type": "error"
                    });
                    toastEvent.fire();
                } else if (method == 'sign') {
                    component.set("v.showESignatureDataTable", true);
                    this.fetchSignatories(component);
                } else if (method == 'sendForSignature') {
                    this.sendForSignature(component, signatories);
                    component.set("v.showESignatureDataTable", false);
                    this.fetchImpressionRequest(component);
                }
            }
            //component.set("v.showSpinner", false);
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    updateSignatories: function (component, signatoriesOutput) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getUpdatedSignatoriesData");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            //"documentId": component.get("v.documentId"),
            "signatoryId": component.get("v.signatoryId"),
            "signatoriesInput": signatoriesOutput,
            "method": component.get("v.selectedMethod"),
            "mobile": component.get("v.selectedMobileSignatory"),
            "email": component.get("v.selectedEmailSignatory")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.signatoriesOutput", data);
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Mobile_Phone == '' || data[i].Email == '' | data[i].Title == '') {
                        component.set("v.isButtonSignatureDisabled", true);
                    }  else {
                        if (component.get("v.isButtonSignatureDisabled") != true) {
                            component.set("v.isButtonSignatureDisabled", false);
                        }
                    }
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    fetchAllClientEmailsSignature: function (component) {
        var action = component.get("c.getAllClientEmailsSignature");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var opts = [];
                //Set first list value
                component.set("v.selectedEmail", data[0]);
                for (var i = 0; i < data.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: data[i],
                        value: data[i]
                    });
                }
                component.set("v.emailOptions", opts);
            }
        });
        $A.enqueueAction(action);
    },

    getMobile: function (component) {
        var action = component.get("c.getMobile");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var opts = [];
                //Set first list value
                if (data.length > 0) {
                    component.set("v.selectedMobile", data[0]);
                }

                for (var i = 0; i < data.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: data[i],
                        value: data[i]
                    });
                }
                component.set("v.mobileOptions", opts);
            }
        });
        $A.enqueueAction(action);
    },

    fetchMethodPickListVal : function(component, fieldName, row) {
        var action = component.get("c.getDigitalSignatorySelectOptions");
        action.setParams({
            "fld": fieldName
        });

        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != undefined && data.length > 0) {
                    opts.push({class: "optionClass", label: row.Method, value: row.Method});
                    for (var i = 0; i < data.length; i++) {
                        if(row.Method != data[i]) {
                            opts.push({class: "optionClass", label: data[i], value: data[i]});
                        }
                    }
                }
                component.set("v.methodOptions", opts);
            }
        });
        $A.enqueueAction(action);
    },

    refreshSignatories: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getSigntoriesData");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.signatoriesOutput", data);
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Mobile_Phone == '' || data[i].Email == '' || data[i].Title == '') {
                        // Tinashe - further coding downstream will fail if any one of these values is null
                        component.set("v.isButtonSignatureDisabled", true);
                    } else {
                        if (component.get("v.isButtonSignatureDisabled") != true) {
                            component.set("v.isButtonSignatureDisabled", false);
                        }
                    }
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    sendForSignature: function (component, signatoriesOutput) {
        component.set("v.isSpinner", true);
        console.log(' console ' + signatoriesOutput);
        var action = component.get("c.sendForImpressionSignature");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "signatories": signatoriesOutput
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Document sent to Impression for signing.",
                    "type":"success"
                });
                toastEvent.fire();
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.isSpinner", false);
        });
        $A.enqueueAction(action);
    },

    fetchImpressionRequest: function (component) {
        //component.set("v.showSpinner", true);
        var action = component.get("c.fetchImpressionRequest");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                component.set("v.impressionRequestData", records);

            }
            else {
                console.log("Failed with state: " + state);
            }
            //component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    download: function (component, docName) {
        component.set('v.showSpinner', true);
        var action = component.get('c.getDocumentContent');
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "sharingMethod": 'Download',
            "clientEmail": ''
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var element = document.createElement('a');
                element.setAttribute('href', 'data:application/octet-stream;content-disposition:attachment;base64,' + data);
                element.setAttribute('download', docName);
                element.style.display = 'none';
                document.body.appendChild(element);
                element.click();
                document.body.removeChild(element);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Document(s) Successfully Downloaded to the Desktop.",
                    "type":"success"
                });
                toastEvent.fire();

            } else {
                console.log("Download failed ...");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Failed Downloaded Document(s) to the Desktop.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set('v.showSpinner', false);
        }));
        $A.enqueueAction(action);
    },

    getDocName: function(component) {
        var action = component.get('c.getQuoteDocumentName');
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.documentId", response.getReturnValue());
                this.download(component, response.getReturnValue());
            } else {
                console.log("Download failed ...");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Failed to get Quote Document Name.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }));
        $A.enqueueAction(action);
    },

    emailSharing: function (component) {
        component.set("v.showSpinner", true);
        var rows = component.get('v.data');
        var action = component.get("c.sendDocumentSharingEmail");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Documents Successfully Emailed to the Client.",
                    "type":"success"
                });
                toastEvent.fire();
            }
            else {
                console.log("Failed with state: " + state);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error with Emailing Documents to the Client.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    // esign the doc //Story W-004373 - Tinashe Shoko - END

    // Added By Himani W-005304
    handleCreateCase : function (component, event, helper) {
        // Find the component whose aura:id is "flowId"
        var flow = component.find("flowId");
        var inputVariables = [{
            name: "OpportunityId",
            type: "String",
            value: component.get("v.recordId")
        }, {
            name: "CaseRecordTypeName",
            type: "String",
            value: "Merchant_Quality_Assurance"
        }, {
            name: "Subject",
            type: "String",
            value: "Merchant Quality Assurance"
        }, {
            name: "ServiceTypeName",
            type: "String",
            value: "Merchant Quality Assurance"
        }];
        //launch the flow
        flow.startFlow("Merchant_Application_Create_Case", inputVariables);
    },

    //D Booysen: 2020/08/07 - W-005541
    //This function is called when the row action revised is selected on the Application
    //It calls an apex method to set the status of the current Merchant Agreement to Outdated
    //This function also calls the reviseApplication logic when the Document Status has been successfully updated
    outdateAppDocumentStatus: function (component, event, helper){
        var action = component.get('c.outdateDocumentStatus');
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.reviseApplication(component, event, helper);
            } else if (response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "outdateAppDocumentStatus: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "outdateAppDocumentStatus: Apex error. ");
            }
        }));
        $A.enqueueAction(action);
    }
})