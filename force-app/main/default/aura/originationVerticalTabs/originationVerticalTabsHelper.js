({
    hideChildCmp: function (component, event) {
        //hide all the components here
        var div1 = component.find("div1");
        $A.util.addClass(div1, "slds-hide");
        var div2 = component.find("div2");
        $A.util.addClass(div2, "slds-hide");
        var div3 = component.find("div3");
        $A.util.addClass(div3, "slds-hide");
        var div4 = component.find("div4");
        $A.util.addClass(div4, "slds-hide");
        var spouse = component.find("spouse");
        $A.util.addClass(spouse, "slds-hide");
        var div6 = component.find("div6");
        $A.util.addClass(div6, "slds-hide");
        var div7 = component.find("div7");
        $A.util.addClass(div7, "slds-hide");
        var div9 = component.find("div9");
        $A.util.addClass(div9, "slds-hide");
        var div10 = component.find("div10");
        $A.util.addClass(div10, "slds-hide");
        var div11 = component.find("div11");
        $A.util.addClass(div11, "slds-hide");
        var div12 = component.find("div12");
        $A.util.addClass(div12, "slds-hide");
        var securityExisting = component.find("securityExisting");
        $A.util.addClass(securityExisting, "slds-hide");
        var aips = component.find("aips");
        $A.util.addClass(aips, "slds-hide");
        var solePropAssetsLiabs = component.find("solePropAssetsLiabs");
        $A.util.addClass(solePropAssetsLiabs, "slds-hide");
        var div12 = component.find("pricingAndFees");
        $A.util.addClass(div12, "slds-hide");
        var div12 = component.find("termsofBusiness");
        $A.util.addClass(div12, "slds-hide");
        var div12 = component.find("acceptTOB");
        $A.util.addClass(div12, "slds-hide");
        var ConditionTab = component.find("conditions");
        $A.util.addClass(ConditionTab, "slds-hide");
        var AgreementTab = component.find("Agreement");
        $A.util.addClass(AgreementTab, "slds-hide");
        var fulfilmentVerTab = component.find("fulfillmentApplication");
        $A.util.addClass(fulfilmentVerTab, "slds-hide");
        var illustrativeDecision = component.find("illustrativeDecision");
        $A.util.addClass(illustrativeDecision, "slds-hide");
        var locateCall = component.find("locateCall");
        $A.util.addClass(locateCall, "slds-hide");
        var decisionSummary = component.find("decisionSummary");
        $A.util.addClass(decisionSummary, "slds-hide");
        var validation2 = component.find("validation2");
        $A.util.addClass(validation2, "slds-hide");
        var validation3 = component.find("validation3");
        $A.util.addClass(validation3, "slds-hide");
        var validation4 = component.find("validation4");
        $A.util.addClass(validation4, "slds-hide");
        var validation5 = component.find("validation5");
        $A.util.addClass(validation5, "slds-hide");
        var scorecardTab = component.find("scorecard");
        $A.util.addClass(scorecardTab, "slds-hide");
        var creditCard = component.find("creditCard");
        $A.util.addClass(creditCard, "slds-hide");
        var bankGuarantee = component.find("bankGuarantee");
        $A.util.addClass(bankGuarantee, "slds-hide");
        var termLoan = component.find("termLoan");
        $A.util.addClass(termLoan, "slds-hide");
    },

    getSuperUser: function (component, event) {
        var action = component.get("c.getSuperUsersAll");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var superUSer = response.getReturnValue();
                console.log("superUSer: " + JSON.stringify(superUSer));
                component.set("v.isSuperUser", superUSer);
            }
        });

        $A.enqueueAction(action);
    },

    getIldsFlag: function (component, event, helper) {
        var oppAccRecord = component.get("v.oppAccRecord");
        var isOtherClientTypes = ((oppAccRecord != null && (oppAccRecord.Account.Client_Type__c == "Company"
            || oppAccRecord.Account.Client_Type__c == "Private Company"
            || oppAccRecord.Account.Client_Type__c == "Incorporated Company"
            || oppAccRecord.Account.Client_Type__c == "Close Corporation"
            || oppAccRecord.Account.Client_Type__c == "Partnership")) ? true : false);

        component.set("v.isOtherClientTypes", isOtherClientTypes);
        var isSoletrader = component.get("v.isSoleTrader");

        if ((isOtherClientTypes && !isSoletrader) || isSoletrader) {
            component.set("v.completedTabsList", "Consumer_Bureau_Captured");
        }
        else {
            component.set("v.completedTabsList", "Commercial_Bureau_Captured");
        }

        var action = component.get("c.getIllustrativeDecisionFlag");

        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var illustrativeDecisionFlag = response.getReturnValue();
                console.log('illustrativeDecisionFlag' + illustrativeDecisionFlag);
                component.set("v.illustrativeDecisionFlag", illustrativeDecisionFlag);

            }
            console.log('vv');
        });

        $A.enqueueAction(action);
    },

    getLocateCallState: function (component) {
        var action = component.get("c.isLocateCallRequired");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("locate call result: " + JSON.stringify(result));
                component.set("v.isLocateCallRequired", result);
            }
        });

        $A.enqueueAction(action);
    },

    refreshValidations: function (objChild) {
        if (objChild.length > 1) {
            objChild.forEach((child) => (child.RefreshFromOriginationTab()));
        }
        else {
            objChild.RefreshFromOriginationTab();
        }
    },

    //Saurabh : W: 11629
    // Adding method to display product tabs based on family selection
    getSelectedProductFamily: function (component, event) {
        var action = component.get("c.getSelectedProductFamily");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var productFamilyList = response.getReturnValue();
                console.log("productFamilyList: " + JSON.stringify(productFamilyList));
                component.set("v.listItems", productFamilyList);
                //--added by Saurabh for W-012285 -->
                //if Cheque Product Family is selected then ConductOnly is false
                var chequeFamilySelected = productFamilyList.indexOf('Cheque & Overdraft') != -1 ? false : true;
                component.set("v.conductAccountsOnly", chequeFamilySelected);
                //added by Manish for W-012105
                var showCreditCard = productFamilyList.indexOf('Credit Card') != -1 ? true : false;
                component.set("v.showCreditTab", showCreditCard);
                //W-012105 changes end
                var showBankGuarantee = productFamilyList.indexOf('Bank Guarantee') != -1 ? true : false;
                component.set("v.showBGTab", showBankGuarantee);
                var showTermLoan = productFamilyList.indexOf('Term Loan') != -1 ? true : false;
                component.set("v.showTLTab", showTermLoan);
            }
        });

        $A.enqueueAction(action);
    },

    //Saurabh : #W-007224
    // Adding method to display next tabs based on application progress
    getCompletedTabsList: function (component, event) {

        //var productfamily = component.get("v.listItems");
        //console.log('productfamily---'+JSON.stringify(productfamily));
        var action = component.get("c.getCompletedTabs");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var completedTabsList = response.getReturnValue();

                console.log("completedTabsList: " + JSON.stringify(completedTabsList));
                component.set("v.completedTabs", completedTabsList);

            }
        });

        $A.enqueueAction(action);
    },

    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
})