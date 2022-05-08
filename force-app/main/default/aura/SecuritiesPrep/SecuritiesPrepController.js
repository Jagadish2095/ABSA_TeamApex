({
    doinit: function (component, event, helper) {
        component.set('v.columns', [
            { label: 'Address Type', fieldName: 'Address_Type__c', type: 'text' },
            { label: 'Street', fieldName: 'Shipping_Street__c', type: 'text' },
            { label: 'Suburb', fieldName: 'Shipping_Suburb__c', type: 'Text' },
            { label: 'Postal Code', fieldName: 'Shipping_Zip_Postal_Code__c', type: 'Text' },
            { label: 'City', fieldName: 'Shipping_City__c', type: 'Text' },
            { label: 'Province', fieldName: 'Shipping_State_Province__c', type: 'Text' },
            { label: 'Country', fieldName: 'Shipping_Country__c', type: 'Text' }]);

        var uploadDocs = [
            { value: '--None--' },
            { value: 'Certified copy of Registration Certificate' },
            { value: 'Memorandum of Incorporation' },
            { value: 'Certificate of Confirmation drawn from CIPC website' },
            { value: 'Certified copy of Articles of Association' },
            { value: 'Certificate to Commence Business' },
            { value: 'Certificate of Incorporation' },
            { value: 'Certificate of Confirmation drawn from Registrar\'s website' },
            { value: 'Certified copy of Master\'s Authorisation' },
            { value: 'Certified copy of trust deed' },
            { value: 'ABSA 6938 EX - Checklist for Trusts' }
        ];
        component.set('v.uploadDocs', uploadDocs);
        helper.loadSecurities(component, event, helper);

        //added by Manish for W-011371
        component.set('v.newExistingSecuritiesOfferedColumns', [
            { label: 'Agreement Type', fieldName: 'Product_Name__c', type: 'text', wrapText: true },
            { label: 'Unique Identifier', fieldName: 'Temp_Account_Number__c', type: 'text', wrapText: true },
            { label: 'Domicile Branch', fieldName: 'Domicible_Branch_Code__c', type: 'text', wrapText: true },
            { label: 'Account Number', fieldName: 'Account_Number__c', type: 'text', wrapText: true },
            { label: 'Limit', fieldName: 'Product_Amount__c', type: 'currency' }
        ]);
    },

    securityFormOnload: function (component, event, helper) {
        component.set('v.selectedMandatedOfficialds', '');
        var del = component.find('del');
        if (del && del != undefined && del != null) {
            del = Array.isArray(del) ? del[0].get("v.value") : del.get("v.value");
            if (del == 'Registered Mail') {
                component.set("v.registeredMail", true);
                //component.set("v.toAnAdultPerson",false);
                component.set("v.radioValue", 'Yes');
                component.set("v.isAdult", false);
            }
            if (del == 'To an adult person') {
                //component.set("v.toAnAdultPerson",true);
                component.set("v.registeredMail", false);
                component.set("v.radioValue", 'No');
                component.set("v.isAdult", true);
            }
        }

        if (component.get('v.isAdult') === false) {
            if (component.get('v.radioValue') == 'Yes') {
                var addressId = component.find('addressId');
                if (addressId && component.find('addressId') != undefined) {
                    addressId = Array.isArray(addressId) ? addressId[0].get("v.value") : addressId.get("v.value");
                    component.set("v.selectedRows", addressId);
                }
            }
        }

        var securityProviderType = component.find('securityProviderType');
        if (securityProviderType && securityProviderType != undefined && securityProviderType != null) {
            securityProviderType = Array.isArray(securityProviderType) ? securityProviderType[0].get("v.value") : securityProviderType.get("v.value");
            component.set("v.resolutionRequired", false);
            switch (securityProviderType) {
                case 'SECURITY ON BEHALF OF A COMPANY BY VIRTUE OF A RESOLUTION':
                    component.set("v.resolutionRequired", true);
                    break;
                case 'SECURITY BY A TRUST AS A MEMBER OF THE CLOSE CORPORATION WITHOUT A RESOLUTION':
                    component.set("v.isATrust", true);
                    var trust = component.find('trust');
                    if (trust) {
                        trust = Array.isArray(trust) ? trust[0].get("v.value") : trust.get("v.value");
                        if (trust == 'YES') {
                            component.set("v.trustIsMemberOfCC", true);
                        }
                    }
                    break;
                case 'SECURITY BY A TRUST AS A MEMBER OF THE CLOSE CORPORATION BY VIRTUE OF A RESOLUTION':
                    component.set("v.isATrust", true);
                    var trust = component.find('trust');
                    if (trust) {
                        trust = Array.isArray(trust) ? trust[0].get("v.value") : trust.get("v.value");
                        if (trust == 'YES') {
                            component.set("v.trustIsMemberOfCC", true);
                        }
                    }
                    component.set("v.resolutionRequired", true);
                    break;
                case 'SECURITY BY A PARTNERSHIP BY VIRTUE OF A RESOLUTION':
                    component.set("v.resolutionRequired", true);
                    component.set("v.isAPartnership", true);
                    component.set('v.isCompany', false);
                    break;
                case 'SECURITY BY A TRUST BY VIRTUE OF A RESOLUTION':
                    component.set("v.resolutionRequired", true);
                    break;
                case 'SECURITY BY A PARTNERSHIP WITHOUT A RESOLUTION':
                    component.set("v.isAPartnership", true);
                    component.set('v.isCompany', false);
                    break;
                case 'SECURITY BY A CLOSE CORPORATION BY VIRTUE OF A RESOLUTION':
                    component.set("v.isATrust", true);
                    component.set("v.resolutionRequired", true);
                    break;
                case 'SECURITY BY A CLOSE CORPORATION WITHOUT A RESOLUTION':
                    component.set("v.isATrust", true);
                    break;
            }
        }

        var securitiesOfferedforFacility = component.find('securitiesOfferedforFacility');
        if (securitiesOfferedforFacility && securitiesOfferedforFacility != undefined && securitiesOfferedforFacility != null) {
            securitiesOfferedforFacility = Array.isArray(securitiesOfferedforFacility) ? securitiesOfferedforFacility[0].get("v.value") : securitiesOfferedforFacility.get("v.value");
            if (securitiesOfferedforFacility == 'Existing') {
                component.set('v.isExistingAcc', true);
            }
        }

        component.set("v.applicant", false);
        var secExternalEntityLinked = component.find('secExternalEntityLinked');
        if (secExternalEntityLinked && secExternalEntityLinked != undefined && secExternalEntityLinked != null) {
            secExternalEntityLinked = Array.isArray(secExternalEntityLinked) ? secExternalEntityLinked[0].get("v.value") : secExternalEntityLinked.get("v.value");
            var secContact = component.find('secContact');
            secContact = Array.isArray(secContact) ? secContact[0].get("v.value") : secContact.get("v.value");
            if (secExternalEntityLinked === true && (secContact === null || secContact === undefined)) {
                component.set("v.applicant", true);
                var officials = component.find('mandatedOfficalsList');
                officials = Array.isArray(officials) ? officials[0].get("v.value") : officials.get("v.value");
                if (officials != null && officials != '') {
                    component.set('v.selectedMandatedOfficialds', officials.split(','));
                }
            }
        }

        var suretyshipLimited = component.find('suretyshipLimited');
        if (suretyshipLimited && suretyshipLimited != undefined && suretyshipLimited != null) {
            suretyshipLimited = Array.isArray(suretyshipLimited) ? suretyshipLimited[0].get("v.value") : suretyshipLimited.get("v.value");

            /*if(suretyshipLimited==='Y'){ //W-014071 removed it
                component.set('v.showCreditTypeAgreement',true);
            }
            if(suretyshipLimited==='N'){
                component.set('v.showCreditTypeAgreement',false);
            }*/
            var securityProviderType = component.find('securityProviderType');
            if (securityProviderType) {
                securityProviderType = Array.isArray(securityProviderType) ? securityProviderType[0].get("v.value") : securityProviderType.get("v.value");
                helper.showDocumentsStubs(component, event, helper, component.get('v.securityName'), securityProviderType, suretyshipLimited);
            }
        } else {
            var securityProviderType = component.find('securityProviderType');
            if (securityProviderType && securityProviderType != undefined && securityProviderType != null) {
                securityProviderType = Array.isArray(securityProviderType) ? securityProviderType[0].get("v.value") : securityProviderType.get("v.value");
                helper.showDocumentsStubs(component, event, helper, component.get('v.securityName'), securityProviderType, '');
            }
        }

        //added by Manish for w-011371
        var isSuretyShip = component.get("v.isSuretyShip");
        var val = component.find("suretyshipAccs");
        var ids = [];

        if (isSuretyShip && val && val != undefined && val != null) {
            var selectedAccounts = JSON.parse(Array.isArray(val) ? val[0].get("v.value") : val.get("v.value"));
            if (selectedAccounts != null && selectedAccounts != undefined) {
                selectedAccounts.forEach(function (res) {
                    ids.push(res.Id);
                });
            }
            if (ids.length > 0) {
                helper.getAppProdcts(component, event, helper, ids, selectedAccounts);
            }
            else {
                component.set("v.newExistingSecuritiesOffered", null);
            }
        }
        //w-011371 changes end
        var causeOfdebt = component.find('causeOfdebt');
        if (causeOfdebt && component.find('causeOfdebt') != undefined) {
            var causeOfdebtValue = Array.isArray(causeOfdebt) ? causeOfdebt[0].get('v.value') : causeOfdebt.get("v.value");
            if (causeOfdebtValue == 'Description of Cause of Debt' && component.get("v.debtCause") != true) {
                component.set("v.debtCause", true);
            }
        }
    },

    //added by Manish for w-011371
    showModal: function (component, event, helper) {
        var selectedRow = event.getParam("selectedRows")[0];
        component.set("v.selectedAccounts", selectedRow);
        if (selectedRow.Id != null && selectedRow.Id != undefined) {
            component.set("v.applicationProductId", selectedRow.Id);
            $A.util.addClass(component.find("detailsModal"), "slds-fade-in-open");
        }
    },

    //added by Manish for w-011371
    closeModal: function (component, event, helper) {
        component.set("v.selectedAccountIds", []);
        component.set("v.applicationProductId", null);
        $A.util.removeClass(component.find("detailsModal"), "slds-fade-in-open");
    },

    //added by Manish for w-011371
    applicationProductFormonSubmit: function (component, event, helper) {
        event.preventDefault();
        $A.util.removeClass(component.find("detailsModal"), "slds-fade-in-open");
        var selectedRecords = component.get("v.selectedAccounts");
        var newExistingSecuritiesOffered = component.get("v.newExistingSecuritiesOffered");
        var eventFields = event.getParam("fields");
        newExistingSecuritiesOffered.forEach(function (res) {
            if (res.Id == selectedRecords[0].Id) {
                res.Domicible_Branch_Code__c = eventFields['Domicible_Branch_Code__c'];
                res.Account_Number__c = eventFields['Account_Number__c'];
            }
        });

        component.set("v.newExistingSecuritiesOffered", newExistingSecuritiesOffered);
        component.find('applicationProductForm').submit(eventFields);
        component.set("v.selectedAccountIds", []);
        component.set("v.applicationProductId", null);
    },

    //added by Manish for w-011371
    applicationProductFormSuccess: function (component, event, helper) {
        $A.util.removeClass(component.find("detailsModal"), "slds-fade-in-open");
    },

    //added by Manish for w-011371
    applicationProductFormError: function (component, event, helper) {
        $A.util.removeClass(component.find("detailsModal"), "slds-fade-in-open");
    },

    openSecuritiesEditForm: function (component, event, helper) {
        var idx = event.target.getAttribute('data-index');
        var existingSecurities = component.get("v.existingSecurities")[idx];
        if (existingSecurities) {
            component.set("v.selectedSecurity", existingSecurities.Id);
        }

        // start Tinashe
        component.set("v.showIndivFields", false);
        component.set("v.securityProviderClientType", event.target.getAttribute('data-secProvClientType'));
        if (event.target.getAttribute('data-secProvClientType') === 'Individual' || event.target.getAttribute('data-secProvClientType') === 'Individual - Minor'
            || event.target.getAttribute('data-secProvClientType') === 'Sole Trader') {
            component.set("v.showIndivFields", true);
        }
        component.set("v.securityProviderName", event.target.getAttribute('data-secProvName'));
        component.set("v.securityProviderEmail", event.target.getAttribute('data-secProvEmail'));
        component.set("v.securityName", event.target.getAttribute('data-securityType'));
        component.set("v.isSuretyShip", false);
        component.set("v.isCession", false);
        switch (event.target.getAttribute('data-securityType')) {
            case 'Suretyship':
                component.set("v.isSuretyShip", true);
                break;
            case 'Bonds and 99-year Leasehold':
                component.set("v.isBond", true);
                break;
            case 'General Pledge':
                break;
            case 'Cession of Internal Investments':
            case 'Cession of External Investments':
            case 'Cession of Life Policy (Not Link)':
                component.set("v.isCession", true);
                break;
            case 'Cession of Life Policy (Link) (Sanlam)':
                component.set("v.isCession", true);
                break;
            case 'Cession of Debtors':
            case 'Cession of Unit Trusts':
            case 'Cession of Dematerialised Shares':
            case 'Cession of Fire/Short Term Insurance':
                component.set("v.isCession", true);
                break;
            case 'General Cession':
                component.set("v.isGeneralCession", true);
                break;
            case 'Letter of Undertaking':
                break;
            case 'Excon Ruling':
                break;
            default:
                console.log('unhandled security type');
                 
                
        } // end Tinashe

        var accId = event.target.getAttribute('data-accId');
        var conId = event.target.getAttribute('data-conId');
        if (event.target.getAttribute('data-securityType') != 'External Party') {
            helper.getAddresses(component, accId, conId);
        }

        //component.find('securityForm').submit(existingSecurities.Id);
        var cmpTarget = component.find('securityModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        var selectedSecurity=component.get("v.selectedSecurity");
        var action = component.get("c.updateSecurities");
        action.setParams({
            "selectedSecurity": selectedSecurity
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var serviceResponse = res.getReturnValue();
                console.log('serviceResponse'+serviceResponse);
                component.set('v.securityStatus',serviceResponse.Security_Status__c);
                component.set('v.bondType',serviceResponse.Bond_type__c);
            }
                });
        $A.enqueueAction(action);
    },

    closeCreditCheckModal: function (component, event, helper) {
        component.set('v.selectedMandatedOfficialds', '');
        var cmpTarget = component.find('securityModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack, 'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

    showToast: function (component, event, helper) {

    },

    causeOfdebtOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.debtCause", false);
        switch (selectedValues) {
            case 'Description of Cause of Debt':
                component.set("v.debtCause", true);
                break;
        }
    },

    collateralTypeOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.absaCashInvestment", false);
        component.set("v.absaDividentFund", false);
        component.set("v.absaSavingsAccount", false);
        component.set("v.cashInheritance", false);
        component.set("v.cessionOfParticipationBond", false);
        component.set("v.customerForeignCurrencyAccount", false);
        component.set("v.debtorsContractorDebtors", false);
        component.set("v.discretionaryFormContractClause", false);
        component.set("v.investmentAtOtherFinancialInstitutionNoReciept", false);
        component.set("v.investmentAtOtherFinancialInstitutionRecieptIssued", false);
        component.set("v.leaseRentalAgreement", false);
        component.set("v.listedSharesStock", false);
        component.set("v.loanAccount", false);
        component.set("v.membersInterest", false);
        component.set("v.moneyMarket", false);
        component.set("v.multiInvestmentPortfolios", false);
        component.set("v.offshoreInvestmentFunds", false);
        component.set("v.openCessionSiloCertificate", false);
        component.set("v.pledgeOfNedgotiableCertificatesOfDeposit", false);
        component.set("v.proceedsSiloCertificates", false);
        component.set("v.proceedsOfCropDeliveryAgreementExists", false);
        component.set("v.proceedsOfCropDNoeliveryAgreement", false);
        component.set("v.productionAdvanceDeferredPayment", false);
        component.set("v.unitTrusts", false);
        component.set("v.unlistedShares", false);
        component.set("v.waterRightsNoCertificate", false);
        component.set("v.waterRightsWithCertificate", false);

        switch (selectedValues) {
            case 'Absa Cash Investment':
                component.set("v.absaCashInvestment", true);
                break;
            case 'Absa Dividend Fund':
                component.set("v.absaDividentFund", true);
                break;
            case 'Absa Savings Account':
                component.set("v.absaSavingsAccount", true);
                break;
            case 'Cash Inheritance':
                component.set("v.cashInheritance", true);
                break;
            case 'Cession Of participation Bond':
                component.set("v.cessionOfParticipationBond", true);
                break;
            case 'Customer Foreign Currency Account':
                component.set("v.customerForeignCurrencyAccount", true);
                break;
            case 'Debtors/Contractor debtors':
                component.set("v.debtorsContractorDebtors", true);
                break;
            case 'Discretionary Form Contract Clause':
                component.set("v.discretionaryFormContractClause", true);
                break;
            case 'Investment at other Financial Institiution - No receipt':
                component.set("v.investmentAtOtherFinancialInstitutionNoReciept", true);
                break;
            case 'Investment at other Financial Institiution - Receipt Issued':
                component.set("v.investmentAtOtherFinancialInstitutionRecieptIssued", true);
                break;
            case 'Lease/Rental Agreement':
                component.set("v.leaseRentalAgreement", true);
                break;
            case 'Listed Shares/Stock':
                component.set("v.listedSharesStock", true);
                break;
            case 'Loan Account':
                component.set("v.loanAccount", true);
                break;
            case 'Members Interest':
                component.set("v.membersInterest", true);
                break;
            case 'Money Market':
                component.set("v.moneyMarket", true);
                break;
            case 'Multi-Investment Portfolios':
                component.set("v.multiInvestmentPortfolios", true);
                break;
            case 'Offshore Investment/Funds':
                component.set("v.offshoreInvestmentFunds", true);
                break;
            case 'Open Cession Silo Certificate':
                component.set("v.openCessionSiloCertificate", true);
                break;
            case 'Pledge of Negotiable Certificates of Deposit':
                component.set("v.pledgeOfNedgotiableCertificatesOfDeposit", true);
                break;
            case 'Proceeds -Silo Certificates':
                component.set("v.proceedsSiloCertificates", true);
                break;
            case 'Proceeds of Crop - Delivery Agreement Exists':
                component.set("v.proceedsOfCropDeliveryAgreementExists", true);
                break;
            case 'Proceed of Crop - No Delivery Agreement':
                component.set("v.proceedsOfCropDNoeliveryAgreement", true);
                break;
            case 'Production Advance/Deferred Payment':
                component.set("v.productionAdvanceDeferredPayment", true);
                break;
            case 'Unit Trusts':
                component.set("v.unitTrusts", true);
                break;
            case 'Unlisted Shares':
                component.set("v.unlistedShares", true);
                break;
            case 'Water Rights - No Certificate':
                component.set("v.waterRightsNoCertificate", true);
                break;
            case 'Water Rights With Certificate':
                component.set("v.waterRightsWithCertificate", true);
                break;
            default:
                console.log('unhandled security type');
        }
    },

    handleChangeForName: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.selectedListForName", selectedValues);
    },

    handleChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.selectedRows", []);
    },

    handleChangeMandatedOfficials: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.selectedMandatedOfficialds", selectedValues);
        component.find('mandatedOfficalsList').set('v.value', selectedValues.toString());
    },

    securityFormonSubmit: function (component, event, helper) {
        //var selectedMandatedOfficialds=component.get("v.selectedMandatedOfficialds");
        //var selectedSecurity=component.get("v.selectedSecurity");
        //helper.insertSecurityContactRecords(component,selectedSecurity, selectedMandatedOfficialds, 'Mandated Official');
        //added by Manish for W-011371
        event.preventDefault();
        var records = component.get("v.newExistingSecuritiesOffered");
        var notApprovedRecords = component.get("v.notApprovedAccounts");
        var eventFields = event.getParam("fields");
        var isError = false;
        var errorMsg = [];
        if (records != null && records != undefined) {
            if (records != undefined && records != null && records.length > 0) {
                records.forEach(function (res) {
                    console.log('res.Product_Name__c >>'+res.Product_Name__c + ' res.Domicible_Branch_Code__c>>>'+res.Domicible_Branch_Code__c);
                    console.log('res.Account_Number__c  >>>'+res.Account_Number__c);
                    if (res.Product_Name__c.toLowerCase() != 'credit card' && (res.Domicible_Branch_Code__c == undefined || res.Domicible_Branch_Code__c == "" || res.Domicible_Branch_Code__c == null) ||
                        (res.Account_Number__c == undefined || res.Account_Number__c == "" || res.Account_Number__c == null)){
                            isError = true;
                            errorMsg.push("Please Capture Account Number, Domicile Branch for the Selected Agreement Types");
                        }
                });
            }
        }
        console.log('isAdult >>> ' + component.get("v.isAdult"));
        if (component.get("v.isAdult") === false) {
            var addressId = component.find('addressId');
            if (addressId && component.find('addressId') != undefined) {
                 var addressId = Array.isArray(addressId) ? addressId[0].get('v.value') : addressId.get("v.value");
                 if (addressId === '' || addressId === null) {
                    isError = true;
                    errorMsg.push("Please select an address!");
                 }
            }
        }
        console.log('we should have an error ' + isError);
        var result = [];
        if ((records != undefined && records != null) && (notApprovedRecords != undefined && notApprovedRecords != null)) {
            result = [...records, ...notApprovedRecords];
        }
        else if ((records != undefined && records != null) && (notApprovedRecords == undefined || notApprovedRecords == null)) {
            result = records;
        }
        else if ((records == undefined || records == null) && (notApprovedRecords != undefined && notApprovedRecords != null)) {
            result = notApprovedRecords;
        }

        eventFields['Suretyship_Selected_Accounts__c'] = JSON.stringify(result);

        if (eventFields['Cause_of_Debt__c'] == 'Any Cause Whatsoever') {
            eventFields['Description_of_Cause_of_Debt__c'] = '';
        }
        if (!isError) {
            component.find('securityForm').submit(eventFields);
        } else {
            if (errorMsg.length > 0) {
                errorMsg.forEach(errFunction);
                function errFunction(errString) {
                    helper.fireToast("Error", errString, "error");
                }
            }
        }
    },

    securityFormSuccess: function (component, event, helper) {
        helper.fireToast("Success", "Additional Details Saved Successfully.", "success");
    },

    //Error
    securityFormError: function (component, event, helper) {
        var errorMessage = "Error on additonal details: " + event.getParam("message");
        console.log(errorMessage + ". " + JSON.stringify(event.getParams()));
        helper.fireToast("Error", errorMessage, "error");
    },

    // Added by Diksha For Flight Centre Case Creation W-007167
    createFlightCentreCase: function (component, event, helper) {
        helper.createFlightCentreCase(component, event, helper);
    },

    // START - Tinashe
    onDeliveryMethodChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        if (selectedValues == 'Registered Mail') {
            component.set("v.registeredMail", true);
            //component.set("v.toAnAdultPerson",false);
            component.set("v.radioValue", 'Yes');
            component.set("v.isAdult", false);
        }
        if (selectedValues == 'To an adult person') {
            //component.set("v.toAnAdultPerson",true);
            component.set("v.registeredMail", false);
            component.set("v.radioValue", 'No');
            component.set("v.isAdult", true);
        }
    },

    onTrustChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.trustIsMemberOfCC", false);
        if (selectedValues == 'YES') {
            component.set("v.trustIsMemberOfCC", true);
            component.set('v.isCompany', false);
            component.set('v.companyRes', false);
        }
    },

    // defect W-010232 - Tinashe
    securityProviderTypeOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set("v.trustIsMemberOfCC", false);
        component.set("v.isATrust", false);
        component.set("v.companyRes", false);
        component.set("v.isAPartnership", false);
        component.set("v.isSecProvIndiv", false);

        component.set("v.resolutionRequired", false);

        switch (selectedValues) {
            case 'SECURITY ON BEHALF OF A COMPANY WITHOUT A RESOLUTION':
                component.set("v.trustIsMemberOfCC", false);
                component.set('v.isCompany', true);
                component.set('v.companyRes', true);
                break;
            case 'SECURITY ON BEHALF OF A COMPANY BY VIRTUE OF A RESOLUTION':
                component.set("v.trustIsMemberOfCC", false);
                component.set('v.isCompany', true);
                component.set('v.companyRes', true);
                component.set("v.resolutionRequired", true);
                break;
            case 'SECURITY BY A TRUST AS A MEMBER OF THE CLOSE CORPORATION WITHOUT A RESOLUTION':
                component.set("v.isATrust", true);
                component.set('v.isCompany', false);
                component.set('v.companyRes', false);
                break;
            case 'SECURITY BY A TRUST AS A MEMBER OF THE CLOSE CORPORATION BY VIRTUE OF A RESOLUTION':
                component.set("v.isATrust", true);
                component.set('v.isCompany', false);
                component.set('v.companyRes', false);
                component.set("v.resolutionRequired", true);
                break;
            case 'SECURITY BY AN INDIVIDUAL':
                component.set("v.isSecProvIndiv", true);
                component.set('v.isCompany', false);
                break;
            case 'SECURITY BY A PARTNERSHIP BY VIRTUE OF A RESOLUTION':
                component.set("v.isAPartnership", true);
                component.set('v.isCompany', false);
                component.set("v.resolutionRequired", true);
                break;
            case 'SECURITY BY A PARTNERSHIP WITHOUT A RESOLUTION':
                component.set("v.isAPartnership", true);
                component.set('v.isCompany', false);
                break;
            case 'SECURITY BY A TRUST BY VIRTUE OF A RESOLUTION':
                component.set("v.resolutionRequired", true);
                break;
            case 'SECURITY BY A CLOSE CORPORATION BY VIRTUE OF A RESOLUTION':
                component.set("v.resolutionRequired", true);
                component.set("v.isATrust", true);
                break;
            case 'SECURITY BY A CLOSE CORPORATION WITHOUT A RESOLUTION':
                component.set("v.isATrust", true);
                break;
        }

        var suretyshipLimited = component.find('suretyshipLimited');
        if (suretyshipLimited) {
            suretyshipLimited = Array.isArray(suretyshipLimited) ? suretyshipLimited[0].get("v.value") : suretyshipLimited.get("v.value");
            helper.showDocumentsStubs(component, event, helper, component.get('v.securityName'), selectedValues, suretyshipLimited);
        } else {
            helper.showDocumentsStubs(component, event, helper, component.get('v.securityName'), selectedValues, '');
        }
    },

    UpdateSelectedRows: function (component, event, helper) {
        var selectedRows = event.getParam("selectedRows");

        if (selectedRows && selectedRows != '' && selectedRows != null) {
            console.log('selectedRows >>>>' + selectedRows + '<<<<');
            var selectedValue = selectedRows[0].Id;
            if (selectedValue != component.find('addressId').get('v.value')) {
                component.find('addressId').set('v.value', selectedValue);
            }
        }
    },
    // END Tinashe

    openLinkSecurityForm: function (component, event, helper) {
        //Sets Security data
        var idx = event.target.getAttribute('data-index');
        var existingSecurities = component.get("v.existingSecurities")[idx];
        if (existingSecurities) {
            component.set("v.selectedSecurity", existingSecurities.Id);
        }
        helper.openSecurityLinkModal(component);
        helper.getAccountDataHelper(component, event, helper);
    },

    closeLinkSecurityForm: function (component, event, helper) {
        helper.closeSecurityLinkModal(component);
    },

    handleRowAction: function (component, event, helper) {
        //Sets Account Data
        var selectedRows = event.getParam("selectedRows");
        var selectedRow = selectedRows[0];
        if (selectedRow) {
            component.set("v.selectedAccountToLink", selectedRow.Id);
            component.set("v.disableLinkBtn", false);
        }
    },

    linkSelectedSecurity: function (component, event, helper) {
        component.find("contactIdField").set("v.value", component.get("v.selectedAccountToLink"));
        component.find("externalEntityLinked").set("v.value", true);
        component.find("clientName").set("v.value", null);
        component.find('linkSecurityOfferedForm').submit();
        component.set("v.isModalSpinner", true);
    },

    //Load
    handleLoad: function (component, event, helper) {
    },

    //Success
    handleSuccess: function (component, event, helper) {
        component.set("v.isModalSpinner", false);
        helper.fireToast("Success", "Security Linked Successfully. ", "success");
        helper.loadSecurities(component, event, helper);
        helper.closeSecurityLinkModal(component);
    },

    //Error
    handleError: function (component, event, helper) {
        component.set("v.isModalSpinner", false);
        var errorMessage = "Error on Update Security_Offered__c: " + event.getParam("message");
        console.log(errorMessage + ". " + JSON.stringify(event.getParams()));
        helper.fireToast("Error", errorMessage, "error");
    },

    companiesActOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.isCompany', false);
        if (selectedValues == '1974' || selectedValues == '2008') {
            component.set('v.isCompany', true);
            component.set("v.trustIsMemberOfCC", false);
        }
    },

    docTypesOnChange: function (component, event, helper) {
        var selectedValues = event.getParam("value");
        component.set('v.documentType', selectedValues);
    },

    /**
     * @description handleUploadFinished function.
     **/
    handleFilesChange: function (component, event, helper) {
        var fileName = "No File Selected..";
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]["name"];
        }
        component.set("v.fileName", fileName);
    },

    /**
    * @description doSave function.
    **/
    doSave: function (component, event, helper) {
        //alert('component.get("v.fileType").length ' + component.get("v.fileType").length);
        if (
            component.find("fileId").get("v.files") &&
            component.find("fileId").get("v.files").length > 0
        ) {
            if (component.get("v.fileType").length > 0) {
                helper.upload(component, event);
            } else {
                alert("Please Select File Type");
            }
        } else {
            alert("Please Select a Valid File");
        }
    },

    handlerefreshEvent: function (component, event, helper) {
        helper.loadSecurities(component, event, helper);
    },

    //added by Manish for W-011457
    redirectToRecord: function (component, event, helper) {
        var evt = $A.get("e.force:navigateToSObject");
        evt.setParams({
            "recordId": event.target.id,
            "slideDevName": "related"
        });
        evt.fire();
    }
})