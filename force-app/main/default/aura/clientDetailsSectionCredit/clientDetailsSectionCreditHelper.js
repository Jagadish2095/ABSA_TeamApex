({
    getClientDetails: function (component, event, helper) {
        var oppId;
        if (component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId"); //when the component is on the NTB form
        }
        else {
            oppId = component.get("v.recordId") //when the component is on the Account form
        }

        var action = component.get("c.getClientDetails");

        return new Promise(function (resolve, reject) {
            action.setParams({
                "opprtunityId": oppId
            });

            action.setCallback(this, function (response) {
                var state = response.getState();

                if (component.isValid() && state === "SUCCESS") {
                    console.log('response%%' + response.getReturnValue());
                    resolve(response.getReturnValue());
                }
                else if (component.isValid() && state === "ERROR") {
                    var errors = response.getError()[0];
                    reject(errors);
                    helper.showError(response, "getClientDetails");
                }
            });

            $A.enqueueAction(action);
        });
    },

    initializeOptions: function (component) {
        var residentStatus = [
            { class: "optionClass", label: "Select an Option", value: "Select an Option", selected: true },
            { class: "optionClass", label: "Boarder", value: "Boarder" },
            { class: "optionClass", label: "Caravan", value: "Caravan" },
            { class: "optionClass", label: "Rented Flat", value: "Rented Flat" },
            { class: "optionClass", label: "Owner", value: "Owner" },
            { class: "optionClass", label: "Living with Parents", value: "Living with Parents" },
            { class: "optionClass", label: "Tenant", value: "Tenant" }
        ];

        component.set("v.addOptions", '');
        component.set("v.borOptions", residentStatus);
    },

    saveHandler: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        var account = component.get("v.data");
        var isClientSoleTrader = false;

        var isCreditMaintenance = false;
        if (component.get("v.OppRecord.RecordTypeName__c") == 'Credit_Maintenance') {
            isCreditMaintenance = true;
        }
        if (isCreditMaintenance) {
            account.fundnumber = component.get("v.data.fundnumber");
        }
        if (account.ClientType.toLowerCase() == "sole trader") {
            isClientSoleTrader = true;
        }

        if (!isCreditMaintenance) {
            //var chText1 = (!isClientSoleTrader ? false : component.find("iIsClientPartOfAnEnterpriseDevelopmentFund").get("v.value"));
            //var chText2 = (!isClientSoleTrader ? false : component.find("iClientOperatesUnderAnExistingFranchiseContractAgreement").get("v.value"));

            /*if(chText1 != null && isClientSoleTrader) {
                component.set("v.data.IsClientPartOfAnEnterpriseDevelopmentFund", chText1);
            }

            if(chText2 != null && isClientSoleTrader) {
                component.set("v.data.ClientOperatesUnderAnExistingFranchiseContractAgreement", chText2);
            }*/

            if (component.get("v.data.IsClientDeclaredInsolvencyLiquidationPast") != null && component.get("v.data.IsClientDeclaredInsolvencyLiquidationPast") != undefined) {
                account.IsClientDeclaredInsolvencyLiquidationPast = component.get("v.data.IsClientDeclaredInsolvencyLiquidationPast");
            }
            //if(!isCreditMaintenance){
            //account.BusinessStartDate = component.get("v.data.BusinessStartDate");
            account.IsClientIntendsToGoIntoBusinessRescue = component.get("v.data.IsClientIntendsToGoIntoBusinessRescue");
            account.IsClientIntendsInsolvencyLiquidation = (isClientSoleTrader ? false : component.get("v.data.IsClientIntendsInsolvencyLiquidation"));
            account.IsClientIsStokvel = component.find("iClientIsStokvel").get("v.value");
            account.IsClientIsAMunicipality = (isClientSoleTrader ? false : component.find("iClientIsAMunicipality").get("v.value"));
            account.IsTradingIndicator = component.get("v.data.IsTradingIndicator");
            account.BusinessRescueAffectedParty = component.get("v.data.BusinessRescueAffectedParty");

            // }
            if (isClientSoleTrader) {
                account.ResidentialStatusAddress = component.get("v.data.ResidentialStatusAddress");
                account.ResidentialStatusBorder = component.get("v.data.ResidentialStatusBorder");
                account.DateCurrentAddressSince = component.get("v.data.DateCurrentAddressSince");
                account.TemporaryResidentPermitNumber = component.get("v.data.TemporaryResidentPermitNumber");
                account.TemporaryResidentPermitExpiryDate = component.get("v.data.TemporaryResidentPermitExpiryDate");
                account.IsClientPartOfAnEnterpriseDevelopmentFund = component.get("v.data.IsClientPartOfAnEnterpriseDevelopmentFund");
                account.DevelopmentFundPartnerClientCode = component.get("v.data.DevelopmentFundPartnerClientCode");
                account.DevelopmentFundName = component.get("v.data.DevelopmentFundName");
                account.ClientOperatesUnderAnExistingFranchiseContractAgreement = component.get("v.data.ClientOperatesUnderAnExistingFranchiseContractAgreement");
                account.FranchiseCode = component.get("v.data.FranchiseCode");
                account.FranchiseName = component.get("v.data.FranchiseName");
                account.fundNumber = component.get("v.data.fundNumber");
                account.Segment = component.get("v.data.Segment");
            }
        }
        //<!-- W:5585 : Saurabh : Removing the Marketing fields as per Story
        // account.IsEmailNonCredit = component.find("iEmailNonCredit").get("v.value");
        // account.IsEmailCredit = component.find("iEmailCredit").get("v.value");
        // account.IsSMSNonCredit = component.find("iSMSNonCredit").get("v.value");
        // account.IsSMSCredit = component.find("iSMSCredit").get("v.value");
        //account.IsPhoneNonCredit = component.find("iPhoneNonCredit").get("v.value");
        // account.IsPhoneCredit = component.find("iPhoneCredit").get("v.value");
        // account.Marketing_Consent_Info__c = component.get("v.data.EmailCredit");
        // account.Marketing_Consent_SMS__c = component.get("v.data.SMSCredit");
        // account.Marketing_Consent_Phone__c = component.get("v.data.PhoneCredit");
        // account.Non_Credit_Marketing_Consent_Email__c = component.get("v.data.EmailNonCredit");
        // account.Non_Credit_Marketing_Consent_SMS__c = component.get("v.data.SMSNonCredit");
        // account.Non_Credit_Marketing_Consent_Phone__c = component.get("v.data.PhoneNonCredit");
        var toastEvent;
        if (account.IsClientDeclaredInsolvencyLiquidationPast != null && account.IsClientIntendsInsolvencyLiquidation != null) {
            if (account.IsClientDeclaredInsolvencyLiquidationPast == true && account.IsClientIntendsInsolvencyLiquidation == true) {
                toastEvent = helper.getToast("Error!", "Select only one between Client has declared insolvency/liquidation in the past and Client intends to declare insolvency/liquidation!", "error");
                toastEvent.fire();

            } else {
                var updateEvent = $A.get("e.c:clientDetailsSectionCreditEvent");
                updateEvent.setParams({ "account": account });
                updateEvent.fire();
            }
        }
    },

    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });

        return toastEvent;
    },

    showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }

        // show error notification
        var toastEvent = this.getToast("Error: ClientDetailsSectionCredit " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})