({
    fetchData: function (component) {
        var oppId;
        if (component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId");
        } else {
            oppId = component.get("v.recordId")
        }

        var action = component.get("c.getRelatedParties");
        console.log("Opp Id " + oppId);
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
              //  console.log('getRelatedParties '+JSON.stringify(data));
                component.set("v.data", data);
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
   getPrimaryAccount: function (component) {
        var oppId;
        if (component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId");
        } else {
            oppId = component.get("v.recordId")
        }
        console.log('<<< recopp id is >>> ' + oppId);

        var action = component.get("c.getPrimaryAccount");
        console.log("Opp Id " + oppId);
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('<<< returned value >>> ' + JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('getPrimary >>>> '+JSON.stringify(data));
                component.set("v.primaryAcc", data);
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },

    getExistingSecurities: function (component) {
        var oppId;
        if (component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId");
        } else {
            oppId = component.get("v.recordId")
        }

        var action = component.get("c.getSecuritiesOffered");
        console.log("Opp Id " + oppId);
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var nominalSumVal = 0;
                var asvSum = 0;
                var data = response.getReturnValue();

                var count = Object.keys(data).length;
                console.log(count);
                var options = [];
                if(count > 0){
                    for(var i = 0; i < data.length; i++){
                        var secProviderName='';
                        var securityAmount=0;
                        var ref = '';
                        if (data[i].Securities_Offered_for_Facility__c == 'Existing'){
                            ref = data[i].Reference_Account_Number__c;
                        }
                        if (data[i].Securities_Offered_for_Facility__c == 'New'){
                            ref = data[i].Unique_Identifier__c;
                        }
                        if (data[i].Specific_Security__c == 'No'){
                            ref = 'Not Linked';
                        }

                        if (data[i].hasOwnProperty('Contact__r') == true) {
                            secProviderName = data[i].Contact__r.Name;
                        }
                        if (data[i].hasOwnProperty('Contact__r') == false && data[i].External_Entity_Linked__c == true) {
                            secProviderName = data[i].Account__r.Name;
                        }
                        if (data[i].hasOwnProperty('Contact__r') == false && data[i].External_Entity_Linked__c == false) {
                            secProviderName=data[i].Client_Name__c;
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

                        options.push({Id: data[i].Id, Name: secProviderName, Security_Type__c: data[i].Security_Type__c,
                            Security_Description__c: data[i].Security_Description__c, securityAmount: securityAmount,
                            Nominal_Value__c: data[i].Nominal_Value__c, ASV_approved_by_Credit__c: asvPerc,
                            Approved_security_value__c: data[i].Approved_security_value__c,
                            Reference_Account_Number__c: ref});

                        nominalSumVal = nominalSumVal + data[i].Nominal_Value__c;
                        asvSum = asvSum + data[i].Approved_Security_Value_ASV__c;
                    }
                     component.set('v.nominalSum',nominalSumVal);
                     component.set('v.totalASVSum',asvSum);
                }
                component.set("v.existingSecurities", data);
                component.set("v.securitiesOfferedData", options);
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },

    showSelectedProducts : function(component, event, helper) {
        var action = component.get("c.getOpportunityLineItems");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
             //   console.log('returnValue' + JSON.stringify(returnValue));
                 component.set("v.SelectedProducts", returnValue);
              /*  if (returnValue != null) {
                    component.set("v.SelectedProduct", returnValue.Product2.Name);
                    this.getAbsaSite(component);
                }
                var selectedProduct = component.get("v.SelectedProduct");
                if(selectedProduct != '' && selectedProduct != null){
                    component.set("v.isButtonVisible", false);
                }*/
            }
        });
        $A.enqueueAction(action);
    },

/**   asvCalculations : function(component, event, helper) {
        console.log('<<<asvCalculations>>>');
        var action = component.get("c.getASVCalculations");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('returnValue getASVCalculations>>>>>' + JSON.stringify(returnValue));
                component.set("v.APP_APP_SECO_ASV_OFFERED", returnValue.APP_APP_SECO_ASV_OFFERED);
                console.log('this is APP_APP_SECO_ASV_OFFERED >>> ' + component.get("v.APP_APP_SECO_ASV_OFFERED"));

                component.set("v.APP_APP_SECO_SUPPORTING_NON_SPECIFIC", returnValue.APP_APP_SECO_SUPPORTING_NON_SPECIFIC);
                console.log('this is APP_APP_SECO_SUPPORTING_NON_SPECIFIC >>> ' + component.get("v.APP_APP_SECO_SUPPORTING_NON_SPECIFIC"));

                component.set("v.APP_APP_SECO_SUPPORTING_SPECIFIC", returnValue.APP_APP_SECO_SUPPORTING_SPECIFIC);
                console.log('this is APP_APP_SECO_SUPPORTING_SPECIFIC >>> ' + component.get("v.APP_APP_SECO_SUPPORTING_SPECIFIC"));

                var APP_PRD_SECO_SPECIFIC = returnValue.APP_PRD_SECO_SPECIFIC;
                var appPRDSECOSPECIFIC = [];
                for (var key in APP_PRD_SECO_SPECIFIC){
                    console.log(key + ' >>><<<< ' + APP_PRD_SECO_SPECIFIC[key]);
                    appPRDSECOSPECIFIC.push({account: key, amount: APP_PRD_SECO_SPECIFIC[key]});
                }
                component.set('v.APP_PRD_SECO_SPECIFIC',appPRDSECOSPECIFIC);

                var APP_PRD_SECO_SUPPORTING_SPECIFIC = returnValue.APP_PRD_SECO_SUPPORTING_SPECIFIC;
                var appPRDSECOSUPPORTINGSPECIFIC = [];
                for (var key in APP_PRD_SECO_SUPPORTING_SPECIFIC){
                    console.log(key + ' >>><<<< ' + APP_PRD_SECO_SUPPORTING_SPECIFIC[key]);
                    appPRDSECOSUPPORTINGSPECIFIC.push({account: key, amount: APP_PRD_SECO_SUPPORTING_SPECIFIC[key]});
                }
                component.set('v.APP_PRD_SECO_SUPPORTING_SPECIFIC',appPRDSECOSUPPORTINGSPECIFIC);
            } else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    **/
})