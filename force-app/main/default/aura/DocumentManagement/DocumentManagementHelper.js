({
    /**
     * @description function to show spinner.
     **/
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    /**
     * @description function to hide spinner.
     **/
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    fetchAuditData: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocAuditHistoryEmail");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var res = JSON.stringify(data);
                console.log("The res>>>" + res);
                var idVsIsSalesforceFileMap = new Map();
                var docIdVSFileId = new Map();
                //console.log('data:' + data);
                data.forEach(function (data) {
                    data.ownerName = data.Owner.Name;
                    if(data.Reference__c != null && data.Reference__c != '' && data.Reference__c != undefined && data.Reference__c != 'NA'){
                        idVsIsSalesforceFileMap[data.Id] = 'No';
                       }else{
                           idVsIsSalesforceFileMap[data.Id] = 'Yes';
                           docIdVSFileId[data.Id] = data.Salesforce_File_Id__c;
                       }
                    if (data.Contact__c == "" || data.Contact__c == null) {
                        data.Contact__c = "Primary Client";
                    } else {
                        data.Contact__c = "Related Party";
                    }
                });
                component.set("v.idVsIsSalesforceFileMap",idVsIsSalesforceFileMap);
                component.set("v.docIdVSFileId",docIdVSFileId);
                component.set("v.dataAudit", data);
                if(data != ''){
                	this.captureDocument(component,data[0].Id);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessageViewDocuments", "Error in fetchAuditData method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessageViewDocuments", "Unknown error in fetchAuditData method. State: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    /**
     * @description download function to download file from ECM.
     **/
    download: function (cmp, row) {
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.getDocumentContent");
        action.setParams({
            documentId: row.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    var element = document.createElement("a");
                    element.setAttribute("href", "data:application/octet-stream;content-disposition:attachment;base64," + data);
                    element.setAttribute("download", row.Name);
                    element.style.display = "none";
                    document.body.appendChild(element);
                    element.click();
                    document.body.removeChild(element);
                } else {
                    console.log("Download failed ...");
                }
                cmp.set("v.showSpinner", false);
            })
        );
        $A.enqueueAction(action);
    },

    generateDocument: function (component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("doGenerate3");
        console.log("GenerateDocument : " + component.get("v.signatureRequestRecords"));

        var action = component.get("c.generateDocument");
        action.setParams({
            opportunityId: component.get("v.recordId"),
            templateName: component.get("v.fileType"),
            signatureRequests: component.get("v.signatureRequestRecords")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            var res = response.getReturnValue();
            console.log("Response from generate document : " + JSON.stringify(res));
            if (state === "SUCCESS" && res.success === "true") {
                toastEvent.setParams({
                    title: "Success!",
                    message: component.get("v.fileType") + " document successfully generated.",
                    type: "success"
                });
                toastEvent.fire();
            } else {
                console.log("Failed with state: " + JSON.stringify(response));
                toastEvent.setParams({
                    title: "Error!",
                    message: "Failed to generate document " + component.get("v.fileType"),
                    type: "error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    //Tinashe
    generateNewDocument: function (component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("doGenerate3");
        console.log("GenerateDocument : " + component.get("v.signatureRequestRecords"));

        var action = component.get("c.generateNewDocument");
        action.setParams({
            opportunityId: component.get("v.recordId"),
            templateName: component.get("v.fileType"),
            signatureRequests: component.get("v.signatureRequestRecords")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            var res = response.getReturnValue();
            console.log("Response from generate document : " + JSON.stringify(res));
            if (state === "SUCCESS" && res.success === "true") {
                toastEvent.setParams({
                    title: "Success!",
                    message: component.get("v.fileType") + " document successfully generated.",
                    type: "success"
                });
                toastEvent.fire();
            } else {
                console.log("Failed with state: " + JSON.stringify(response));
                toastEvent.setParams({
                    title: "Error!",
                    message: "Failed to generate document " + component.get("v.fileType"),
                    type: "error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    // end Tinashe

    fetchFileTypesPickListVal: function (component) {
        var action = component.get("c.getDocumentTemplatesNamePickList");
        action.etParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        });
        $A.enqueueAction(action);
    },

    fetchTemplateTypesPickListVal: function (component, event, helper) {
        var action = component.get("c.getDocumentTemplatesNamePickList");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        });
        $A.enqueueAction(action);
    },

    fetchPersonAccs: function (component, event, helper) {
        var action = component.get("c.fetchPersonAccList");
        action.setParams({ oppid: component.get("v.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationRecordDetail = response.getReturnValue();
                console.log("applicationRecordDetail" + JSON.stringify(applicationRecordDetail));
                component.set("v.personAccList", applicationRecordDetail);
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

    //Start changes for W-004683 By Himani

    checkStage: function (component, event, helper) {
        var action = component.get("c.getDocs");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responsevalue1 = response.getReturnValue();
                component.set("v.documentsUploaded", responsevalue1);
                //this.getMandatoryDocs(component);//w-005661
                this.getPrimayClientMandatoryDocs(component);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    getMandatoryDocs: function (component) {
        var Entitytype = component.get("v.opportunityRecord.Entity_Type__c");
        var action = component.get("c.getAllMandatoryDocuments");
        action.setParams({
            Entitytype: Entitytype
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responsevalue = response.getReturnValue();
                console.log("responsevalue" + responsevalue);
                component.set("v.Mandatorydocuments", responsevalue);

                var Mandatorydocuments = component.get("v.Mandatorydocuments");
                var documentsUploaded = component.get("v.documentsUploaded");
                var DocFlag;
                var checkFlag;
                var nonMandFlag = "F";
                for (var i in Mandatorydocuments) {
                    DocFlag = "F";
                    for (var j in documentsUploaded) {
                        if (documentsUploaded[j] === Mandatorydocuments[i].ECM_Type__c) {
                            console.log("Mandatorydocuments Mach 184 " + Mandatorydocuments[i].ECM_Type__c);
                            DocFlag = "T";
                        }
                    }
                    if (DocFlag === "F") {
                        console.log("bb");
                        nonMandFlag = "T";
                    }
                }

                if (nonMandFlag === "T") {
                    console.log("non mand");
                    this.setOpportunityVal(component, event, true);
                } else {
                    console.log("mand");
                    this.setOpportunityVal(component, event, false);
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

    setOpportunityVal: function (component, event, checkFlag) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateOpportunity");
        action.setParams({
            recordId: recordId,
            docFlag: checkFlag
        });
        action.setCallback(this, function (data) {
            var response = data.getReturnValue();
            console.log("Response 238 " + response);
        });
        $A.enqueueAction(action);
    },

    getSelectDocumentTemplateRecord: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.signatureRequestRecords", null);
        component.set("v.showSignatoriesCmp", false);
        var ftype = component.find("generateFileType").get("v.value");
        var action = component.get("c.getSelectedDocumentTemplate");
        action.setParams({
            documentTemplateName: ftype
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var documentTemplateRecord = response.getReturnValue();
                component.set("v.showSignatoriesCmp", false);
                if (documentTemplateRecord != null && documentTemplateRecord.Signature_Required__c == true) {
                    console.log('ftype >> ' + ftype + ' <<< ' + component.get("v.showSignatoriesCmp"));
                    console.log('documentTemplateRecord >>>' + documentTemplateRecord);
                    component.set("v.showSignatoriesCmp", true);
                    var signatoriesCmp = component.find("documentSignatoriesCmp");
                    signatoriesCmp.getDocumentType(ftype);
                    console.log("DocumntManagement:setDocumentTemplate:fileType - " + ftype);
                    component.set("v.fileType", ftype);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.this("Error", errors, "error");
                component.set("v.showSignatoriesCmp", false);
            } else {
                this.this("Document Template Error", "Unable to find selected Document Template: Please contact your System Administrator", "Error");
                component.set("v.showSignatoriesCmp", false);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    //Lightning  toastie
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },

    //End changes for W-004683 By Himani

    //Added by Diksha for W-4255
    getAppRecordTypeId: function (component, event, helper) {
        var action = component.get("c.getApplicationrecordtypeId");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationRecordTypeId = response.getReturnValue();
                console.log("applicationRecordTypeId" + JSON.stringify(applicationRecordTypeId));
                if (applicationRecordTypeId != null) {
                    component.set("v.recordTypeId", applicationRecordTypeId);
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

    //Added by Diksha for W-4255

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

    //Added by Diksha for W-4255

    getAppDetails: function (component, event, helper) {
        var action = component.get("c.saveAppDetails");
        var applicationRecid = component.get("v.applicationRecordId");

        action.setParams({
            Signedat: component.find("Signedat").get("v.value"),
            Signedon: component.find("Signedon").get("v.value"),
            globalapplicationform: component.find("globalapplicationform").get("v.value"),
            StandardAbsaresolutionforyou: component.find("StandardAbsaresolutionforyou").get("v.value"),
            Absamandateandindemnity: component.find("Absamandateandindemnity").get("v.value"),
            StandardAbsasitevisitforyou: component.find("StandardAbsasitevisitforyou").get("v.value"),
            StandardAbsapowerofattorneyforyou: component.find("StandardAbsapowerofattorneyforyou").get("v.value"),
            Recordoftelephonicengagement: component.find("Recordoftelephonicengagement").get("v.value"),
            Arealltherelatedparties: component.find("Arealltherelatedparties").get("v.value"),
            Istheremorethanonenaturalperson: component.find("Istheremorethanonenaturalperson").get("v.value"),
            ForeignExchangeAuthorityFormforyou: component.find("ForeignExchangeAuthorityFormforyou").get("v.value"),
            applicationId: applicationRecid,
            forWhom: component.find("forWhom").get("v.value")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationDetails = response.getReturnValue();
                console.log("applicationdetails" + JSON.stringify(applicationDetails));
                // component.set("v.applicationRecordId",applicationDetails.id );
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type: "success",
                    message: "The Record Saved Successfully"
                });
                toastEvent.fire();
            } else if (state === "INCOMPLETE") {
                console.log("Error message: " + errors[0].message);
                //cmp.set('v.showSpinner', true);
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

    //Added by Diksha for W-4257
    getsitevisitDetails: function (component, event, helper) {
        // start Tinashe
        var verify;
        if (component.get("v.showverifyaddress") === true) verify = component.find("verifyaddress").get("v.value");
        else verify = "";
        // end Tinashe
        var action = component.get("c.saveSiteVisitDetails");
        var applicationRecid = component.get("v.applicationRecordId");

        action.setParams({
            settlementtype: component.find("settlementtype").get("v.value"),
            sitevisitdate: component.find("sitevisitdate").get("v.value"),
            addresstype: component.find("addresstype").get("v.value"),
            firstname: component.find("firstname").get("v.value"),
            surname: component.find("surname").get("v.value"),
            completedby: component.find("completedby").get("v.value"),
            applicationId: applicationRecid,
            verifyaddressP: verify //Manoj
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var sitevisitDetails = response.getReturnValue();
                console.log("sitevisitDetails" + JSON.stringify(sitevisitDetails));
                component.set("v.applicationRecordId", sitevisitDetails.Id);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type: "success",
                    message: "The Record Saved Successfully"
                });
                toastEvent.fire();
            } else if (state === "INCOMPLETE") {
                console.log("Error message: " + errors[0].message);
                //cmp.set('v.showSpinner', true);
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

    getResolutionDetails: function (component, event, helper) {
        var action = component.get("c.saveResolutionDetails");
        var applicationRecid = component.get("v.applicationRecordId");

        action.setParams({
            individualsisareauthorisedtoact: component.find("individualsisareauthorisedtoact").get("v.value"),
            applicationId: applicationRecid
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resolutionDetails = response.getReturnValue();
                console.log("resolutionDetails" + JSON.stringify(resolutionDetails));
                component.set("v.applicationRecordId", resolutionDetails.Id);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type: "success",
                    message: "The Record Saved Successfully"
                });
                toastEvent.fire();
            } else if (state === "INCOMPLETE") {
                console.log("Error message: " + errors[0].message);
                //cmp.set('v.showSpinner', true);
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

    getAppRecorddetails: function (component, event, helper) {
        var action = component.get("c.getApplicationRecordDetails");
        action.setParams({ oppId: component.get("v.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationRecordDetail = response.getReturnValue();
                console.log("applicationRecordDetail" + JSON.stringify(applicationRecordDetail));
                if (applicationRecordDetail != null && applicationRecordDetail != "") {
                    component.set("v.applicationRecordDetail", applicationRecordDetail);
                    var sitevisitvalue = component.get("v.applicationRecordDetail.Standard_Absa_site_visit_for_you__c");
                    console.log(sitevisitvalue);
                    var resolutionvalue = component.get("v.applicationRecordDetail.Standard_Absa_resolution_for_you__c");

                    if (sitevisitvalue == "YES" || resolutionvalue == "YES") {
                        component.set("v.showsitevisit", true);
                        component.set("v.showResolution", true);
                    } else {
                        component.set("v.showsitevisit", false);
                        component.set("v.showResolution", false);
                    }

                    //if (applicationRecordDetail.Completed_By__r != null && applicationRecordDetail.Completed_By__r != "")
                    //    component.set("v.employeenumber", applicationRecordDetail.Completed_By__r.EmployeeNumber);

                    /* console.log(showvalue);
                console.log("showvalue"+JSON.stringify(showvalue));*/
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

    //W-005661 - Anka Ganta - 2020-09-19
    getPrimayClientMandatoryDocs: function (component) {
        var Entitytype = component.get("v.opportunityRecord.Entity_Type__c");
        var OppId = component.get("v.recordId");
        var documentsUploaded = component.get("v.documentsUploaded");
        console.log("documentsUploaded" + documentsUploaded);
        var action = component.get("c.getPrimaryClientMandatoryDocuments");
        action.setParams({
            Entitytype: Entitytype,
            OppId: OppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respmsg = response.getReturnValue();
                component.set("v.PrimaryClientMandDocs", respmsg);
                console.log("respmsg " + JSON.stringify(respmsg));
                console.log("length " + respmsg.length);
                if ((respmsg != null) & (respmsg.length >= 1)) {
                    var errormsgs = "";
                    var i;
                    for (i in respmsg) {
                        errormsgs += respmsg[i] + ";";
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: "error",
                        title: "",
                        message: errormsgs
                    });
                    toastEvent.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Success!",
                        message: " primary client mandatory documents has been uploaded successfully.",
                        type: "success"
                    });
                    toastEvent.fire();
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    fetchActiveUser: function (component, event, helper) {
        var myAction = component.get("c.getActiveUser");
        myAction.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.AbsaUserID", response.getReturnValue());
            }
        });
        $A.enqueueAction(myAction);
    },
    fetchRelatedParties: function (component, event, helper) {
        var myAction = component.get("c.getRelatedParties");
        var recordId = component.get("v.recordId");
        myAction.setParams({
            oppId: recordId
        });

        myAction.setCallback(this, function (response) {
            //debugger;
            var resultData = response.getReturnValue();
            if (response.getState() === "SUCCESS") {
                console.log("callsList" + resultData[0]);
                var data = component.set("v.conlist", resultData);
            }
        });
        $A.enqueueAction(myAction);
    },

    getCallReportList: function (component, event, helper) {
        component.set("v.mycolumn", [
            { label: "Person Spoken", fieldName: "WhoId", type: "text" },
            { label: "Call Duration", fieldName: "Duration_of_Call_in_Minutes__c", type: "text" },
            { label: "Number Dialled", fieldName: "Number_Dialled__c", type: "number" },
            { label: "Extension Dailed", fieldName: "Extension_Dailed_From__c", type: "text" },
            { label: "Description", fieldName: "Description", type: "text" }
        ]);

        var myAction = component.get("c.getCallReport");
        var recordId = component.get("v.recordId");
        myAction.setParams({
            oppId: recordId
        });

        myAction.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.callsList", response.getReturnValue());
            }
        });
        $A.enqueueAction(myAction);
    },
    /* Added by Prashanth Boeni */
    fetchOppRecordTypeName: function (component) {
        var action = component.get("c.getRecordTypeName");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data == true) {
                    component.set("v.isCAFApplication", data);
                }
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    isItAnOpp: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.isItAnOpportunity");
        action.setParams({
            OppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("dateeee" + data);
                component.set("v.oppBoolean", data);
            } else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
            if (component.get("v.oppBoolean") == true) {
                this.fetchPersonAccs(component);
                this.getAppId(component);
                this.getAppRecorddetails(component);
                this.getCallReportList(component);
                this.fetchRelatedParties(component);
            }
        });
        $A.enqueueAction(action);
    },

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

    sortData: function(cmp, event,dtName) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var DATA = cmp.get(dtName);
        var cloneData = DATA.slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));

        cmp.set(dtName, cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    },
    getDocumentData : function (component, event, docId)  {
        //alert(docId);
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocumentContent");
        action.setParams({
            "documentId": docId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('PDF DATA '+data);
                component.set("v.pdfData", data);
                component.set("v.isShowPreview",true);
            }
            else {
                console.log("Failed with state: " + state);
                var errors = response.getError();
                console.log('errors '+JSON.stringify(errors));
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    deleteDocument : function(component, event,docId) {
        component.set("v.showSpinner", true);
        var action = component.get("c.deleteDocument");  
        action.setParams({  
            "recordId":component.get("v.recordId"),
            "docId" : docId
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();  
                component.set("v.deleteDocument",result);
            }
            else {
                console.log("Failed with state: " + state);
                var errors = response.getError();
                console.log('errors '+JSON.stringify(errors));
            }
            
        });
        component.set("v.showSpinner", false);
        $A.enqueueAction(action);  
    },
    restrictSystemDocs : function(component, event,docId) {
        var action = component.get("c.restrictSystemDocs");  
        action.setParams({  
            "recordId":component.get("v.recordId"),
            "docId" : docId
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();  
                component.set("v.documentGenerated",result);
                
                if(result == 'System Generated'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Could not delete the system generated documents ",
                        "type":"error"
                    });
                    toastEvent.fire();
                }else{
                    this.deleteDocument(component, event,docId);
                }
                
            }else {
                console.log("Failed with state: " + state);
                var errors = response.getError();
                console.log('errors '+JSON.stringify(errors));
            }
        });  
        $A.enqueueAction(action);  
    },
    
    //Added by chandra dated 24/08/2021 for preview functionality
    handlePreviewDocument: function (component, event, helper, row) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocumentContent");
        action.setParams({
            documentId: row.Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    component.set("v.pdfData",data);
                    component.set("v.isShowPreview", true);
                } else {
                    console.log("Preview failed ...");
                }
                component.set("v.showSpinner", false);
            })
        );
        $A.enqueueAction(action);
    },
    
    //Changes by chandra dated 24/08/2021 against W-012497
    sendEmailHelper: function (component, event, helper) {
        console.log('Inside sendEmailHelper');
        var action = component.get("c.sendEmail");
        var effectiveDate = new Date();
        effectiveDate.setDate(effectiveDate.getDate() + 5);
        console.log(component.get("v.recordId")+' : '+component.get("v.emailAddress")+' : '+component.get("v.documentTemplateName")+' : '+component.get("v.pdfData"));
        action.setParams({
            opportunityId: component.get("v.recordId"),
            emailTemplate: 'VoiceContract',
            emailAddress: component.get("v.emailAddress"),
            fileName: component.get("v.documentTemplateName") + '_' + $A.localizationService.formatDate(effectiveDate, "yyyyMMdd"),
            pdfData: component.get("v.pdfData")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state : '+state);
            if (state === "SUCCESS") {
                helper.showToast("Success!", "success", "Voice Contract emailed successfully!");
                component.set("v.pdfData", null);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in caseCloseHelper method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in caseCloseHelper method. State: " + state);
            }
        });
        $A.enqueueAction(action);
    },
	
    //Changes by chandra against W-012497
    oppurtunityCloseHelper: function (component, event, helper) {
        component.find("acceptButton").set("v.disabled",true);
        component.set("v.isShowSpinner", true);
        var action = component.get("c.opportunityStatusUpdate");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnResponse = response.getReturnValue();
                if (returnResponse == "success") {
                    helper.showToast("Success!", "success", "Opportunity has been successfully closed!");
               		$A.get('e.force:refreshView').fire();
                } else {
                    component.set("v.errorMessage", "Opportunity could not be closed. Error: " + returnResponse);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in oppurtunityCloseHelper method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in oppurtunityCloseHelper method. State: " + state);
            }

            component.find("acceptButton").set("v.disabled",false);
            component.set("v.isShowSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    
    //Changes by chandra against W-012497
    showToast: function (title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            type: type,
            message: message
        });
        toastEvent.fire();
    },
    
    //Added by chandra dated 24/08/2021 for preview functionality
    captureDocument: function (component, Id) {
        var action = component.get("c.getDocumentContent");
        action.setParams({
            documentId: Id
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    component.set("v.pdfData",data);
                } else {
                    console.log("Capture failed ...");
                }
            })
        );
        $A.enqueueAction(action);
    },
});