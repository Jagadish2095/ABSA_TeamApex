({
    doInit: function (component, event, helper) {
        helper.checkStockNumber(component);
        //helper.getApplication(component);
        //helper.getEDFdetails(component, event, helper);
        var action = component.get("c.getApplicationDetails");

        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (data) {
            component.set("v.applicationList", data.getReturnValue());
            var showapp = data.getReturnValue();
            var stockNumber;

            if (showapp !== null) {
                stockNumber = showapp.Stock_Number__c;
                component.set("v.appId", showapp.Id);
                if (stockNumber === null || stockNumber === undefined) {
                    helper.submitStockDetails(component, event, helper);
                }
                helper.getEDFdetails(component, event, helper,showapp);
            }
        });

        $A.enqueueAction(action);
    },
    showfranchiseList : function (component, event, helper) {
      //var fValue = event.getSource().get("v.value");
      //component.set("v.showFranchiseList",fValue);
    },
    showEDFList : function (component, event, helper) {
      var fValue = event.getSource().get("v.value");
      console.log('showEDFList'+component.get("v.showEDFList"));
       /* if(component.get("v.showEDFList")){
            component.set("v.showEDFList",false);
        }
        else{
            component.set("v.showEDFList",true);
        }*/

    },
    getMaxFieldText: function (component, event, helper) {
        var fValue = event.getSource().get("v.value");
        if(fValue.length > 15) {
            var toastEvent = helper.getToast("Error!", "Maximum characters on field reached!", "error");
            toastEvent.fire();
        }
    },

    handleUpdateAccount: function (component, event, helper) {
        var account = component.get("v.account");
        var selectedPrin = component.get("v.selectedPrincipal");
        var selectedMainPrin = component.get("v.selectedMainPrincipal");
        var isInfoPrinCorrect = component.get("v.isPrincipalInfoCorrect");
        var isInfoPrinRequired = component.get("v.isPrincipalInfoRequired");
        var maxNumberSelected = component.get("v.maxNumberSelected");
        var principalsDetails = component.get("v.principalsDetails");

        var updatedAcc = event.getParam("account");
        var updatedPrin = event.getParam("selectedPrincipal");
        var updatedMainPrin = event.getParam("selectedMainPrincipal");
        var upIsInfoPrinCorrect = event.getParam("isPrincipalInfoCorrect");
        var upIsInfoPrinRequired = event.getParam("isPrincipalInfoRequired");
        var upMaxNumberSelected = event.getParam("maxNumberSelected");
        var upPrincipalsDetails = event.getParam("principalsDetails");

        component.set("v.account", (updatedAcc != null ? updatedAcc : account));
        component.set("v.selectedPrincipal", (updatedPrin != null ? updatedPrin : selectedPrin));
        component.set("v.selectedMainPrincipal", (updatedMainPrin != null ? updatedMainPrin : selectedMainPrin));
        component.set("v.isPrincipalInfoCorrect", (upIsInfoPrinCorrect != null ? upIsInfoPrinCorrect : isInfoPrinCorrect));
        component.set("v.isPrincipalInfoRequired", (upIsInfoPrinRequired != null ? upIsInfoPrinRequired : isInfoPrinRequired));
        component.set("v.maxNumberSelected", (upMaxNumberSelected != null ? upMaxNumberSelected : maxNumberSelected));
        component.set("v.principalsDetails", (upPrincipalsDetails != null ? upPrincipalsDetails : principalsDetails));
    },

    validateAndContinue: function (component, event, helper) {
        var oppRecord = component.get("v.oppRecord");
        var apcId = component.get("v.apcId");
        var isNcaValidated = false;

        var assetValue = component.find('assetValue');
        var assetVal = assetValue.get("v.value");

        var annualTurnover = component.find('annualTurnover');
        var annualTurnoverVal = annualTurnover.get("v.value");

        var numberOfTrusteesVal = component.find('numberOfTrustees').get("v.value");
        var anyJuristicTrusteeVal = component.find('anyJuristicTrustee').get("v.value");
        var isTrustAccount = ((oppRecord.Account.Client_Type__c && oppRecord.Account.Client_Type__c.toLowerCase() == "trusts") ? true : false);
        var isSoleTraderAccount = ((oppRecord.Account.Client_Type__c && oppRecord.Account.Client_Type__c.toLowerCase() == "sole trader") ? true : false); // Tinashe - W-010733

        var isInfoCorrect = ((oppRecord.Account.Client_Type__c && oppRecord.Account.Client_Type__c.toLowerCase() == "sole trader") ? true : component.get("v.isPrincipalInfoCorrect"));
        var isInfoRequired = component.get("v.isPrincipalInfoRequired");
        var maxNumberSelected = component.get("v.maxNumberSelected");
        var selectedIDs = component.get("v.selectedPrincipal");
        var selectedMainID = component.get("v.selectedMainPrincipal");
        var toastEvent;
        var prinMissingInfo;


        if (!oppRecord.Selected_Product_Family__c) {
            toastEvent = helper.getToast("Error!", "Application not Verified, Please Ensure you have Selected a Product or Contact your Administrator!", "error");
            toastEvent.fire();
        }
        else if (selectedIDs && selectedMainID == null && isInfoRequired && !isSoleTraderAccount) {
            toastEvent = helper.getToast("Error!", "Please select main PRINCIPAL/SHAREHOLDER!", "error");
            toastEvent.fire();
        }
        else if (selectedIDs && selectedMainID != null && (selectedIDs.length < parseInt(maxNumberSelected)) && !isSoleTraderAccount) {
            toastEvent = helper.getToast("Error!", "Please select all PRINCIPAL/SHAREHOLDER(s) up to a maximum of 4!", "error");
            toastEvent.fire();
        }
        else if (!helper.validatePrincipalsDet(component) && !isSoleTraderAccount) {
            var prinMissingInfo = component.get("v.prinMissingInfo");
            toastEvent = helper.getToast("Error!", "Please capture all missing info for "+ prinMissingInfo +" under PRINCIPAL/SHAREHOLDER(s) section!", "error");
            toastEvent.fire();
        }
        else if ((!isInfoCorrect) && isInfoRequired && !isSoleTraderAccount) {
            toastEvent = helper.getToast("Error!", "Please confirm that the PRINCIPAL/SHAREHOLDER(s) information is correct!", "error");
            toastEvent.fire();
        }
        else if (!annualTurnoverVal) {
            toastEvent = helper.getToast("Error!", "Please fill in Annual Turnover!", "error");
            toastEvent.fire();
        }
        else if (!assetVal) {
            toastEvent = helper.getToast("Error!", "Please fill in Asset Value!", "error");
            toastEvent.fire();
        }
        else if (!numberOfTrusteesVal && isTrustAccount) {
            toastEvent = helper.getToast("Error!", "Please fill in Number of Trustees!", "error");
            toastEvent.fire();
        }
        else if (!anyJuristicTrusteeVal && isTrustAccount) {
            toastEvent = helper.getToast("Error!", "Please fill in Any Juristic Trustees!", "error");
            toastEvent.fire();
        }
        else {
            isNcaValidated = true;
            helper.updateClientDetails(component, event, helper);
            var isClntValidated = component.get("v.isClntValidated");

            if (isNcaValidated && isClntValidated) {
                //validate if stage moves or not
                component.set("v.isNcaValidated", isNcaValidated);

                helper.updatePrincipal(component);
                helper.updateNCA(component, event, helper);
                helper.updateEDFDetails(component, event, helper);
            }
        }
    }
})