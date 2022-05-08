({
    fetchMemberData: function (component, event, helper) {
        helper.showSpinner(component);
        var oppId;
        if (component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId");
        } else {
            oppId = component.get("v.recordId")
        }
        var memberId = component.get("v.memberId");
        var action = component.get("c.getSelectedMemberDetails");
        action.setParams({
            "oppId": oppId,
            "memberId": memberId
        });
        action.setCallback(this, function (response) {
            helper.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();

                if (data != null) {
                    component.set("v.data", data);
                    component.set("v.memberId", memberId);
                    component.set("v.clientName", data.Contact.FirstName + ' ' + data.Contact.LastName);
                    component.set("v.id", data.Contact.ID_Number__c);
                    component.set("v.cif", data.Contact.CIF__c);
                    component.set("v.capacity", data.Share_Percentage__c);
                    component.set("v.maritalContract", data.Contact.Marital_Contract_Type__c);
                    component.set("v.maritalStatus", data.Contact.Marital_Status__c);
                    component.set("v.accName", data.Contact.Name);
                    component.set("v.contactId", data.ContactId);
                    component.set("v.AccountId", data.AccountId);
                } else {
                    var action = component.get("c.getPrimaryAccount");
                    action.setParams({
                        "oppId": memberId
                    });
                    action.setCallback(this, function (response) {
                        helper.hideSpinner(component);
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var data = response.getReturnValue();
                            component.set("v.data", JSON.stringify(data));
                            component.set("v.memberId", memberId);
                            component.set("v.clientName", data.Name);
                            if (data.ID_Number__pc != null) {
                                component.set("v.id", data.ID_Number__pc);
                            } else {
                                component.set("v.id", data.Registration_Number__c);
                            }
                            component.set("v.cif", data.CIF__c);
                            //component.set("v.capacity", data.Share_Percentage__c);
                            component.set("v.maritalContract", data.Marital_Contract_Type__pc);
                            component.set("v.maritalStatus", data.Marital_Status__pc);
                            component.set("v.accName", data.Name);
                            component.set("v.contactId", null);
                            component.set("v.AccountId", data.Id);
                        }
                        else {
                            console.log("Failed with state: " + JSON.stringify(response));
                        }
                    });
                    $A.enqueueAction(action);
                }

            }
            else {
                console.log("fetchMemberData Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },

    getExistingSecuritiesforAccount: function (component) {
        var oppId = component.get("v.recordId")
        var memberId = component.get('v.memberId');
        var action = '';

        if (!$A.util.isEmpty(memberId) && memberId.length > 1) {
            action = component.get("c.getSecuritiesOfferedByAccount");
            action.setParams({
                "oppId": oppId,
                "memberId": memberId
            });
        } else {
            action = component.get("c.getSecuritiesOfferedByExternalEntity");
            action.setParams({
                "oppId": oppId,
            });
        }

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                // for datatable
                var options = [];
                for (var i = 0; i < data.length; i++) {
                    var secProviderName = '';
                    var secProviderUrl = '';
                    var securityAmount = 0;
                    var ref = '';
                    if (data[i].Securities_Offered_for_Facility__c == 'Existing') {
                        ref = data[i].Reference_Account_Number__c;
                    }
                    if (data[i].Securities_Offered_for_Facility__c == 'New') {
                        ref = data[i].Unique_Identifier__c;
                    }
                    if (data[i].Specific_Security__c == 'No') {
                        ref = 'Not Linked';
                    }

                    var url = location.href;
                    var baseURL = url.substring(0, url.indexOf('/', 14)) + '/';

                    if (data[i].hasOwnProperty('Contact__r') == true) {
                        secProviderUrl = baseURL + data[i].Contact__r.Id;
                        secProviderName = data[i].Contact__r.Name;
                    }
                    if (data[i].hasOwnProperty('Contact__r') == false && data[i].External_Entity_Linked__c == true) {
                        secProviderUrl = baseURL + data[i].Account__r.Id;
                        secProviderName = data[i].Account__r.Name;
                    }
                    if (data[i].hasOwnProperty('Contact__r') == false && data[i].External_Entity_Linked__c == false) {
                        secProviderUrl = baseURL + '#';
                        secProviderName = data[i].Client_Name__c;
                    }

                    switch (data[i].Security_Type__c) {
                        case 'Bonds and 99-year Leasehold':
                            securityAmount = data[i].Bond_amount_registered_offered__c;
                            data[i].Security_Description__c = data[i].Property_description__c;
                            break;
                        case 'Cession of Internal Investments':
                            securityAmount = data[i].Amount_ceded__c;
                            break;
                        case 'Cession of External Investments':
                            securityAmount = data[i].Amount_ceded__c;
                            break;
                        case 'Cession of Life Policy (Not Link)':
                            securityAmount = data[i].Amount_ceded__c;
                            break;
                        case 'Cession of Life Policy (Link) (Sanlam)':
                            securityAmount = data[i].Amount_ceded__c;
                            break;
                        case 'Suretyship':
                            securityAmount = data[i].Security_Amount__c;
                            break;
                        case 'General Pledge':
                            securityAmount = data[i].Pledge_amount__c;
                            break;
                        case 'Cession of Debtors':
                            securityAmount = data[i].Nominal_Value__c;
                            break;
                        case 'Cession of Unit Trusts':
                            securityAmount = data[i].Cession_Amount__c;
                            break;
                        case 'Cession of Dematerialised Shares':
                            securityAmount = data[i].Cession_Amount__c;
                            break;
                        case 'Cession of Fire/Short Term Insurance':
                            securityAmount = data[i].Policy_amount__c;
                            break;
                        case 'General Cession':
                            securityAmount = data[i].Cession_Amount__c;
                            break;
                        case 'Letter of Undertaking':
                            securityAmount = data[i].Nominal_Value__c;
                            data[i].Security_Description__c = data[i].Description_of_Letter_of_Undertaking__c;
                            break;
                        case 'Excon Ruling':
                            securityAmount = data[i].Excon_Approved_Amount__c;
                            break;
                        default:
                            console.log(data[i].Security_Type__c + ' is Undefined/unhandled ' + data[i].Id);
                    }
                    var asvPerc = data[i].ASV_approved_by_Credit__c != null ? data[i].ASV_approved_by_Credit__c : data[i].Approved_Security_Value_Percentage_ASV__c;

                    options.push({
                        Id: data[i].Id, Name: secProviderName, NameUrl: secProviderUrl, Security_Type__c: data[i].Security_Type__c,
                        Security_Description__c: data[i].Security_Description__c, securityAmount: securityAmount,
                        Nominal_Value__c: data[i].Nominal_Value__c, ASV_approved_by_Credit__c: asvPerc,
                        Approved_security_value__c: data[i].Approved_security_value__c,
                        Reference_Account_Number__c: ref
                    });
                }
                if (options == null) {
                    component.set('v.optionsNotEmpty', false);
                } else {
                    component.set('v.optionsNotEmpty', true);
                    component.set("v.securitiesOfferedData", options);
                }
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },

    showSelectedProducts: function (component, event, helper) {
        var action = component.get("c.getOpportunityLineItems");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                component.set("v.SelectedProducts", returnValue);
                var prodWithAccNumber = [];
                for (var i = 0; i < returnValue.length; i++) {
                    if (returnValue[i].Account_Number__c != null) {
                        prodWithAccNumber.push(returnValue[i].Account_Number__c);
                    }
                }
                component.set("v.SelectedProductsWithAccRefNum", prodWithAccNumber);
            }
        });
        $A.enqueueAction(action);
    },

    getOpportunityApplicationProducts: function (component, event, helper) {
        //var action = component.get("c.getOpportunityApplicationProducts"); // Tinashe
        var action = component.get("c.getOpportunityApplicationProducts");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                var selectedOppAppProducts = [];
                returnValue.forEach(function (result) {
                    selectedOppAppProducts.push({ value: result.Account_Number__c, label: result.Account_Number__c });
                });
                component.set("v.selectedOppAppProducts", returnValue);
                component.set("v.selectedOppAppProductsMultiple", selectedOppAppProducts);
            }
        });
        $A.enqueueAction(action);
    },

    getOpportunityUniqueIdentifierss: function (component, event, helper) {
        var action = component.get("c.getUniqueIdentifiers");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('returnValue'+JSON.stringify(returnValue));
                if(returnValue.Product_Name__c=='Bank Guarantee'){
                  var uniqueIdentifiers = [{ value: 'BG-1234567890', label: 'BG-1234567890' }];
                returnValue.forEach(function (result) {
                    uniqueIdentifiers.push({ value: 'BG-' + result.Temp_Account_Number__c, label: 'BG-' + result.Temp_Account_Number__c });
                });  
                }
                if(returnValue.Product_Name__c=='Cheque' || returnValue.Product_Name__c=='Overdraft'){
                var uniqueIdentifiers = [{ value: 'CHQ-1234567890', label: 'CHQ-1234567890' }];
                returnValue.forEach(function (result) {
                    uniqueIdentifiers.push({ value: 'CHQ-' + result.Temp_Account_Number__c, label: 'CHQ-' + result.Temp_Account_Number__c });
                });
                }
                component.set("v.uniqueIdentifiers", returnValue);
                component.set("v.uniqueIdentifiersMultiple", uniqueIdentifiers);
            } else {
                console.log("getOpportunityUniqueIdentifierss Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },

    //Handle onchange for Realistic Market Value & Bond Amount.
    //Sets Nominal Value to the less of the 2 variables
    calculateNominalValueHelper: function (component, event, helper) {
        var bondAmount = component.find("iAmountReg");
        bondAmount = Array.isArray(bondAmount) ? bondAmount[0].get("v.value") : bondAmount.get("v.value");
        var marketValue = component.find("iMarketValue");
        marketValue = Array.isArray(marketValue) ? marketValue[0].get("v.value") : marketValue.get("v.value");
        var nominalValueField = component.find("iNominalValue");
        var nominalValue;
        if (bondAmount && marketValue) {
            if (parseInt(bondAmount) < parseInt(marketValue)) {
                nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", bondAmount) : nominalValueField.set("v.value", bondAmount);
                nominalValue = bondAmount;
            } else {
                nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", marketValue) : nominalValueField.set("v.value", marketValue);
                nominalValue = marketValue;
            }
            //Calculate iRealMarkValASV
            var propertyType = component.find("iPropType");
            propertyType = Array.isArray(propertyType) ? propertyType[0].get("v.value") : propertyType.get("v.value");
            if (propertyType) {
                var ASVPercentage;
                var iASVApprByCR = component.find("iASVApprByCR");
                iASVApprByCR = Array.isArray(iASVApprByCR) ? iASVApprByCR[0].get("v.value") : iASVApprByCR.get("v.value");
                //If ASV % approved by Credit has a value, use that rather then the calculated %
                if (iASVApprByCR && parseInt(iASVApprByCR) > 0) {
                    ASVPercentage = iASVApprByCR;
                } else {
                    ASVPercentage = propertyType.split(" - ")[1];
                }
                var iRealMarkValASV = component.find("iRealMarkValASV");
                if (ASVPercentage && marketValue) {
                    var realMarkValASVValue = parseInt(marketValue) * parseInt(ASVPercentage) / 100;
                    iRealMarkValASV = Array.isArray(iRealMarkValASV) ? iRealMarkValASV[0].set("v.value", realMarkValASVValue) : iRealMarkValASV.set("v.value", realMarkValASVValue);
                    //Calculate iApprovedASV
                    var iASVApprByCR = component.find("iASVApprByCR");
                    iASVApprByCR = Array.isArray(iASVApprByCR) ? iASVApprByCR[0].get("v.value") : iASVApprByCR.get("v.value");
                    if (iASVApprByCR && parseInt(iASVApprByCR) > 0) {

                    }
                    var iApprovedASV = component.find("iApprovedASV");
                    if (parseInt(nominalValue) < parseInt(realMarkValASVValue)) {
                        iApprovedASV = Array.isArray(iApprovedASV) ? iApprovedASV[0].set("v.value", nominalValue) : iApprovedASV.set("v.value", nominalValue);
                    } else {
                        iApprovedASV = Array.isArray(iApprovedASV) ? iApprovedASV[0].set("v.value", realMarkValASVValue) : iApprovedASV.set("v.value", realMarkValASVValue);
                    }
                }
            }
        }
    },

    //Handle onchange for Product Type to get the associated ASV%
    calculateASVPercentHelper: function (component, event, helper) {
        var propertyType = component.find("iPropType");
        propertyType = Array.isArray(propertyType) ? propertyType[0].get("v.value") : propertyType.get("v.value");
        var asvField = component.find("iASV");
        if (propertyType) {
            var ASVPercentage;
            var iASVApprByCR = component.find("iASVApprByCR");
            iASVApprByCR = Array.isArray(iASVApprByCR) ? iASVApprByCR[0].get("v.value") : iASVApprByCR.get("v.value");
            //If ASV % approved by Credit has a value, use that rather then the calculated %
            if (iASVApprByCR && parseInt(iASVApprByCR) > 0) {
                ASVPercentage = iASVApprByCR;
            } else {
                ASVPercentage = propertyType.split(" - ")[1];
            }
            asvField = Array.isArray(asvField) ? asvField[0].set("v.value", propertyType.split(" - ")[1]) : asvField.set("v.value", propertyType.split(" - ")[1]);
            //Calculate iRealMarkValASV
            var marketValue = component.find("iMarketValue");
            marketValue = Array.isArray(marketValue) ? marketValue[0].get("v.value") : marketValue.get("v.value");
            var iRealMarkValASV = component.find("iRealMarkValASV");
            if (ASVPercentage && marketValue) {
                var realMarkValASVValue = parseInt(marketValue) * parseInt(ASVPercentage) / 100;
                iRealMarkValASV = Array.isArray(iRealMarkValASV) ? iRealMarkValASV[0].set("v.value", realMarkValASVValue) : iRealMarkValASV.set("v.value", realMarkValASVValue);
                //Calculate iApprovedASV
                var nominalValue = component.find("iNominalValue");
                nominalValue = Array.isArray(nominalValue) ? nominalValue[0].get("v.value") : nominalValue.get("v.value");
                if (nominalValue && realMarkValASVValue) {
                    var iApprovedASV = component.find("iApprovedASV");
                    if (parseInt(nominalValue) < parseInt(realMarkValASVValue)) {
                        iApprovedASV = Array.isArray(iApprovedASV) ? iApprovedASV[0].set("v.value", nominalValue) : iApprovedASV.set("v.value", nominalValue);
                    } else {
                        iApprovedASV = Array.isArray(iApprovedASV) ? iApprovedASV[0].set("v.value", realMarkValASVValue) : iApprovedASV.set("v.value", realMarkValASVValue);
                    }
                }
            }
        } else {
            asvField = Array.isArray(asvField) ? asvField[0].set("v.value", null) : asvField.set("v.value", null);
        }
    },

    getApplicationAccIdHelper: function (component, event, helper) {
        var action = component.get("c.getPrimaryAccount");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.AccountId", resp.Id);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error securitiesOfferedCTRL.getPrimaryAccount: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, securitiesOfferedCTRL.getPrimaryAccount state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    //Start of changes made by Jason Q - (W-007807)
    getApplicationIdHelper: function (component, event, helper) {
        var action = component.get("c.getApplicationId");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.applicationRecordId", resp);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error securitiesOfferedCTRL.getApplicationId: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, securitiesOfferedCTRL.getApplicationId state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    //Show Spinner
    showSpinner: function (component) {
        component.set("v.isSpinner", true);
    },

    //Hide Spinner
    hideSpinner: function (component) {
        component.set("v.isSpinner", false);
    },

    //Lightning toastie
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },

    setFocusedTabLabel: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function (response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Add New Securities"
            });
        })
            .catch(function (error) {
                console.log(error);
            });
    },

    DematerialisedCalcs: function (component) {
        var iDemLimitedCession = component.find("iDemLimitedCession");
        iDemLimitedCession = Array.isArray(iDemLimitedCession) ? iDemLimitedCession[0].get("v.value") : iDemLimitedCession.get("v.value");
        var iDemNoOfShares = component.find("iDemNoOfShares");
        iDemNoOfShares = Array.isArray(iDemNoOfShares) ? iDemNoOfShares[0].get("v.value") : iDemNoOfShares.get("v.value");
        var iDemUnitVal = component.find("iDemUnitVal");
        iDemUnitVal = Array.isArray(iDemUnitVal) ? iDemUnitVal[0].get("v.value") : iDemUnitVal.get("v.value");

        var nominalValueField = component.find("iDemNominalVal");
        var iDemApprovedSecValue = component.find("iDemApprovedSecValue");
        var nominalValue;
        var approvedSecurityValue;

        var iDemASVPerc = component.find("iDemASVPerc");
        iDemASVPerc = Array.isArray(iDemASVPerc) ? iDemASVPerc[0].get("v.value") : iDemASVPerc.get("v.value");
        var iDemASVCr = component.find("iDemASVCr");
        iDemASVCr = Array.isArray(iDemASVCr) ? iDemASVCr[0].get("v.value") : iDemASVCr.get("v.value");

        if (iDemLimitedCession == 'Y') {
            component.set('v.showiDemLimitedCession', true);
            var iDemCessionAmt = component.find("iDemCessionAmt");
            iDemCessionAmt = Array.isArray(iDemCessionAmt) ? iDemCessionAmt[0].get("v.value") : iDemCessionAmt.get("v.value");
            nominalValue = parseFloat(iDemNoOfShares) * parseFloat(iDemUnitVal);
            if (parseFloat(iDemCessionAmt) < parseFloat(nominalValue)) { nominalValue = parseFloat(iDemCessionAmt); }
        }
        if (iDemLimitedCession == 'N') {
            nominalValue = parseFloat(iDemNoOfShares) * parseFloat(iDemUnitVal);
        }
        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            if (parseFloat(iDemASVCr) && parseFloat(iDemASVCr) > 0) { approvedSecurityValue = nominalValue * parseFloat(iDemASVCr) / 100; }
            else { approvedSecurityValue = nominalValue * parseFloat(iDemASVPerc) / 100; }
        }
        iDemApprovedSecValue = Array.isArray(iDemApprovedSecValue) ? iDemApprovedSecValue[0].set("v.value", approvedSecurityValue) : iDemApprovedSecValue.set("v.value", approvedSecurityValue);
    },

    BondCalcs: function (component) {
        var iBondLimitedCession = component.find("iBondLimitedCession");
        iBondLimitedCession = Array.isArray(iBondLimitedCession) ? iBondLimitedCession[0].get("v.value") : iBondLimitedCession.get("v.value");
        var iBondNoOfShares = component.find("iBondNoOfShares");
        iBondNoOfShares = Array.isArray(iBondNoOfShares) ? iBondNoOfShares[0].get("v.value") : iBondNoOfShares.get("v.value");
        var iBondUnitVal = component.find("iBondUnitVal");
        iBondUnitVal = Array.isArray(iBondUnitVal) ? iBondUnitVal[0].get("v.value") : iBondUnitVal.get("v.value");

        var nominalValueField = component.find("iBondNominalVal");
        var iBondApprovedSecValue = component.find("iBondApprovedSecValue");
        var nominalValue;
        var approvedSecurityValue;

        var iBondASVPerc = component.find("iBondASVPerc");
        iBondASVPerc = Array.isArray(iBondASVPerc) ? iBondASVPerc[0].get("v.value") : iBondASVPerc.get("v.value");
        var iBondASVCr = component.find("iBondASVCr");
        iBondASVCr = Array.isArray(iBondASVCr) ? iBondASVCr[0].get("v.value") : iBondASVCr.get("v.value");

        if (iBondLimitedCession == 'Y') {
            component.set('v.showiBondLimitedCession', true);
            var iBondCessionAmt = component.find("iBondCessionAmt");
            iBondCessionAmt = Array.isArray(iBondCessionAmt) ? iBondCessionAmt[0].get("v.value") : iBondCessionAmt.get("v.value");
            nominalValue = parseFloat(iBondNoOfShares) * parseFloat(iBondUnitVal);
            if (parseFloat(iBondCessionAmt) < parseFloat(nominalValue)) { nominalValue = parseFloat(iBondCessionAmt); }
        }
        if (iBondLimitedCession == 'N') {
            nominalValue = parseFloat(iBondNoOfShares) * parseFloat(iBondUnitVal);
        }
        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            if (parseFloat(iBondASVCr) && parseFloat(iBondASVCr) > 0) { approvedSecurityValue = nominalValue * parseFloat(iBondASVCr) / 100; }
            else { approvedSecurityValue = nominalValue * parseFloat(iBondASVPerc) / 100; }
        }
        iBondApprovedSecValue = Array.isArray(iBondApprovedSecValue) ? iBondApprovedSecValue[0].set("v.value", approvedSecurityValue) : iBondApprovedSecValue.set("v.value", approvedSecurityValue);
    },

    PledgeCalcs: function (component) {
        var iLimitedPledge = component.find("iLimitedPledge");
        iLimitedPledge = Array.isArray(iLimitedPledge) ? iLimitedPledge[0].get("v.value") : iLimitedPledge.get("v.value");

        var iPledgeRealisticMarketVal = component.find("iPledgeRealisticMarketVal");
        iPledgeRealisticMarketVal = Array.isArray(iPledgeRealisticMarketVal) ? iPledgeRealisticMarketVal[0].get("v.value") : iPledgeRealisticMarketVal.get("v.value");

        var nominalValueField = component.find("iPledgeNominalValue");
        var nominalValue;

        var iPLedgeASVApprovedCr = component.find("iPLedgeASVApprovedCr");
        iPLedgeASVApprovedCr = Array.isArray(iPLedgeASVApprovedCr) ? iPLedgeASVApprovedCr[0].get("v.value") : iPLedgeASVApprovedCr.get("v.value");
        var iPLedgeASVPerc = component.find("iPLedgeASVPerc");
        iPLedgeASVPerc = Array.isArray(iPLedgeASVPerc) ? iPLedgeASVPerc[0].get("v.value") : iPLedgeASVPerc.get("v.value");

        if (iLimitedPledge == 'Yes') {
            var iPledgeAmt = component.find("iPledgeAmt");
            iPledgeAmt = Array.isArray(iPledgeAmt) ? iPledgeAmt[0].get("v.value") : iPledgeAmt.get("v.value");
            nominalValue = iPledgeRealisticMarketVal;
            if (iPledgeAmt < nominalValue) { nominalValue = iPledgeAmt; }
        }
        if (iLimitedPledge == 'No') {
            nominalValue = iPledgeRealisticMarketVal;
        }

        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            component.find('iPLedgeApprovedSecurityValueASV').set('v.value', nominalValue * iPLedgeASVPerc / 100);
            if (iPLedgeASVApprovedCr && iPLedgeASVApprovedCr > 0) {
                component.find('iPLedgeApprovedSecurityValueASV').set('v.value', nominalValue * iPLedgeASVApprovedCr / 100);
            }
        }
    },

    unitTrustCalcs: function (component) {
        var iUnitVal = component.find("iUnitVal");
        iUnitVal = Array.isArray(iUnitVal) ? iUnitVal[0].get("v.value") : iUnitVal.get("v.value");

        var iNumberofUnits = component.find('iNumberofUnits');
        iNumberofUnits = Array.isArray(iNumberofUnits) ? iNumberofUnits[0].get("v.value") : iNumberofUnits.get("v.value");

        var iUnitTrustsLimitedCession = component.find("iUnitTrustsLimitedCession");
        iUnitTrustsLimitedCession = Array.isArray(iUnitTrustsLimitedCession) ? iUnitTrustsLimitedCession[0].get("v.value") : iUnitTrustsLimitedCession.get("v.value");

        var nominalValueField = component.find("iUnitTrustsNominalValue");
        var nominalValue;
        if (iUnitTrustsLimitedCession == 'Y') {
            var iUnitTrustsCessionAmt = component.find("iUnitTrustsCessionAmt");
            iUnitTrustsCessionAmt = Array.isArray(iUnitTrustsCessionAmt) ? iUnitTrustsCessionAmt[0].get("v.value") : iUnitTrustsCessionAmt.get("v.value");
            if (iUnitVal && iNumberofUnits) {
                nominalValue = parseFloat(iUnitVal) * parseFloat(iNumberofUnits);
                if (iUnitTrustsCessionAmt && iUnitTrustsCessionAmt < nominalValue) { nominalValue = iUnitTrustsCessionAmt; }
            } else { nominalValue = iUnitTrustsCessionAmt; }
        }
        if (iUnitTrustsLimitedCession == 'N') {
            if (iUnitVal && iNumberofUnits) { nominalValue = parseFloat(iUnitVal) * parseFloat(iNumberofUnits); }
        }
        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
        }

        var iUnitTrustsASVCr = component.find("iUnitTrustsASVCr");
        iUnitTrustsASVCr = Array.isArray(iUnitTrustsASVCr) ? iUnitTrustsASVCr[0].get("v.value") : iUnitTrustsASVCr.get("v.value");
        if (iUnitTrustsASVCr && iUnitTrustsASVCr > 0) { component.find('iUnitTrustsApprovedSecValue').set('v.value', iUnitTrustsASVCr * nominalValue / 100); }
        else {
            var iUnitTrustsASVPerc = component.find("iUnitTrustsASVPerc");
            iUnitTrustsASVPerc = Array.isArray(iUnitTrustsASVPerc) ? iUnitTrustsASVPerc[0].get("v.value") : iUnitTrustsASVPerc.get("v.value");
            component.find('iUnitTrustsApprovedSecValue').set('v.value', iUnitTrustsASVPerc * nominalValue / 100)
        }
    },

    generalCessionCalc: function (component) {
        var iGeneralLimitedCession = component.find("iGeneralLimitedCession");
        iGeneralLimitedCession = Array.isArray(iGeneralLimitedCession) ? iGeneralLimitedCession[0].get("v.value") : iGeneralLimitedCession.get("v.value");

        var nominalValueField = component.find("iGeneralNominalVal");
        var nominalValue;

        var iGeneralRealisticMarketVal = component.find("iGeneralRealisticMarketVal");
        iGeneralRealisticMarketVal = Array.isArray(iGeneralRealisticMarketVal) ? iGeneralRealisticMarketVal[0].get("v.value") : iGeneralRealisticMarketVal.get("v.value");

        var iGeneralASVCr = component.find("iGeneralASVCr");
        iGeneralASVCr = Array.isArray(iGeneralASVCr) ? iGeneralASVCr[0].get("v.value") : iGeneralASVCr.get("v.value");
        var iGeneralASVPerc = component.find("iGeneralASVPerc");
        iGeneralASVPerc = Array.isArray(iGeneralASVPerc) ? iGeneralASVPerc[0].get("v.value") : iGeneralASVPerc.get("v.value");

        if (iGeneralLimitedCession == 'Y') {
            var iGeneralCessionAmt = component.find("iGeneralCessionAmt");
            iGeneralCessionAmt = Array.isArray(iGeneralCessionAmt) ? iGeneralCessionAmt[0].get("v.value") : iGeneralCessionAmt.get("v.value");
            nominalValue = parseFloat(iGeneralRealisticMarketVal) < parseFloat(iGeneralCessionAmt) ? parseFloat(iGeneralRealisticMarketVal) : parseFloat(iGeneralCessionAmt);
        }

        if (iGeneralLimitedCession == 'N') {
            nominalValue = parseFloat(iGeneralRealisticMarketVal) != null ? parseFloat(iGeneralRealisticMarketVal) : 0;
        }

        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            if (iGeneralASVCr && iGeneralASVCr > 0) { component.find('iGeneralApprovedSecValue').set('v.value', nominalValue * parseFloat(iGeneralASVCr) / 100); }
            else { component.find('iGeneralApprovedSecValue').set('v.value', nominalValue * parseFloat(iGeneralASVPerc) / 100); }
        }
    },

    linkCalcs: function (component) {
        var iLinklimitedCession = component.find("iLinklimitedCession");
        iLinklimitedCession = Array.isArray(iLinklimitedCession) ? iLinklimitedCession[0].get("v.value") : iLinklimitedCession.get("v.value");

        var iLinkFSV = component.find("iLinkFSV");
        iLinkFSV = Array.isArray(iLinkFSV) ? iLinkFSV[0].get("v.value") : iLinkFSV.get("v.value");

        var iLinkASV = component.find("iLinkASV");
        iLinkASV = Array.isArray(iLinkASV) ? iLinkASV[0].get("v.value") : iLinkASV.get("v.value");

        var nominalValueField = component.find("iLinkNominalValue");
        var nominalValue;

        if (iLinklimitedCession == 'Y') {
            var iLinkAmountCeded = component.find("iLinkAmountCeded");
            iLinkAmountCeded = Array.isArray(iLinkAmountCeded) ? iLinkAmountCeded[0].get("v.value") : iLinkAmountCeded.get("v.value");

            nominalValue = parseFloat(iLinkFSV);
            if (nominalValue < parseFloat(iLinkAmountCeded)) { nominalValue = parseFloat(iLinkAmountCeded); }
        }

        if (iLinklimitedCession == 'N') {
            nominalValue = parseFloat(iLinkFSV);
        }

        if (nominalValue) {
            nominalValueField = Array.isArray(nominalValueField) ? nominalValueField[0].set("v.value", nominalValue) : nominalValueField.set("v.value", nominalValue);
            component.find('iLinkApprovedValue').set('v.value', nominalValue * parseFloat(iLinkASV) / 100);
        }
    },

    deleteSecurityOffered: function (component, recId, secType) {
        var action = component.get("c.deleteSecurityOfferedRecord");
        action.setParams({
            secId: recId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.fireToast("Success", secType + " record deleted successfully", "success");
                this.getExistingSecuritiesforAccount(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error securitiesOfferedCTRL.deleteSecurityOfferedRecord: " + JSON.stringify(errors));
                this.fireToast("Error", secType + " record NOT deleted successfully", "error");
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, securitiesOfferedCTRL.deleteSecurityOfferedRecord state returned: " + state);
                this.fireToast("Error", secType + " record NOT deleted successfully", "error");
            }
        });
        $A.enqueueAction(action);
    },

    iGenericFormLoad: function (component, form, limCession, showLimCession, specificSec, specificSecBoolean, agreeAccs) {
        if (form == 'General Cession') {
            var iGeneralCessionType = component.find('iGeneralCessionType');
            iGeneralCessionType = Array.isArray(iGeneralCessionType) ? iGeneralCessionType[0].get("v.value") : iGeneralCessionType.get("v.value");
            if (iGeneralCessionType == 'RENTALS' || iGeneralCessionType == 'CESS OF RENTALS') { component.set('v.monthlyRentalMandatory', true); }
            if (iGeneralCessionType == 'INHERIT' || iGeneralCessionType == 'CESS OF INHERITANCE') { component.set('v.executorMandatory', true); }
        }

        if (form != 'Letter of Undertaking' && form != 'Excon Ruling' && form != 'Cession of Fire/Short Term Insurance' && form != 'Bonds and 99-year Leasehold'
            && form != 'Cession of Debtors') {
            var iLimitedCession = component.find(limCession);
            iLimitedCession = Array.isArray(iLimitedCession) ? iLimitedCession[0].get("v.value") : iLimitedCession.get("v.value");
            if (iLimitedCession == 'Y' || iLimitedCession == 'Yes') {
                component.set(showLimCession, true);
            }
        }

        if (form == 'Suretyship') {
            var iCessionLoanAcc = component.find('iCessionLoanAcc');
            if (iCessionLoanAcc){
                iCessionLoanAcc = Array.isArray(iCessionLoanAcc) ? iCessionLoanAcc[0].get("v.value") : iCessionLoanAcc.get("v.value");
                if (iCessionLoanAcc == 'Yes') {
                    component.set('v.showiCessionAccLimited', true);
                    var iCessionAccLimited = component.find('iCessionAccLimited');
                    if (iCessionAccLimited){
                        iCessionAccLimited = Array.isArray(iCessionAccLimited) ? iCessionAccLimited[0].get("v.value") : iCessionAccLimited.get("v.value");
                        if (iCessionAccLimited == 'Yes') {
                            component.set('v.showiCessionLoanAccAmt', true);
                        }
                    }
                }
            }

            var iSupportedBySec = component.find('iSupportedBySec');
            if (iSupportedBySec){
                iSupportedBySec = Array.isArray(iSupportedBySec) ? iSupportedBySec[0].get("v.value") : iSupportedBySec.get("v.value");
                if (iSupportedBySec == 'Yes') {
                    component.set('v.showiApprovedSec', true);
                    var iApprovedSec = component.find('iApprovedSec');
                    if (iApprovedSec){
                        iApprovedSec = Array.isArray(iApprovedSec) ? iApprovedSec[0].get("v.value") : iApprovedSec.get("v.value");
                        if (iApprovedSec == 'Yes') { component.set('v.showiSuretyDateSigned', true); }
                    }
                }
            }
        }

        var iSpecificSecurity = component.find(specificSec);
        if (iSpecificSecurity) {
            iSpecificSecurity = Array.isArray(iSpecificSecurity) ? iSpecificSecurity[0].get("v.value") : iSpecificSecurity.get("v.value");
            if (iSpecificSecurity === 'Yes') {
                component.set(specificSecBoolean, true);
                //added by Manish for W-011371
                var suretyAccs = component.find('iSuretyAccs');
                console.log('yeah hopw many times do we call >>>> ' + suretyAccs);
                if (suretyAccs){
                    suretyAccs = Array.isArray(suretyAccs) ? suretyAccs[0].get("v.value") : suretyAccs.get("v.value");
                    if (suretyAccs != undefined) {
                        var selectedRows = JSON.parse(suretyAccs);
                        var selectedIds = [];
                        var selectedAccounts = [];
                        selectedRows.forEach(function (res) {
                            selectedIds.push(res.Id);
                            selectedAccounts.push(res);
                        });
                        component.set("v.selectedAccountIds", selectedIds);
                        component.set("v.selectedAccounts", selectedAccounts);
                    }
                }
            } else {
                component.set(specificSecBoolean, false);
            }
        }
    },

    sendMessage: function (component, event, helper) {
        var payload = {
            refresh: true
        };

        component.find("securitiesMessageChannel").publish(payload);
    },
    //added by Manish for W-011371
    getNewExistingSecurities: function (component, event, helper) {
        var action = component.get("c.getNewExistingProducts");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                var resp = JSON.parse(JSON.stringify(returnValue));
                resp.forEach(function (res) {
                    if (res.Account_Number__c == null || res.Account_Number__c == undefined) {
                        res.Temp_Account_Number__c = 'CHQ-' + res.Temp_Account_Number__c
                    } else {
                        res.Temp_Account_Number__c = '';
                    }
                });
                console.log('why me - >>>>'+resp);
                component.set("v.newExistingSecuritiesOffered", resp);
            } else {
                console.log("getOpportunityUniqueIdentifierss Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    }
})