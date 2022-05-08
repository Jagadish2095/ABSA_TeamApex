({
	helperMethod : function() {
	},
    
    showSpinner : function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner : function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    checkBankingDetailsValidated: function(component) {

            var action = component.get("c.checkBankingDetailsValidated");
            action.setParams({
                opportunityId: component.get("v.recordId")
            });

            action.setCallback(this, function(response) {

                var state = response.getState();

                if (state === "SUCCESS") {

                    if (response.getReturnValue()) {

                        component.set("v.bankDetailsValidated", true);

                    } else {

                        component.set("v.bankDetailsValidated", false);
                        component.set("v.bankDetailsPendingValidation", true);

                    }
                } else if (state === "INCOMPLETE") {
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {

                        console.log("Unknown error");
                    }
                }
            });

            $A.enqueueAction(action);
        },
    
    checkPaymentPreferenceSetTypeonApplication : function(component) {
        this.showSpinner(component);
        var action = component.get("c.checkPaymentPreferenceSetTypeonApplication");
		action.setParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.draftingFeePaymentMethod", response.getReturnValue());
                var draftingFeePaymentMethod = component.get("v.draftingFeePaymentMethod");
                if (draftingFeePaymentMethod == "Fees Paid") {
                    this.checkBankingDetailsValidated(component);
                }
                if (draftingFeePaymentMethod == 'Fees Waived' || draftingFeePaymentMethod == 'Fees for Estate Provider Plan'|| draftingFeePaymentMethod == 'Fees for Staff' ||draftingFeePaymentMethod == 'Fees Paid') {
                    component.set("v.draftingFeeNotFound", false);
                    component.set("v.showSafeCustody", false);
                    component.set("v.showSafeCustodyRequired", false);
                    
                } else {
                    component.set("v.draftingFeeNotFound", true);
                    component.set("v.showSafeCustody", false);
                    component.set("v.showSafeCustodyRequired", false);
                }
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    submitPayment : function(component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.updateApplication");
        var SCFPaymentIndicator;
        if (component.get("v.selectSCFPaymentOption") == 'Yes') {
            SCFPaymentIndicator = 'Yes';
        } else if (component.get("v.selectSCFPaymentOption") == 'No') {
            SCFPaymentIndicator = 'No';
        }
        var SCFRequired;
        if (component.get("v.selectSCFPaymentRequired") == 'Yes') {
            SCFRequired = 'Yes';
        } else if (component.get("v.selectSCFPaymentRequired") == 'No') {
            SCFRequired = 'No';
        }
        
        action.setParams({
            "opportunityId" : component.get("v.recordId"),
            "SCFPaymentIndicator" : SCFPaymentIndicator,
            "SCFRequired" : SCFRequired
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                if (component.get("v.selectSCFPaymentRequired") == 'No') {
                    component.set("v.showSafeCustodyRequired", false);
                    component.set("v.SCFTypeIsSet", true);
                    component.set("v.showSCFRequired", true);
                    component.set("v.showSaveButton", false);
                    component.set("v.showEditButton", true);
                    component.set("v.showCancelButton", false);
                } else if (component.get("v.selectSCFPaymentOption") == 'No') {
                    this.validatePayment(component, event, helper);
                } else if (component.get("v.selectSCFPaymentOption") == 'Yes') {
                    this.copyPayment(component, event, helper);
                }
            }   
            this.hideSpinner(component);
        });       
        $A.enqueueAction(action);
    },
    
    fetchDraftingFeePaymentMethod : function(component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.getPaymentMethod");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "type": 'Will Drafting Fee'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS" ) {
                component.set("v.draftingFeePaymentPlanMethod", response.getReturnValue());
            }
            this.hideSpinner(component);
        });       
        $A.enqueueAction(action);
    },
    
    fetchPickListVal : function(component, fieldName, elementId) {
        this.showSpinner(component);
        var action = component.get("c.getSelectOptions");
        	action.setParams({
            "objObject": component.get("v.paymentPlan"),
        	"fld": fieldName
        });
                
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var allValues = response.getReturnValue();
                if (elementId == 'PaymentMethod') {
                    opts.push({class: "optionClass", label: "Debit Instruction",value: "Debit Instruction"});
                } else if (elementId == 'AccountType') {
                    opts.push({class: "optionClass", label: "--- None ---", value: ""});
                    opts.push({class: "optionClass", label: "Cheque",value: "Cheque"});
                    opts.push({class: "optionClass", label: "Savings",value: "Savings"});
                } else if (allValues != undefined && allValues.length > 0) {
                    opts.push({class: "optionClass", label: "--- None ---", value: ""});                        
                    for (var i = 0; i < allValues.length; i++) {
                        opts.push({class: "optionClass", label: allValues[i], value: allValues[i]});
                    }
                }
                
            	if (elementId == 'PaymentMethod') {
                    component.set("v.paymentMethodOptions", opts);
                } else if (elementId == 'AccountType') {
                    component.set("v.accTypeOptions", opts);
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    updateSafeCustodyFeeStatus : function(component, safeCustodyFeeStatus) {
        this.showSpinner(component);
        var action = component.get("c.updateSafeCustodyFeeStatus");
        action.setParams({
            opportunityId: component.get("v.recordId"),
            safeCustodyFeeStatus: safeCustodyFeeStatus
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            this.hideSpinner(component);
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },

    setBankingDetailsValidationStatus : function(component, bankingDetailsValidationStatus) {

            var action= component.get("c.setBankingDetailsValidationStatus");
            action.setParams({
                opportunityId: component.get("v.recordId"),
                bankingDetailsValidationStatus: bankingDetailsValidationStatus
            });
            action.setCallback(this, function(response) {

                var state = response.getState();

                if (state === "SUCCESS") {
                } else if (state === "INCOMPLETE") {
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
                $A.get('e.force:refreshView').fire();
            });
            $A.enqueueAction(action);
        },
    
    validatePayment : function (component, event, helper) {
        var allValid = true;        
        if (allValid) {
            if (component.get("v.selectedPaymentAmount") == null) {
                allValid = false; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Amount cannot be blank.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }
        
        if (allValid) {
            var accountType = component.get("v.selectedAccType");
            if (component.get("v.selectedAccType").length == 0) {
                allValid = false; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Account Type cannot be blank. Please correct before continuing.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }
        
        if (allValid) {
            if (component.get("v.selectedBankName").length == 0) {
                allValid = false; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Bank Name cannot be blank. Please correct before continuing.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }
        
        if (allValid) {
            if (component.get("v.selectedBranchName").length == 0) {
                allValid = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Branch Name cannot be blank. Please correct before continuing.",
                    "type":"error"
                });
                toastEvent.fire();
            }    
        }
        
        if (allValid) {
            var accountNumber = component.get("v.selectedAccNumber");
            if (accountNumber.length == 0) {
                allValid = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Bank Account Number cannot be blank. Please correct before continuing.",
                    "type":"error"
                });
                toastEvent.fire();
            } else {
                var letters = /^[0-9]+$/;   		
                if (!accountNumber.toString().match(letters)) {
                    allValid = false; 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Bank Account Number can only have numeric values. Please correct before continuing.",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
        }
        
        if (allValid) {
            if (component.get("v.selectedBankName") == 'ABSA BANK LIMITED') {
                //Absa bank account validations
                this.showSpinner(component);
                var action = component.get("c.validateAbsaBankAccount");
                var accountType = component.get("v.selectedAccType");
                var accountNumber = component.get("v.selectedAccNumber");
                var branchCode = component.get("v.selectedBranchCode");
                var amount = component.get("v.selectedPaymentAmount");                
        		action.setParams({
                    "accountNumber": accountNumber,
            		"accountType": accountType,
                    "branchCode": branchCode,
                    "amount": amount
        		});
        		action.setCallback(this, function(response) {
            		var state = response.getState();
                	if (state === "SUCCESS" ) {
                        if (response.getReturnValue()) {
                            var toastEvent = $A.get("e.force:showToast");
                			toastEvent.setParams({
                    			"title": "Success",
                    			"message": component.get("v.selectedBankName") + " bank account details validated successfully.",
                    			"type": "Success"
                			});
                			toastEvent.fire();
                        	//component.set("v.showSavePaymentPlanButton", true);
                        	this.submitPaymentPlan(component, event, helper);
                        	component.set("v.bankDetailsValidated", true);
                            component.set("v.bankDetailsPendingValidation", false);
                        	this.setBankingDetailsValidationStatus(component, "Valid");
                        } else {
                            var toastEvent = $A.get("e.force:showToast");
                        	toastEvent.setParams({
                            	"title": "Error",
                            	"message": "Invalid bank account details. Please correct before continuing." ,
                            	"type":"Error"
                        	});
                        	toastEvent.fire();
                        }
                	}
                    this.hideSpinner(component);
        		});
        		$A.enqueueAction(action);
            } else {
                //first check if the bank is on the AVS list
                this.showSpinner(component);
                var action = component.get("c.checkIfBankIsOnAVSList");
                action.setParams({
                    bankName: component.get("v.selectedBankName")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        if (response.getReturnValue()) {
                            //Non-Absa AVS banks bank account validation
                            var action = component.get("c.validateAVSBankAccount");
                            var accountNumber = component.get("v.selectedAccNumber");
                            var branchCode = component.get("v.selectedBranchCode");
                            var bankName = component.get("v.selectedBankName");
                            var accountType = component.get("v.selectedAccType");
                            action.setParams({
                                "opportunityId": component.get("v.recordId"),
                                "accountNumber": accountNumber,
                                "branchCode": branchCode,
                                "bankName": bankName,
                                "accountType": accountType
                            });
                            action.setCallback(this, function(response) {

                                var state = response.getState();

                                if (state === "SUCCESS" ) {

                                    var result = response.getReturnValue();
                                    var toastEvent = $A.get("e.force:showToast");

                                    switch (result) {

                                        case "Pending":

                                            toastEvent.setParams({
                                                "title": "Warning",
                                                "message": "Unable to proceed with " + component.get("v.selectedBankName") + " verification, validation result is pending. You may however proceed with the Opportunity." ,
                                                "type": "Warning",
                                                "mode": "sticky"
                                            });
                                            toastEvent.fire();
                                            //this.updateDraftingFeeStatus(component, result);
                                            this.updateSafeCustodyFeeStatus(component, result);
                                            this.submitPaymentPlan(component, event, helper);
                                            this.setBankingDetailsValidationStatus(component, "Invalid");
                                            component.set("v.bankDetailsValidated", false);
                                            component.set("v.bankDetailsPendingValidation", true);
                                            break;

                                        case "Pass":

                                            toastEvent.setParams({
                                                "title": "Success",
                                                "message": component.get("v.selectedBankName") + " bank account details validated successfully.",
                                                "type": "Success"
                                            });
                                            toastEvent.fire();
                                            //component.set("v.showSavePaymentPlanButton", true);
                                            this.updateSafeCustodyFeeStatus(component, result);
                                            this.submitPaymentPlan(component, event, helper);
                                            this.setBankingDetailsValidationStatus(component, "Valid");
                                            component.set("v.bankDetailsValidated", true);
                                            component.set("v.bankDetailsPendingValidation", false);
                                            break;

                                        case "Fail-ValidationUnsuccessful":

                                            toastEvent.setParams({
                                                "title": "Error",
                                                "message": component.get("v.selectedBankName") + " bank account details verification failed. Please rectify before continuing further." ,
                                                "type":"Error",
                                                "mode": "sticky"
                                            });
                                            toastEvent.fire();
                                            break;

                                        case "Fail-ServiceOffline":
                                            toastEvent.setParams({
                                                "title": "Warning",
                                                "message": "Unable to proceed with " + component.get("v.selectedBankName") + " verification, validation service temporarily unavailable. Please contact your System Administrator, however you may proceed with the Opportunity." ,
                                                "type":"Warning"
                                            });
                                            toastEvent.fire();
                                            //component.set("v.showSavePaymentPlanButton", true);
                                            this.updateSafeCustodyFeeStatus(component, result);
                                            this.submitPaymentPlan(component, event, helper);
                                            this.setBankingDetailsValidationStatus(component, "Invalid");
                                            component.set("v.bankDetailsValidated", false);
                                            component.set("v.bankDetailsPendingValidation", true);
                                            break;
                                    }
                                }

                                this.hideSpinner(component);

                            });

                            $A.enqueueAction(action);

                        } else {
                            //For all other banks do check digit bank account validation (because the CheckDigitVerification switch is true)
                            if (component.get("v.CheckDigitVerification")) {
                                this.showSpinner(component);
                                var action = component.get("c.checkBankAccount");
                                var accountNumber = component.get("v.selectedAccNumber");
                            	var branchCode = component.get("v.selectedBranchCode");
                                var accountTypeStr = component.get("v.selectedAccType");
                                var accountType;
                                if(accountTypeStr == 'Cheque') {
                                    accountType = '01';
                                } else if(accountTypeStr == 'Savings') {
                                    accountType = '02';
                                } else if(accountTypeStr == 'Transmission') {
                                    accountType = '03';
                                }
                                action.setParams({
                                    "accountNumber": accountNumber,
                                    "branchCode": branchCode,
                                    "accountType": accountType
                                });
                                action.setCallback(this, function(response) {
                                    var state = response.getState();
                                    if (state === "SUCCESS" ) {
                                        if (response.getReturnValue()) {
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                "title": "Success",
                                                "message": component.get("v.selectedBankName") + " bank account details validated successfully.",
                                                "type": "Success"
                                            });
                                            toastEvent.fire();
                                            //component.set("v.showSavePaymentPlanButton", true);
                                            this.submitPaymentPlan(component, event, helper);
                                        } else {
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                "title": "Error",
                                                "message": "Invalid bank account details. Please correct before continuing." ,
                                                "type":"Error"
                                            }); 
                                            toastEvent.fire();
                                        }
                                    }
                                    this.hideSpinner(component);
                                });       
                            	$A.enqueueAction(action);
                            } else {
                                //bank validations are not required (because the CheckDigitVerification switch is false)
            					component.set("v.showSavePaymentPlanButton", false);
                            }
                        }
                    } else if (state === "INCOMPLETE") {
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        } else {

                            console.log("Unknown error");
                        }
                    }
                    this.hideSpinner(component);
                });
                $A.enqueueAction(action);
            }
        }
    },
    
    submitPaymentPlan : function (component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.submitPaymentPlanDetail");
        var method = 'Debit Instruction';
        var accNumber = component.get("v.selectedAccNumber");
        var accType = component.get("v.selectedAccType");
        var bankName = component.get("v.selectedBankName");
        var branchCode = component.get("v.selectedBranchCode");
        var branchName = component.get("v.selectedBranchName");
        var name = accType + ' - ' +  accNumber;
        var frequency = 'Yearly';
        var amount = component.get("v.selectedPaymentAmount");
        var status = 'New';
        var type = 'Will Safe Custody Fee';
        action.setParams({"opportunityId": component.get("v.recordId"),
                          "accNumber": accNumber,
                          "accType": accType,
                          "bankName": bankName,
                          "branchCode": branchCode,
                          "branchName": branchName,
                          "name": name,
                          "frequency": frequency,
                          "amount": amount,
                          "method": method,
                          "status": status,
                          "type": type
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (component.get("v.selectSCFPaymentOption") == 'Yes') {
                    component.set("v.selectSCFOption", true);
                } else if (component.get("v.selectSCFPaymentOption") == 'No') {
                    component.set("v.selectSCFOption", false);
                }
                component.set("v.SCFTypeIsSet", true);
                component.set("v.showPaymentDetails", true);
                component.set("v.showSafeCustody", false);
                component.set("v.showSafeCustodyRequired", false);
                component.set("v.showSavePaymentPlanButton", false);
                component.set("v.disableRadioButtonGroup", true);
                component.set("v.disableAccountType", true);
                component.set("v.disableBankAccountNumber", true);
                component.set("v.selectedBankNameReadOnly", component.get("v.selectedBankName"));
                component.set("v.selectedBranchNameReadOnly", component.get("v.selectedBranchName"));
                component.set("v.showBankNameReadOnly", true);
                component.set("v.showBankName", false);
                component.set("v.showBranchNameReadOnly", true);
                component.set("v.showBranchName", false);
                component.set("v.showSaveButton", false);
                component.set("v.showEditButton", true);
                component.set("v.showCancelButton", false);
                var opts = [];
                opts.push({class: "optionClass", label: component.get("v.selectedAccType"),value: component.get("v.selectedAccType")});
                component.set("v.accTypeOptions", opts);
//            	var toastEvent = $A.get("e.force:showToast");
//                toastEvent.setParams({
//                    "title": "Success!",
//                    "message": "Safe Custody information has been updated successfully.",
//                    "type":"success"
//                });
//                toastEvent.fire();
            }
            this.hideSpinner(component);
        });        
        $A.enqueueAction(action);
    },
    
    checkIfPaymentPlanExists : function(component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.existsPaymentPlan");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "type": 'Will Safe Custody Fee'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                if(response.getReturnValue()) {
                    this.fetchPaymentPlanDetails(component, event, helper);
                }
            }
            this.hideSpinner(component);
        });       
        $A.enqueueAction(action);
    },
    
    fetchPaymentPlanDetails : function(component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.selectByTypeByApplicationId");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "type": 'Will Safe Custody Fee'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                component.set("v.paymentPlan", response.getReturnValue());
                component.set("v.selectedPaymentMethod", component.get("v.paymentPlan.Method__c"));
                component.set("v.selectedPaymentFrequency", component.get("v.paymentPlan.Frequency__c"));
                component.set("v.selectedPaymentAmount", component.get("v.paymentPlan.Amount__c"));
                component.set("v.selectedAccType", component.get("v.paymentPlan.Account_Type__c"));
                component.set("v.selectedBankNameReadOnly", component.get("v.paymentPlan.Bank_Name__c"));
                component.set("v.selectedBranchNameReadOnly", component.get("v.paymentPlan.Branch_Name__c"));
                component.set("v.selectedBranchCode", component.get("v.paymentPlan.Branch_Code__c"));
                component.set("v.selectedAccNumber", component.get("v.paymentPlan.Account_Number__c"));
                component.set("v.disableRadioButtonGroup", true);
        		component.set("v.disableAccountType", true);
                component.set("v.disableBankAccountNumber", true);
                component.set("v.showBankName", false);
                component.set("v.showBankNameReadOnly", true);
                component.set("v.showBranchName", false);
                component.set("v.showBranchNameReadOnly", true);
                component.set("v.showPaymentDetails", true);
                component.set("v.showSaveButton", false);
                component.set("v.showEditButton", true);
               	component.set("v.showCancelButton", false);
                var opts = [];
                opts.push({class: "optionClass", label: component.get("v.selectedAccType"),value: component.get("v.selectedAccType")});
                component.set("v.accTypeOptions", opts);
            }
            this.hideSpinner(component);
        });       
        $A.enqueueAction(action);
    },
    
    fetchApplicationDetails : function(component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.selectByOpportunityId");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.SCFTypeIsSet", true);
                component.set("v.applicationDetail", response.getReturnValue());
                component.set("v.selectSCFPaymentRequired", component.get("v.applicationDetail.Safe_Custody_Is_Required__c"));
                if (component.get("v.applicationDetail.Safe_Custody_Is_Required__c") == 'Unselected') {                    
                    component.set("v.showSafeCustodyRequired", true);
                    component.set("v.showSaveButton", true);
                	component.set("v.showEditButton", false);
               		component.set("v.showCancelButton", false);
                } else if (component.get("v.applicationDetail.Safe_Custody_Is_Required__c") == 'No') {
                    component.set("v.selectSCFPaymentRequired", 'No');
                    component.set("v.showSafeCustodyRequired", false);
                    component.set("v.showSCFRequired", true);                    
                    component.set("v.showSaveButton", false);
                	component.set("v.showEditButton", true);
               		component.set("v.showCancelButton", false);
                } else if (component.get("v.applicationDetail.Safe_Custody_Required__c") == 'Yes') {
                    component.set("v.selectSCFPaymentRequired", 'Yes');
                    component.set("v.showSafeCustodyRequired", false);
                    component.set("v.showSCFRequired", false);                    
                } else if (component.get("v.applicationDetail.Safe_Custody_Payment_Same_As_Drafting__c") == 'Yes') {
                    component.set("v.selectSCFPaymentOption", 'Yes');
                    component.set("v.selectSCFOption", true);
                    component.set("v.showSafeCustody", false);
                    component.set("v.showSafeCustodyRequired", false);                    
                } else if (component.get("v.applicationDetail.Safe_Custody_Payment_Same_As_Drafting__c") == 'No') {
                    component.set("v.selectSCFPaymentOption", 'No');
                    component.set("v.selectSCFOption", false);
                    component.set("v.showSafeCustody", false);
                    component.set("v.showSafeCustodyRequired", false);
                }
            }
            this.hideSpinner(component);
        });       
        $A.enqueueAction(action);
    },
    
    fetchDraftingFeePaymentOption : function(component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.applicationExistsByOpportunityId");      
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                if (response.getReturnValue()) {
                    this.fetchApplicationDetails(component, event, helper);
                }
            }
            this.hideSpinner(component);
        });       
        $A.enqueueAction(action);
    },
    
    getPaymentMethod : function(component, event, helper) {
        this.showSpinner(component);
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.getDrafingFeePaymentMethod");
        action.setParams({
            "opportunityId": opportunityId,
            "type": 'Will Drafting Fee'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS" ) {
                component.set("v.draftingFeePaymentMethod", response.getReturnValue());
            }
            this.showSpinner(component);
        });       
        $A.enqueueAction(action);
    },
    
    copyPayment : function (component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.copyDraftingPaymentPlanAsSafeCustodyPaymentPlan");
        action.setParams({
        	opportunityId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (component.get("v.selectSCFPaymentOption") == 'Yes') {
                    component.set("v.selectSCFOption", true);
                } else if (component.get("v.selectSCFPaymentOption") == 'No') {
                    component.set("v.selectSCFOption", false);
                }
                component.set("v.SCFTypeIsSet", true);
                component.set("v.showSafeCustody", false);
                component.set("v.showSafeCustodyRequired", false);
                component.set("v.showPaymentDetails", true);
                component.set("v.showSavePaymentPlanButton", false);
                component.set("v.disableRadioButtonGroup", true);
                var opts = [];
                opts.push({class: "optionClass", label: component.get("v.selectedAccType"),value: component.get("v.selectedAccType")});
                component.set("v.accTypeOptions", opts);
                component.set("v.disableAccountType", true);
                component.set("v.disableBankAccountNumber", true);
                component.set("v.selectedBankNameReadOnly", component.get("v.selectedBankName"));
                component.set("v.selectedBranchNameReadOnly", component.get("v.selectedBranchName"));
                component.set("v.showBankNameReadOnly", true);
                component.set("v.showBankName", false);
                component.set("v.showBranchNameReadOnly", true);
                component.set("v.showBranchName", false);
                component.set("v.showSaveButton", false);
                component.set("v.showEditButton", true);
                component.set("v.showCancelButton", false);                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Safe Custody information has been updated successfully.",
                    "type":"success"
                });                
                toastEvent.fire();
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            this.hideSpinner(component);
        });        
        $A.enqueueAction(action);
		$A.get('e.force:refreshView').fire();        
    }
})