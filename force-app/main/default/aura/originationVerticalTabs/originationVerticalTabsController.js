({
    doInit: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.getIldsFlag(component, event, helper);
        helper.getSuperUser(component, event);
        helper.getLocateCallState(component);
        helper.getSelectedProductFamily(component, event);
        helper.getCompletedTabsList(component, event);
        // Check for client type
        var action = component.get("c.isSoleTraderAccount");

        action.setParams({
            oppId: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var results = response.getReturnValue();

                console.log("results in vertical doInit---", results);
                component.set("v.isSoleTrader", results);
            } else {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast("Error!", "Origination Tab: " + errors[0].message, "error");
                    }
                } else {
                    helper.showToast("Error!", "Origination Tab: unknown error", "error");
                }

                console.log(
                    "Failed with state in Origination Tab: " + JSON.stringify(response)
                );
            }

            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    /* Trying to init the cmp on Attest popup for Lazy loading
       Handler for applicationEvent */
    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        var opportunityId = event.getParam("opportunityId");
        console.log('App event Fired ++ ' + sourceComponent);
        if (sourceComponent == "CheckAndOverdraft" || sourceComponent == "GeneralQualitativeInfo"
            || sourceComponent == "ConsumerBureau" || sourceComponent == "CommercialBureau") {

            if (sourceComponent == "CommercialBureau") {
                component.set("v.commBureauData", event.getParam("commBureauData"));
            }
            if (sourceComponent == "ConsumerBureau") {
                component.set("v.consBureauData", event.getParam("consBureauData"));
            }
            var a = component.get("c.doInit");
            $A.enqueueAction(a);
        }
        // Condition to not handle self raised event
        if ((sourceComponent != null || sourceComponent != "") && opportunityId != null && opportunityId != "") {
            // Calling Init on App Event
            var a = component.get("c.doInit");
            $A.enqueueAction(a);
        }
    },

    toggleClass: function (component, event, helper) {
        helper.hideChildCmp(component, event); // Hide all components and show only selected child component
        var selectedvalue = component.get("v.selectedItem");

        console.log("value is::: " + selectedvalue);
        if (selectedvalue == "spouse") {
            var divChild = component.find("spouse");
            $A.util.removeClass(divChild, "slds-hide");
        }
        else if (selectedvalue == "TabOne") {
            var divChild = component.find("div1");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "creditCard") {
            var divChild = component.find("creditCard");
            $A.util.removeClass(divChild, "slds-hide");
        }
        else if (selectedvalue == "bankGuarantee") {
            var divChild = component.find("bankGuarantee");
            $A.util.removeClass(divChild, "slds-hide");

        }
            else if (selectedvalue == "termLoan") {
            var divChild = component.find("termLoan");
            $A.util.removeClass(divChild, "slds-hide");

        }else if (selectedvalue == "TabTwo") {
            var divChild = component.find("div2");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "TabThree") {
            var divChild = component.find("div3");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "TabFour") {
            var divChild = component.find("div4");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "TabSix") {
            var divChild = component.find("div6");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "TabSeven") {
            var divChild = component.find("div7");
            $A.util.removeClass(divChild, "slds-hide");
        } else if (selectedvalue == "TabNine") {
            var divChild = component.find("div9");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "TabTen") {
            var divChild = component.find("div10");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "TabEleven") {
            var divChild = component.find("div11");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "TabTwelve") {
            var divChild = component.find("div12");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "illustrativeDecision") {
            var divChild = component.find("illustrativeDecision");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "locateCall") {
            var divChild = component.find("locateCall");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "securityExisting") {
            var divChild = component.find("securityExisting");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "aips") {
            var divChild = component.find("aips");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "borrowingCapactiy") {
            var divChild = component.find("borrowingCapactiy");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "scorecard") {
            var divChild = component.find("scorecard");
            var scorecardCmp = component.find("scorecardCmp");
            $A.util.removeClass(divChild, "slds-hide");
            scorecardCmp.initializeCmpData();

        } else if (selectedvalue == "solePropAssetsLiabs") {
            var divChild = component.find("solePropAssetsLiabs");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "pricingAndFees") {
            var divChild = component.find("pricingAndFees");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "decisionSummary") {
            var divChild = component.find("decisionSummary");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "termsofBusiness") {
            var divChild = component.find("termsofBusiness");
            $A.util.removeClass(divChild, "slds-hide");
            var termsofBusinessCmp = component.find("termsofBusinessCmp");
            termsofBusinessCmp.initializeTOBCmpData();

        } else if (selectedvalue == "conditions") {
            var divChild = component.find("conditions");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "agreement") {
            var divChild = component.find("Agreement");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "acceptTOB") {
            var divChild = component.find("acceptTOB");
            $A.util.removeClass(divChild, "slds-hide");
            var accepttermsofBusinessCmp = component.find("acceptTOBcmp");
            accepttermsofBusinessCmp.initializeAcceptTOBCmpData();

        } else if (selectedvalue == "validation2") {
            var divChild = component.find("validation2");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "validation3") {
            var divChild = component.find("validation3");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "validation4") {
            var divChild = component.find("validation4");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "validation5") {
            var divChild = component.find("validation5");
            $A.util.removeClass(divChild, "slds-hide");

        } else if (selectedvalue == "fulfillmentApplication") {
            var divChild = component.find("fulfillmentApplication");
            var fulfillmentApplicationCmp = component.find("fulfillmentApplicationCmp");

            $A.util.removeClass(divChild, "slds-hide");
            fulfillmentApplicationCmp.initializeCmpData();
        } else {
            //  Block of code to be executed if the condition1 is false and condition2 is false
        }
    }
});