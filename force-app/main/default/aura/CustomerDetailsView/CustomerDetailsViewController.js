({
    init : function(component, event, helper)
    {
        helper.setForeignTaxReadOnlyColumns(component);
        helper.loadForeignTaxData(component);
        helper.fetchTranslationValues(component);
        helper.setDate(component);
        helper.setControls(component);
		helper.loadLists(component, helper);
        helper.loadMarketingPicklist(component);
    },

    foreignTaxOptionsChanged : function(component, event, helper) {
        helper.foreignTaxOptionsLoaded(component, helper);
    },

    recordLoaded : function(component, event, helper) {
        if (!component.get("v.submitting")) {
            var payload = event.getParam("recordUi");
            // Personal Information
            helper.loadBackupData(component, "v.clientType", payload.record.fields["Client_Type__c"].value);
            helper.loadBackupData(component, "v.titleMap", payload.record.fields["Titles__pc"].value);
            helper.loadBackupData(component, "v.firstNameMap", payload.record.fields["FirstName"].value);
            helper.loadBackupData(component, "v.lastNameMap", payload.record.fields["LastName"].value);
            helper.loadBackupData(component, "v.iDNumberMap", payload.record.fields["ID_Number__pc"].value);
            helper.loadBackupData(component, "v.dateIssuedMap", payload.record.fields["Date_Issued__pc"].value);
            helper.loadBackupData(component, "v.countryOfBirthMap", payload.record.fields["Country_of_Birth__pc"].value);
            helper.loadBackupData(component, "v.nationalityMap", payload.record.fields["Nationality_List__pc"].value);
            helper.loadBackupData(component, "v.maritalStatusMap", payload.record.fields["Marital_Status__pc"].value);
            helper.loadBackupData(component, "v.maritalTypeMap", payload.record.fields["Marital_Contract_Type__pc"].value);
            helper.loadBackupData(component, "v.homeLanguageMap", payload.record.fields["Home_Language__pc"].value);
            helper.loadBackupData(component, "v.incomeSourceMap", payload.record.fields["Income_Source__pc"].value);
            helper.loadBackupData(component, "v.homeLanguageOtherMap", payload.record.fields["Home_Language_Other__pc"].value);
            // Contact information
            helper.loadBackupData(component, "v.personEmail", payload.record.fields["PersonEmail"].value);
            helper.loadBackupData(component, "v.personOtherPhone", payload.record.fields["PersonOtherPhone"].value);
            helper.loadBackupData(component, "v.communicationLanguage", payload.record.fields["Communication_Language__pc"].value);
            helper.loadBackupData(component, "v.personMobilePhone", payload.record.fields["PersonMobilePhone"].value);
            helper.loadBackupData(component, "v.communicationMethod", payload.record.fields["Preferred_Communication_Method__pc"].value);
            // Address information
            helper.loadBackupData(component, "v.residentialStatus", payload.record.fields["Residential_Status__pc"].value);
            // Marketing Consent
            helper.loadBackupData(component, "v.nonCreditMarketing", payload.record.fields["Non_Credit_Marketing_Consent__pc"].value);
            helper.loadBackupData(component, "v.nonCreditCheck", helper.stringAsListValue(payload.record.fields["Non_Credit_Marketing_Indicator__pc"].value, ";"));
            helper.loadBackupData(component, "v.creditMarketing", payload.record.fields["Credit_Marketing_Consent__pc"].value);
            helper.loadBackupData(component, "v.creditCheck", helper.stringAsListValue(payload.record.fields["Credit_Marketing_Indicator__pc"].value, ";"));
            // Next of Kin
            helper.loadBackupData(component, "v.kinFirstNameMap", payload.record.fields["Next_of_Kin_First_Name_s__pc"].value);
            helper.loadBackupData(component, "v.kinLastNameMap", payload.record.fields["Next_of_Kin_Last_Name__pc"].value);
            helper.loadBackupData(component, "v.kinRelationshipMap", payload.record.fields["Next_of_Kin_Relationship__pc"].value);
            helper.loadBackupData(component, "v.kinCellphoneNumberMap", payload.record.fields["Next_of_Kin_Cellphone_Number__pc"].value);
            helper.loadBackupData(component, "v.kinTelephoneNumberMap", payload.record.fields["Next_of_Kin_Telephone_Number__pc"].value);
            helper.loadBackupData(component, "v.kinEmailAddressMap", payload.record.fields["Next_of_Kin_Email_Address__pc"].value);
            // Employment details
            helper.loadBackupData(component, "v.occupationStatus", payload.record.fields["Occupation_Status__pc"].value);
            helper.loadBackupData(component, "v.occupationLevel", payload.record.fields["Occupation_Level__pc"].value);
            helper.loadBackupData(component, "v.occupationCategory", payload.record.fields["Occupation_Category__pc"].value);
            helper.loadBackupData(component, "v.hasQualification", helper.yesNoUiValue(payload.record.fields["Has_Post_Matric_Qualification__pc"].value));
            helper.loadBackupData(component, "v.qualification", payload.record.fields["Post_Matric_Qualification__pc"].value);
            helper.loadBackupData(component, "v.employerSector", payload.record.fields["Employer_Sector__pc"].value);
            // Employers details
            helper.loadBackupData(component, "v.employerName", payload.record.fields["Employer_Name__pc"].value);
            helper.loadBackupData(component, "v.employerPhone", payload.record.fields["Employer_Phone__c"].value);
            // Tax details
            helper.loadBackupData(component, "v.incomeTaxNumber", payload.record.fields["Income_Tax_Number__pc"].value);
            helper.loadBackupData(component, "v.incomeTaxReason", payload.record.fields["Income_Tax_Number_Reason__pc"].value);
            helper.loadBackupData(component, "v.incomeTax", helper.yesNoUiValue(payload.record.fields["Is_customer_registered_for_income_tax__c"].value));
            helper.loadBackupData(component, "v.foreignTax", helper.yesNoUiValue(payload.record.fields["Is_customer_registered_for_foreign_tax__c"].value));
            component.set("v.recordLoaded", true);
            helper.setMissingData(component, helper);
            helper.checkLoaded(component, helper);
        }
    },

    recordSubmit : function(component, event, helper) {
        component.set("v.submitting", false);
        event.preventDefault();
        var eventFields = event.getParam("fields");
        // Personal Information
        if (component.get("v.showPersonalInformation")) {
            eventFields["Client_Type__c"] = helper.getValueFromMap(component, "v.clientType", "value");
            eventFields["Titles__pc"] = helper.getValueFromMap(component, "v.titleMap", "value");
            eventFields["FirstName"] = helper.getValueFromMap(component, "v.firstNameMap", "value");
            eventFields["LastName"] = helper.getValueFromMap(component, "v.lastNameMap", "value");
            eventFields["ID_Number__pc"] = helper.getValueFromMap(component, "v.iDNumberMap", "value");
            eventFields["Date_Issued__pc"] = helper.getValueFromMap(component, "v.dateIssuedMap", "value");
            eventFields["Country_of_Birth__pc"] = helper.getValueFromMap(component, "v.countryOfBirthMap", "value");
            eventFields["Nationality_List__pc"] = helper.getValueFromMap(component, "v.nationalityMap", "value");
            eventFields["Marital_Status__pc"] = helper.getValueFromMap(component, "v.maritalStatusMap", "value");
            eventFields["Marital_Contract_Type__pc"] = helper.getSubmitValue(helper.getValueFromMap(component, "v.maritalTypeMap", "value"), "", "0");
            eventFields["Home_Language__pc"] = helper.getValueFromMap(component, "v.homeLanguageMap", "value");
            eventFields["Home_Language_Other__pc"] = helper.getValueFromMap(component, "v.homeLanguageOtherMap", "value");
            eventFields["Income_Source__pc"] = helper.getValueFromMap(component, "v.incomeSourceMap", "value");
        }
        // Contact information
        if (component.get("v.showContactInformation")) {
            eventFields["PersonEmail"] = helper.getValueFromMap(component, "v.personEmail", "value");
            eventFields["PersonOtherPhone"] = helper.getValueFromMap(component, "v.personOtherPhone", "value");
            eventFields["Communication_Language__pc"] = helper.getValueFromMap(component, "v.communicationLanguage", "value");
            eventFields["PersonMobilePhone"] = helper.getValueFromMap(component, "v.personMobilePhone", "value");
            eventFields["Preferred_Communication_Method__pc"] = helper.getValueFromMap(component, "v.communicationMethod", "value");
        }
        // Address information
        if (component.get("v.showAddressInformation")) {
            eventFields["Residential_Status__pc"] = helper.getValueFromMap(component, "v.residentialStatus", "value");
        }
        // Marketing Consent
        if (component.get("v.showMarketingConsent")) {
            eventFields["Non_Credit_Marketing_Consent__pc"] = helper.getValueFromMap(component, "v.nonCreditMarketing", "value");
            eventFields["Non_Credit_Marketing_Indicator__pc"] = helper.listAsStringValue(helper.getValueFromMap(component, "v.nonCreditCheck", "value"));
            eventFields["Credit_Marketing_Consent__pc"] = helper.getValueFromMap(component, "v.creditMarketing", "value");
            eventFields["Credit_Marketing_Indicator__pc"] = helper.listAsStringValue(helper.getValueFromMap(component, "v.creditCheck", "value"));
        }
        // Next of Kin
        if (component.get("v.showNextOfKinInformation")) {
            eventFields["Next_of_Kin_First_Name_s__pc"] = helper.getValueFromMap(component, "v.kinFirstNameMap", "value");
            eventFields["Next_of_Kin_Last_Name__pc"] = helper.getValueFromMap(component, "v.kinLastNameMap", "value");
            eventFields["Next_of_Kin_Relationship__pc"] = helper.getValueFromMap(component, "v.kinRelationshipMap", "value");
            eventFields["Next_of_Kin_Cellphone_Number__pc"] = helper.getValueFromMap(component, "v.kinCellphoneNumberMap", "value");
            eventFields["Next_of_Kin_Telephone_Number__pc"] = helper.getValueFromMap(component, "v.kinTelephoneNumberMap", "value");
            eventFields["Next_of_Kin_Email_Address__pc"] = helper.getValueFromMap(component, "v.kinEmailAddressMap", "value");
        }
        // Employment details
        if (component.get("v.showEmploymentInformation")) {
            eventFields["Occupation_Status__pc"] = helper.getValueFromMap(component, "v.occupationStatus", "value");
            eventFields["Occupation_Level__pc"] = helper.getValueFromMap(component, "v.occupationLevel", "value");
            eventFields["Occupation_Category__pc"] = helper.getValueFromMap(component, "v.occupationCategory", "value");
            eventFields["Has_Post_Matric_Qualification__pc"] = helper.yesNoFieldValue(helper.getValueFromMap(component, "v.hasQualification", "value"));
            eventFields["Post_Matric_Qualification__pc"] = helper.getValueFromMap(component, "v.qualification", "value");
            eventFields["Employer_Sector__pc"] = helper.getValueFromMap(component, "v.employerSector", "value");
        }
        // Employers details
        if (component.get("v.showEmployersInformation")) {
            eventFields["Employer_Name__pc"] = helper.getValueFromMap(component, "v.employerName", "value");
            eventFields["Employer_Phone__c"] = helper.getValueFromMap(component, "v.employerPhone", "value");
        }
        // Tax details
        if (component.get("v.showTaxInformation")) {
            eventFields["Income_Tax_Number__pc"] = helper.getValueFromMap(component, "v.incomeTaxNumber", "value");
            eventFields["Income_Tax_Number_Reason__pc"] = helper.getValueFromMap(component, "v.incomeTaxReason", "value");
            eventFields["Is_customer_registered_for_income_tax__c"] = helper.yesNoFieldValue(helper.getValueFromMap(component, "v.incomeTax", "value"));
            eventFields["Is_customer_registered_for_foreign_tax__c"] = helper.yesNoFieldValue(helper.getValueFromMap(component, "v.foreignTax", "value"));
        }
        component.find("CustomerInformation").submit(eventFields);
    },

    recordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        helper.showError(component, errorMessage, JSON.stringify(eventDetails));
		component.set("v.updating", false);
    },

    recordSuccess : function(component, event, helper) {
        var actionClicked = component.get("v.actionClicked");
        switch(actionClicked)
        {
            case "NEXT":
            case "FINISH":
            case "BACK":
            case "PAUSE":
            case "CANCEL":
                helper.componentNavigate(component, helper);
                break;
            case "SAVE":
                helper.checkKycFields(component, helper);
                break;
        }
    },

    dialogSelectionChanged : function(component, event, helper) {
		helper.setDialogSelection(component, helper);
    },

    onEditButtonPressed : function(component, event, helper) {
		helper.setEdit(component);
    },

    maritalStatusChanged : function(component, event, helper) {
		helper.setMaritalStatus(component, helper);
    },

    occupationStatusChange : function(component, event, helper) {
		helper.setOccupationStatus(component, helper);
    },

    checkForEmail : function(component, event, helper) {
        helper.setEmail(component, helper);
    },

    checkMissingData : function(component, event, helper) {
        helper.setMissingData(component, helper);
    },

    postalSelectionChange : function(component, event, helper) {
        var changeValue = event.getParam("value");
        if (changeValue == "Yes") {
            helper.setPostalAddress(component, helper);
        } else {
            helper.enablePostalAddress(component, helper);
        }
    },

    addressChanged : function (component, event, helper) {
        if (component.get("v.postalAddressSame") == "Yes") {
            var changeValue = helper.isAddressSame(component, helper);
            if (changeValue == "No") {
                helper.enablePostalAddress(component, helper);
            }
            component.set("v.postalAddressSame", changeValue);
        }
    },

    hasQualificationChange : function(component, event, helper) {
		helper.setHasQualification(component, helper);
    },

    incomeTaxChange : function(component, event, helper) {
		helper.setIncomeTax(component, helper);
    },

    updateSelectedForeignTax: function (cmp, event) {
        var selectedRows = event.getParam("selectedRows");
        cmp.set("v.selectedRowsCount", selectedRows.length);
    },

    handleRecordEvent : function(component, event, helper) {
        helper.handleRecordEvent(component, event, helper);
    },

    handleNavigate : function(component, event, helper) {
        var actionClicked = event.getParam("action");
        component.set("v.actionClicked", actionClicked);
        component.set("v.updating", true);
        helper.createForeignTaxCVSObject(component, helper, actionClicked);
    },
})