({
    doInit: function (component, event, helper) {
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
        var actions = [{ label: "Download", name: "download" }];

        component.set("v.columnsAudit", [
            { label: "Name", fieldName: "Name", type: "text" },
            { label: "User", fieldName: "ownerName", type: "text" },
            { label: "Document Uploaded For", fieldName: "Contact__c", type: "text" },
            {
                label: "Created Date",
                fieldName: "CreatedDate",
                type: "date",
                typeAttributes: { day: "numeric", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: true }
            },
            { type: "action", typeAttributes: { rowActions: actions } }
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
            { type: "action", typeAttributes: { rowActions: actions } }
        ]);
        helper.isItAnOpp(component); // are we working with an Opportunity?
        helper.fetchOppRecordTypeName(component); // Added by Prashanth Boeni
        helper.fetchAuditData(component);

        helper.fetchTemplateTypesPickListVal(component);
        if (component.get("v.oppBoolean") == true) {
            //Added by Diksha for Document Prepopulation
            /* 
            helper.getAppId(component, event, helper);
            helper.getAppRecorddetails(component, event, helper);
			*/
        }
        helper.fetchActiveUser(component, event, helper);
        //13225
        var opportunity = component.get("v.opportunityRecord");
        if(component.get("v.opportunityRecord.Business_Unit__c") == 'WIMI'){
         component.set("v.isWealthProduct",true);
        }
        //alert('test67--'+component.get("v.isWealthProduct"));
    },

    /**
     * @description download function to download file from ECM.
     **/
    download: function (cmp, event, helper) {
        var row = event.getParam("row");
        var actionName = event.getParam("action").name;
        helper.download(cmp, row);
    },

    getParty: function (component, event, helper) {
        var currentRec = component.get("v.recordId");
        var selectedBillingAccount = component.find("relatedParties").get("v.value");
        component.set("v.selectedValue", selectedBillingAccount);
        component.set("v.PersonSpokenTo", selectedBillingAccount);
        component.set("v.isOpen", true);
        //var idNbr = component.get("v.IDNumber");
        //var surname = component.get("v.LastName");
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam("action");
        var row = event.getParam("row");
        switch (action.name) {
            case "download":
                helper.download(component, row);
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
            //alert('Generate document code here');
            helper.generateDocument(component, event, helper);
        }
    },

    // Tinashe
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
            //alert('Generate document code here');
            helper.generateNewDocument(component, event, helper);
        }
    },
    // end Tinashe

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
        /*component.find("lastName").set("v.value",null);
        component.find("idNuber").set("v.value",null);
        component.find("emailId").set("v.value",null);
        component.find("phoneNumber").set("v.value",null);
        component.set("v.selectedFirstName",'');*/
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
        //component.set("v.show2Initials",!component.get("v.show2Initials"));
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
        /* component.find("lastName").set("v.value",null);
        component.find("idNuber").set("v.value",null);
        component.find("emailId").set("v.value",null);
        component.find("phoneNumber").set("v.value",null);*/

        var selectedFirstName = event.getSource().get("v.value");
        //helper.fetchRoles(component, event, selectedFirstName,changedRow);
        //alert(selectedFirstName+' == '+changedRow);
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

        /*
        var show2Initials = component.get("v.show2Initials");
        var flag = true;
        for(var i in  component.find("allFieldId")){
            var eachField = component.find("allFieldId")[i];
            if(eachField.get("v.fieldName") == 'Witness_1_initials__c' || eachField.get("v.fieldName") == 'Witness_1_surname__c'){
                if(eachField.get("v.value") == '' || eachField.get("v.value") == undefined || eachField.get("v.value") == null){
                    flag = false;
                }
            }
            if(eachField.get("v.fieldName") == 'Witness_2_initials__c' || eachField.get("v.fieldName") == 'Witness_2_surname__c'){
                if(show2Initials && (eachField.get("v.value") == '' || eachField.get("v.value") == undefined || eachField.get("v.value") == null)){
                    flag = false;
                }
            }
        }
        if(flag){
            component.find('applicationRecForm').submit();
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "Please fill all required fields",
                "type": "error"
            });
            toastEvent.fire();
        }*/
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
        /*component.find("lastName").set("v.value",null);
        component.find("idNuber").set("v.value",null);
        component.find("emailId").set("v.value",null);
        component.find("phoneNumber").set("v.value",null);
        component.set("v.selectedFirstName",'');*/
    },

    //Tdb - Show or Hide Signatories based on Document Type
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
        //var durationofCallinMinutes = component.get("v.DurationofCallinMinutes");
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
        //if(durationofCallinMinutes 	== ''){err++; msg += '\nEnter Duration of Call in Minutes';}
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
                    //component.set("v.PersonSpokenTo","");
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
    //W-13225
    submitPowerOfAttornyDetails: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getPowerOfAttornyDetails(component, event, helper);
    },
     //W-13225
    submitMandateIndemnityDetails: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getMandateIndemnityDetails(component, event, helper);
    },
     //W-13225
    submitForeignNationalDetails: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getForeignNationalDetails(component, event, helper);
    },
     //W-13225
     submitSavingsInvestmentDetails: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getSavingsInvestmentDetails(component, event, helper);
    },
     //W-13225
    submitBankingMandateDetails: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getBankingMandateDetails(component, event, helper);
    },
     //W-13225
    submitElectronicBankingDetails: function (component, event, helper) {
        event.preventDefault(); // stop the form from submitting
        helper.getElectronicBankingDetails(component, event, helper);
    },
     //W-13225
    isAttorneyGiven : function(component, event, helper)
    {
        var attornyGiven = component.find("attorneyGroup").get("v.value");
        //component.set("v.isAdviseGivenBol", adviseGiven);
        //component.find("powerofattorneyGiven").set("v.value", attornyGiven);
        //if(adviseGiven == 'Y'){
        component.set("v.attorneyGiven", attornyGiven);
            //component.set("v.isAdviceGiven", true);
        //}
        //else{
            //component.set("v.adviseGiven", 'N');
            //component.set("v.isAdviceGiven", true);
        //}
    },
    
    
});