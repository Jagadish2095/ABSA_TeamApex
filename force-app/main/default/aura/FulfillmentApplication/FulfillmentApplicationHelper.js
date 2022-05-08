({
    //Function to retrieve the Account/Contact data via apex query
    fetchClientData: function (component, event, helper) {
        var action = component.get("c.getClientData");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("FulfillmentApplicationHelper Client Data: " + JSON.stringify(resp));
                component.set("v.clientCodeReviewData", resp);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error FulfillmentApplicationController.getClientData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, FulfillmentApplicationController.getClientData state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    //added by gulafsha
    fetchUserData: function (component, event, helper) {
        var action = component.get("c.fetchUser");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("FulfillmentApplicationHelper User Data: " + JSON.stringify(resp));
                component.set("v.hasRegion", resp);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error FulfillmentApplicationController.fetchUserData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, FulfillmentApplicationController.fetchUserData state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    //Added By Himani Joshi
    updateCompliance: function (component, event, helper) {
        var action = component.get("c.getUpdatedCompliance");
        action.setParams({
            oppId: component.get("v.recordId"),
            checkboxValue: component.get("v.checkboxValue")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.isCompliant", resp);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error FulfillmentApplicationController.getUpdatedCompliance: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, FulfillmentApplicationController.getUpdatedCompliance state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    //Function to retrieve the product data via apex query
    fetchProductData: function (component, event, helper) {
        var action = component.get("c.getCreditProductData");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("FulfillmentApplicationHelper Product Data: " + JSON.stringify(resp));
                component.set("v.productsForFulfillmentData", resp['Accepted']);
                //added by Manish for w-011452
                this.fetchSecuritiesOfferedForApprovedProd(component, event, helper);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error FulfillmentApplicationController.getCreditProductData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, FulfillmentApplicationController.getCreditProductData state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    //Submit to fulfillment creating a credit fulfillment case for each parent product
    submitToFulfillment: function (component, event, helper) {
        //helper.showSpinner(component, event, helper);
        var action = component.get("c.createFulfillmentCase");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("FulfillmentApplicationHelper Create Case(s) method: " + JSON.stringify(resp));
                if (resp == "Success") {
                    helper.fireToast("success", "Success!", "Application submitted for fulfillment. Fulfillment Case(s) created successfully.", "");
                } else {
                    helper.fireToast("error", "Error!", "Application not submitted for fulfillment. " + JSON.stringify(resp), "");
                    component.find("submitFulfillment").set("v.disabled", false);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error FulfillmentApplicationController.createFulfillmentCase: " + JSON.stringify(errors));
                component.find("submitFulfillment").set("v.disabled", false);
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, FulfillmentApplicationController.createFulfillmentCase state returned: " + state);
                component.find("submitFulfillment").set("v.disabled", false);
            }
            helper.hideSpinner(component, event, helper);
        });
        $A.enqueueAction(action);
    },

    //Function to retrieve the Securities Offered data via apex query
    securitiesOfferedData: function (component, event, helper) {
        helper.showSpinner(component, event, helper);
        var action = component.get("c.getSecuritiesOfferedData");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("FulfillmentApplicationHelper Securities Data: " + JSON.stringify(resp));
                component.set("v.securitiesOfferedData", resp);
                helper.validateFulfillmentData(component, event, helper);

            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error FulfillmentApplicationController.getSecuritiesOfferedData: " + JSON.stringify(errors));
                helper.hideSpinner(component, event, helper);
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, FulfillmentApplicationController.getSecuritiesOfferedData state returned: " + state);
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },

    //Validates that the Products have Account number (applicable to new products)
    //               the Main Applicant's onboarding status is Compliant
    //               the Related parties all have CIF codes
    //               the Related parties who offered a security has the appropriate role of Sureties
    validateFulfillmentData: function (component, event, helper) {
        var hasregion = component.get("v.hasRegion");
        console.log('hasregion' + hasregion);
        if (!hasregion) {
            helper.fireToast("error", "Error!", "Application not submitted for fulfillment. No region for the Banker User.", "");
            component.find("submitFulfillment").set("v.disabled", false);
            helper.hideSpinner(component, event, helper);
        }
        else {
            var error = false;
            var errorMsg = "";
            var productsForFulfillmentFinal = component.get("v.productsForFulfillmentData");
            for (var i = 0; i < productsForFulfillmentFinal.length; i++) {
                //New accepted product has Account Number validation check
                if ((!$A.util.isEmpty(productsForFulfillmentFinal[i].productState) && productsForFulfillmentFinal[i].productState == "New")
                    && $A.util.isEmpty(productsForFulfillmentFinal[i].productAccountNumber) && (productsForFulfillmentFinal[i].productName != 'Credit Card')) {
                    error = true;
                    errorMsg += "* There is a " + productsForFulfillmentFinal[i].productName + " product without an account number. Account number required.\n";
                }
                //Check for review date before fulfillment W-013970
            }
            
            var isAllProductfulfilled;
             for (var i = 0; i < productsForFulfillmentFinal.length; i++) {
                 
                  if(productsForFulfillmentFinal[i].productStatus == 'Pipeline For Fulfillment' || productsForFulfillmentFinal[i].productStatus == 'FulFilled'){
                     
                      isAllProductfulfilled = true;
                  }else if(productsForFulfillmentFinal[i].productStatus != 'Pipeline For Fulfillment' || productsForFulfillmentFinal[i].productStatus != 'FulFilled'){
                     isAllProductfulfilled = false;
                      break;
                  }
              
            }
            
            if(isAllProductfulfilled){
                 	error = true;
                    errorMsg += "Product(s) is/are already Pipelined For Fulfillment Or Fulfilled ! Can't Submit For Fulfillment Again.";
                	component.find("submitFulfillment").set("v.disabled", false);
             
            }

            var clientCodeReviewDataList = component.get("v.clientCodeReviewData");
            var securitiesOfferedDataList = component.get("v.securitiesOfferedData");
            for (var k = 0; k < clientCodeReviewDataList.length; k++) {
			//Main applicant Onboarding Status validation check
			/*
			if(clientCodeReviewDataList[k].isApplicant == true){
				if(clientCodeReviewDataList[k].onboardingStatus != "Compliant"){
					error = true;
					errorMsg += "* Customer " + clientCodeReviewDataList[k].clientName + " not fully onboarded.\n";
				}
			}
*/          var isCompliant = component.get('v.isCompliant');
                if (clientCodeReviewDataList[k].isApplicant == true) {
                    if (!isCompliant) {
                        error = true;
                        errorMsg += "* Customer " + clientCodeReviewDataList[k].clientName + " not fully onboarded.\n";
                    }
                }
                //Related party CIF validation check
                if ($A.util.isEmpty(clientCodeReviewDataList[k].clientCode)) {
                    error = true;
                    errorMsg += "* " + clientCodeReviewDataList[k].clientName + " is not onboarded to CIF.\n";
                }

                if (!$A.util.isEmpty(securitiesOfferedDataList)) {
                    for (var x = 0; x < securitiesOfferedDataList.length; x++) {
                        if (clientCodeReviewDataList[k].clientCode == securitiesOfferedDataList[x].Client_Code__c) {
                            if (!$A.util.isEmpty(clientCodeReviewDataList[k].Roles) && !clientCodeReviewDataList[k].Roles.includes("Sureties")) {
                                error = true;
                                errorMsg += "* " + clientCodeReviewDataList[k].clientName + " doesn't have a Role of Sureties but has offered a Security.\n";
                            }
                        }
                    }
                }
            }

            if (error) {
                helper.hideSpinner(component, event, helper);
                helper.fireToast("error", "Error!", errorMsg, "sticky");
            } else {
                component.find("submitFulfillment").set("v.disabled", true);
                helper.fireToast("success", "Success!", "Fulfillment process started.", "");
                helper.submitToFulfillment(component, event, helper);
            }
        }
    },

    /*@ Author: Danie Booysen
      **@ Date: 24/01/2021
      **@ Description: Method that fires a toast message(event)*/
    fireToast: function (type, title, message, mode) {
        var toastMode;
        if (mode == "") {
            toastMode = "dismissible"
        } else {
            toastMode = mode;
        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message,
            "mode": toastMode
        });
        toastEvent.fire();
    },

    //Open Modal
    openModalHelper: function (component) {
        component.set("v.isModalSpinner", true);
        $A.util.addClass(component.find("accountDetailsModal"), "slds-fade-in-open");
        $A.util.addClass(component.find("Modalbackdrop"), "slds-backdrop--open");
    },

    //Close Modal
    closeModalHelper: function (component) {
        component.find("prodFulfillDatatable").set("v.selectedRows", []);
        component.set("v.applicationProductId", null);
        $A.util.removeClass(component.find("Modalbackdrop"), "slds-backdrop--open");
        $A.util.removeClass(component.find("accountDetailsModal"), "slds-fade-in-open");
    },

    /*@ Author: Danie Booysen
      **@ Date: 09/04/2020
      **@ Description: Method that shows the spinner*/
    showSpinner: function (component, event, helper) {
        component.set("v.isMainSpinner", true);
    },

    /*@ Author: Danie Booysen
      **@ Date: 08/04/2020
      **@ Description: Method that hides the spinner*/
    hideSpinner: function (component, event, helper) {
        component.set("v.isMainSpinner", false);
    },
    //added by Manish for W-011452
    fetchSecuritiesOfferedForApprovedProd: function (component, event, helper) {
        var action = component.get("c.getSecuritiesOfferedData");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.securitiesOfferedData", response.getReturnValue());
                this.fetchRequiredDocs(component, event, helper);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error FulfillmentApplicationController.getSecuritiesOfferedData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, FulfillmentApplicationController.getSecuritiesOfferedData state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    //added by Manish for W-011452
    fetchRequiredDocs: function (component, event, helper) {
        var products = component.get("v.productsForFulfillmentData");
        var securitiesOffered = component.get("v.securitiesOfferedData");
        var action = component.get("c.getRequiredDocs");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var requiredApplicationDocs = [], requiredAgreementDocs = [], requiredSecurityDocs = [], tempAccNumber = [], accNumber = [], selectedAccId = [];
                var docs = response.getReturnValue();;
                products.forEach(function (product) {
                    if (product.parentTempAccountNumber != undefined) {
                        if (product.productName.includes('Overdraft')) {
                            tempAccNumber.push('CHQ-' + product.parentTempAccountNumber);
                        }
                    }
                    else if (product.parentAccountNumber != undefined) {
                        accNumber.push(product.parentAccountNumber);
                    }
                    else if (product.tempAccountNumber != undefined) {
                        tempAccNumber.push(product.tempAccountNumber);
                    }
                    securitiesOffered.forEach(function (securityOff) {
                        var selectedAcc = securityOff.Suretyship_Selected_Accounts__c != undefined && securityOff.Suretyship_Selected_Accounts__c.length > 0 ? JSON.parse(securityOff.Suretyship_Selected_Accounts__c) : [];
                        selectedAcc.forEach(function (acc) {
                            if (acc.Application_Product_Parent__c == product.Id)
                                selectedAccId.push(securityOff.Id);
                        });
                    });
                });
                products.forEach(function (prod) {
                    docs.forEach(function (doc) {
                        if (prod.productName.includes(doc.Product__c) && doc.Document_Type__c == 'Application Forms') {
                            var accNumber = prod.AccountNumber != undefined ? prod.AccountNumber : doc.Product__c == 'Overdraft' ? 'CHQ-' + prod.tempAccountNumber : prod.tempAccountNumber;
                            requiredApplicationDocs.push({ 'Id': prod.Id, 'productName': prod.productName, 'account_Unique_No': accNumber, 'applicationForms': doc.Applications__c });
                        }
                        else if (prod.productName.includes(doc.Product__c) && doc.Document_Type__c == 'Agreements') {
                            var accNumber = prod.AccountNumber != undefined ? prod.AccountNumber : doc.Product__c == 'Overdraft' ? 'CHQ-' + prod.tempAccountNumber : prod.tempAccountNumber;
                            if (prod.ncaAppplicable != undefined && (doc.Rule__c.includes(prod.ncaAppplicable) || prod.ncaAppplicable.includes(doc.Rule__c))) {
                                requiredAgreementDocs.push({ 'Id': prod.Id, 'productName': prod.productName, 'account_Unique_No': accNumber, 'agreements': doc.Applications__c });
                            }
                        }
                    });
                });
                docs.forEach(function (doc) {
                    if (doc.Document_Type__c == 'Security Documents') {
                        securitiesOffered.forEach(function (security) {
                            if (security.Security_Type__c == doc.Rule__c && (accNumber.indexOf(security.Reference_Account_Number__c) != -1 || tempAccNumber.indexOf(security.Unique_Identifier__c) != -1 || selectedAccId.indexOf(security.Id) != -1)) {
                                var provider = security.Contact__c != undefined ? security.Contact__r.Name : security.Client_Name__c != undefined ? security.Client_Name__c : security.Account__r.Name;
                                requiredSecurityDocs.push({ 'Id': security.Id, 'securityType': security.Security_Type__c, 'providerName': provider, 'document': doc.Applications__c });
                            }
                        });
                    }
                });
                component.set("v.requiredApplicationDocs", requiredApplicationDocs);
                component.set("v.requiredAgreementDocs", requiredAgreementDocs);
                component.set("v.requiredSecurityDocs", requiredSecurityDocs);
                console.log('requiredAgreementDocs ' + JSON.stringify(requiredAgreementDocs));
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error FulfillmentApplicationController.fetchRequiredDocs: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, FulfillmentApplicationController.fetchRequiredDocs state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})