({
    doInit: function (component, event, helper) {
        var actions = [
            { label: 'Delete Security Offered', name: 'delete' },
            { label: 'Edit Security Offered', name: 'edit' }
        ];

        component.set('v.securitiesOfferedcolumns', [
            { label: 'Security Provider Name', fieldName: 'NameUrl', type: 'url', wrapText: true, typeAttributes: { label: { fieldName: 'Name' }, target: '_top' } },
            { label: 'Security Type', fieldName: 'Security_Type__c', type: 'text', wrapText: true },
            { label: 'Security Description', fieldName: 'Security_Description__c', type: 'text', wrapText: true },
            { label: 'Security Amount (R)', fieldName: 'securityAmount', type: 'currency' },
            { label: 'Nominal Value (R)', fieldName: 'Nominal_Value__c', type: 'currency' },
            { label: 'ASV %', fieldName: 'ASV_approved_by_Credit__c', type: 'percentage', initialWidth: 34, cellAttributes: { alignment: 'right' } },
            { label: 'ASV (R)', fieldName: 'Approved_security_value__c', type: 'currency' },
            { label: 'Specific Account', fieldName: 'Reference_Account_Number__c', type: 'text' }
            //,
            //{ type: 'action', typeAttributes: { rowActions: actions }}
        ]);

        //added by Manish for W-011371
        component.set('v.newExistingSecuritiesOfferedColumns', [
            { label: 'Agreement Type', fieldName: 'Product_Name__c', type: 'text', wrapText: true },
            { label: 'Unique Identifier', fieldName: 'Temp_Account_Number__c', type: 'text', wrapText: true },
            { label: 'Account Number', fieldName: 'Account_Number__c', type: 'text', wrapText: true },
            { label: 'Limit', fieldName: 'Product_Amount__c', type: 'currency' }
        ]);

        var memId = component.get("v.memberId");
        //Start of changes made by Jason Q - (W-007807)
        //When External Entity is selected the memberId is passed as a String with a space. e.g. " "
        //Therefore we need to check if the length is greater then 1 as well so that we know it was an ID passed or not
        if (!$A.util.isEmpty(memId) && memId.length > 1) {
            component.set("v.hasMemberId", true);
            helper.fetchMemberData(component, event, helper);
        } else {
            component.set("v.hasMemberId", false);
            helper.getApplicationAccIdHelper(component, event, helper);
        }
        helper.getApplicationIdHelper(component, event, helper);
        //End of changes made by Jason Q - (W-007807)
        helper.showSelectedProducts(component);
        helper.getExistingSecuritiesforAccount(component);

        var selectedMemberValue = event.getSource().get("v.selectedMemberValue");
        // console.log('add selectedMemberValue'+ selectedMemberValue);
        component.set("v.Get_Result", selectedMemberValue);

        //Get the event message attribute
        var message = event.getParam("message");
        //Set the handler attributes based on event data
        component.set("v.eventMessage", message);

        helper.getOpportunityApplicationProducts(component, event, helper);
        helper.hideSpinner(component);
        helper.setFocusedTabLabel(component, event, helper);
        helper.getOpportunityUniqueIdentifierss(component);
        helper.getNewExistingSecurities(component, event, helper);//added by Manish for W-011371
    },

    handleRowAction: function (component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        var row = selectedRows[0];
        if (row) {
            switch (row.Security_Type__c) {
                case 'Bonds and 99-year Leasehold':
                    component.set("v.showBondDetails", false);
                    component.set('v.iBondSecRecId', null);
                    component.set('v.iBondSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'newBondSecurity');
                    component.set("v.showBondDetails", true);
                    break;
                case 'Cession of Internal Investments':
                    component.set("v.showInternalDetails", false);
                    component.set('v.iInternalSecRecId', null);
                    component.set('v.iInternalSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'cessionInternalInvestment');
                    component.set("v.showInternalDetails", true);
                    console.log('<<<<<Id is >>>>' + component.get('v.iInternalSecRecId'));
                    break;
                case 'Cession of External Investments':
                    component.set("v.showExternalDetails", false);
                    component.set('v.iExternalSecRecId', null);
                    component.set('v.iExternalSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'cessionExternal');
                    component.set("v.showExternalDetails", true);
                    break;
                case 'Cession of Life Policy (Not Link)':
                    component.set("v.showNotLinkDetails", false);
                    component.set('v.iNotLinkSecRecId', null);
                    component.set('v.iNotLinkSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'notLink');
                    component.set("v.showNotLinkDetails", true);
                    break;
                case 'Cession of Life Policy (Link) (Sanlam)':
                    component.set("v.showLinkDetails", false);
                    component.set('v.iLinkSecRecId', null);
                    component.set('v.iLinkSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'link');
                    component.set("v.showLinkDetails", true);
                    break;
                case 'Suretyship':
                    component.set("v.showSuretyDetails", false);
                    component.set('v.iSuretySecRecId', null);
                    component.set('v.iSuretySecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'suretyShip');
                    component.set("v.showSuretyDetails", true);
                    break;
                case 'General Pledge':
                    component.set("v.showPledgeDetails", false);
                    component.set('v.iPLedgeSecRecId', null);
                    component.set('v.iPLedgeSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'pledge');
                    component.set("v.showPledgeDetails", true);
                    break;
                case 'Cession of Debtors':
                    component.set("v.showDebtorsDetails", false);
                    component.set('v.iDebtorsSecRecId', null);
                    component.set('v.iDebtorsSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'debtors');
                    component.set("v.showDebtorsDetails", true);
                    break;
                case 'Cession of Unit Trusts':
                    component.set("v.showUnitTrustDetails", false);
                    component.set('v.iUnitSecRecId', null);
                    component.set('v.iUnitSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'unitTrusts');
                    component.set("v.showUnitTrustDetails", true);
                    break;
                case 'Cession of Dematerialised Shares':
                    component.set("v.showDematerialisedDetails", false);
                    component.set('v.iDemSecRecId', null);
                    component.set('v.iDemSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'dematerialised');
                    component.set("v.showDematerialisedDetails", true);
                    break;
                case 'Cession of Fire/Short Term Insurance':
                    component.set("v.showFireDetails", false);
                    component.set('v.iFireSecRecId', null);
                    component.set('v.iFireSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'fire');
                    component.set("v.showFireDetails", true);
                    break;
                case 'General Cession':
                    component.set("v.showGeneralDetails", false);
                    component.set('v.iGeneralSecRecId', null);
                    component.set('v.iGeneralSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'genCession');
                    component.set("v.showGeneralDetails", true);
                    break;
                case 'Letter of Undertaking':
                    component.set("v.showLetterDetails", false);
                    component.set('v.iLetterSecRecId', null);
                    component.set('v.iLetterSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'letterUndertaking');
                    component.set("v.showLetterDetails", true);
                    break;
                case 'Excon Ruling':
                    component.set("v.showExconDetails", false);
                    component.set('v.iExconSecRecId', null);
                    component.set('v.iExconSecRecId', row.Id);
                    component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'exconRuling');
                    component.set("v.showExconDetails", true);
                    break;
                default:
                    console.log(row.Security_Type__c + ' is Undefined/unhandled ' + row.Id);
            }
        }
    },

    refreshDocuments: function (component, event, helper) {
        if (!$A.util.isEmpty(memId) && memId.length > 1) {
            component.set("v.hasMemberId", true);
        } else {
            component.set("v.hasMemberId", false);
        }
        helper.getApplicationIdHelper(component, event, helper);
        helper.getExistingSecuritiesforAccount(component);
    },

    getValueFromApplicationEvent: function (component, event) {
        var selectedMemberValue = event.getParam("selectedMemberValue");
        // set the handler attributes based on event data
        component.set("v.Get_Result", selectedMemberValue);
    },

    showBtn: function (component, event, helper) {
        var iTermsAndConditionsField = component.find("iTermsAndConditions");
        var iTermsAndConditionsValue = iTermsAndConditionsField.get("v.value");
        component.set("v.agreeToTerms", iTermsAndConditionsValue);
    },

    closeAddScreen: function (component, event, helper) {
        component.set("v.showMoreDetails", false);
    },

    //methods for calling helper classes for security types

    insertInternalCessionSecurity: function (component, event, helper) {
        var iInternalMaturityDate = component.find("iInternalMaturityDate");
        var errMsg = [];
        if (iInternalMaturityDate) {
            iInternalMaturityDate = Array.isArray(iInternalMaturityDate) ? iInternalMaturityDate[0].get("v.value") : iInternalMaturityDate.get("v.value");
            var todayDate = new Date().toISOString().slice(0, 10);
            if (iInternalMaturityDate < todayDate) {
                errMsg.push("Maturity Date cannot be less than today.");
            }
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
            }
        }
        else {
            helper.insertNewCessionSecurityHelper(component, event, helper);
        }
    },

    insertCessionofDebtors: function (component, event, helper) {
        var idateASVApprovedbyCr = component.find("idateASVApprovedbyCr");
        var errMsg = [];
        if (idateASVApprovedbyCr) {
            idateASVApprovedbyCr = Array.isArray(idateASVApprovedbyCr) ? idateASVApprovedbyCr[0].get("v.value") : idateASVApprovedbyCr.get("v.value");
            var todayDate = new Date().toISOString().slice(0, 10);
            if (idateASVApprovedbyCr > todayDate) {
                errMsg.push("Date ASV % approved by Credit - cannot be greater than today.");
            }
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
            }
        }
        else {
            helper.insertNewCessionofDebtorsHelper(component, event, helper);
        }
    },

    //Handle onchange for Realistic Market Value & Bond Amount.
    //Sets Nominal Value to the less of the 2 variables
    calculateNominalValue: function (component, event, helper) {
        helper.calculateNominalValueHelper(component, event, helper);
    },

    //Handle onchange for Product Type to get the associated ASV%
    calculateASVPercent: function (component, event, helper) {
        helper.calculateASVPercentHelper(component, event, helper);
    },

    //Handle onchange for ASV % Approved by Credit to update the ASV
    recalculateASV: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.mandatory', false);
        if (selectedValues && selectedValues > 0) {
            component.set('v.mandatory', true);
        }
        //Recalculate values using new ASV %
        helper.calculateNominalValueHelper(component, event, helper);
        helper.calculateASVPercentHelper(component, event, helper);
    },

    //Handle onchange for Security Offered for Specific Facility
    displaySpecificEntity: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.displaySpecificEntity", selectedValues);
    },

    //Handle onchange for Facility Stage for Specific Facility
    displayFacilityStateInd: function (component, event, helper) {
        var securityOfferedBonds = component.find("iSecurittOfferedBonds");
        securityOfferedBonds = Array.isArray(securityOfferedBonds) ? securityOfferedBonds[0].get("v.value") : securityOfferedBonds.get("v.value");
        var facilityStateBonds = component.find("iFacilityStateBonds");
        facilityStateBonds = Array.isArray(facilityStateBonds) ? facilityStateBonds[0].get("v.value") : facilityStateBonds.get("v.value");
        if ((securityOfferedBonds && securityOfferedBonds == "Yes") && (facilityStateBonds && facilityStateBonds == "EXISTING")) {
            component.set("v.isNewFacility", false);
        } else if ((securityOfferedBonds && securityOfferedBonds == "Yes") && (facilityStateBonds && facilityStateBonds == "NEW")) {
            component.set("v.isNewFacility", true);
        }
    },

    //Start of changes made by Jason Q - (W-007807)
    //Handle New Security Offered Client Type change
    handleClientTypeChange: function (component, event, helper) {
        var selectedClientType = component.find("clientTypeField").get("v.value");
        component.set("v.isMarried", false);
        if (selectedClientType == "Individual") {
            //Individual
            component.set("v.isBusiness", false);
        } else {
            //Business
            component.set("v.isBusiness", true);
            component.find("maritalStatusField").set("v.value", null);
            component.find("maritalContractTypeField").set("v.value", null);
        }
    },

    //Handle New Security Offered Marital Status change
    handleMaritalStatusChange: function (component, event, helper) {
        var maritalStatus = component.find("maritalStatusField").get("v.value");
        if (maritalStatus == "Married") {
            component.set("v.isMarried", true);
        } else {
            component.set("v.isMarried", false);
            component.find("maritalContractTypeField").set("v.value", null);
        }
    },

    //Submit
    saveNewSecurityOffered: function (component, event, helper) {
        helper.showSpinner(component);
        //Set Security_Type__c
        component.find("securityTypeField").set("v.value", "External Party");
        //Set Application__c
        component.find("applicationIdField").set("v.value", component.get("v.applicationRecordId"));
        //component.find("newSecurityOfferedForm").submit(); // we are just creating a blank record here why?

        if (component.get('v.isBusiness') == true) {
            component.set('v.maritalStatusField', component.find('maritalStatusField').get('v.value'));
        }
        if (component.get('v.isMarried') == true) {
            component.set('v.maritalContractTypeField', component.find('maritalContractTypeField').get('v.value'));
        }
        component.set('v.clientNameField', component.find('clientNameField').get('v.value'));
        component.set('v.clientCodeField', component.find('clientCodeField').get('v.value'));
        component.set('v.capacityField', component.find('capacityField').get('v.value'));
        component.set('v.clientTypeField', component.find('clientTypeField').get('v.value'));
        component.set('v.iDTypeField', component.find('iDTypeField').get('v.value'));
        component.set('v.iDRegNumField', component.find('iDRegNumField').get('v.value'));
        if (component.get('v.clientNameField') != null && component.get('v.clientTypeField') != null) {
            component.set('v.externalEntityLinked', false);
            helper.fireToast("Success", "External Entity Details Successfully created - Please capture the Securities Offered below.", "success");
        } else {
            helper.fireToast("Error", "External Entity Details Not Successfully created - Please capture mandatory details below.", "error");
        }
        helper.hideSpinner(component);
    },

    //Success
    handleSuccess: function (component, event, helper) {
        component.set("v.isFormReadOnly", true);
        helper.hideSpinner(component);
        helper.fireToast("Success", "New Security Offered Successfully created. ", "success");
    },

    //Error
    handleError: function (component, event, helper) {
        helper.hideSpinner(component);
        var errorMessage = "Error on Create New Security_Offered__c: " + event.getParam("message");
        console.log(errorMessage + ". " + JSON.stringify(event.getParams()));
        helper.fireToast("Error", errorMessage, "error");
    },
    //End of changes made by Jason Q - (W-007807)

    // Methods by Tinashe Shoko
    oniInternallimitedCessionChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiAmountCeded', false);
        if (selectedValues == 'Y') {
            component.set('v.showiAmountCeded', true);
        }
    },

    oniSpecificSecurityChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.intspecificSec', false);
        if (selectedValues == 'Yes') {
            component.set('v.intspecificSec', true);
        }
    },

    onintiSecurityOfferedChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.intFacInd', selectedValues);
    },

    iExtCessionSecurityOfferedChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.extCessionFacInd', selectedValues);
    },

    extilimitedCessionChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.extCessionIsLimited', false);
        var nominalValue = null;
        var iExtCessionAvailAmt = component.find("iExtCessionAvailAmt");
        iExtCessionAvailAmt = Array.isArray(iExtCessionAvailAmt) ? iExtCessionAvailAmt[0].get("v.value") : iExtCessionAvailAmt.get("v.value");
        var iExtCessionAccBal = component.find("iExtCessionAccBal");
        iExtCessionAccBal = Array.isArray(iExtCessionAccBal) ? iExtCessionAccBal[0].get("v.value") : iExtCessionAccBal.get("v.value");
        var nominalValueField = component.find("iExtCessionNominalValue");
        if (selectedValues == 'Y') {
            component.set('v.extCessionIsLimited', true);
            var iExtCessionAmountCeded = component.find("iExtCessionAmountCeded");
            iExtCessionAmountCeded = Array.isArray(iExtCessionAmountCeded) ? iExtCessionAmountCeded[0].get("v.value") : iExtCessionAmountCeded.get("v.value");
            nominalValue = iExtCessionAmountCeded;
            if (iExtCessionAvailAmt < iExtCessionAmountCeded && iExtCessionAvailAmt < iExtCessionAccBal) { nominalValue = iExtCessionAvailAmt; }
            if (iExtCessionAccBal < iExtCessionAmountCeded && iExtCessionAccBal < iExtCessionAvailAmt) { nominalValue = iExtCessionAccBal; }
        }
        if (selectedValues == 'N') {
            nominalValue = iExtCessionAvailAmt;
            if (iExtCessionAccBal < iExtCessionAvailAmt) { nominalValue = iExtCessionAccBal; }
        }
        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
        }

        var iExtCessionASVApprovPerc = component.find("iExtCessionASVApprovPerc").get('v.value');
        if (iExtCessionASVApprovPerc && iExtCessionASVApprovPerc > 0) {
            component.find('iExtCessionASVApprovSecVal').set('v.value', iExtCessionASVApprovPerc * nominalValue / 100);
        } else {
            var iExtCessionASVPerc = component.find('iExtCessionASVPerc').get('v.value');
            component.find('iExtCessionASVApprovSecVal').set('v.value', iExtCessionASVPerc * nominalValue / 100);
        }
    },

    iExtCessionAmountCededOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        var iExtCessionlimitedCession = component.find("iExtCessionlimitedCession").get("v.value");

        var nominalValue = null;
        var iExtCessionAvailAmt = component.find("iExtCessionAvailAmt");
        iExtCessionAvailAmt = Array.isArray(iExtCessionAvailAmt) ? iExtCessionAvailAmt[0].get("v.value") : iExtCessionAvailAmt.get("v.value");
        var iExtCessionAccBal = component.find("iExtCessionAccBal");
        iExtCessionAccBal = Array.isArray(iExtCessionAccBal) ? iExtCessionAccBal[0].get("v.value") : iExtCessionAccBal.get("v.value");
        var nominalValueField = component.find("iExtCessionNominalValue");
        if (iExtCessionlimitedCession == 'Y') {
            nominalValue = selectedValues;
            if (iExtCessionAvailAmt < selectedValues && iExtCessionAvailAmt < iExtCessionAccBal) { nominalValue = iExtCessionAvailAmt; }
            if (iExtCessionAccBal < selectedValues && iExtCessionAccBal < iExtCessionAvailAmt) { nominalValue = iExtCessionAccBal; }
        }
        if (iExtCessionlimitedCession == 'N') {
            nominalValue = iExtCessionAvailAmt;
            if (iExtCessionAccBal < iExtCessionAvailAmt) { nominalValue = iExtCessionAccBal; }
        }
        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
        }

        var iExtCessionASVApprovPerc = component.find("iExtCessionASVApprovPerc").get('v.value');
        if (iExtCessionASVApprovPerc && iExtCessionASVApprovPerc > 0) {
            component.find('iExtCessionASVApprovSecVal').set('v.value', iExtCessionASVApprovPerc * nominalValue / 100);
        } else {
            var iExtCessionASVPerc = component.find('iExtCessionASVPerc').get('v.value');
            component.find('iExtCessionASVApprovSecVal').set('v.value', iExtCessionASVPerc * nominalValue / 100);
        }
    },

    iExtCessionSpecificSecurityChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showCessionExtiSpecificSecurity', false);
        if (selectedValues == 'Yes') {
            component.set('v.showCessionExtiSpecificSecurity', true);
        }
    },

    calcExtCessionNominalValue: function (component, event, helper) {
        var iExtCessionAccBal = component.find("iExtCessionAccBal");
        iExtCessionAccBal = Array.isArray(iExtCessionAccBal) ? iExtCessionAccBal[0].get("v.value") : iExtCessionAccBal.get("v.value");
        var iExtCessionAvailAmt = event.getSource().get("v.value");
        var nominalValueField = component.find("iExtCessionNominalValue");
        var nominalValue;
        var iextCessionlimitedCession = component.find("iExtCessionlimitedCession");
        iextCessionlimitedCession = Array.isArray(iextCessionlimitedCession) ? iextCessionlimitedCession[0].get("v.value") : iextCessionlimitedCession.get("v.value");
        if (iextCessionlimitedCession == 'Y') {
            var iExtCessionAmountCeded = component.find("iExtCessionAmountCeded");
            iExtCessionAmountCeded = Array.isArray(iExtCessionAmountCeded) ? iExtCessionAmountCeded[0].get("v.value") : iExtCessionAmountCeded.get("v.value");
            if (iExtCessionAccBal && iExtCessionAvailAmt && iExtCessionAmountCeded) {
                if (parseFloat(iExtCessionAccBal) <= parseFloat(iExtCessionAvailAmt) && parseFloat(iExtCessionAccBal) <= parseFloat(iExtCessionAmountCeded)) { nominalValue = iExtCessionAccBal; }
                if (parseFloat(iExtCessionAvailAmt) <= parseFloat(iExtCessionAccBal) && parseFloat(iExtCessionAvailAmt) <= parseFloat(iExtCessionAmountCeded)) { nominalValue = iExtCessionAvailAmt; }
                if (parseFloat(iExtCessionAmountCeded) <= parseFloat(iExtCessionAccBal) && parseFloat(iExtCessionAmountCeded) <= parseFloat(iExtCessionAvailAmt)) { nominalValue = iExtCessionAmountCeded; }
            }
        }
        if (iextCessionlimitedCession == 'N') {
            if (iExtCessionAccBal && iExtCessionAvailAmt) {
                nominalValue = parseFloat(iExtCessionAvailAmt) < parseFloat(iExtCessionAccBal) ? iExtCessionAvailAmt : iExtCessionAccBal;
            }
        }
        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            var iExtCessionASVPerc = component.find("iExtCessionASVPerc");
            if (iExtCessionASVPerc) {
                iExtCessionASVPerc = Array.isArray(iExtCessionASVPerc) ? iExtCessionASVPerc[0].get("v.value") : iExtCessionASVPerc.get("v.value");
                component.find('iExtCessionASVApprovSecVal').set('v.value', iExtCessionASVPerc * nominalValue / 100);
            }
        }
    },

    iExtCessionAccBalOnChange: function (component, event, helper) {
        var iExtCessionAvailAmt = component.find("iExtCessionAvailAmt");
        iExtCessionAvailAmt = Array.isArray(iExtCessionAvailAmt) ? iExtCessionAvailAmt[0].get("v.value") : iExtCessionAvailAmt.get("v.value");
        var iExtCessionAccBal = event.getSource().get("v.value");
        var nominalValueField = component.find("iExtCessionNominalValue");
        var nominalValue;
        var iextCessionlimitedCession = component.find("iExtCessionlimitedCession");
        iextCessionlimitedCession = Array.isArray(iextCessionlimitedCession) ? iextCessionlimitedCession[0].get("v.value") : iextCessionlimitedCession.get("v.value");
        if (iextCessionlimitedCession == 'Y') {
            var iExtCessionAmountCeded = component.find("iExtCessionAmountCeded");
            iExtCessionAmountCeded = Array.isArray(iExtCessionAmountCeded) ? iExtCessionAmountCeded[0].get("v.value") : iExtCessionAmountCeded.get("v.value");
            if (iExtCessionAccBal && iExtCessionAvailAmt && iExtCessionAmountCeded) {
                if (parseFloat(iExtCessionAccBal) <= parseFloat(iExtCessionAvailAmt) && parseFloat(iExtCessionAccBal) <= parseFloat(iExtCessionAmountCeded)) { nominalValue = iExtCessionAccBal; }
                if (parseFloat(iExtCessionAvailAmt) <= parseFloat(iExtCessionAccBal) && parseFloat(iExtCessionAvailAmt) <= parseFloat(iExtCessionAmountCeded)) { nominalValue = iExtCessionAvailAmt; }
                if (parseFloat(iExtCessionAmountCeded) <= parseFloat(iExtCessionAccBal) && parseFloat(iExtCessionAmountCeded) <= parseFloat(iExtCessionAvailAmt)) { nominalValue = iExtCessionAmountCeded; }
            }
        }
        if (iextCessionlimitedCession == 'N') {
            if (iExtCessionAccBal && iExtCessionAvailAmt) {
                nominalValue = parseFloat(iExtCessionAvailAmt) < parseFloat(iExtCessionAccBal) ? iExtCessionAvailAmt : iExtCessionAccBal;
            }
        }
        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            var iExtCessionASVPerc = component.find("iExtCessionASVPerc");
            if (iExtCessionASVPerc) {
                iExtCessionASVPerc = Array.isArray(iExtCessionASVPerc) ? iExtCessionASVPerc[0].get("v.value") : iExtCessionASVPerc.get("v.value");
                component.find('iExtCessionASVApprovSecVal').set('v.value', iExtCessionASVPerc * nominalValue / 100);
            }
        }
    },

    iextCessionHolderChange: function (component, event, helper) {
        var cessionHolder = event.getSource().get("v.value");
        
        if(cessionHolder == 'Other'){
            component.set("v.isOther" ,true);
        }
        if (cessionHolder == 'Capitec' || cessionHolder == 'First National Bank' || cessionHolder == 'Investec' || cessionHolder == 'Nedbank' || cessionHolder == 'RANDMRC' || cessionHolder == 'Standard Bank') {
            component.find('iExtCessionASVPerc').set('v.value', '90');
            component.set("v.isOther" ,false);
        } else {
            component.find('iExtCessionASVPerc').set('v.value', '0');
        }
    },

    iextCessionASVApprovPercChange: function (component, event, helper) {
        var asvPerc = event.getSource().get("v.value");
        var nominalValue = component.find("iExtCessionNominalValue").get('v.value');
        if (asvPerc && asvPerc > 0) {
            component.set('v.extMandatory', true);
            component.find('iExtCessionASVApprovSecVal').set('v.value', asvPerc * nominalValue / 100);
        } else {
            component.set('v.extMandatory', false);
            var iExtCessionCessionHolder = component.find('iExtCessionCessionHolder').get('v.value');
            var iextCessionASVPerc;
            if (iExtCessionCessionHolder == 'CAPITEC' || iExtCessionCessionHolder == 'FNB' || iExtCessionCessionHolder == 'INVESTE' || iExtCessionCessionHolder == 'NEDBANK'
                || iExtCessionCessionHolder == 'RANDMRC' || iExtCessionCessionHolder == 'SBA') {
                iextCessionASVPerc = 90;
            } else {
                iextCessionASVPerc = 0;
            }
            component.find('iExtCessionASVApprovSecVal').set('v.value', iextCessionASVPerc * nominalValue / 100);
        }
    },

    iDebtorsASVApprovedbyCrOnChange: function (component, event, helper) {
        component.set('v.debtorsMandatory', false);
        var asvPerc = event.getSource().get("v.value");
        var nominalValue = component.find("iDebtorsNominalValue").get('v.value');
        if (asvPerc && asvPerc > 0) {
            component.set('v.debtorsMandatory', true);
            component.find('iDebtorsApprovedASV').set('v.value', asvPerc * nominalValue / 100);
        } else {
            var iDebtorsASV = component.find('iDebtorsASV').get('v.value');
            component.find('iDebtorsApprovedASV').set('v.value', iDebtorsASV * nominalValue / 100);
        }
    },

    iNotLinklimitedCessionChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        var iNotLinkFSV = component.find("iNotLinkFSV");
        iNotLinkFSV = Array.isArray(iNotLinkFSV) ? iNotLinkFSV[0].get("v.value") : iNotLinkFSV.get("v.value");
        var nominalValue = null;
        component.set('v.showNotLinkCeded', false);
        if (selectedValues == 'Y') {
            component.set('v.showNotLinkCeded', true);
            component.find('iNotLinkNominalValue').set('v.value', iNotLinkFSV);
            nominalValue = iNotLinkFSV;
            var iNotLinkAmountCeded = component.find("iNotLinkAmountCeded");
            iNotLinkAmountCeded = Array.isArray(iNotLinkAmountCeded) ? iNotLinkAmountCeded[0].get("v.value") : iNotLinkAmountCeded.get("v.value");
            if (iNotLinkAmountCeded < iNotLinkFSV) {
                component.find('iNotLinkNominalValue').set('v.value', iNotLinkAmountCeded);
                nominalValue = iNotLinkAmountCeded;
            }
        }
        if (selectedValues == 'N') {
            if (iNotLinkFSV) {
                component.find('iNotLinkNominalValue').set('v.value', iNotLinkFSV);
                nominalValue = iNotLinkFSV;
            }
        }

        var iNotLinkASVbyCredit = component.find("iNotLinkASVbyCredit");
        iNotLinkASVbyCredit = Array.isArray(iNotLinkASVbyCredit) ? iNotLinkASVbyCredit[0].get("v.value") : iNotLinkASVbyCredit.get("v.value");
        if (iNotLinkASVbyCredit && iNotLinkASVbyCredit > 0) { component.find('iNotLinkASV').set('v.value', iNotLinkASVbyCredit * nominalValue / 100); }
        else {
            var iNotLinkASVPerc = component.find("iNotLinkASVPerc");
            iNotLinkASVPerc = Array.isArray(iNotLinkASVPerc) ? iNotLinkASVPerc[0].get("v.value") : iNotLinkASVPerc.get("v.value");
            component.find('iNotLinkASV').set('v.value', iNotLinkASVPerc * nominalValue / 100)
        }
    },

    iNotLinkAmountCededOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        var nominalValue = null;
        var iNotLinklimitedCession = component.find("iNotLinklimitedCession");
        iNotLinklimitedCession = Array.isArray(iNotLinklimitedCession) ? iNotLinklimitedCession[0].get("v.value") : iNotLinklimitedCession.get("v.value");

        var iNotLinkFSV = component.find("iNotLinkFSV");
        iNotLinkFSV = Array.isArray(iNotLinkFSV) ? iNotLinkFSV[0].get("v.value") : iNotLinkFSV.get("v.value");

        if (iNotLinklimitedCession == 'Y') {
            component.find('iNotLinkNominalValue').set('v.value', selectedValues);
            nominalValue = selectedValues;
            if (iNotLinkFSV < selectedValues) {
                component.find('iNotLinkNominalValue').set('v.value', iNotLinkFSV);
                nominalValue = iNotLinkFSV;
            }
        }

        if (iNotLinklimitedCession == 'N') {
            if (iNotLinkFSV) {
                component.find('iNotLinkNominalValue').set('v.value', iNotLinkFSV);
                nominalValue = iNotLinkFSV;
            }
        }

        var iNotLinkASVbyCredit = component.find("iNotLinkASVbyCredit");
        iNotLinkASVbyCredit = Array.isArray(iNotLinkASVbyCredit) ? iNotLinkASVbyCredit[0].get("v.value") : iNotLinkASVbyCredit.get("v.value");
        if (iNotLinkASVbyCredit && iNotLinkASVbyCredit > 0) { component.find('iNotLinkASV').set('v.value', iNotLinkASVbyCredit * nominalValue / 100); }
        else {
            var iNotLinkASVPerc = component.find("iNotLinkASVPerc");
            iNotLinkASVPerc = Array.isArray(iNotLinkASVPerc) ? iNotLinkASVPerc[0].get("v.value") : iNotLinkASVPerc.get("v.value");
            component.find('iNotLinkASV').set('v.value', iNotLinkASVPerc * nominalValue / 100)
        }
    },

    iNotLinkFSVChange: function (component, event, helper) {
        var fsvAmt = event.getSource().get("v.value");
        var iNotLinklimitedCession = component.find("iNotLinklimitedCession");
        iNotLinklimitedCession = Array.isArray(iNotLinklimitedCession) ? iNotLinklimitedCession[0].get("v.value") : iNotLinklimitedCession.get("v.value");
        var nominalValueField = component.find("iNotLinkNominalValue");
        var nominalValue;
        if (iNotLinklimitedCession == 'Y') {
            var iNotLinkAmountCeded = component.find("iNotLinkAmountCeded");
            iNotLinkAmountCeded = Array.isArray(iNotLinkAmountCeded) ? iNotLinkAmountCeded[0].get("v.value") : iNotLinkAmountCeded.get("v.value");
            if (iNotLinkAmountCeded && fsvAmt) {
                if (parseFloat(iNotLinkAmountCeded) <= parseFloat(fsvAmt)) { nominalValue = parseFloat(iNotLinkAmountCeded); }
                if (parseFloat(iNotLinkAmountCeded) >= parseFloat(fsvAmt)) { nominalValue = parseFloat(fsvAmt); }
            }
        }
        if (iNotLinklimitedCession == 'N') {
            if (fsvAmt) { nominalValue = parseFloat(fsvAmt); }
        }
        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
        }

        var iNotLinkASVbyCredit = component.find("iNotLinkASVbyCredit");
        iNotLinkASVbyCredit = Array.isArray(iNotLinkASVbyCredit) ? iNotLinkASVbyCredit[0].get("v.value") : iNotLinkASVbyCredit.get("v.value");
        if (iNotLinkASVbyCredit && iNotLinkASVbyCredit > 0) { component.find('iNotLinkASV').set('v.value', iNotLinkASVbyCredit * nominalValue / 100); }
        else {
            var iNotLinkASVPerc = component.find("iNotLinkASVPerc");
            iNotLinkASVPerc = Array.isArray(iNotLinkASVPerc) ? iNotLinkASVPerc[0].get("v.value") : iNotLinkASVPerc.get("v.value");
            component.find('iNotLinkASV').set('v.value', iNotLinkASVPerc * nominalValue / 100)
        }
    },

    iNotLinkInsCompChange: function (component, event, helper) {
        var InsComp = event.getSource().get("v.value");
        if (InsComp == 'ABSA' || InsComp == 'DISCOVER' || InsComp == 'LIBERTY' || InsComp == 'METLIFE'
            || InsComp == 'METROPOL' || InsComp == 'MOMENT' || InsComp == 'MOMENTUM' || InsComp == 'OLDMMAN' || InsComp == 'OMUTUALG') {
            component.find('iNotLinkASVPerc').set('v.value', '100');
        } else {
            component.find('iNotLinkASVPerc').set('v.value', '0');
        }
        var nominalValue = component.find("iNotLinkNominalValue").get('v.value');
        var iNotLinkASVbyCredit = component.find("iNotLinkASVbyCredit");
        iNotLinkASVbyCredit = Array.isArray(iNotLinkASVbyCredit) ? iNotLinkASVbyCredit[0].get("v.value") : iNotLinkASVbyCredit.get("v.value");
        if (iNotLinkASVbyCredit && iNotLinkASVbyCredit > 0) { component.find('iNotLinkASV').set('v.value', iNotLinkASVbyCredit * nominalValue / 100); }
        else {
            var iNotLinkASVPerc = component.find("iNotLinkASVPerc");
            iNotLinkASVPerc = Array.isArray(iNotLinkASVPerc) ? iNotLinkASVPerc[0].get("v.value") : iNotLinkASVPerc.get("v.value");
            component.find('iNotLinkASV').set('v.value', iNotLinkASVPerc * nominalValue / 100)
        }
    },

    iNotLinkASVApprovCreditChange: function (component, event, helper) {
        var ASVApprCredit = event.getSource().get("v.value");
        component.set('v.mandatoryNotLink', false);
        var nominalValue = component.find("iNotLinkNominalValue").get('v.value');
        if (ASVApprCredit && ASVApprCredit > 0) {
            component.find('iNotLinkASV').set('v.value', ASVApprCredit * nominalValue / 100);
            component.set('v.mandatoryNotLink', true);
        } else {
            var iNotLinkASVPerc = component.find("iNotLinkASVPerc").get('v.value');
            component.find('iNotLinkASV').set('v.value', iNotLinkASVPerc * nominalValue / 100);
        }
    },

    iNotLinkSecurittOfferedChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.facIndNotLink', selectedValues);
    },

    iNotLinkSpecificSecurityChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.notLinkSpecificSec', false);
        if (selectedValues == 'Yes') {
            component.set('v.notLinkSpecificSec', true);
        }
    },

    iInternalAmountCededOnChange: function (component, event, helper) {
        var iInternalAmountCeded = event.getSource().get("v.value");

        var iInternallimitedCession = component.find("iInternallimitedCession");
        iInternallimitedCession = Array.isArray(iInternallimitedCession) ? iInternallimitedCession[0].get("v.value") : iInternallimitedCession.get("v.value");
        var iInternalAvailAmt = component.find("iInternalAvailAmt");
        iInternalAvailAmt = Array.isArray(iInternalAvailAmt) ? iInternalAvailAmt[0].get("v.value") : iInternalAvailAmt.get("v.value");
        var nominalValueField = component.find("iInternalNominalValue");
        var nominalValue;
        var iInternalAccBal = component.find("iInternalAccBal");
        iInternalAccBal = Array.isArray(iInternalAccBal) ? iInternalAccBal[0].get("v.value") : iInternalAccBal.get("v.value");

        if (iInternallimitedCession == 'Y') {
            if (parseFloat(iInternalAmountCeded) <= parseFloat(iInternalAccBal) && parseFloat(iInternalAmountCeded) <= parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAmountCeded); }
            if (parseFloat(iInternalAccBal) <= parseFloat(iInternalAmountCeded) && parseFloat(iInternalAccBal) <= parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAccBal); }
            if (parseFloat(iInternalAvailAmt) <= parseFloat(iInternalAccBal) && parseFloat(iInternalAvailAmt) <= parseFloat(iInternalAmountCeded)) { nominalValue = parseFloat(iInternalAvailAmt); }
        }
        if (iInternallimitedCession == 'N') {
            if (iInternalAvailAmt && iInternalAccBal) {
                nominalValue = parseFloat(iInternalAvailAmt);
                if (parseFloat(iInternalAccBal) < parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAccBal); }
            }
        }

        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            var iApprovedSecVal = component.find("iApprovedSecVal");
            iApprovedSecVal = Array.isArray(iApprovedSecVal) ? iApprovedSecVal[0].set("v.value", nominalValue * 1) : iApprovedSecVal.set("v.value", nominalValue * 1);
        }
    },

    iInternalAccBalOnChange: function (component, event, helper) {
        var iInternalAccBal = event.getSource().get("v.value");

        var iInternallimitedCession = component.find("iInternallimitedCession");
        iInternallimitedCession = Array.isArray(iInternallimitedCession) ? iInternallimitedCession[0].get("v.value") : iInternallimitedCession.get("v.value");
        var iInternalAvailAmt = component.find("iInternalAvailAmt");
        iInternalAvailAmt = Array.isArray(iInternalAvailAmt) ? iInternalAvailAmt[0].get("v.value") : iInternalAvailAmt.get("v.value");
        var nominalValueField = component.find("iInternalNominalValue");
        var nominalValue;

        if (iInternallimitedCession == 'Y') {
            var iInternalAmountCeded = component.find("iInternalAmountCeded");
            iInternalAmountCeded = Array.isArray(iInternalAmountCeded) ? iInternalAmountCeded[0].get("v.value") : iInternalAmountCeded.get("v.value");
            if (parseFloat(iInternalAmountCeded) <= parseFloat(iInternalAccBal) && parseFloat(iInternalAmountCeded) <= parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAmountCeded); }
            if (parseFloat(iInternalAccBal) <= parseFloat(iInternalAmountCeded) && parseFloat(iInternalAccBal) <= parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAccBal); }
            if (parseFloat(iInternalAvailAmt) <= parseFloat(iInternalAccBal) && parseFloat(iInternalAvailAmt) <= parseFloat(iInternalAmountCeded)) { nominalValue = parseFloat(iInternalAvailAmt); }
        }
        if (iInternallimitedCession == 'N') {
            if (iInternalAvailAmt && iInternalAccBal) {
                nominalValue = parseFloat(iInternalAvailAmt);
                if (parseFloat(iInternalAccBal) < parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAccBal); }
            }
        }

        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            var iApprovedSecVal = component.find("iApprovedSecVal");
            iApprovedSecVal = Array.isArray(iApprovedSecVal) ? iApprovedSecVal[0].set("v.value", nominalValue * 1) : iApprovedSecVal.set("v.value", nominalValue * 1);
        }
    },

    iInternalAvailAmtChange: function (component, event, helper) {
        var iInternalAvailAmt = event.getSource().get("v.value");

        var iInternallimitedCession = component.find("iInternallimitedCession");
        iInternallimitedCession = Array.isArray(iInternallimitedCession) ? iInternallimitedCession[0].get("v.value") : iInternallimitedCession.get("v.value");
        var iInternalAccBal = component.find("iInternalAccBal");
        iInternalAccBal = Array.isArray(iInternalAccBal) ? iInternalAccBal[0].get("v.value") : iInternalAccBal.get("v.value");
        var nominalValueField = component.find("iInternalNominalValue");
        var nominalValue;

        if (iInternallimitedCession == 'Y') {
            var iInternalAmountCeded = component.find("iInternalAmountCeded");
            iInternalAmountCeded = Array.isArray(iInternalAmountCeded) ? iInternalAmountCeded[0].get("v.value") : iInternalAmountCeded.get("v.value");
            if (parseFloat(iInternalAmountCeded) <= parseFloat(iInternalAccBal) && parseFloat(iInternalAmountCeded) <= parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAmountCeded); }
            if (parseFloat(iInternalAccBal) <= parseFloat(iInternalAmountCeded) && parseFloat(iInternalAccBal) <= parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAccBal); }
            if (parseFloat(iInternalAvailAmt) <= parseFloat(iInternalAccBal) && parseFloat(iInternalAvailAmt) <= parseFloat(iInternalAmountCeded)) { nominalValue = parseFloat(iInternalAvailAmt); }
        }
        if (iInternallimitedCession == 'N') {
            if (iInternalAvailAmt && iInternalAccBal) {
                nominalValue = parseFloat(iInternalAvailAmt);
                if (parseFloat(iInternalAccBal) < parseFloat(iInternalAvailAmt)) { nominalValue = parseFloat(iInternalAccBal); }
            }
        }

        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            var iApprovedSecVal = component.find("iApprovedSecVal");
            iApprovedSecVal = Array.isArray(iApprovedSecVal) ? iApprovedSecVal[0].set("v.value", nominalValue * 1) : iApprovedSecVal.set("v.value", nominalValue * 1);
        }
    },

    iSuretylimitedCessionOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiSuretyAmt', false);
        if (selectedValues == 'Y') { component.set('v.showiSuretyAmt', true); }
    },

    iCessionLoanAccOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiCessionAccLimited', false);
        if (selectedValues == 'Yes') { component.set('v.showiCessionAccLimited', true); }
    },

    iCessionAccLimitedOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiCessionLoanAccAmt', false);
        if (selectedValues == 'Yes') { component.set('v.showiCessionLoanAccAmt', true); }
    },

    iSupportedBySecOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiApprovedSec', false);
        if (selectedValues == 'Yes') { component.set('v.showiApprovedSec', true); }
    },

    // Fire
    addCessionofFireShortTermInsurance: function (component, event, helper) {
        component.set('v.iFireSecRecId', null);
        component.set("v.showFireDetails", true);
    },

    iFireSpecificSecurityOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.fireSpecificSec', false);
        if (selectedValues == 'Yes') { component.set('v.fireSpecificSec', true); }
    },

    iFireSecOfferedForfacOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.firefacInd', selectedValues);
    },

    iFirePolicyTypeSelOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.iFirePolicyType', selectedValues);
    },

    iFireAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Cession of Fire/Short Term Insurance', '', '',
            'iFireSpecificSecurity', 'v.fireSpecificSec', '');
    },

    iFireAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iFireSpecificSecurity = component.find("iFireSpecificSecurity").get("v.value");
                        if (iFireSpecificSecurity == 'Yes') {
                            var iFireSecOfferedForfac = component.find("iFireSecOfferedForfac").get("v.value");
                            if (iFireSecOfferedForfac == 'Existing') {
                                var val = component.find('iFireReferenceAccNumSel');
                                if (val) {
                                    eventFields['Reference_Account_Number__c'] = component.find('iFireReferenceAccNumSel').get('v.value');
                                }
                            }
                            if (iFireSecOfferedForfac == 'New') {
                                var val = component.find('iFireUniqueIdentifierSel');
                                if (val) {
                                    eventFields['Unique_Identifier__c'] = component.find('iFireUniqueIdentifierSel').get('v.value');
                                }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields

                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iFireAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iFireAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iFireAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iFireAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iFireAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iFireSecRecId', payload.id);
        helper.fireToast("Success", "Cession of Fire/Short Term Insurance created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showFireDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iFireAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Cession of Fire/Short Term Insurance!!", "error");
    },

    iFireReferenceAccNumSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iFireReferenceAccNum').set('v.value', selectedValues);
    },

    iFireUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iFireUniqueIdentifier').set('v.value', selectedValues);
    },

    closeFireAddScreen: function (component, event, helper) {
        if (component.get('v.iFireSecRecId') != '' && component.get('v.iFireSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iFireSecRecId'), 'Cession of Fire/Short Term Insurance');
        }
        component.set('v.showFireDetails', false);
        component.set('v.iFireSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // Fire

    // Dematerialised
    addCessionofDematerialisedShares: function (component, event, helper) {
        component.set('v.iDemSecRecId', null);
        component.set("v.showDematerialisedDetails", true);
    },

    iDemAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Cession of Dematerialised Shares', 'iDemLimitedCession', 'v.showiDemLimitedCession',
            'iDemSpecificSecurity', 'v.DemSpecificSec', '');
    },

    iDemAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iDemSpecificSecurity = component.find("iDemSpecificSecurity").get("v.value");
                        if (iDemSpecificSecurity == 'Yes') {
                            var iDemSecOfferedForfac = component.find("iDemSecOfferedForfac").get("v.value");
                            if (iDemSecOfferedForfac == 'Existing') {
                                var val = component.find('iDemReferenceAccNumSel');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iDemReferenceAccNumSel').get('v.value'); }
                            }
                            if (iDemSecOfferedForfac == 'New') {
                                var val = component.find('iDemUniqueIdentifierSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iDemUniqueIdentifierSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iDemAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iDemAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iDemAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iDemAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iDemAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iDemSecRecId', payload.id);
        helper.fireToast("Success", "Cession of Dematerialised Shares created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showDematerialisedDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iDemAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Cession of Dematerialised Shares!!", "error");
    },

    iDemSpecificSecurityOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.DemSpecificSec', false);
        if (selectedValues == 'Yes') { component.set('v.DemSpecificSec', true); }
    },

    iDemSecOfferedForfacOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.DemfacInd', selectedValues);
    },

    iDemLimitedCessionOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiDemLimitedCession', false);
        if (selectedValues == 'Y') {
            component.set('v.showiDemLimitedCession', true);
        }
        helper.DematerialisedCalcs(component);
    },

    iDemTransferDeedOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        if (selectedValues == 'Yes') { component.find('iDemASVPerc').set('v.value', 50); }
        if (selectedValues == 'No') { component.find('iDemASVPerc').set('v.value', 0); }
        helper.DematerialisedCalcs(component);
    },

    iDemNoOfSharesOnChange: function (component, event, helper) {
        helper.DematerialisedCalcs(component);
    },

    iDemCessionAmtOnChange: function (component, event, helper) {
        helper.DematerialisedCalcs(component);
    },

    iDemUnitValOnChange: function (component, event, helper) {
        helper.DematerialisedCalcs(component);
    },

    iDemNominalValOnChange: function (component, event, helper) {
        helper.DematerialisedCalcs(component);
    },

    iDemASVPercOnChange: function (component, event, helper) {
        helper.DematerialisedCalcs(component);
    },

    iDemNominalValOnChange: function (component, event, helper) {
        helper.DematerialisedCalcs(component);
    },

    iDemASVCrOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.set('v.mandatoryDema', false);
        if (selectedValues && selectedValues > 0) {
            component.set('v.mandatoryDema', true);
        }
        helper.DematerialisedCalcs(component);
    },

    iDemReferenceAccNumSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iDemReferenceAccNum').set('v.value', selectedValues);
    },

    iDemUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iDemUniqueIdentifier').set('v.value', selectedValues);
    },

    closeDemaAddScreen: function (component, event, helper) {
        if (component.get('v.iDemSecRecId') != '' && component.get('v.iDemSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iDemSecRecId'), 'Cession of Dematerialised Shares');
        }
        component.set('v.showDematerialisedDetails', false);
        component.set('v.iDemSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // Dematerialised

    // Bonds
    addBond: function (component, event, helper) {
        component.set('v.iBondSecRecId', null);
        component.set("v.showBondDetails", true);
    },

    oniBondsSpecificSecurityChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.iBondsSpecificSec', false);
        if (selectedValues == 'Yes') {
            component.set('v.iBondsSpecificSec', true);
        }
    },

    iBondsRefAccNoOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iBondReferenceAccNum').set('v.value', selectedValues);
    },

    iUniqueIdBondsOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iUniqueIdBonds').set('v.value', selectedValues);
    },

    iBondAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Bonds and 99-year Leasehold', '', '',
            'iBondsSpecificSecurity', 'v.iBondsSpecificSec', '');
    },

    iBondAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();

        var iASVApprByCRDate = component.find("iASVApprByCRDate");
        var errMsg = [];
        if (iASVApprByCRDate) {
            iASVApprByCRDate = Array.isArray(iASVApprByCRDate) ? iASVApprByCRDate[0].get("v.value") : iASVApprByCRDate.get("v.value");
            var todayDate = new Date().toISOString().slice(0, 10);
            if (iASVApprByCRDate > todayDate) {
                errMsg.push("Date ASV was approved by Credit cannot be greater than today.");
            }
        }
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }

        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iBondsSpecificSecurity = component.find("iBondsSpecificSecurity").get("v.value");
                        if (iBondsSpecificSecurity == 'Yes') {
                            var iSecurittOfferedBonds = component.find("iSecurittOfferedBonds").get("v.value");
                            if (iSecurittOfferedBonds == 'Existing') {
                                var val = component.find('iBondsRefAccNo');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iBondsRefAccNo').get('v.value'); }
                            }
                            if (iSecurittOfferedBonds == 'New') {
                                var val = component.find('iUniqueIdBondsSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iUniqueIdBondsSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iBondAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iBondAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iBondAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iBondAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iBondAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iBondSecRecId', payload.id);
        helper.fireToast("Success", "Bonds and 99-year Leasehold created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showBondDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iBondAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Bonds and 99-year Leasehold!!", "error");
    },

    closeBondAddScreen: function (component, event, helper) {
        if (component.get('v.iBondSecRecId') != '' && component.get('v.iBondSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iBondSecRecId'), 'Bonds and 99-year Leasehold');
        }
        component.set('v.showBondDetails', false);
        component.set('v.iBondSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // Bonds

    // Internal
    addCessionofInternalInvestments: function (component, event, helper) {
        component.set('v.iInternalSecRecId', null);
        component.set("v.showInternalDetails", true);
    },

    iIntRefAccNoOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iInternalRefAccNo').set('v.value', selectedValues);
    },

    iInternalUniqueNoSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iInternalUniqueNo').set('v.value', selectedValues);
    },

    iInternalAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Cession of Internal Investments', 'iInternallimitedCession', 'v.showiAmountCeded',
            'iSpecificSecurity', 'v.intspecificSec', '');
    },

    iInternalAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iSpecificSecurity = component.find("iSpecificSecurity").get("v.value");
                        if (iSpecificSecurity == 'Yes') {
                            var iSecurityOffered = component.find("iSecurityOffered").get("v.value");
                            if (iSecurityOffered == 'Existing') {
                                var val = component.find('iIntRefAccNo');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iIntRefAccNo').get('v.value'); }
                            }
                            if (iSecurityOffered == 'New') {
                                var val = component.find('iInternalUniqueNoSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iInternalUniqueNoSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iInternalAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iInternalAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iInternalAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iInternalAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iInternalAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iInternalSecRecId', payload.id);
        helper.fireToast("Success", "Cession of Internal Investments created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showInternalDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iInternalAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Cession of Internal Investments!!", "error");
    },

    closeInternalAddScreen: function (component, event, helper) {
        if (component.get('v.iInternalSecRecId') != '' && component.get('v.iInternalSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iInternalSecRecId'), 'Cession of Internal Investments');
        }
        component.set('v.showInternalDetails', false);
        component.set('v.iInternalSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // Internal

    //External
    addCessionofExternalInvestments: function (component, event, helper) {
        component.set('v.iExternalSecRecId', null);
        component.set("v.showExternalDetails", true);
    },

    iExtCessionRefAccNoSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iExtCessionRefAccNo').set('v.value', selectedValues);
    },

    iExtCessionUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iExtCessionUniqueIdentifier').set('v.value', selectedValues);
    },

    iExternalAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Cession of External Investments', 'iExtCessionlimitedCession', 'v.extCessionIsLimited',
            'iExtCessionSpecificSecurity', 'v.showCessionExtiSpecificSecurity', '');
    },

    iExternalAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iExtCessionSpecificSecurity = component.find("iExtCessionSpecificSecurity").get("v.value");
                        if (iExtCessionSpecificSecurity == 'Yes') {
                            var iExtCessionSecurityOffered = component.find("iExtCessionSecurityOffered").get("v.value");
                            if (iExtCessionSecurityOffered == 'Existing') {
                                var val = component.find('iExtCessionRefAccNoSel');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iExtCessionRefAccNoSel').get('v.value'); }
                            }
                            if (iExtCessionSecurityOffered == 'New') {
                                var val = component.find('iExtCessionUniqueIdentifierSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iExtCessionUniqueIdentifierSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iCessionExternalAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iCessionExternalAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iCessionExternalAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iCessionExternalAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iExternalAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iExternalSecRecId', payload.id);
        helper.fireToast("Success", "Cession of External Investments created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showExternalDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iExternalAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Cession of External Investments!!", "error");
    },

    closeExternalAddScreen: function (component, event, helper) {
        if (component.get('v.iExternalSecRecId') != '' && component.get('v.iExternalSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iExternalSecRecId'), 'Cession of External Investments');
        }
        component.set('v.showExternalDetails', false);
        component.set('v.iExternalSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // External

    // Not Link
    addCessionofLifePolicyNotLink: function (component, event, helper) {
        component.set('v.iNotLinkSecRecId', null);
        component.set("v.showNotLinkDetails", true);
    },

    iNotLinkRefAccNoSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iNotLinkRefAccNo').set('v.value', selectedValues);
    },

    iNotLinkUniqueNoSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iNotLinkUniqueNo').set('v.value', selectedValues);
    },

    iNotLinkAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Cession of Life Policy (Not Link)', 'iNotLinklimitedCession', 'v.showNotLinkCeded',
            'iNotLinkSpecificSecurity', 'v.notLinkSpecificSec', '');
            /**var iNotLinkSpecificSecurity = component.find('iNotLinkSpecificSecurity');
            if (iNotLinkSpecificSecurity) {
                iNotLinkSpecificSecurity = Array.isArray(iNotLinkSpecificSecurity) ? iNotLinkSpecificSecurity[0].get("v.value") : iNotLinkSpecificSecurity.get("v.value");
                console.log('iNotLinkSpecificSecurity >>>'+iNotLinkSpecificSecurity);
                if (iNotLinkSpecificSecurity == 'Yes') {
                    component.set('v.notLinkSpecificSec', true);
                } else {
                    component.set('v.notLinkSpecificSec', false);
                }
            }
            console.log('for ontrol kangani >>>>'+component.get('v.notLinkSpecificSec'));**/
    },

    iNotLinkAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iNotLinkSpecificSecurity = component.find("iNotLinkSpecificSecurity").get("v.value");
                        if (iNotLinkSpecificSecurity == 'Yes') {
                            var iNotLinkSecurittOffered = component.find("iNotLinkSecurittOffered").get("v.value");
                            if (iNotLinkSecurittOffered == 'Existing') {
                                var val = component.find('iNotLinkRefAccNoSel');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iNotLinkRefAccNoSel').get('v.value'); }
                            }
                            if (iNotLinkSecurittOffered == 'New') {
                                var val = component.find('iNotLinkUniqueNoSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iNotLinkUniqueNoSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iCessionLifePolicyNotLinkSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iCessionLifePolicyNotLink').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iCessionLifePolicyNotLinkSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iCessionLifePolicyNotLinkSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iNotLinkAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iNotLinkSecRecId', payload.id);
        helper.fireToast("Success", "Cession of Life Policy (Not Link) created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showNotLinkDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iNotLinkAppRecordError: function (component, event, helper) {
        var errors = event.getParams();
        console.log("response", JSON.stringify(errors));
        helper.fireToast("Error", "Error creating Cession of Life Policy (Not Link)!!", "error");
    },

    closeNotLinkAddScreen: function (component, event, helper) {
        if (component.get('v.iNotLinkSecRecId') != '' && component.get('v.iNotLinkSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iNotLinkSecRecId'), 'Cession of Life Policy (Not Link)');
        }
        component.set('v.showNotLinkDetails', false);
        component.set('v.iNotLinkSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // Not Link

    // link
    addCessionofLifePolicyLinkSanlam: function (component, event, helper) {
        component.set('v.iLinkSecRecId', null);
        component.set("v.showLinkDetails", true);
    },

    iLinkCalcs: function (component, event, helper) {
        helper.linkCalcs(component);
    },

    iLinklimitedCessionOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.set('v.showiLinkAmountCeded', false);
        if (selectedValues == 'Y') { component.set('v.showiLinkAmountCeded', true); }
        helper.linkCalcs(component);
    },

    iLinkRefAccNoSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iLinkRefAccNo').set('v.value', selectedValues);
    },

    iLinkUniqueNoSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iLinkUniqueIdentifier').set('v.value', selectedValues);
    },

    iLinkAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Cession of Life Policy (Link) (Sanlam)', 'iLinklimitedCession', 'v.showiLinkAmountCeded',
            'iLinkSpecificSecurity', 'v.showiLinkSpecificSec', '');
    },

    iLinkAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iLinkSpecificSecurity = component.find("iLinkSpecificSecurity").get("v.value");
                        if (iLinkSpecificSecurity == 'Yes') {
                            var iLinkSecurityOffered = component.find("iLinkSecurityOffered").get("v.value");
                            if (iLinkSecurityOffered == 'Existing') {
                                var val = component.find('selectLinkRefAccNum');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('selectLinkRefAccNum').get('v.value'); }
                            }
                            if (iLinkSecurityOffered == 'New') {
                                var val = component.find('iLinkUniqueIdentifierSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iLinkUniqueIdentifierSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iLinkAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iLinkAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iLinkAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iLinkAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iLinkAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iLinkSecRecId', payload.id);
        helper.fireToast("Success", "Cession of Life Policy (Link) (Sanlam) created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showLinkDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iLinkAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Cession of Life Policy (Link) (Sanlam)!!", "error");
    },

    iLinkSpecificSecurityOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiLinkSpecificSec', false);
        if (selectedValues == 'Yes') { component.set('v.showiLinkSpecificSec', true); }
    },

    iLinkOfferedChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.linkFacInd', selectedValues);
    },

    closeLinkAddScreen: function (component, event, helper) {
        if (component.get('v.iLinkSecRecId') != '' && component.get('v.iLinkSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iLinkSecRecId'), 'Cession of Life Policy (Link) (Sanlam)');
        }
        component.set('v.showLinkDetails', false);
        component.set('v.iLinkSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    //link

    // Suretyship
    addSuretyship: function (component, event, helper) {
        component.set('v.iSuretySecRecId', null);
        component.set("v.showSuretyDetails", true);
    },

    iApprovedSecOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiSuretyDateSigned', false);
        if (selectedValues == 'Yes') { component.set('v.showiSuretyDateSigned', true); }
    },

    iSuretySpecificSecOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiSuretyFacInd', false);
        if (selectedValues == 'Yes') { component.set('v.showiSuretyFacInd', true); }
    },

    iSuretySecurityOfferedChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.suretyFacInd', selectedValues);
    },

    selectSuretyRefAccNumOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iSuretyRefAccNo').set('v.value', selectedValues);
    },

    iSuretyUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iSuretyUniqueIdentifier').set('v.value', selectedValues);
    },

    iSuretyAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Suretyship', 'iSuretylimitedCession', 'v.showiSuretyAmt',
            'iSuretySpecificSec', 'v.showiSuretyFacInd', '');
    },
    //added by Manish for W-011371
    getSelectedAccounts: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var selectedIds = [];
        selectedRows.forEach(function (res) {
            selectedIds.push(res.Id);
        });
        component.set("v.selectedAccountIds", selectedIds);
        component.set("v.selectedAccounts", selectedRows);
        console.log('selectedIds >>>>'+selectedIds);
        console.log('selectedRows >>>>'+selectedRows);
        var iSuretyAccs = component.find('iSuretyAccs');
        if (iSuretyAccs) {
            var iSuretyAccs_Curval = Array.isArray(iSuretyAccs) ? iSuretyAccs[0].get("v.value") : iSuretyAccs.get("v.value");
            console.log('iSuretyAccs_Curval >>>>'+iSuretyAccs_Curval);
            if (iSuretyAccs_Curval != selectedIds) {
                iSuretyAccs = Array.isArray(iSuretyAccs) ? iSuretyAccs[0].set("v.value", selectedIds) : iSuretyAccs.set("v.value", selectedIds);
            }
        }
    },
    iSuretyAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");

        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }

        //added by Manish for W-011372
        var isLimited = component.find("iSuretylimitedCession").get("v.value");
        var specificSecurity = component.find("iSuretySpecificSec");
        if (specificSecurity) {
            specificSecurity = Array.isArray(specificSecurity) ? specificSecurity[0].get("v.value") : specificSecurity.get("v.value");
            var iSuretyAmt = component.find("iSuretyAmt") != undefined ? component.find("iSuretyAmt").get("v.value") : undefined;
            if (isLimited == 'Y' && specificSecurity == 'No' && (iSuretyAmt == null || iSuretyAmt == undefined)) {
                errMsg.push("Please capture the Security Amount.");
                isError = true;
            }

            //added by manish for W-011371
            var selectedAccounts = component.get("v.selectedAccounts");
            if (selectedAccounts.length === 0 && specificSecurity === 'Yes') {
                errMsg.push("Please Select Accounts.");
                isError = true;
            }
        }

        //W-011371 changes end
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iSuretySpecificSec = component.find("iSuretySpecificSec")
                        if (iSuretySpecificSec){
                            iSuretySpecificSec = Array.isArray(iSuretySpecificSec) ? iSuretySpecificSec[0].get("v.value") : iSuretySpecificSec.get("v.value");
                            if (iSuretySpecificSec == 'Yes') {
                                //added by Manish for W-011371
                                eventFields['Suretyship_Selected_Accounts__c'] = JSON.stringify(component.get("v.selectedAccounts"));
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iSuretyAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iSuretyAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iSuretyAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iSuretyAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iSuretyAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iSuretySecRecId', payload.id);
        helper.fireToast("Success", "Suretyship created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showSuretyDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iSuretyAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Suretyship!!", "error");
    },

    closeSuretyAddScreen: function (component, event, helper) {
        if (component.get('v.iSuretySecRecId') != '' && component.get('v.iSuretySecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iSuretySecRecId'), 'Suretyship');
        }
        component.set('v.showSuretyDetails', false);
        component.set('v.iSuretySecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    //Suretyship

    // Gen PLedge
    addGeneralPledge: function (component, event, helper) {
        component.set('v.iPLedgeSecRecId', null);
        component.set("v.showPledgeDetails", true);
    },

    oniPLedgeSpecificSecChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.specificSec', false);
        if (selectedValues == 'Yes') {
            component.set('v.specificSec', true);
        }
    },

    oniPLedgefacIndChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.facInd', selectedValues);
    },

    pledgeCals: function (component, event, helper) {
        helper.PledgeCalcs(component);
    },

    iPLedgeASVApprovedCrOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.mandatoryPLedge', false);
        if (selectedValues && selectedValues > 0) { component.set('v.mandatoryPLedge', true); }
        helper.PledgeCalcs(component);
    },

    onLimitedPledgeChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showPledgeAmount', false);
        if (selectedValues == 'Yes') {
            component.set('v.showPledgeAmount', true);
        }
        helper.PledgeCalcs(component);
    },

    iPledgeReferenceAccNumSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iPLedgeReferenceAccNum').set('v.value', selectedValues);
    },

    iPLedgeUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iPledgeUniqueIdentifier').set('v.value', selectedValues);
    },

    iPLedgeAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'General Pledge', 'iLimitedPledge', 'v.showPledgeAmount',
            'iPLedgeSpecificSec', 'v.specificSec', '');
    },

    iPLedgeAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iPLedgeSpecificSec = component.find("iPLedgeSpecificSec").get("v.value");
                        if (iPLedgeSpecificSec == 'Yes') {
                            var iPLedgeSecOfferedForfac = component.find("iPLedgeSecOfferedForfac").get("v.value");
                            if (iPLedgeSecOfferedForfac == 'Existing') {
                                var val = component.find('iPledgeReferenceAccNumSel');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iPledgeReferenceAccNumSel').get('v.value'); }
                            }
                            if (iPLedgeSecOfferedForfac == 'New') {
                                var val = component.find('iPledgeUniqueIdentifierSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iPledgeUniqueIdentifierSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iPledgeAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iPledgeAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iPLedgeAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iPLedgeAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iPLedgeAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iPLedgeSecRecId', payload.id);
        helper.fireToast("Success", "General Pledge created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showPledgeDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iPledgeAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating General Pledge!!", "error");
    },

    closePledgeAddScreen: function (component, event, helper) {
        if (component.get('v.iPLedgeSecRecId') != '' && component.get('v.iPLedgeSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iPLedgeSecRecId'), 'General Pledge');
        }
        component.set('v.showPledgeDetails', false);
        component.set('v.iPLedgeSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    //Gen Pledge

    // Debtors
    addCessionofDebtors: function (component, event, helper) {
        component.set('v.iDebtorsSecRecId', null);
        component.set("v.showDebtorsDetails", true);
    },

    iDebtorsSpecificSecurityOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        console.log('we here here here >>>'+ selectedValues);
        component.set('v.showiDebtorsFacInd', false);
        if (selectedValues === 'Yes') {
            component.set('v.showiDebtorsFacInd', true);
        }
    },

    iDebtorsSecOfferedForfacOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.debtorsFacInd', selectedValues);
    },

    iDebtorsNominalValueOnChange: function (component, event, helper) {
        var nominalValue = event.getParam("value");
        var iDebtorsASVApprovedbyCr = component.find("iDebtorsASVApprovedbyCr").get('v.value');
        if (iDebtorsASVApprovedbyCr && iDebtorsASVApprovedbyCr > 0) {
            component.find('iDebtorsApprovedASV').set('v.value', iDebtorsASVApprovedbyCr * nominalValue / 100);
        } else {
            var iDebtorsASV = component.find('iDebtorsASV').get('v.value');
            component.find('iDebtorsApprovedASV').set('v.value', iDebtorsASV * nominalValue / 100);
        }
    },

    iDebtorsRefAccNoSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iDebtorsRefAccNo').set('v.value', selectedValues);
    },

    iDebtorsUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iDebtorsUniqueIdentifier').set('v.value', selectedValues);
    },

    iDebtorsAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Cession of Debtors', '', '',
            'iDebtorsSpecificSecurity', 'v.showiDebtorsFacInd', '');
    },

    iDebtorsAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        //alert(component.get('v.externalEntityLinked')  + ' -- ' + $A.util.isEmpty(memId) + '  ----- ' +  memId.length);
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iDebtorsSpecificSecurity = component.find("iDebtorsSpecificSecurity").get("v.value");
                        if (iDebtorsSpecificSecurity == 'Yes') {
                            var iDebtorsSecOfferedForfac = component.find("iDebtorsSecOfferedForfac").get("v.value");
                            if (iDebtorsSecOfferedForfac == 'Existing') {
                                var val = component.find('iDebtorsRefAccNoSel');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iDebtorsRefAccNoSel').get('v.value'); }
                            }
                            if (iDebtorsSecOfferedForfac == 'New') {
                                var val = component.find('iDebtorsUniqueIdentifierSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iDebtorsUniqueIdentifierSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iDebtorsAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iDebtorsSecRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iDebtorsAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iDebtorsAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iDebtorsAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iDebtorsSecRecId', payload.id);
        helper.fireToast("Success", "Cession of Debtors created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showDebtorsDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iDebtorsAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Cession of Debtors!!", "error");
    },

    closeDebtorsAddScreen: function (component, event, helper) {
        if (component.get('v.iDebtorsSecRecId') != '' && component.get('v.iDebtorsSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iDebtorsSecRecId'), 'Cession of Debtors');
        }
        component.set('v.showDebtorsDetails', false);
        component.set('v.iDebtorsSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // Debtors

    // Unit Trusts
    addCessionofUnitTrusts: function (component, event, helper) {
        component.set('v.iUnitSecRecId', null);
        component.set("v.showUnitTrustDetails", true);
    },

    iUnitTrustsReferenceAccNumSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iUnitTrustsReferenceAccNumSel').set('v.value', selectedValues);
    },

    iUnitTrustsUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iUnitTrustsUniqueIdentifier').set('v.value', selectedValues);
    },

    iUnitTrustsNominalValueOnChange: function (component, event, helper) {
        helper.unitTrustCalcs(component);
    },

    iUnitTrustsLimitedCessionChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiUnitTrustsCessionAmt', false);
        if (selectedValues == 'Y') {
            component.set('v.showiUnitTrustsCessionAmt', true);
        }
        helper.unitTrustCalcs(component);
    },

    iNumberofUnitsOnChange: function (component, event, helper) {
        helper.unitTrustCalcs(component);
    },

    iUnitTrustsCessionAmtOnChange: function (component, event, helper) {
        helper.unitTrustCalcs(component);
    },

    calcUnitTrustsNominalValue: function (component, event, helper) {
        helper.unitTrustCalcs(component);
    },

    iRedemptionFormHeldChange: function (component, event, helper) {
        var redemption = event.getSource().get("v.value");
        var perc;

        var iUnitTrustsASVCr = component.find("iUnitTrustsASVCr");
        iUnitTrustsASVCr = Array.isArray(iUnitTrustsASVCr) ? iUnitTrustsASVCr[0].get("v.value") : iUnitTrustsASVCr.get("v.value");
        var nominalValueField = component.find("iUnitTrustsNominalValue");
        nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].get("v.value") : nominalValueField.get("v.value");
        var iUnitTrustsASVPerc = component.find("iUnitTrustsASVPerc");
        if (redemption == 'Yes') {
            iUnitTrustsASVPerc = Array.isArray(iUnitTrustsASVPerc) ? iUnitTrustsASVPerc[0].set("v.value", 50) : iUnitTrustsASVPerc.set("v.value", 50);
            perc = 50;
        }
        if (redemption == 'No') {
            iUnitTrustsASVPerc = Array.isArray(iUnitTrustsASVPerc) ? iUnitTrustsASVPerc[0].set("v.value", 0) : iUnitTrustsASVPerc.set("v.value", 0);
            perc = 0;
        }
        var iUnitTrustsApprovedSecValue = component.find("iUnitTrustsApprovedSecValue");
        iUnitTrustsApprovedSecValue = Array.isArray(iUnitTrustsApprovedSecValue) ? iUnitTrustsApprovedSecValue[0].set("v.value", iUnitTrustsASVCr * perc / 100) : iUnitTrustsApprovedSecValue.set("v.value", iUnitTrustsASVCr * perc / 100);

        if (iUnitTrustsASVCr && iUnitTrustsASVCr > 0 && nominalValueField && nominalValueField >= 0) {
            var iUnitTrustsApprovedSecValue = component.find("iUnitTrustsApprovedSecValue");
            iUnitTrustsApprovedSecValue = Array.isArray(iUnitTrustsApprovedSecValue) ? iUnitTrustsApprovedSecValue[0].set("v.value", iUnitTrustsASVCr * nominalValueField / 100) : iUnitTrustsApprovedSecValue.set("v.value", iUnitTrustsASVCr * nominalValueField / 100);
        }
    },

    iUnitAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Cession of Unit Trusts', 'iUnitTrustsLimitedCession', 'v.showiUnitTrustsCessionAmt',
            'iUnitTrustsSpecificSecurity', 'v.UnitTrustsspecificSec', '');
    },

    iUnitTrustsASVCrChange: function (component, event, helper) {
        var iUnitTrustsASVCr = event.getSource().get("v.value");
        if (iUnitTrustsASVCr && iUnitTrustsASVCr > 0) {
            component.set('v.unittrustMandatory', true);
        } else {
            component.set('v.unittrustMandatory', false);
        }
        helper.unitTrustCalcs(component);
    },

    iUnitTrustsSpecificSecurityChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.UnitTrustsspecificSec', false);
        if (selectedValues == 'Yes') {
            component.set('v.UnitTrustsspecificSec', true);
        }
    },

    iUnitTrustsSecOfferedForfacChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.UnitTrustsfacInd', selectedValues);
    },

    iUnitAppRecordSubmit: function (component, event, helper) {
        var isError = false;
        event.preventDefault();
        var iDateASVApprovCr = component.find("iDateASVApprovCr");
        var errMsg = [];
        if (iDateASVApprovCr) {
            iDateASVApprovCr = Array.isArray(iDateASVApprovCr) ? iDateASVApprovCr[0].get("v.value") : iDateASVApprovCr.get("v.value");
            var todayDate = new Date().toISOString().slice(0, 10);
            if (iDateASVApprovCr > todayDate) {
                isError = true;
                errMsg.push("Date ASV % approved by Credit - cannot be greater than today.");
            }
        }
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }

        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iUnitTrustsSpecificSecurity = component.find("iUnitTrustsSpecificSecurity").get("v.value");
                        if (iUnitTrustsSpecificSecurity == 'Yes') {
                            var iUnitTrustsSecOfferedForfac = component.find("iUnitTrustsSecOfferedForfac").get("v.value");
                            if (iUnitTrustsSecOfferedForfac == 'Existing') {
                                var val = component.find('iUnitTrustsReferenceAccNumSel');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iUnitTrustsReferenceAccNumSel').get('v.value'); }
                            }
                            if (iUnitTrustsSecOfferedForfac == 'New') {
                                var val = component.find('iUnitTrustsUniqueIdentifierSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iUnitTrustsUniqueIdentifierSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iUnitAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iUnitAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iUnitAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iUnitAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iUnitAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iUnitSecRecId', payload.id);
        helper.fireToast("Success", "Cession of Unit Trusts created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showUnitTrustDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iUnitAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Cession of Unit Trusts!!", "error");
    },

    closeUnitAddScreen: function (component, event, helper) {
        if (component.get('v.iUnitSecRecId') != '' && component.get('v.iUnitSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iUnitSecRecId'), 'Cession of Unit Trusts');
        }
        component.set('v.showUnitTrustDetails', false);
        component.set('v.iUnitSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // Unit Trusts

    // Letter of Undertaking
    addLetterofUndertaking: function (component, event, helper) {
        component.set('v.iLetterSecRecId', null);
        component.set("v.showLetterDetails", true);
    },

    iLetterAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'Letter of Undertaking', '', '', 'iLetterSpecificSecurity', 'v.letterSpecificSec', '');
    },

    iLetterAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iLetterSpecificSecurity = component.find("iLetterSpecificSecurity").get("v.value");
                        if (iLetterSpecificSecurity == 'Yes') {
                            var iLetterSecOfferedForfac = component.find("iLetterSecOfferedForfac").get("v.value");
                            if (iLetterSecOfferedForfac == 'Existing') {
                                var val = component.find('iLetterReferenceAccNumSel');
                                if (val) { eventFields['Reference_Account_Number__c'] = component.find('iLetterReferenceAccNumSel').get('v.value'); }
                            }
                            if (iLetterSecOfferedForfac == 'New') {
                                var val = component.find('iLetterUniqueIdentifierSel');
                                if (val) { eventFields['Unique_Identifier__c'] = component.find('iLetterUniqueIdentifierSel').get('v.value'); }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iLetterAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iLetterAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iLetterAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iLetterAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iLetterAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iLetterSecRecId', payload.id);
        helper.fireToast("Success", "Letter of Undertaking created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showLetterDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iLetterAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Letter of Undertaking!!", "error");
    },

    iLetterCalcSecValue: function (component, event, helper) {
        var iLetterNominalVal = component.find("iLetterNominalVal");
        iLetterNominalVal = Array.isArray(iLetterNominalVal) ? iLetterNominalVal[0].get("v.value") : iLetterNominalVal.get("v.value");

        var iLetterASVCr = component.find("iLetterASVCr");
        iLetterASVCr = Array.isArray(iLetterASVCr) ? iLetterASVCr[0].get("v.value") : iLetterASVCr.get("v.value");
        component.set('v.letterMandatory', false);

        var iLetterASVPerc = component.find("iLetterASVPerc");
        iLetterASVPerc = Array.isArray(iLetterASVPerc) ? iLetterASVPerc[0].get("v.value") : iLetterASVPerc.get("v.value");

        if (iLetterASVCr && iLetterASVCr > 0) {
            component.set('v.letterMandatory', true);
            component.find('iLetterApprovedSecValue').set('v.value', iLetterNominalVal * iLetterASVCr / 100);
        }
        else { component.find('iLetterApprovedSecValue').set('v.value', iLetterNominalVal * iLetterASVPerc / 100); }
    },

    iLetterSpecificSecurityOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.letterSpecificSec', false);
        if (selectedValues == 'Yes') {
            component.set('v.letterSpecificSec', true);
        }
    },

    iLetterSecOfferedForfacOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.letterfacInd', selectedValues);
    },

    iLetterReferenceAccNumSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iLetterReferenceAccNum').set('v.value', selectedValues);
    },

    iLetterUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iLetterUniqueIdentifier').set('v.value', selectedValues);
    },

    closeLetterAddScreen: function (component, event, helper) {
        if (component.get('v.iLetterSecRecId') != '' && component.get('v.iLetterSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iLetterSecRecId'), 'Letter of Undertaking');
        }
        component.set('v.showLetterDetails', false);
        component.set('v.iLetterSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    //Letter of Undertaking

    // Excon
    addExconRuling: function (component, event, helper) {
        component.set('v.iExconSecRecId', null);
        component.set("v.showExconDetails", true);
    },

    iExconAppRecordLoad: function (component, event, helper) {
        // hmmm
    },

    iExconAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iExconAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iExconAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iExconAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iExconAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iExconAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iExconSecRecId', payload.id);
        helper.fireToast("Success", "Excon Ruling created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showExconDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iExconAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating Excon Ruling!!", "error");
    },

    closeExconAddScreen: function (component, event, helper) {
        if (component.get('v.iExconSecRecId') != '' && component.get('v.iExconSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iExconSecRecId'), 'Excon Ruling');
        }
        component.set('v.showExconDetails', false);
        component.set('v.iExconSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    // Excon

    // General
    generalCalcs: function (component, event, helper) {
        component.set('v.iGeneralSecRecId', null);
        helper.generalCessionCalc(component);
    },

    addGeneralCession: function (component, event, helper) {
        component.set("v.showGeneralDetails", true);
        component.set('v.iGeneralSecRecId', '');
    },

    iGeneralASVCrOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.generalMandatory', false);
        if (selectedValues && selectedValues > 0) { component.set('v.generalMandatory', true); }
        helper.generalCessionCalc(component);
    },

    iGeneralLimitedCessionOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.showiGeneralCessionAmt', false);
        if (selectedValues == 'Y') { component.set('v.showiGeneralCessionAmt', true); }
        helper.generalCessionCalc(component);
    },

    iGeneralAppRecordLoad: function (component, event, helper) {
        helper.iGenericFormLoad(component, 'General Cession', 'iGeneralLimitedCession', 'v.showiGeneralCessionAmt', 'iGeneralSpecificSecurity', 'v.generalSpecificSec','');
    },

    iGeneralAppRecordSubmit: function (component, event, helper) {
        // validate fields here
        var isError = false;
        event.preventDefault();
        var errMsg = [];
        var memId = component.get("v.memberId");
        if (component.get('v.externalEntityLinked') == true && ($A.util.isEmpty(memId) || memId.length <= 1)) {
            errMsg.push("Please capture the relevant External Entity details.");
            isError = true;
        }
        if (errMsg.length > 0) {
            errMsg.forEach(errFunction);
            function errFunction(errString) {
                helper.fireToast("Error", errString, "error");
                isError = true;
            }
        }
        if (!isError) {
            var oppId = component.get("v.recordId");
            var action = component.get("c.setValidationFields");
            action.setParams({
                "oppId": oppId,
                "sectionName": "Securities_Offered",
                "validationValue": true
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!isError) {
                        var eventFields = event.getParam("fields");
                        // Salesforce bug
                        var iGeneralSpecificSecurity = component.find("iGeneralSpecificSecurity").get("v.value");
                        if (iGeneralSpecificSecurity == 'Yes') {
                            var iGeneralSecOfferedForfac = component.find("iGeneralSecOfferedForfac").get("v.value");
                            if (iGeneralSecOfferedForfac == 'Existing') {
                                var val = component.find('iGeneralReferenceAccNumSel');
                                if (val) {
                                    eventFields['Reference_Account_Number__c'] = component.find('iGeneralReferenceAccNumSel').get('v.value');
                                }
                            }
                            if (iGeneralSecOfferedForfac == 'New') {
                                var val = component.find('iGeneralUniqueIdentifierSel');
                                if (val) {
                                    eventFields['Unique_Identifier__c'] = component.find('iGeneralUniqueIdentifierSel').get('v.value');
                                }
                            }
                        }
                        // Salesforce bug

                        // External Entity fields
                        eventFields['Client_Name__c'] = component.get('v.clientNameField');
                        eventFields['Client_Code__c'] = component.get('v.clientCodeField');
                        eventFields['Capacity__c'] = component.get('v.capacityField');
                        eventFields['Client_Type__c'] = component.get('v.clientTypeField');
                        eventFields['ID_Type__c'] = component.get('v.iDTypeField');
                        eventFields['ID_Registration_Number__c'] = component.get('v.iDRegNumField');
                        eventFields['MaritalStatus__c'] = component.get('v.maritalStatusField');
                        eventFields['Marital_Contract_Type__c'] = component.get('v.maritalContractTypeField');
                        eventFields['External_Entity_Linked__c'] = component.get('v.externalEntityLinked');
                        // External Entity fields
                        console.log('-------SAVING FORM---------');
                        console.log('*INSIDE iGeneralAppRecordSubmit==>: ' + JSON.stringify(eventFields));
                        component.find('iGeneralAppRecord').submit(eventFields);
                    }
                } else {
                    var errors = response.getError();
                    isError = true;
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("iGeneralAppRecordSubmit Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("iGeneralAppRecordSubmit Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },

    iGeneralAppRecordSuccess: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.iGeneralSecRecId', payload.id);
        helper.fireToast("Success", "General Cession created successfully!!", "success");
        helper.getExistingSecuritiesforAccount(component);
        component.set("v.showGeneralDetails", false);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.sendMessage(component, event, helper);
    },

    iGeneralAppRecordError: function (component, event, helper) {
        helper.fireToast("Error", "Error creating General Cession!!", "error");
    },

    iGeneralSpecificSecurityOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.generalSpecificSec', false);
        if (selectedValues == 'Yes') {
            component.set('v.generalSpecificSec', true);
        }
    },
    
    iGeneralproceedOfChange : function(component, event, helper){
         var proceedOfHolder = event.getSource().get("v.value");
        
        if(proceedOfHolder == 'book debts' || proceedOfHolder == 'cash investments' || proceedOfHolder == 'contracts'){
            component.set("v.isProceed" ,true);
        }else{
            component.set("v.isProceed" ,false);
        }
        
    },

    iGeneralSecOfferedForfacOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.generalfacInd', selectedValues);
    },

    iGenRefeAccNumSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iGeneralReferenceAccNum').set('v.value', selectedValues);
    },

    iGeneralUniqueIdentifierSelOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('iGeneralUniqueIdentifier').set('v.value', selectedValues);
    },

    iGeneralCessionTypeOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.set('v.monthlyRentalMandatory', false)
        component.set('v.executorMandatory', false)
        if (selectedValues == 'RENTALS' || selectedValues == 'CESS OF RENTALS') { component.set('v.monthlyRentalMandatory', true); }
        if (selectedValues == 'INHERIT' || selectedValues == 'CESS OF INHERITANCE') { component.set('v.executorMandatory', true); }
        helper.generalCessionCalc(component);
    },

    closeGeneralAddScreen: function (component, event, helper) {
        if (component.get('v.iGeneralSecRecId') != '' && component.get('v.iGeneralSecRecId') != null) {
            helper.deleteSecurityOffered(component, component.get('v.iGeneralSecRecId'), 'General Cession');
        }
        component.set('v.showGeneralDetails', false);
        component.set('v.iGeneralSecRecId', null);
        component.find("securitiesOfferedAccordion").set('v.activeSectionName', 'summaryOffered');
        helper.getExistingSecuritiesforAccount(component);
        helper.sendMessage(component, event, helper);
    },
    //General
    // end Methods by Tinashe Shoko
})