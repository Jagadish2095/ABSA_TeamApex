//Generic Signatories component developed by Tinashe, Masechaba and Tracy used for Signatories selection and esign
//Origninal component: DocumentShare and DocumentGenerate
({
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getDocumentsData");
        action.setParams({
            "opportunityId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.data", data);
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    fetchUserName: function (component) {
        var action = component.get("c.fetchAdviserName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.adviserName", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    fetchOwnerName: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.fetchOppOwnerName");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.oppOwnerName", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    fetchImpressionRequest: function (component) {
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
                component.set("v.data1", records);
            }
            else {
                console.log("Failed with state: " + state);
            }
            //component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    fetchAllClientEmails: function (component) {
        var action = component.get("c.getAllClientEmails");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var opts = [];
                //Set first list value
                component.set("v.selectedEmailSharing", data[0]);
                for (var i = 0; i < data.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: data[i],
                        value: data[i]
                    });
                }
                component.set("v.emailOptionsSharing", opts);
            }
        });
        $A.enqueueAction(action);
    },

    refreshSignatories: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getSignatoriesData");
        action.setParams({
            "documentId": component.get("v.documentId")
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
                //Set first list  value
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

    checkIfDocumentRestricted: function(component, event, helper, method, signatories) {
        //component.set("v.showSpinner", true);
        var action = component.get("c.documentRestricted");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "documentId": component.get("v.documentId")
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
        $A.enqueueAction(action);
    },

    fetchSignatories: function (component) {
        component.set("v.showSpinner", true);
        console.log('fetchSignatories: documentTemplate - ' + component.get("v.docTemplateName"));
        var action = component.get("c.getSignatoriesData");
        action.setParams({
            "documentId": component.get("v.documentId"),
            "documentTemplateName": component.get("v.docTemplateName"),
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('fetchSignatories : state - ' + state);
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.signatoriesOutput", data); 
                console.log('fetchSignatories : data - ' + data);
                if(data != null) {
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].Mobile_Phone == '' || data[i].Email == '' || data[i].Title == '') {
                            // Tinashe - further coding downstream will fail if any one of these values is null
                            component.set("v.isButtonSignatureDisabled", true);
                            component.set("v.isButtonSaveSignatoriesDisabled", true);
                        }  else {
                            if (component.get("v.isButtonSignatureDisabled") != true) {
                                component.set("v.isButtonSignatureDisabled", false);
                            }
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
        component.set("v.showSpinner", true);
        console.log(' console ' + signatoriesOutput);
        var action = component.get("c.sendForImpressionSignature");
        action.setParams({
            "documentId": component.get("v.documentId"),
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
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    //TdB - Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("theSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    //TdB - Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("theSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    //TdB - Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    },

    getAppId: function (component, event, helper) {
        var action = component.get("c.getApplicationId");
        action.setParams({ oppId: component.get("v.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationId = response.getReturnValue();
                console.log("applicationId" + JSON.stringify(applicationId));
                if (applicationId != null) {
                    component.set("v.applicationRecordId", applicationId);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})