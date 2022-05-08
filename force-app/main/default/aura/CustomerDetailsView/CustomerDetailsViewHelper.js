({
    communicationLanguageOptions : [
        "Afrikaans",
        "English"
    ],

    kycFields : [
        "v.titleMap",
        "v.firstNameMap",
        "v.lastNameMap",
        "v.iDNumberMap"
    ],

    setAvailableActions : function(component) {
        var availableActions = [];
        if (!component.get("v.readOnly")) {
            availableActions = component.get("v.availableActions");
            if(availableActions.length == 0) {
                availableActions.push("SAVE");
                availableActions.push("CANCEL");
                component.set("v.availableActions", availableActions);
            }
        } else {
            component.set("v.availableActions", availableActions);
        }
    },

    setEdit : function(component) {
        component.set("v.updating", true);
        this.setAddressLoaded(component, false);
        component.set("v.firstLoad", false);
        component.set("v.readOnly", false);
    },

    setReadOnly : function(component, helper) {
        this.setAddressLoaded(component, false);
        this.loadForeignTaxData(component);
        if (component.get("v.kycFieldChanged")) {
            component.set("v.submitting", false);
            component.set("v.firstLoad", false);
            component.set("v.readOnly", true);
            component.set("v.startNewFlow", true);
        } else {
            if (component.get("v.caseCreated")) {
                this.updateMaintenanceCase(component, helper, "Closed");
            } else {
                component.set("v.readOnly", true);
            }
        }
    },

    resetUpdate : function(component) {
        component.set("v.spinnerText", "");
        component.set("v.updating", false);
    },

    setAddressLoaded : function(component, loaded) {
        this.addValueToMap(component, "v.residentialAddress", "loaded", loaded);
        this.addValueToMap(component, "v.postalAddress", "loaded", loaded);
        this.addValueToMap(component, "v.employersAddress", "loaded", loaded);
    },

    setMissingData : function(component, helper) {
        helper.clearMissingData(component, helper);
        var missingData = component.get("v.complianceMissingData");
        component.set("v.loadedMissingData", missingData);
        var styleLabel= "missingData-Label";
        var styleBorder= "slds-border_bottom slds-var-p-top_xx-small slds-var-p-bottom_x-small missingData-Border";
        for (var field in missingData) {
            helper.handleMissingDataValidation(component, missingData[field], helper, styleLabel, styleBorder);
        }
    },

    clearMissingData : function(component, helper) {
        var loadedMissingData = component.get("v.loadedMissingData");
        var styleLabel= "";
        var styleBorder= "slds-border_bottom slds-var-p-top_xx-small slds-var-p-bottom_x-small";
        for (var field in loadedMissingData) {
            helper.handleMissingDataValidation(component, loadedMissingData[field], helper, styleLabel, styleBorder);
        }
    },

    handleMissingDataValidation : function(component, componentAuraId, helper, styleLabel, styleBorder) {
        var globalId = component.getGlobalId();
        var componentAuraIdReadOnly = componentAuraId + "ReadOnly";
        helper.documentSetClassAttribute((globalId + "_" + componentAuraIdReadOnly), styleBorder);
        helper.documentSetClassAttribute((globalId + "_" + componentAuraIdReadOnly + "_label"), styleLabel);
        helper.documentSetClassAttribute((globalId + "_" + componentAuraId + "_label"), styleLabel);
    },

    documentSetClassAttribute : function(elementId, styleClass) {
        if(document.getElementById(elementId)) {
            document.getElementById(elementId).setAttribute("class", styleClass);
        }
    },

    setDate : function(component) {
        var today = new Date();
        today.setDate(today.getDate() - 1);
        this.addValueToMap(component, "v.dateIssuedMap", "max", $A.localizationService.formatDate(today, "YYYY-MM-DD"));
    },

    setControls : function(component) {
        var processType = component.get("v.processType");
        if (processType == "Packages") {
            this.addValueToMap(component, "v.titleMap", "disabled", true);
        }
    },

    setMaritalStatus : function(component, helper) {
        if (helper.getValueFromMap(component, "v.maritalStatusMap", "value") == "Married") {
            helper.addValueToMap(component, "v.maritalTypeMap", "disabled", false);
            helper.addValueToMap(component, "v.maritalTypeMap", "required", true);
        } else {
            helper.addValueToMap(component, "v.maritalTypeMap", "value", "0");
            helper.addValueToMap(component, "v.maritalTypeMap", "required", false);
            helper.addValueToMap(component, "v.maritalTypeMap", "disabled", true);
        }
    },

    setOccupationStatus : function(component, helper) {
		var valueMaps = ["v.occupationLevel", "v.occupationCategory", "v.employerSector", "v.employerName", "v.employerPhone"];
        var fields = ["street", "street2", "suburb", "city", "code", "province", "country"];

		if (helper.checkOccupationStatus(component, helper)) {
			helper.setValueToMap(component, helper, valueMaps, "required", true);
			helper.setValueToMap(component, helper, valueMaps, "disabled", false);
            helper.addValueToMap(component, "v.employersAddress", "disabled", false);
		} else {
			helper.setValueToMap(component, helper, valueMaps, "value", "");
			helper.setValueToMap(component, helper, valueMaps, "required", false);
			helper.setValueToMap(component, helper, valueMaps, "disabled", true);
            for (var field in fields) {
                helper.addValueToMap(component, "v.employersAddress", fields[field], "");
            }
            helper.addValueToMap(component, "v.employersAddress", "disabled", true);
		}
    },

    setPostalAddress : function(component, helper) {
        var fields = ["street", "street2", "suburb", "city", "code", "province", "country"];
        for (var field in fields) {
            helper.addValueToMap(component, "v.postalAddress", fields[field], helper.getValueFromMap(component, "v.residentialAddress", fields[field]));
        }
        helper.addValueToMap(component, "v.postalAddress", "readOnly", true);
    },

    enablePostalAddress : function(component, helper) {
        helper.addValueToMap(component, "v.postalAddress", "readOnly", false);
    },

    setEmail : function(component, helper) {
        if (helper.getValueFromMap(component, "v.communicationMethod", "value") == "Email")
        {
            helper.addValueToMap(component, "v.personEmail", "required", true);
        } else {
            helper.addValueToMap(component, "v.personEmail", "required", false);
        }
    },

    setHasQualification : function(component, helper) {
		var hasQualification = helper.getValueFromMap(component, "v.hasQualification", "value");
		if (hasQualification == "No") {
			helper.addValueToMap(component, "v.qualification", "value", null);
		}
    },

    setIncomeTax : function(component, helper) {
		var incomeTax = this.getValueFromMap(component, "v.incomeTax", "value");
		if (incomeTax == "No") {
			helper.addValueToMap(component, "v.incomeTaxNumber", "value", "");
            helper.addValueToMap(component, "v.incomeTaxReason", "value", "");
		}
    },

    setValueToMap : function(component, helper, valueMaps, mapKey, mapValue) {
        for (var vMap in valueMaps) {
			helper.addValueToMap(component, valueMaps[vMap], mapKey, mapValue);
        }
    },

    loadBackupData : function(component, fieldMap, payloadValue) {
        this.addValueToMap(component, fieldMap, "value", payloadValue);
        this.addValueToMap(component, fieldMap, "backupValue", payloadValue);
        this.addValueToMap(component, fieldMap, "kycValue", payloadValue);
    },

    checkBackupData : function(component) {
        var fieldMaps = ["v.clientType","v.titleMap","v.firstNameMap","v.lastNameMap","v.iDNumberMap","v.dateIssuedMap","v.countryOfBirthMap",
        "v.nationalityMap","v.maritalStatusMap","v.maritalTypeMap","v.homeLanguageMap","v.incomeSourceMap","v.homeLanguageOtherMap",
        "v.personEmail","v.personOtherPhone","v.communicationLanguage","v.personMobilePhone","v.communicationMethod","v.nonCreditMarketing",
        "v.nonCreditCheck","v.creditMarketing","v.creditCheck","v.residentialStatus","v.kinFirstNameMap","v.kinLastNameMap","v.kinRelationshipMap","v.kinCellphoneNumberMap",
        "v.kinTelephoneNumberMap","v.kinEmailAddressMap","v.occupationStatus","v.occupationLevel","v.occupationCategory","v.hasQualification","v.qualification",
        "v.employerSector","v.employerName","v.employerPhone","v.incomeTaxNumber","v.incomeTaxReason","v.incomeTax","v.foreignTax"
    ];
        for (var fieldMap in fieldMaps) {
            var fieldValue = this.getValueFromMap(component, fieldMaps[fieldMap], "value");
            var backupValue = this.getValueFromMap(component, fieldMaps[fieldMap], "backupValue");
            if (fieldValue != backupValue) {
                this.addValueToMap(component, fieldMaps[fieldMap], "value", backupValue);
            }
        }
    },

    fetchTranslationValues : function(component) {
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "IndividualCustomertype", "Account", "Client_Type__c"), "v.clientTypeOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Titles", "Account", "Titles__pc"), "v.titleOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Maritstat", "Account", "Marital_Status__pc"), "v.maritalStatusOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Marrcontype", "Account", "Marital_Contract_Type__pc"), "v.maritalContractTypeOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Casa Country", "Account", "Country_of_Birth__pc"), "v.countryOfBirthOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Nationality", "Account", "Nationality_List__pc"), "v.nationalityOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Lang", "Account", "Home_Language__pc"), "v.homeLanguageOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Sofsoi", "Account", "Income_Source__pc"), "v.incomeSourceOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Prefcomms", "Account", "Preferred_Communication_Method__pc"), "v.communicationMethodOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Residential Status", "Account", "Residential_Status__pc"), "v.residentialStatusOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Nextofkinrelationship", "Account", "Next_of_Kin_Relationship__pc"), "v.relationshipOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Emplstatus", "Account", "Occupation_Status__pc"), "v.occupationStatusOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Occulvl", "Account", "Occupation_Level__pc"), "v.occupationLevelOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Occucode", "Account", "Occupation_Category__pc"), "v.occupationCategoryOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Postmatq", "Account", "Post_Matric_Qualification__pc"), "v.qualificationOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Emplsector", "Account", "Employer_Sector__pc"), "v.employerSectorOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "ReasonSATaxNotGiven", "Account", "Income_Tax_Number_Reason__pc"), "v.incomeTaxReasonOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Casa Country", "IdentityDocument", "Issuing_Country__c"), "v.foreignTaxCountryOptions");
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "ReasonSATaxNotGiven", "IdentityDocument", "Reason_Not_Provided__c"), "v.foreignTaxReasonOptions");
    },

    loadLists : function(component, helper) {
        component.set("v.communicationLanguageOptions", helper.communicationLanguageOptions);
        component.set("v.hasQualificationOptions", helper.getYesNoOptions(helper));
        component.set("v.postalAddressOptions", helper.getYesNoOptions(helper));
        component.set("v.incomeTaxOptions", helper.getYesNoOptions(helper));
        component.set("v.foreignTaxOptions", helper.getYesNoOptions(helper));
        component.set("v.nonCreditMarketingOptions", helper.getYesNoOptions(helper));
        component.set("v.creditMarketingOptions", helper.getYesNoOptions(helper));
        component.set("v.kycFieldList", helper.kycFields);
    },

    loadMarketingPicklist : function(component) {
        this.callApex(component, "c.getCreditConsent", null, this.setCreditMarketingPicklist);
        this.callApex(component, "c.getNonCreditConsent", null, this.setNonCreditMarketingPicklist);
    },

    setCreditMarketingPicklist : function(component, returnValue) {
        if(returnValue){
            returnValue = Object.values(returnValue);
            var resultValue = returnValue.filter(function (e) {return e != "Mail" && e != "Phone" && e != "Voice Recording";});
            this.selectMarketingValues(component, resultValue, "v.creditMarketingIndicators");
        }
    },

    setNonCreditMarketingPicklist : function(component, returnValue) {
        if(returnValue){
            returnValue = Object.values(returnValue);
            var resultValue = returnValue.filter(function (r) {return r != "Mail" && r != "Phone"  && r != "Call" && r != "Telephone";});
            this.selectMarketingValues(component, resultValue, "v.nonCreditMarketingIndicators");
        }
    },

    selectMarketingValues : function(component, resultValue, viewList) {
        var indicators = [];
        for(var key in resultValue){
            indicators.push({label: resultValue[key], value: resultValue[key]});
        }
        component.set(viewList, indicators);
    },

    setForeignTaxReadOnlyColumns : function(component) {
        component.set('v.taxReadOnlyColumns', [
            { label: 'Country', fieldName: 'Issuing_Country__c', type: 'text' },
            { label: 'Tax number', fieldName: 'Document_Data__c', type: 'text' },
            { label: 'Reason not given', fieldName: 'Reason_Not_Provided__c', type: 'text' }
        ]);
    },

    loadForeignTaxData : function(component) {
        var recordId = component.get("v.recordId");
        this.callApex(component, "c.getForeignTaxData", { recordId: recordId }, this.setForeignTaxData);
    },

    setForeignTaxData : function(component, returnValue) {
        if(returnValue){
            component.set("v.foreignTaxData", returnValue);
        }
    },

    foreignTaxOptionsLoaded : function(component, helper) {
        var countryOptions = component.get("v.foreignTaxCountryOptions");
        var reasonOptions = component.get("v.foreignTaxReasonOptions");
        if ((countryOptions.length > 0 && reasonOptions.length > 0)) {
            helper.removeForeignTaxOption(component, helper);
            helper.setupForeignTaxTable(component);
        }
    },

    removeForeignTaxOption : function(component, helper) {
        var removeKey = "";
        var countryOptions = component.get("v.foreignTaxCountryOptions");
        for(var optionKey in countryOptions) {
            if (countryOptions[optionKey] == "South Africa") {
                removeKey = optionKey;
            }
        }
        if (removeKey != "") {
            countryOptions.splice(removeKey, 1);
            component.set("v.foreignTaxCountryOptions", countryOptions);
        }
    },

    setupForeignTaxTable : function(component) {
        var countryOptions = [];
        Object.entries(component.get("v.foreignTaxCountryOptions")).forEach(([key, value]) => countryOptions.push({label:value,value:value}));
        var reasonOptions = [];
        Object.entries(component.get("v.foreignTaxReasonOptions")).forEach(([key, value]) => reasonOptions.push({label:value,value:value}));
        var taxColumns = [
            {label: "Country", fieldName: "Issuing_Country__c", editable: true, type:"picklist", selectOptions:countryOptions},
            {label: "Tax number", fieldName: "Document_Data__c", editable: true },
            {label: "Reason not given", fieldName: "Reason_Not_Provided__c", editable: true, type:"picklist", selectOptions:reasonOptions},
        ];
        component.set("v.foreignTaxColumns", taxColumns);
    },

    checkOccupationStatus : function(component, helper) {
        switch (helper.getValueFromMap(component, "v.occupationStatus", "value")) {
            case "Housewife":
            case "Student":
            case "Unemployed":
            case "Pensioner":
            case "Pre-School/Scholar":
				return false;
            default:
				return true;
        }
    },

    checkLoaded : function(component, helper) {
        var residentialLoaded = true;
        var postalLoaded = true;
        var employersLoaded = true;
        if (component.get("v.showAddressInformation")) {
            residentialLoaded = this.getValueFromMap(component, "v.residentialAddress", "loaded");
            postalLoaded = this.getValueFromMap(component, "v.postalAddress", "loaded");
        }
        if (component.get("v.showEmployersInformation")) {
            employersLoaded = this.getValueFromMap(component, "v.employersAddress", "loaded");
        }

        if (component.get("v.recordLoaded") && residentialLoaded && postalLoaded && employersLoaded) {
            helper.setAvailableActions(component);
            component.set("v.postalAddressSame", helper.isAddressSame(component, helper));
            if (!component.get("v.firstLoad")) {
                component.set("v.firstLoad", true);
                helper.resetUpdate(component);
            }
        }
    },

    isAddressSame : function(component, helper) {
        var fields = ["street", "street2", "suburb", "city", "code", "province", "country"];
        var postalAddressSame = "Yes";
        for (var field in fields) {
            if (helper.getValueFromMap(component, "v.residentialAddress", fields[field]) != helper.getValueFromMap(component, "v.postalAddress", fields[field])) {
                postalAddressSame = "No";
            }
        }
        if (postalAddressSame == "Yes") {
            helper.addValueToMap(component, "v.postalAddress", "readOnly", true);
        }
        return postalAddressSame;
    },

    saveAddress : function(component, helper) {
        var globalId = component.getGlobalId();
        if (component.get("v.showAddressInformation")) {
            var addressComponent = component.find("residentialAddress");
            addressComponent.SubmitAddress();
        } else if (component.get("v.showEmployersInformation")) {
            var addressComponent = component.find("employersAddress");
            addressComponent.SubmitAddress();
        } else {
            document.getElementById(globalId + "_information_submit").click();
        }
    },

    loadAddressKyc : function(component, helper) {
        var fields = ["street", "street2", "suburb", "city", "code", "province", "country"];
        for (var field in fields) {
            helper.addValueToMap(component, "v.residentialAddressKyc", fields[field], helper.getValueFromMap(component, "v.residentialAddress", fields[field]))
        }
    },

    handleRecordEvent : function(component, event, helper) {
        var globalId = component.getGlobalId();
        var eventName = event.getParam("eventName");
        var eventData = event.getParam("eventData");
        var errorMessage = event.getParam("errorMessage");
        var eventDetails = event.getParam("eventDetails");
        switch (eventName) {
            case "RecordLoaded":
                if (!component.get("v.submitting")) {
                    if (eventData == helper.getValueFromMap(component, "v.residentialAddress", "type")) {
                        helper.addValueToMap(component, "v.residentialAddress", "loaded", true);
                        helper.loadAddressKyc(component, helper);
                    }
                    if (eventData == helper.getValueFromMap(component, "v.postalAddress", "type")) {
                        helper.addValueToMap(component, "v.postalAddress", "loaded", true);
                    }
                    if (eventData == helper.getValueFromMap(component, "v.employersAddress", "type")) {
                        helper.addValueToMap(component, "v.employersAddress", "loaded", true);
                    }
                    helper.checkLoaded(component, helper);
                }
                break;
            case "RecordError":
                helper.showError(component, errorMessage, JSON.stringify(eventDetails));
                component.set("v.submitting", false);
                helper.resetUpdate(component);
                break;
            case "RecordSuccess":
                if (eventData == this.getValueFromMap(component, "v.residentialAddress", "type")) {
                    var addressComponent = component.find("postalAddress");
                    addressComponent.SubmitAddress();
                } else if (eventData == this.getValueFromMap(component, "v.postalAddress", "type")) {
                    if (component.get("v.showEmployersInformation")) {
                        var addressComponent = component.find("employersAddress");
                        addressComponent.SubmitAddress();
                    } else {
                        document.getElementById(globalId + "_information_submit").click();
                    }
                } else if (eventData == this.getValueFromMap(component, "v.employersAddress", "type")) {
                    document.getElementById(globalId + "_information_submit").click();
                }
                break;
        }
    },

    checkValidity : function(component, helper) {
        component.set("v.spinnerText", "Validating...");
        var returnValue = "pass";
        var validateFields = [];
        // Personal Information
        if (component.get("v.showPersonalInformation")) {
            validateFields = helper.validatePersonalInformation(component, validateFields);
        }
        // Contact information
        if (component.get("v.showContactInformation")) {
            validateFields = helper.validateContactInformation(validateFields);
        }
        // Marketing Consent
        if (component.get("v.showMarketingConsent")) {
            validateFields = helper.validateMarketingConsent(component, validateFields);
        }
        // Address information
        if (component.get("v.showAddressInformation")) {
            validateFields.push("ResidentialStatus");
            if (component.find("residentialAddress").validate() != "pass") {
                returnValue = "fail";
            }
            if (component.get("v.postalAddressSame") == "No") {
                if (component.find("postalAddress").validate() != "pass") {
                    returnValue = "fail";
                }
            }
        }
        // Next of Kin
        if (component.get("v.showNextOfKinInformation")) {
            validateFields = helper.validateNextOfKinInformation(validateFields);

            this.removeValidation(component,"NextofKinCellphoneNumber");
            var pattern = new RegExp(this.getValueFromMapNullCheck(component, "v.personMobilePhone", "value"));
            if (this.getValueFromMapNullCheck(component, "v.kinCellphoneNumberMap", "value").match(pattern)){
                this.addValidation(component, "NextofKinCellphoneNumber", "CELLPHONE CAN NOT BE THE SAME AS CUSTOMER CELLPHONE.");
                returnValue = "fail";
            }
        }
        // Employment details
        if (component.get("v.showEmploymentInformation")) {
            validateFields = helper.validateEmploymentDetails(component, helper, validateFields);
        }
        // Employers details
        if (component.get("v.showEmployersInformation")) {
            validateFields = helper.validateEmployersDetails(component, helper, validateFields);
            if (helper.checkOccupationStatus(component, helper)) {
                if (component.find("employersAddress").validate() != "pass") {
                    returnValue = "fail";
                }
            }
        }
        // Tax details
        if (component.get("v.showTaxInformation")) {
            validateFields = helper.validateTaxDetails(validateFields);
            this.removeValidation(component,"foreignTaxDataTable");
            if (this.getValueFromMap(component, "v.foreignTax", "value") == "Yes") {
                if (component.find("foreignTaxDataTable").verityTaxData() != "pass") {
                    returnValue = "fail";
                }
            }
        }
        // Validate
        for (var fieldId in validateFields) {
            if (!this.isValid(component, validateFields[fieldId])) {
                returnValue = "fail";
            }
        }
        return returnValue;
    },

    validatePersonalInformation : function(component, validateFields) {
        var validFields = [ "title", "fullName", "LastName", "IdNumber", "DateIdIssued", "countryOfBirth", "nationality", "MaritalStatus", "HomeLanguage", "SourceOfIncome" ];
        if (this.getValueFromMap(component, "v.maritalStatusMap", "value") == "Married") {
            validFields.push("MaritalContractType");
        }
        if (this.getValueFromMap(component, "v.homeLanguageMap", "value") == "Other") {
            validFields.push("HomeLanguageOther");
        }
        for (var fieldId in validFields) {
            validateFields.push(validFields[fieldId]);
        }
        return validateFields;
    },

    validateContactInformation : function(validateFields) {
        var validFields = [ "PersonEmail", "PersonOtherPhone", "CommunicationLanguage", "PersonMobilePhone", "PreferredCommunicationMethod" ];
        for (var fieldId in validFields) {
            validateFields.push(validFields[fieldId]);
        }
        return validateFields;
    },

    validateMarketingConsent : function(component, validateFields) {
		var validFields = [ "nonCreditMarketingGroup", "CreditMarketingGroup" ];
        if (this.getValueFromMap(component, "v.nonCreditMarketing", "value") == "No") {
            validFields.push("nonCreditCheckBoxGroup");
        }
        if (this.getValueFromMap(component, "v.creditMarketing", "value") == "Yes") {
            validFields.push("CreditCheckBoxGroup");
        }
        for (var fieldId in validFields) {
            validateFields.push(validFields[fieldId]);
        }
        return validateFields;
    },

    validateNextOfKinInformation : function(validateFields) {
		var validFields = [ "NextofKinFirstName", "NextofKinLastName", "NextofKinRelationship", "NextofKinCellphoneNumber", "NextofKinTelephoneNumber", "NextofKinEmailAddress" ];
        for (var fieldId in validFields) {
            validateFields.push(validFields[fieldId]);
        }
        return validateFields;
    },

    validateEmploymentDetails : function(component, helper, validateFields) {
        var validFields = [ "OccupationStatus", "HasPostMatricQualificationRadioGroup" ];
        if (helper.checkOccupationStatus(component, helper)) {
            validFields.push("OccupationLevel");
            validFields.push("OccupationCategory");
            validFields.push("Industry");
        }
        if (this.getValueFromMap(component, "v.hasQualification", "value") == "Yes") {
            validFields.push("PostMatricQualification");
        } else {
            this.addValueToMap(component, 'v.qualification', 'value', "");
        }
        for (var fieldId in validFields) {
            validateFields.push(validFields[fieldId]);
        }
        return validateFields;
    },

    validateEmployersDetails : function(component, helper, validateFields) {
        var validFields = [];
        if (helper.checkOccupationStatus(component, helper)) {
            validFields.push("EmployerName");
            validFields.push("EmployerPhone");
        }
        for (var fieldId in validFields) {
            validateFields.push(validFields[fieldId]);
        }
        return validateFields;
    },

    validateTaxDetails : function(validateFields) {
		var validFields = [ "IncomeTaxRadioGroup", "ForeignTaxRadioGroup" ];
        for (var fieldId in validFields) {
            validateFields.push(validFields[fieldId]);
        }
        return validateFields;
    },

    getFieldsToValidate : function(component, helper) {
        var fieldsValidation = [];
        var sectionFields = [];
        // Personal information
        if (component.get("v.showPersonalInformation")) {
            sectionFields = helper.getPersonalInformationFields(component);
            fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
        }
        // Contact information
        if (component.get("v.showContactInformation")) {
            sectionFields = helper.getContactInformationFields(component);
            fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
        }
        // Marketing Consent
        if (component.get("v.showMarketingConsent")) {
            sectionFields = helper.getMarketingConsentFields(component);
            fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
        }
        // Address information
        if (component.get("v.showAddressInformation")) {
            sectionFields = helper.getAddressInformationFields(component);
            fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
        }
        // Next of Kin
        if (component.get("v.showNextOfKinInformation")) {
            sectionFields = helper.getNextOfKinFields(component);
            fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
        }
        // Employment details
        if (component.get("v.showEmploymentInformation")) {
            sectionFields = helper.getEmploymentInformationFields(component, helper);
            fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
        }
        // Employers details
        if (component.get("v.showEmployersInformation")) {
            sectionFields = helper.getEmployersInformationFields(component, helper);
            fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
        }
        // Tax details
        if (component.get("v.showTaxInformation")) {
            sectionFields = helper.getTaxInformationFields(component);
            fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
            var foreignTaxCVSData = component.get("v.foreignTaxCVSData");
            if ((this.getValueFromMap(component, "v.foreignTax", "value") == "Yes") && (foreignTaxCVSData)) {
                sectionFields = helper.getForeignTaxInformationFields(foreignTaxCVSData);
                fieldsValidation = helper.addFieldsToValidate(fieldsValidation, sectionFields);
            }
        }
        return fieldsValidation;
    },

    addFieldsToValidate : function(fieldsValidation, sectionFields) {
        for (var fieldId in sectionFields) {
            fieldsValidation.push(sectionFields[fieldId]);
        }
        return fieldsValidation;
    },

    getPersonalInformationFields : function(component) {
        return [
            {Value: this.getValueFromMap(component, "v.titleMap", "value"), CMPField: "title", ServiceField: "titleCode"},
            {Value: this.getValueFromMap(component, "v.firstNameMap", "value"), CMPField:"fullName", ServiceField: "firstNames" },
            {Value: this.getValueFromMap(component, "v.lastNameMap", "value"), CMPField:"LastName", ServiceField: "surname" },
            {Value: this.getValueFromMap(component, "v.iDNumberMap", "value"), CMPField:"IdNumber", ServiceField: "idNumber" },
            {Value: $A.localizationService.formatDate(this.getValueFromMap(component, "v.dateIssuedMap", "value"), "YYYYMMDD").toString(), CMPField:"DateIdIssued", ServiceField: "dateIdDocIssued" },
            {Value: this.getValueFromMap(component, "v.countryOfBirthMap", "value"), CMPField:"countryOfBirth", ServiceField: "countryOfBirthCode" },
            {Value: this.getValueFromMap(component, "v.nationalityMap", "value"), CMPField:"nationality", ServiceField: "clientNationalityCode" },
            {Value: this.getValueFromMap(component, "v.maritalStatusMap", "value"), CMPField:"MaritalStatus", ServiceField: "maritalStatusCode" },
            {Value: this.getValueFromMap(component, "v.homeLanguageMap", "value"), CMPField:"HomeLanguage", ServiceField: "homeLanguageCode" },
            {Value: this.getValueFromMap(component, "v.incomeSourceMap", "value"), CMPField:"SourceOfIncome", ServiceField: "sourceOfIncomeCode" }
        ];
    },

    getContactInformationFields : function(component) {
        var otherPhoneValue = this.getValueFromMap(component, "v.personOtherPhone", "value");
        var otherPhoneCode = "0";
        var otherPhone = "0";
        if ((!$A.util.isUndefinedOrNull(otherPhoneValue)) && (otherPhoneValue != "" )) {
            var otherPhoneCode = otherPhoneValue.substring(0, 3);
            var otherPhone = otherPhoneValue.substring(3, 10);
        }
        return [
            {Value: this.getSubmitValue(this.getValueFromMap(component, "v.personEmail", "value"), ""), CMPField:"PersonEmail", ServiceField: "emailAddress"},
            {Value: otherPhone, CMPField: "PersonOtherPhone", ServiceField: "homeFaxOrAlternativeNumber"},
            {Value: otherPhoneCode, CMPField: "PersonOtherPhone", ServiceField: "homeFaxOrAlternativeNumDialCode"},
            {Value: this.getValueFromMap(component, "v.communicationLanguage", "value"), CMPField: "CommunicationLanguage", ServiceField: "commLanguageCode"},
            {Value: this.getValueFromMap(component, "v.personMobilePhone", "value"), CMPField: "PersonMobilePhone", ServiceField: "cellphoneNumber"},
            {Value: this.getValueFromMap(component, "v.communicationMethod", "value"), CMPField: "PreferredCommunicationMethod", ServiceField: "preferredCommMethodCode"},
        ];
    },

	getMarketingConsentFields : function(component) {
        var nonCredit = this.getValueFromMap(component, "v.nonCreditCheck", "value");
        var credit = this.getValueFromMap(component, "v.creditCheck", "value");

        if (!Array.isArray(nonCredit)) {
            nonCredit = nonCredit.split(";");
        }
        if (!Array.isArray(credit)) {
            credit = credit.split(";");
        }

        var nonCreditMarketingGroup = this.yesNoServiceValue(this.getValueFromMap(component, "v.nonCreditMarketing", "value"));
        var nonCreditMarketingSms = "N";
        var nonCreditMarketingEmail = "N";
        var nonCreditMarketingAutoVoice = "N";
        var nonCreditMarketingTelephone = "N";
        var nonCreditMarketingPost = "N";

        var creditMarketingGroup = this.yesNoServiceValue(this.getValueFromMap(component, "v.creditMarketing", "value"));
        var creditMarketingSms = "N";
        var creditMarketingEmail = "N";
        var creditMarketingAutoVoice = "N";
        var creditMarketingTelephone = "N";
        var creditMarketingPost = "N";

        if (nonCreditMarketingGroup == "Y") {
            var nonCreditMarketingSms = "Y";
            var nonCreditMarketingEmail = "Y";
            var nonCreditMarketingAutoVoice = "Y";
            this.addValueToMap(component, 'v.nonCreditCheck', 'value', "Email;SMS;Voice Recording");
        } else {
            if (nonCredit.includes("No thanks")) {
                nonCreditMarketingGroup = "N";
            } else {
                nonCreditMarketingGroup = "Y";
                if (nonCredit.includes("SMS")) {
                    nonCreditMarketingSms = "Y";
                }
                if (nonCredit.includes("Email")) {
                    nonCreditMarketingEmail = "Y";
                }
                if (nonCredit.includes("Voice Recording")) {
                    nonCreditMarketingAutoVoice = "Y";
                }
                if (nonCredit.includes("Telephone")) {
                    nonCreditMarketingTelephone = "Y";
                }
                if (nonCredit.includes("Mail")) {
                    nonCreditMarketingPost = "Y";
                }
            }
        }

        if (creditMarketingGroup == "Y") {
            if (credit.includes("SMS")) {
                creditMarketingSms = "Y";
            }
            if (credit.includes("Email")) {
                creditMarketingEmail = "Y";
            }
            if (credit.includes("Voice Recording")) {
                creditMarketingAutoVoice = "Y";
            }
            if (credit.includes("Telephone")) {
                creditMarketingTelephone = "Y";
            }
            if (credit.includes("Mail")) {
                creditMarketingPost = "Y";
            }
        } else {
            this.addValueToMap(component, 'v.creditCheck', 'value', "");
        }

        return [
            {Value: nonCreditMarketingGroup, CMPField: "nonCreditMarketingGroup", ServiceField: "nonCreditMarketingGroupInd"},
            {Value: creditMarketingGroup, CMPField:"CreditMarketingGroup", ServiceField: "creditMarketingGroupInd" },

            {Value: nonCreditMarketingSms, CMPField:"nonCreditCheckBoxGroup", ServiceField: "nonCreditMarketingSmsInd" },
            {Value: nonCreditMarketingEmail, CMPField:"nonCreditCheckBoxGroup", ServiceField: "nonCreditMarketingEmailInd" },
            {Value: nonCreditMarketingAutoVoice, CMPField:"nonCreditCheckBoxGroup", ServiceField: "nonCreditMarketingAutoVoiceInd" },
            {Value: nonCreditMarketingTelephone, CMPField:"nonCreditCheckBoxGroup", ServiceField: "nonCreditMarketingTelephoneInd" },
            {Value: nonCreditMarketingPost, CMPField:"nonCreditCheckBoxGroup", ServiceField: "nonCreditMarketingPostInd" },

            {Value: creditMarketingSms, CMPField:"creditCheckBoxGroup", ServiceField: "creditMarketingSmsInd" },
            {Value: creditMarketingEmail, CMPField:"creditCheckBoxGroup", ServiceField: "creditMarketingEmailInd" },
            {Value: creditMarketingAutoVoice, CMPField:"creditCheckBoxGroup", ServiceField: "creditMarketingAutoVoiceInd" },
            {Value: creditMarketingTelephone, CMPField:"creditCheckBoxGroup", ServiceField: "creditMarketingTelephoneInd" },
            {Value: creditMarketingPost, CMPField:"creditCheckBoxGroup", ServiceField: "creditMarketingPostInd" },
        ];
    },

    getAddressInformationFields : function(component) {
        return [
            {Value: this.getValueFromMap(component, "v.residentialStatus", "value"), CMPField: "ResidentialStatus", ServiceField: "residentialStatusCode"},
            {Value: this.getValueFromMap(component, "v.residentialAddress", "street"), CMPField: "ResidentialStreet", ServiceField: "physicalAddrLine1"},
            {Value: this.getSubmitValue(this.getValueFromMap(component, "v.residentialAddress", "street2"), ""), CMPField: "ResidentialStreet2", ServiceField: "physicalAddrLine2"},
            {Value: this.getValueFromMap(component, "v.residentialAddress", "suburb"), CMPField: "ResidentialSuburb", ServiceField: "physicalSuburb"},
            {Value: this.getValueFromMap(component, "v.residentialAddress", "city"), CMPField: "ResidentialCity", ServiceField: "physicalTown"},
            {Value: this.getValueFromMap(component, "v.residentialAddress", "code"), CMPField: "ResidentialPostalCode", ServiceField: "physicalRsaPostalCode"},
            {Value: this.getValueFromMap(component, "v.residentialAddress", "country"), CMPField: "residentialCountry", ServiceField: "countryOfPhysicalAddrCode"},
            {Value: this.getValueFromMap(component, "v.postalAddress", "street"), CMPField: "PostalStreet", ServiceField: "postalAddrLine1"},
            {Value: this.getSubmitValue(this.getValueFromMap(component, "v.postalAddress", "street2"), ""), CMPField: "PostalStreet2", ServiceField: "postalAddrLine2"},
            {Value: this.getValueFromMap(component, "v.postalAddress", "suburb"), CMPField: "PostalSuburb", ServiceField: "postalSuburb"},
            {Value: this.getValueFromMap(component, "v.postalAddress", "city"), CMPField: "PostalCity", ServiceField: "postalTown"},
            {Value: this.getValueFromMap(component, "v.postalAddress", "code"), CMPField: "PostalPostalCode", ServiceField: "postalAddrRsaCode"},
        ];
    },

	getNextOfKinFields : function(component) {
        return [
            {Value: this.getValueFromMap(component, "v.kinFirstNameMap", "value"), CMPField: "NextofKinFirstName", ServiceField: "nextOfkinFirstname"},
            {Value: this.getValueFromMap(component, "v.kinLastNameMap", "value"), CMPField:"NextofKinLastName", ServiceField: "nextOfkinSurname" },
            {Value: this.getValueFromMap(component, "v.kinRelationshipMap", "value"), CMPField:"NextofKinRelationship", ServiceField: "nextOfkinRelationCode" },
            {Value: this.getValueFromMap(component, "v.kinCellphoneNumberMap", "value"), CMPField:"NextofKinCellphoneNumber", ServiceField: "nextOfKinCellNumber" },
            {Value: this.getSubmitValue(this.getValueFromMap(component, "v.kinTelephoneNumberMap", "value"), ""), CMPField:"NextofKinTelephoneNumber", ServiceField: "nextOfkinHomeTelNumber" },
            {Value: this.getSubmitValue(this.getValueFromMap(component, "v.kinEmailAddressMap", "value"), ""), CMPField:"NextofKinEmailAddress", ServiceField: "nextOfKinEmail" }
        ];
    },

    getEmploymentInformationFields : function(component, helper) {
		if (!this.checkOccupationStatus(component, helper)) {
			return [
				{Value: this.getValueFromMap(component, "v.occupationStatus", "value"), CMPField: "OccupationStatus", ServiceField: "occupationStatusCode"},
				{Value: this.yesNoServiceValue(this.getValueFromMap(component, "v.hasQualification", "value")), CMPField:"HasPostMatricQualificationRadioGroup", ServiceField: "postMatricQualificationInd"},
				{Value: this.getValueFromMap(component, "v.qualification", "value"), CMPField:"PostMatricQualification", ServiceField: "postMatricQualificationCode"},
			];
		} else {
			return [
				{Value: this.getValueFromMap(component, "v.occupationStatus", "value"), CMPField: "OccupationStatus", ServiceField: "occupationStatusCode"},
				{Value: this.getValueFromMap(component, "v.occupationLevel", "value"), CMPField: "OccupationLevel", ServiceField: "occupationLevelCode"},
				{Value: this.yesNoServiceValue(this.getValueFromMap(component, "v.hasQualification", "value")), CMPField:"HasPostMatricQualificationRadioGroup", ServiceField: "postMatricQualificationInd"},
				{Value: this.getSubmitValue(this.getValueFromMap(component, "v.qualification", "value"), "0", ""), CMPField:"PostMatricQualification", ServiceField: "postMatricQualificationCode"},
				{Value: this.getValueFromMap(component, "v.occupationCategory", "value"), CMPField: "OccupationCategory", ServiceField: "occupationCode"},
				{Value: this.getValueFromMap(component, "v.employerSector", "value"), CMPField: "Industry", ServiceField: "employmentSectorCode"},
			];
		}
    },

    getEmployersInformationFields : function(component, helper) {
		if (!this.checkOccupationStatus(component, helper)) {
			return [];
		} else {
			var employerPhoneValue = this.getValueFromMap(component, "v.employerPhone", "value");
			var employerPhoneCode = "0";
			var employerPhone = "0";
			if ((!$A.util.isUndefinedOrNull(employerPhoneValue)) && (employerPhoneValue != "" )) {
				var employerPhoneCode = employerPhoneValue.substring(0, 3);
				var employerPhone = employerPhoneValue.substring(3, 10);
			}
			return [
				{Value: this.getValueFromMap(component, "v.employerName", "value"), CMPField: "EmployerName", ServiceField: "employerName"},
				{Value: employerPhone, CMPField: "EmployerPhone", ServiceField: "workTelephoneNumber"},
				{Value: employerPhoneCode, CMPField: "EmployerPhone", ServiceField: "workTelephoneDialcode"},
                {Value: this.getValueFromMap(component, "v.employersAddress", "street"), CMPField: "EmployersStreet", ServiceField: "employerAddrLine1"},
                {Value: this.getValueFromMap(component, "v.employersAddress", "suburb"), CMPField: "EmployersSuburb", ServiceField: "employerSuburb"},
                {Value: this.getValueFromMap(component, "v.employersAddress", "city"), CMPField: "EmployersCity", ServiceField: "employerTown"},
                {Value: this.getValueFromMap(component, "v.employersAddress", "code"), CMPField: "EmployersPostalCode", ServiceField: "employerRsaPostalCode"},
			];
		}
    },

    getTaxInformationFields : function(component) {
        return [
            {Value: this.yesNoServiceValue(this.getValueFromMap(component, "v.incomeTax", "value")), CMPField: "IncomeTaxRadioGroup", ServiceField: "saTaxRegisteredInd"},
            {Value: this.getSubmitValue(this.getValueFromMap(component, "v.incomeTaxNumber", "value"), "0", ""), CMPField: "IncomeTaxNumber", ServiceField: "saTaxNumber"},
            {Value: this.getSubmitValue(this.getValueFromMap(component, "v.incomeTaxReason", "value"), ""), CMPField: "ReasonSaTaxNotGiven", ServiceField: "reasonSaTaxNotGivenCode"},
            {Value: this.yesNoServiceValue(this.getValueFromMap(component, "v.foreignTax", "value")), CMPField: "ForeignTaxRadioGroup", ServiceField: "foreignTaxRegisteredInd"},
        ];
    },

    getForeignTaxInformationFields : function(foreignTaxData) {
        return [
            {Value: foreignTaxData, CMPField:"foreignTaxDataTable", ServiceField: "foreignTaxDataTable" },
        ];
    },

    showError : function(component, heading, message) {
        component.set("v.heading", heading);
        component.set("v.message", message);
        component.set("v.dialogShowYesNo", false);
        component.set("v.showDialog", true);
    },

    showDialog : function(component, heading, message) {
        component.set("v.heading", heading);
        component.set("v.message", message);
        component.set("v.dialogShowYesNo", true);
        component.set("v.showDialog", true);
    },

    setDialogSelection : function(component, helper) {
        if (component.get("v.actionClicked") == "PAUSE") {
            if (component.get("v.dialogSelection") == "Yes" ) {
                helper.componentNavigate(component, helper);
             }
        }
        component.set("v.dialogSelection", '');
    },

    checkKycFields : function(component, helper) {
        component.set("v.spinnerText", "Checking Know Your Customer Data");
        var kycFields = component.get("v.kycFieldList");
        var kycChanged = "";
        for (var fieldId in kycFields) {
            var fieldValue = this.getValueFromMap(component, kycFields[fieldId], "value");
            fieldValue = $A.util.isUndefinedOrNull(fieldValue) ? "" : fieldValue;
            var kycValue = this.getValueFromMap(component, kycFields[fieldId], "kycValue");
            kycValue = $A.util.isUndefinedOrNull(kycValue) ? "" : kycValue;
            if (fieldValue != kycValue) {
                kycChanged = helper.checkKycSection(kycChanged, "ID");
            }
        }
        helper.checkKycAddress(component, helper, kycChanged);
    },

    checkKycAddress : function(component, helper, kycChanged) {
        var caseRecord = component.get("v.maintenanceCase");
        var kycFieldChanged = kycChanged == "" ? false : true;
        var fields = ["street", "street2", "suburb", "city", "code", "province", "country"];
        for (var field in fields) {
            var fieldValue = helper.getValueFromMap(component, "v.residentialAddress", fields[field]);
            fieldValue = $A.util.isUndefinedOrNull(fieldValue) ? "" : fieldValue;
            var kycValue = helper.getValueFromMap(component, "v.residentialAddressKyc", fields[field]);
            kycValue = $A.util.isUndefinedOrNull(kycValue) ? "" : kycValue;
            if (fieldValue != kycValue) {
                kycFieldChanged = true;
                kycChanged = helper.checkKycSection(kycChanged, "ADDRESS");
            }
        }
        if (kycFieldChanged) {
            component.set("v.kycFieldChanged", kycFieldChanged);
            this.callApex(component, "c.getProcessDetails", { caseRecord: caseRecord, onboardingMode: kycChanged }, this.setKycSelectedProcess, helper);
        } else {
            helper.createOrUpdateCIF(component, helper);
        }
    },

    checkKycSection : function(kycChanged, kycSection) {
        switch(kycChanged)
        {
            case "":
                kycChanged = kycSection;
                break;
            case "ID":
                if (kycSection == "ADDRESS") {
                    kycChanged = "BOTH";
                }
                break;
            case "ADDRESS":
                if (kycSection == "ID") {
                    kycChanged = "BOTH";
                }
                break;
            case "BOTH":
                break;
        }
        return kycChanged;
    },

    setKycSelectedProcess : function(component, returnValue, helper) {
        if(returnValue){
            component.set("v.selectedProcess", JSON.parse(returnValue));
            this.componentNavigate(component, helper);
        }
    },

    saveForeignTaxData : function(component, helper) {
        component.set("v.spinnerText", "Saving Information");
        component.set("v.submitting", true);
        if (component.get("v.showTaxInformation")) {
            var data = component.get("v.foreignTaxData");
            if (this.getValueFromMap(component, "v.foreignTax", "value") == "Yes") {
                helper.callApexPromise(component, "c.updateTaxDocuments", { jsonString: JSON.stringify(data) })
                .then(
                    $A.getCallback(function(returnValue) {
                        var deleteData = component.get("v.foreignTaxDeleteData");
                        if (!$A.util.isUndefinedOrNull(deleteData)) {
                            helper.deleteForeignTaxData(component, helper, JSON.stringify(deleteData));
                        } else {
                            helper.saveAddress(component, helper);
                        }
                    }),
                    $A.getCallback(function(error) {
                        helper.showError(component, "Error calling ApexPromise: c.updateTaxDocuments", error);
                        helper.resetUpdate(component);
                    })
                )
            } else {
                helper.checkForeignTaxData(component, helper);
            }
        } else {
            helper.saveAddress(component, helper);
        }
    },

    checkForeignTaxData : function(component, helper) {
        var foreignTaxData = component.get("v.foreignTaxData");
        var deleteTaxData = [];
        var deleteAdded = false;
        if (!$A.util.isUndefinedOrNull(foreignTaxData)) {
            foreignTaxData.forEach(function(value, index) {
                if (!$A.util.isUndefinedOrNull(value.Id)) {
                    deleteTaxData.push(foreignTaxData[index]);
                    deleteAdded = true;
                }
            });
        }
        if (deleteAdded) {
            helper.deleteForeignTaxData(component, helper, JSON.stringify(deleteTaxData));
        } else {
            helper.saveAddress(component, helper);
        }
    },

    deleteForeignTaxData : function(component, helper, jsonString) {
        helper.callApexPromise(component, "c.deleteTaxDocuments", { jsonString: jsonString })
        .then(
            $A.getCallback(function(returnValue) {
                helper.saveAddress(component, helper);
            }),
            $A.getCallback(function(error) {
                helper.showError(component, "Error calling ApexPromise: c.deleteTaxDocuments", error);
                helper.resetUpdate(component);
            })
        )
    },

    createForeignTaxCVSObject : function(component, helper, actionClicked) {
        var foreignTaxData = component.get("v.foreignTaxData");
        if (component.get("v.showTaxInformation") && (this.getValueFromMap(component, "v.foreignTax", "value") == "Yes") && (foreignTaxData) && (actionClicked != "CANCEL")) {
            component.set("v.spinnerText", "Creating CVS Data Objects");
            this.callApexPromise(component, "c.getForeignTaxCVSData", { jsonString: JSON.stringify(foreignTaxData) })
            .then(
                $A.getCallback(function(returnValue) {
                    component.set("v.foreignTaxCVSData", returnValue);
                    helper.navigateAfterCVSObject(component, helper);
                }),
                $A.getCallback(function(error) {
                    helper.showError(component, "Error calling ApexPromise: c.getForeignTaxCVSData", error);
                    helper.resetUpdate(component);
                })
            )
        } else {
            this.navigateAfterCVSObject(component, helper);
        }
    },

    navigateAfterCVSObject : function(component, helper) {
        var actionClicked = component.get("v.actionClicked");
        switch(actionClicked)
        {
            case "NEXT":
            case "FINISH":
            case "BACK":
            case "PAUSE":
            case "CANCEL":
                helper.handleNavigate(component, helper);
                break;
            case "SAVE":
                helper.createMaintenanceCase(component, helper);
                break;
        }
    },

    createMaintenanceCase : function(component, helper) {
        if (!component.get("v.caseCreated")) {
            component.set("v.spinnerText", "Creating Maintenance Case");
            var recordId = component.get("v.recordId");
            helper.callApexPromise(component, "c.createMaintenanceCase", { recordId: recordId })
            .then(
                $A.getCallback(function(returnValue) {
                    component.set("v.maintenanceCase", returnValue);
                    component.set("v.caseCreated", true);
                    helper.handleNavigate(component, helper);
                }),
                $A.getCallback(function(error) {
                    helper.showError(component, "Error calling ApexPromise: c.createMaintenanceCase", error);
                    helper.resetUpdate(component);
                })
            )
        } else {
            helper.handleNavigate(component, helper);
        }
    },

    updateMaintenanceCase : function(component, helper, caseStatus) {
        component.set("v.spinnerText", "Updating Maintenance Case");
        var caseRecord = component.get("v.maintenanceCase");
        helper.callApexPromise(component, "c.updateMaintenanceCase", { caseRecord: caseRecord, caseStatus: caseStatus })
        .then(
            $A.getCallback(function(returnValue) {
                component.set("v.maintenanceCase", returnValue);
                component.set("v.caseCreated", false);
                component.set("v.submitting", false);
                component.set("v.firstLoad", false);
                component.set("v.readOnly", true);
            }),
            $A.getCallback(function(error) {
                helper.showError(component, "Error calling ApexPromise: c.updateMaintenanceCase", error);
                helper.resetUpdate(component);
            })
        )
    },

    createOrUpdateCIF : function(component, helper) {
        component.set("v.spinnerText", "Updating CIF");
        var recordId = component.get("v.recordId");
        helper.callApexPromise(component, "c.createOrUpdate", { objId: recordId })
        .then(
            $A.getCallback(function(returnValue) {
				if (returnValue == "Success") {
					helper.componentNavigate(component, helper);
				} else {
                    helper.showError(component, "Error calling ApexPromise: c.createOrUpdate", returnValue);
                    helper.componentNavigate(component, helper);
				}
            }),
            $A.getCallback(function(error) {
                helper.showError(component, "Error calling ApexPromise: c.createOrUpdate", error);
                helper.componentNavigate(component, helper);
            })
        )
    },

	handleNavigate : function(component, helper) {
        switch(component.get("v.actionClicked"))
        {
            case "NEXT":
            case "FINISH":
            case "SAVE":
                if (this.checkValidity(component, helper) == "pass") {
                    component.set("v.spinnerText", "Running CVS Validations");
                    helper.handleRemoveValidation(component, component.get("v.errorMap"));
                    var recordId = component.get("v.recordId");
                    var validateFields = this.getFieldsToValidate(component, helper);
                    helper.callApexPromise(component, "c.validateFields", { accountID: recordId, fieldsToValidate: validateFields })
                    .then(
                        $A.getCallback(function(returnValue) {
                            if (returnValue["Response"]) {
                                helper.saveForeignTaxData(component, helper);
                            } else {
                                component.set("v.errorMap", returnValue);
                                helper.resetUpdate(component);
                                helper.handleAddValidation(component, component.get("v.errorMap"));
                            }
                        }),
                        $A.getCallback(function(error) {
                            helper.showError(component, "Error calling ApexPromise: c.validateFields", error);
                            helper.resetUpdate(component);
                        })
                    )
                } else {
                    helper.resetUpdate(component);
                }
                break;
            case "BACK":
            case "PAUSE":
                if (this.checkValidity(component, helper) == "pass") {
                    helper.saveForeignTaxData(component, helper);
                } else {
                    helper.resetUpdate(component);
                    helper.showDialog(component, "Please Note", "Validation failed! Continue without saving?");
                }
                break;
            case "CANCEL":
                this.checkBackupData(component);
                this.componentNavigate(component, helper);
                break;
        }
    },

	componentNavigate : function(component, helper) {
		var actionClicked = component.get("v.actionClicked");
        switch(component.get("v.actionClicked"))
        {
            case "NEXT":
            case "FINISH":
            case "BACK":
            case "PAUSE":
                helper.resetUpdate(component);
                var navigate = component.get("v.navigateFlow");
                if (navigate != null) {
                    navigate(actionClicked);
                } else {
                    alert("NavigateFlow was not found!");
                }
                break;
            case "SAVE":
            case "CANCEL":
                component.set("v.spinnerText", "");
                component.set("v.firstLoad", false);
                this.setReadOnly(component, helper);
                break;
        }
    },
})