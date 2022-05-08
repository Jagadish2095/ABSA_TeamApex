({
    saveSelectedProduct: function (component, event, helper) {
        component.find("saveProductBtn").set("v.disabled", true);
        var product = component.get("v.selectedProductRecord");
        var action = component.get("c.saveOpportunityLineItem");
        // console.log('product.Id: ' + product.Name);

        //T Senkomane JULY 2020 :  added to show error when no product selected
        if (!product) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": 'Please Select a Product Before Saving!'

            });
            toastEvent.fire();
        }
        if (product != null) {
            action.setParams({
                oppId: component.get("v.recordId"),
                productId: product.Id,
                productName : product.Name
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    var applicationId = returnValue['applicationId'];
                    var opportunityProductId = returnValue['opportunityProductId'];
                    var userSite = returnValue['userSite'];
                    var siteRegion = returnValue['siteRegion'];
                    var error = returnValue['error'];
                    if (applicationId) {
                        component.set("v.applicationId", applicationId);
                    }
                    if (opportunityProductId) {
                        component.set("v.opportunityProductId", opportunityProductId);
                    }
                    if (userSite) {
                        component.set("v.userSite", userSite);
                    }
                    if (siteRegion) {
                        component.set("v.siteRegion", siteRegion);
                    }

                    if (error) {
                        helper.fireToast("Error", error, "error");
                    } else {
                        helper.fireApplicationEvent(component, event, helper);
                        component.set("v.SelectedProduct", product.Name);
                        component.set("v.isButtonVisible", false); //Disable the button to prevent adding more than single Product
                        $A.get('e.force:refreshView').fire(); //Refresh the page once reocrd is Created Successfully
                        helper.fireToast("Success!", "Product added successfully.", "success");
                    }
                    component.find("saveProductBtn").set("v.disabled", false);
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    var errors2 = JSON.stringify(errors); //W-004819 Masechaba Maseli
                    console.log('errors: ' + JSON.stringify(errors));
                    component.find("saveProductBtn").set("v.disabled", false);

                    if (errors2.includes("Please select a valid product for your Merchant Onboarding")) { //W-004819 Masechaba Maseli

                        helper.fireToast("Error!", "Please select a valid product for your Merchant Onboarding.", "error");//W-004819 Masechaba Maseli

                    }//W-004819 Masechaba Maseli

                    else {//W-004819 Masechaba Maseli
                        helper.fireToast("Error!", "Something went wrong. Error: " + JSON.stringify(errors), "error");
                    }//W-004819 Masechaba Maseli
                } else {
                    component.find("saveProductBtn").set("v.disabled", false);
                    helper.fireToast("Error!", "Something went wrong.", "error");
                }
            });
            $A.enqueueAction(action);
        }
    },

    showSelectedProduct: function (component, event, helper) {

        var action = component.get("c.getOpportunityLineItem");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('retrunValue' + JSON.stringify(returnValue));
                if (returnValue != null) {
                    component.set("v.SelectedProduct", returnValue.Product2.Name);
                    this.getAbsaSite(component);
                }
                var selectedProduct = component.get("v.SelectedProduct");
                if (selectedProduct != '' && selectedProduct != null) {
                    component.set("v.isButtonVisible", false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getAbsaSite: function (component) {

        var action = component.get("c.getAbsaSite");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                component.set("v.userSite", returnValue);

            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('errors: ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);

    },

    fireApplicationEvent: function (component, event, helper) {
        console.log("fireApplicationEvent");
        // Fire onboardingOpportunityIdsCreated Applicaion Event
        var appEvent = $A.get("e.c:onboardingOpportunityIdsCreated");
        appEvent.setParams({
            "sourceComponent": "OnboardingProductInformation",
            "opportunityId": component.get("v.recordId"),
            "opportunityProductId": component.get("v.opportunityProductId"),
            "applicationId": component.get("v.applicationId")
        });
        appEvent.fire();
    },

    //Lightning toastie
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type": type
        });
        toastEvent.fire();
    },

    saveIllustrativeDecision: function (component, event, helper) {
        console.log("updateIllustrativeDecision " + component.get("v.illustrativeDecision"));
        var action = component.get("c.updateIllustrativeDecision");
        action.setParams({
            oppId: component.get("v.recordId"),
            illustrativeDecision: component.get("v.illustrativeDecision")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('errors: ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    },
    //Added By Himani Joshi
    getOpp: function (component, event, helper) {
      var action = component.get("c.getOpportunity");
        action.setParams({
            oppId: component.get("v.recordId"),
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var opp = response.getReturnValue();
                component.set('v.illustrativeDecision',opp.Illustrative_Decision__c);
                console.log('illustrativeDecision'+component.get('v.illustrativeDecision'));
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('errors: ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    }
})