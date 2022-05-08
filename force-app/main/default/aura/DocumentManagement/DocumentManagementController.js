({
    doInit: function (component, event, helper) {
        helper.isItAnOpp(component); // are we working with an Opportunity?
        //Added By Rajesh START
        var applicationRecordArray = component.get("v.applicationRecordArray");
        var appRec = {
            rowNumber: "1",
            firstName: "",
            sirName: "",
            idNumber: "",
            email: "",
            phone: "",
            capacity: "",
            selectedAcc: null,
            initial1: "",
            surname1: "",
            initial2: "",
            surname2: ""
        };
        applicationRecordArray.push(appRec);
        component.set("v.applicationRecordArray", applicationRecordArray);
        //Added By Rajesh END
        var actions = [{ label: "Download", name: "download" },
                       { label: 'View Document', name: 'View' },
                       { label: 'Delete', name: 'Delete' }
                       
                      ];
        var columnsAuditActions;
        var action = component.get("c.fetchCaseStage");
        action.setParams({
            "caseId": ''+component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                //alert(data);
                if(data == 'Case Closed'){
                    //alert('INN');
                    columnsAuditActions = [
                        { label: 'Download', name: 'download' },
                        { label: 'View Document', name: 'View' },
                        { label: 'Delete', name: 'Delete',disabled:true }
                        
                    ]; 
                }else{
                    columnsAuditActions = [
                        { label: 'Download', name: 'download' },
                        { label: 'View Document', name: 'View' },
                        { label: 'Delete', name: 'Delete' }
                        
                    ];
                    
                }
                }
            else {
                var errors = response.getError();
                console.log('errors '+JSON.stringify(errors));
            }
            
             component.set("v.columnsAudit", [
                    { label: "Name", fieldName: "Name", type: "text", sortable: true, wrapText: true},
                    { label: "User", fieldName: "ownerName", type: "text", sortable: true, wrapText: true, initialWidth: 150},
                    { label: "Document Type", fieldName: "Type__c", type: "text", sortable: true, wrapText: true },
                    { label: "Document Source", fieldName: "Source_System__c", type: "text", sortable: true, initialWidth: 150 },
                    { label: "Document Status", fieldName: "Document_Status__c", type: "text", sortable: true, initialWidth: 150 },
                    { label: "Document Uploaded For", fieldName: "Contact__c", type: "text", sortable: true, wrapText: true, initialWidth: 220 },
                    {
                        label: "Created Date",
                        fieldName: "CreatedDate",
                        type: "date", initialWidth: 200, sortable: true,
                        typeAttributes: { day: "numeric", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: true }
                    },
                    { type: "action", typeAttributes: { rowActions: columnsAuditActions } }
                ]);
            
        // Added by Prashanth Boeni
        component.set("v.columnsAuditCAF", [
            { label: "Application", fieldName: "Application_Vehicle_Make_Model__c", type: "text" },
            { label: "Name", fieldName: "Name", type: "text" },
            { label: "User", fieldName: "ownerName", type: "text" },
            {
                label: "Created Date",
                fieldName: "CreatedDate",
                type: "date",
                typeAttributes: { day: "numeric", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: true }
            },
            { type: "action", typeAttributes: { rowActions: columnsAuditActions } }
        ]);
            
        });
        $A.enqueueAction(action);
        helper.fetchOppRecordTypeName(component); // Added by Prashanth Boeni
        helper.fetchAuditData(component);
        helper.fetchTemplateTypesPickListVal(component);
        helper.fetchActiveUser(component, event, helper);
    },

    /**
     * @description download function to download file from ECM.
     **/
    download: function (cmp, event, helper) {
        var row = event.getParam("row");
        helper.download(cmp, row);
    },

    getParty: function (component, event, helper) {
        var selectedBillingAccount = component.find("relatedParties").get("v.value");
        component.set("v.selectedValue", selectedBillingAccount);
        component.set("v.PersonSpokenTo", selectedBillingAccount);
        component.set("v.isOpen", true);
    },

    handleRowAction: function (component, event, helper) {
        var idVsIsSalesforceFileMap = component.get("v.idVsIsSalesforceFileMap");
        var docIdVSFileId = component.get("v.docIdVSFileId");
        var action = event.getParam("action");
        var row = event.getParam("row");
        switch (action.name) {
            case "download":
                if(idVsIsSalesforceFileMap[row.Id] == 'No'){
                    helper.download(component, row);
                }else{
                    
                }
                break;
            case 'View':
                //commented because document is not viewed properly
                /*if(idVsIsSalesforceFileMap[row.Id] == 'No'){
                    helper.getDocumentData(component, event, row.Id);
                }else{
                    var fileId = docIdVSFileId[row.Id];
                    //alert('IN' +fileId);
                    $A.get('e.lightning:openFiles').fire({ //Lightning Openfiles event  
                        recordIds: [fileId] //file id  
                    }); 
                }*/
                helper.handlePreviewDocument(component, event, helper, row);
                break;
            case 'Delete':
                var flag = confirm("Are you sure, you want to delete document ?");
                if(flag){
                 helper.restrictSystemDocs(component, event, row.Id);   
                }
                break;
        }
    },

    doGenerate: function (component, event, helper) {
        console.log("signatureRequest : " + component.get("v.signatureRequestRecords"));
        if (component.get("v.fileType") == "") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "To generate a document please select the type of document to generate.",
                type: "error"
            });
            toastEvent.fire();
        } else {
            console.log("doGenerate");
            helper.generateDocument(component, event, helper);
        }
    },

    //Tinashe
    doNewGenerate: function (component, event, helper) {
        console.log("signatureRequest : " + component.get("v.signatureRequestRecords"));
        if (component.get("v.fileType") == "") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "To generate a document please select the type of document to generate.",
                type: "error"
            });
            toastEvent.fire();
        } else {
            console.log("doGenerate");
            helper.generateNewDocument(component, event, helper);
        }
    },
    //end Tinashe

    refreshDocuments: function (component, event, helper) {
        helper.fetchAuditData(component);
        var isCAF = component.get("v.isCAFApplication");
        if (isCAF == false && component.get("v.oppBoolean") == true) {
            helper.checkStage(component);
        }
    },

    handleClickCancel: function (component, event, helper) {
        for (var i in component.find("allFieldId")) {
            var eachField = component.find("allFieldId")[i];
            eachField.set("v.value", null);
        }

        var applicationRecordArray = [];
        var appRec = {
            rowNumber: "1",
            firstName: "",
            sirName: "",
            idNumber: "",
            email: "",
            phone: "",
            capacity: "",
            selectedAcc: null,
            initial1: "",
            surname1: "",
            initial2: "",
            surname2: ""
        };
        applicationRecordArray.push(appRec);
        component.set("v.applicationRecordArray", applicationRecordArray);
    },
    handleClickAdd: function (component, event, helper) {
        var applicationRecordArray = component.get("v.applicationRecordArray");
        var rowNum = applicationRecordArray.length + 1;
        var appRec = {
            rowNumber: rowNum,
            firstName: "",
            sirName: "",
            idNumber: "",
            email: "",
            phone: "",
            capacity: "",
            selectedAcc: null,
            initial1: "",
            surname1: "",
            initial2: "",
            surname2: ""
        };
        applicationRecordArray.push(appRec);
        component.set("v.applicationRecordArray", applicationRecordArray);
    },

    handleRemoveApp: function (component, event, helper) {},

    handleSelectFirstName: function (component, event, helper) {
        var changedRow = event.getSource().get("v.class");
        var selectedFirstName = event.getSource().get("v.value");
        var accList = component.get("v.personAccList");
        console.log("accList " + JSON.stringify(accList));
        var firstName = "";
        var lastName = "";
        var idNumber = "";
        var phone = "";
        var email = "";
        var capacity = "";
        for (var i in accList) {
            console.log(accList[i].Id + " == " + selectedFirstName);
            if (accList[i].Id == selectedFirstName) {
                console.log("accList[i] " + JSON.stringify(accList[i]));
                firstName = accList[i].Contact.FirstName;
                lastName = accList[i].Contact.LastName;
                idNumber = accList[i].Contact.ID_Number__c;
                email = accList[i].Contact.Email;
                phone = accList[i].Contact.Phone;
                capacity = accList[i].Roles;
            }
        }
        console.log("firstName " + firstName);
        console.log("lastName " + lastName);
        console.log("idNumber " + idNumber);
        console.log("email " + email);
        console.log("phone " + phone);
        var applicationRecordArray = component.get("v.applicationRecordArray");
        console.log("applicationRecordArray " + JSON.stringify(applicationRecordArray));
        for (var i in applicationRecordArray) {
            if (applicationRecordArray[i].rowNumber == changedRow) {
                applicationRecordArray[i].firstName = firstName;
                applicationRecordArray[i].sirName = lastName;
                applicationRecordArray[i].idNumber = idNumber != undefined ? idNumber : "";
                applicationRecordArray[i].email = email != undefined ? email : "";
                applicationRecordArray[i].phone = phone != undefined ? phone : "";
                applicationRecordArray[i].capacity = capacity;
            }
        }
        console.log("applicationRecordArray AFTER" + JSON.stringify(applicationRecordArray));
        component.set("v.applicationRecordArray", applicationRecordArray);
    },

    handleClickSave: function (component, event, helper) {
        var applicationRec = component.get("v.applicationRec");
        console.log("applicationRec " + JSON.stringify(applicationRec));
    },

    handleSubmitApp: function (component, event, helper) {
        event.preventDefault(); // stop the form from submittin
        var isValid = true;
        var applicationRecordArray = component.get("v.applicationRecordArray");
        for (var i in applicationRecordArray) {
            if (
                applicationRecordArray[i].initial1 == undefined ||
                applicationRecordArray[i].initial1 == "" ||
                applicationRecordArray[i].initial1 == null ||
                applicationRecordArray[i].surname1 == undefined ||
                applicationRecordArray[i].surname1 == "" ||
                applicationRecordArray[i].surname1 == null ||
                applicationRecordArray[i].initial2 == undefined ||
                applicationRecordArray[i].initial1initial2 == "" ||
                applicationRecordArray[i].initial2 == null ||
                applicationRecordArray[i].surname2 == undefined ||
                applicationRecordArray[i].surname2 == "" ||
                applicationRecordArray[i].surname2 == null
            ) {
                isValid = false;
            }
        }
        if (isValid) {
            var editForms = component.find("applicationRecForm");
            var forms = [].concat(editForms || []);
            //alert(forms.length);
            for (var i in forms) {
                var subForm = forms[i];
                subForm.submit();
            }
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Please fill all required fields",
                type: "error"
            });
            toastEvent.fire();
        }
    },

    handleSuccessApp: function (component, event) {
        var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
        console.log("onsuccess: ", updatedRecord);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            message: "Sign document has submitted.",
            type: "success"
        });
        toastEvent.fire();
        for (var i in component.find("allFieldId")) {
            var eachField = component.find("allFieldId")[i];
            eachField.set("v.value", null);
        }
        var applicationRecordArray = [];
        var appRec = {
            rowNumber: "1",
            firstName: "",
            sirName: "",
            idNumber: "",
            email: "",
            phone: "",
            capacity: "",
            selectedAcc: null,
            initial1: "",
            surname1: "",
            initial2: "",
            surname2: ""
        };
        applicationRecordArray.push(appRec);
        component.set("v.applicationRecordArray", applicationRecordArray);
    },

    //Tdb -  Show or Hide Signatories based on Document Type
    setDocumentTemplate: function (component, event, helper) {
        helper.getSelectDocumentTemplateRecord(component, event, helper);
    },

    setSelectedSignatoreRequests: function (component, event, helper) {
        var eventAccountValue = event.getParam("signatureRequests");
        console.log("DocumentManagement - signatureRequests ; " + eventAccountValue);
        component.set("v.signatureRequestRecords", eventAccountValue);
    },

    submit: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getAppDetails(component, event, helper);
    },

    showSiteVisit: function (component, event, helper) {
        var sitevisit = component.find("StandardAbsasitevisitforyou").get("v.value");
        console.log(sitevisit);
        if (sitevisit == "YES") {
            component.set("v.showsitevisit", true);
        } else {
            component.set("v.showsitevisit", false);
        }
    },
    showTelephonicEngagement: function (component, event, helper) {
        var tel_engagement = component.get("v.showTelephonicEngagementBlock");
        console.log("Tel Engagement :" + tel_engagement);
        if (tel_engagement) {
            component.set("v.showTelephonicEngagementBlock", false);
        } else {
            component.set("v.showTelephonicEngagementBlock", true);
        }
    },
    showIdentificationOfGrantor: function (component, event, helper) {
       var powerOfAttorneyVal = component.find("StandardAbsapowerofattorneyforyou").get("v.value");
       console.log("powerOfAttorneyVal :" + powerOfAttorneyVal);
       if (powerOfAttorneyVal == 'YES') {
           component.set("v.showIdentificationOfGrantorField", true);
       } else {
           component.set("v.showIdentificationOfGrantorField", false);
       }
   },
   submitSiteVisitDetails: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getsitevisitDetails(component, event, helper);
    },
    showResolution: function (component, event, helper) {
        var resoultion = component.find("StandardAbsaresolutionforyou").get("v.value");
        console.log(resoultion);
        if (resoultion == "YES") {
            component.set("v.showResolution", true);
        } else {
            component.set("v.showResolution", false);
        }
    },

    submitResolutionDetails: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getResolutionDetails(component, event, helper);
    },

    showAnnualCreditLimitIncrease: function (component) {
        var debtCounselling = component.find("AnnualCreditLimitIncreaseForYou").get("v.value");
        console.log(debtCounselling);
        if (debtCounselling == "YES") {
            component.set("v.showAnnualCreditLimitIncrease", true);
        } else {
            component.set("v.showAnnualCreditLimitIncrease", false);
        }
    },

    onloadAnnualCreditLimitIncrease: function (component, event, helper) {},

    handleAnnualCreditLimitIncreaseSuccess: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            type: "success",
            message: "Annual Credit Limit Increases details Saved Successfully!"
        });
        toastEvent.fire();
    },

    handleAnnualCreditLimitIncreaseError: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error!",
            type: "error",
            message: "Annual Credit Limit Increases details Save failed!"
        });
        toastEvent.fire();
    },

    showDebtCounselling: function (component) {
        var debtCounselling = component.find("debtCounsellingforyou").get("v.value");
        console.log(debtCounselling);
        if (debtCounselling == "YES") {
            component.set("v.showDebtCounselling", true);
        } else {
            component.set("v.showDebtCounselling", false);
        }
    },

    onloadDebtCounselling: function (component, event, helper) {},
    handleDebtCounsellingSuccess: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            type: "success",
            message: "Debt Counselling details Saved Successfully!"
        });
        toastEvent.fire();
    },

    handleDebtCounsellingError: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error!",
            type: "error",
            message: "Debt Counselling details Save failed!"
        });
        toastEvent.fire();
    },

    showUSPersons: function (component) {
        var usPersons = component.find("USPersonsInfoforyou").get("v.value");
        console.log(usPersons);
        if (usPersons == "YES") {
            component.set("v.showUSPersons", true);
        } else {
            component.set("v.showUSPersons", false);
        }
    },

    onloadUSPersons: function (component, event, helper) {
        var usOtherPersons = component.find("USPerson").get("v.value");
        console.log(usOtherPersons);
        if (usOtherPersons == true) {
            component.set("v.showOtherUSPersons", true);
        } else {
            component.set("v.showOtherUSPersons", false);
        }
    },

    showOtherUSPersons: function (component) {
        var usOtherPersons = component.find("USPerson").get("v.value");
        console.log(usOtherPersons);
        if (usOtherPersons == true) {
            component.set("v.showOtherUSPersons", true);
        } else {
            component.set("v.showOtherUSPersons", false);
        }
    },

    handleUSPersonsSuccess: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            type: "success",
            message: "US Persons details Saved Successfully!"
        });
        toastEvent.fire();
    },

    handleUSPersonsError: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error!",
            type: "error",
            message: "US Persons details Save failed!"
        });
        toastEvent.fire();
    },

    //Manoj - Document Management
    handleAddressVerify: function (component, event, helper) {
        component.set("v.showverifyaddress", true);
        var settlementtype = component.find("settlementtype").get("v.value");
        console.log("settlementtype>>>" + settlementtype);
        if (settlementtype == "INFORMAL SETTLEMENT") {
            component.set("v.showverifyaddress", true);
        } else {
            component.set("v.showverifyaddress", false);
        }
    },

    addCallRecordingDetails: function (component, event, helper) {
        var err = 0;
        var msg = "";
        var oppId = component.get("v.recordId");
        var personSpokenTo = component.get("v.PersonSpokenTo");
        var numberDialled = component.get("v.NumberDialled");
        var callStart = component.get("v.callStart");
        var callEnd = component.get("v.callEnd");
        var extensionDailedFrom = component.get("v.ExtensionDailedFrom");
        var absaUserID = component.get("v.AbsaUserID");
        var briefDescription = component.get("v.BriefDescription");

        if (personSpokenTo == "") {
            err++;
            msg += "\nEnter Person Spoken To";
        }
        if (numberDialled == "") {
            err++;
            msg += "\nEnter Number Dialled";
        }
        if (callStart == "") {
            err++;
            msg += "\nEnter Call Start";
        }
        if (callEnd == "") {
            err++;
            msg += "\nEnter Call End";
        }
        if (extensionDailedFrom == "") {
            err++;
            msg += "\nEnter Extension Dailed From";
        }
        if (absaUserID == "") {
            err++;
            msg += "\nEnter Absa User ID";
        }
        if (briefDescription == "") {
            err++;
            msg += "\nEnter Brief Description";
        }

        if (err == 0) {
            var myAction = component.get("c.addCallReport");
            myAction.setParams({
                oppId: oppId,
                personSpokenTo: personSpokenTo,
                numberDialled: numberDialled,
                callStart: callStart,
                callEnd: callEnd,
                extensionDailedFrom: extensionDailedFrom,
                absaUserID: absaUserID,
                briefDescription: briefDescription
            });
            myAction.setCallback(this, function (response) {
                console.log("data is:" + response.getReturnValue());
                if (response.getState() === "SUCCESS") {
                    helper.fireToast("Success", response.getReturnValue(), "success");
                    helper.getCallReportList(component, event, helper);
                    component.set("v.NumberDialled", "");
                    component.set("v.ExtensionDailedFrom", "");
                    component.set("v.DurationofCallinMinutes", "");
                    component.set("v.BriefDescription", "");
                } else {
                    helper.fireToast("Errors", response.getReturnValue(), "error");
                }
            });
            $A.enqueueAction(myAction);
        } else {
            helper.fireToast("Errors", msg, "error");
        }
    },

    handleSort: function(component, event, helper) {
        helper.sortData(component, event, 'v.dataAudit');
    },
    handleCloseModal: function (component, event, helper) {
        component.set("v.isShowPreview", false);
    },

    //Added by chandra dated 26/07/2021
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            component.set("v.processType",component.get("v.opportunityRecord.Process_Type__c"));
            component.set("v.emailAddress",component.get("v.opportunityRecord.Email__c"));
            console.log('process type: '+component.get("v.processType"));
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    
    //Changes by chandra against W-012497
    handleCheckBoxChange: function(component, event, helper){
   		let checkBoxVal = component.find("consnetCheckBox").get("v.checked");
        if(checkBoxVal){
            component.find("acceptButton").set("v.disabled",false);
        }else{
            component.find("acceptButton").set("v.disabled",true);
        }
	},
    
    //Changes by chandra against W-012497
    handleAccept : function (component, event, helper) {
        helper.oppurtunityCloseHelper(component, event, helper);
        helper.sendEmailHelper(component, event, helper);
    },
});