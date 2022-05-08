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
                // Tinashe Shoko: 20200726: Sort the data by CreatedDate on load
                var sortDirection = 'desc';
                var DATA = component.get("v.data");
                var cloneData = DATA.slice(0);
                cloneData.sort((this.sortBy('CreatedDate', sortDirection === 'asc' ? 1 : -1)));

                component.set('v.data', cloneData);
                component.set('v.sortDirection', sortDirection);
                component.set('v.sortedBy', 'CreatedDate');
                // finish sort data
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
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

    emailSharing: function (component, clientEmail, idListJSON) {
    	component.set("v.showSpinner", true);
        var rows = component.get('v.data');
        var action = component.get("c.sendDocumentSharingEmail");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "clientEmail": clientEmail,
            "idListJSON": idListJSON
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

    download: function (component, docId, docName) {
    	component.set('v.showSpinner', true);
        var action = component.get('c.getDocumentContent');
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "documentId": docId,
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

    refresh: function (component) {
        var action = component.get("c.dummyRefresh");
        action.setCallback(this, function(response) {
            var state = response.getState();
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
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

    fetchSignatories: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getSignatoriesData");
        action.setParams({
            "documentId": component.get("v.documentId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != null) { // Tinashe - W-005660 - Handle the error gracefully so it does not popup a Component error to user
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
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Unable to sign the document - No signatory data found.",
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

    getAllEmails: function (component) {
        var action = component.get("c.getAllClientEmails");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var opts = [];
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
                if (data.length > 0) {
                    component.set("v.selectedEmailSharing", data[0]);
                    for (var i = 0; i < data.length; i++) {
                        opts.push({
                            class: "optionClass",
                            label: data[i],
                            value: data[i]
                        });
                    }
                } else {
                    component.set("v.selectedEmailSharing", 'None');
                    opts.push({
                        class: "optionClass",
                        label: 'Please add email addresses for Client or use Alternative email option.',
                        value: 'None'
                    });
                }
                component.set("v.emailOptionsSharing", opts);
            }
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

    updateSignatories: function (component, signatoriesOutput) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getUpdatedSignatoriesData");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "documentId": component.get("v.documentId"),
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

    checkCasaValidity: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkCASAValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                var casaValidity = response.getReturnValue();
                if(casaValidity == 'Valid'){
                    component.set("v.showDocumentScreen", true);
                    component.set("v.showCasaNotCompleted", false);

                }else{
                    component.set("v.showDocumentScreen", false);
                    component.set("v.showCasaNotCompleted", true);
                }
            }
        });
        component.set("v.showSpinner", false);
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

    //Start changes for W-005270
    checkStage: function (component, event, helper) {
        var action = component.get("c.getDocs");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var responsevalue1=response.getReturnValue();
                component.set("v.documentsUploaded",responsevalue1);
                this.getMandatoryDocs(component);
            }
            else {
                console.log("Failed with state: " + state);
            }

        });
        $A.enqueueAction(action);
    },

    getMandatoryDocs : function (component) {
        var Entitytype = component.get("v.opportunityRecord.Entity_Type__c");
        var action = component.get("c.getAllMandatoryDocuments");
        action.setParams({
            "Entitytype": Entitytype
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var responsevalue=response.getReturnValue();

                component.set('v.Mandatorydocuments',responsevalue);

                var Mandatorydocuments=component.get("v.Mandatorydocuments");
                var documentsUploaded=component.get("v.documentsUploaded");

                var DocFlag;
                var checkFlag;
                var nonMandFlag='F';
                for(var i in Mandatorydocuments)
                {

                    DocFlag='F';
                    for(var j in documentsUploaded)
                    {

                        if(documentsUploaded[j]===Mandatorydocuments[i].ECM_Type__c)
                        {
                            DocFlag='T';
                        }
                    }
                    if (DocFlag==='F')
                    {
                        console.log("bb");
                        nonMandFlag='T'
                    }
                }

                if (nonMandFlag==='T')
                {
                    console.log("non mand");
                    this.setOpportunityVal(component, event, true);
                }
                else
                {
                    console.log("mand");
                 	this.setOpportunityVal(component, event, false);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    setOpportunityVal : function(component, event, checkFlag) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateOpportunity");
        action.setParams({
            recordId: recordId,
            docFlag: checkFlag
        });
        action.setCallback(this, function(data) {
            var response = data.getReturnValue();
        });
        $A.enqueueAction(action);
    },
    //End changes for W-005270

    // Tinashe Shoko: 20200726: Used to sort the data
    sortBy: function(field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },

    // Tinashe Shoko: 20200726
    sortData: function(cmp, event) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var DATA = cmp.get("v.data");
        var cloneData = DATA.slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));

        cmp.set('v.data', cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    }
})