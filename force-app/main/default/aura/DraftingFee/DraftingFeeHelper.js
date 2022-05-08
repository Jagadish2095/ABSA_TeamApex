({
    helperMethod : function() {
    },
    
    doInit : function(component) {
        this.showSpinner(component);       
        var action = component.get("c.getApplicationByOpportunityId");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() != null)
                {                 
                    component.set("v.latestApplication", response.getReturnValue());
                    component.set("v.paymentPreferenceTypeIsSet", true);
                    component.set("v.showSaveButton", false);
                    component.set("v.showEditButton", true);
                    component.set("v.showCancelButton", false);
                    component.set("v.disableRadioButtonGroup", true);
                    var feesWaived = component.get("v.latestApplication.Fees_Waived__c");
                    var feesForEPP = component.get("v.latestApplication.Fee_For_Estate_Provider_Plan__c");
                    var feesForStaff = component.get("v.latestApplication.Fee_For_Staff__c");
                    var daraftingFeeStatus = component.get("v.latestApplication.Drafting_Fee_Status__c");
                    var draftBankDetailsValidated = component.get("v.latestApplication.Drafting_Banking_Details_Validated__c");                     
                    console.log("feesWaived :"+feesWaived);
                    console.log("feesForEPP :"+feesForEPP);
                    console.log("feesForStaff :"+feesForStaff);
                    console.log("daraftingFeeStatus :"+daraftingFeeStatus);
                    console.log("draftBankDetailsValidated :"+draftBankDetailsValidated); 
                    if(!feesWaived && !feesForEPP && !feesForStaff){
                        component.set("v.paymentPreferenceType", "Fees Paid");
                        if(daraftingFeeStatus == 'Valid'){
                            if(draftBankDetailsValidated){
                                component.set("v.bankDetailsValidated", true);
                                this.fetchPaymentPlanDetails(component);
                                this.logApplication(component);
                    			this.logVariables(component);
                            }
                            else{
                                component.set("v.bankDetailsValidated", false);
                                this.fetchPaymentPlanDetails(component);
                                this.logApplication(component);
                    			this.logVariables(component);
                            }                                
                        }
                        else if(daraftingFeeStatus == 'New'){
                            this.submitEdit(component);
                            this.logApplication(component);
                    		this.logVariables(component);
                        }
                        else{
                            this.submitEdit(component);
                            this.logApplication(component);
                    		this.logVariables(component);
                        }
                    }
                    else if(feesForStaff){
                        component.set("v.paymentPreferenceType", "Fees for Staff");
                        this.getReferenceNumber(component);
                    }
                    else if(feesForEPP){
                        component.set("v.paymentPreferenceType", "Fees for Estate Provider Plan");
                        this.getReferenceNumber(component);
                    }
                    else if(feesWaived){
                        component.set("v.paymentPreferenceType", "Fees Waived");
                        this.getReferenceNumber(component);
                    }
                }
                else{
                    this.getReferenceNumber(component);
                    this.submitEdit(component);
                }
            }            
        });        
        $A.enqueueAction(action);
        this.hideSpinner(component);
    },
    
    showSpinner : function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner : function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    submitApplicationData : function(component) {
        
        var draftingFee = component.get("v.selectedDraftingFee")
        this.showSpinner(component);
        var action= component.get("c.submitApplication");
        action.setParams({
            opportunityId: component.get("v.recordId"),
            paymentPreferenceType: component.get("v.paymentPreferenceType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                this.submitProductItemData(component);
                //this.checkPaymentPreferenceSetonApplication(component); 
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
        });        
        $A.enqueueAction(action);
        this.hideSpinner(component);        
    },
    
    updateDraftingFeeStatus : function(component, draftingFeeStatus) {
        this.showSpinner(component);
        var action= component.get("c.submitDraftingFeeStatus");
        action.setParams({
            opportunityId: component.get("v.recordId"),
            draftingFeeStatus: draftingFeeStatus
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
        this.hideSpinner(component);
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
                    opts.push({class: "optionClass", label: "--- None ---", value: ""});
                    opts.push({class: "optionClass", label: "Branch Payment",value: "Branch Payment"});
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

        });
        $A.enqueueAction(action);
		this.hideSpinner(component);
    },
    
    fetchDraftingFees : function(component) {
        this.showSpinner(component);
        var action = component.get("c.getDraftingFeesList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var opts = [];
                var allValues = response.getReturnValue();
                opts.push({class: "optionClass", label: "--- Please select a fee option ---", value: ""});
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({class: "optionClass", label: allValues[i], value: allValues[i]});
                }
                component.set("v.draftingFeeOptions", opts);
            }
        });       
        $A.enqueueAction(action);
        this.hideSpinner(component);
    },
    
    fetchDraftingFeesDirectDebit : function(component) {
        this.showSpinner(component);
        var action = component.get("c.getDraftingFeesList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var opts = [];
                var allValues = response.getReturnValue();
                opts.push({class: "optionClass", label: "--- Please select a fee option ---", value: ""});
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({class: "optionClass", label: allValues[i], value: allValues[i]});
                }
                component.set("v.draftingFeeDebitInstructionOptions", opts);
            }
        });       
        $A.enqueueAction(action);
        this.hideSpinner(component);
    },
    
    getReferenceNumber : function(component) {
        this.showSpinner(component);
        var action = component.get("c.getPersonAccountIDNumber");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var personAccountIdNumber = response.getReturnValue();
                component.set("v.selectedPaymentReference", personAccountIdNumber);
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
        });        
        $A.enqueueAction(action);
        this.hideSpinner(component);
    },
    
    submitPaymentPlan : function (component) {
        this.showSpinner(component);
        var action= component.get("c.submitApplication");
        action.setParams({
            opportunityId: component.get("v.recordId"),
            paymentPreferenceType: component.get("v.paymentPreferenceType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var action = component.get("c.submitPaymentPlanDetail");
                var method = component.get("v.selectedPaymentMethod");
                var accNumber = component.get("v.selectedAccNumber");
                var accType = component.get("v.selectedAccType");
                var bankName = component.get("v.selectedBankName");
                var branchCode = component.get("v.selectedBranchCode");
                var branchName = component.get("v.selectedBranchName");
                var name = accType + ' - ' +  accNumber;
                var frequency = '';
                var amount = component.get("v.selectedPaymentAmount");
                var reference = component.get("v.selectedPaymentReference");
                var status = 'New';
                var type = 'Will Drafting Fee';
                var productName = component.get("v.selectedDraftingFee");
                action.setParams({
                    "opportunityId": component.get("v.recordId"),
                    "accNumber": accNumber,
                    "accType": accType,
                    "bankName": bankName,
                    "branchCode": branchCode,
                    "branchName": branchName,
                    "name": name,
                    //"frequency": frequency,
                    "amount": amount,
                    "reference": reference,
                    "method": method,
                    "status": status,
                    "type": type,
                    "productName": productName
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.paymentPreferenceTypeIsSet", true);
                        this.submitProductItemData(component);
                    }
                });        
                $A.enqueueAction(action);
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
        this.hideSpinner(component);
    },  
    
    submitProductItemData : function(component) {
        this.showSpinner(component);
        var action = component.get("c.submitProductItem");
        var productName;
        var selectedDraftingFee = component.get("v.selectedDraftingFee");
        var quantity = 1;
        var totalPrice = 1.00;
        if (selectedDraftingFee == '' || selectedDraftingFee == null || selectedDraftingFee == undefined) {
            productName = 'AS PAID IN - AN AMOUNT (NOT LISTED)';
        } else {
            productName = component.get("v.selectedDraftingFee");
        }
        if(productName == 'AS PAID IN - AN AMOUNT (NOT LISTED)'){
            totalPrice = component.get("v.selectedPaymentAmount");
        } 
        action.setParams({
            opportunityId: component.get("v.recordId"),
            productName: productName,
            quantity: quantity ,	
            totalPrice : totalPrice
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.disableRadioButtonGroup", true);
                component.set("v.disableDraftingFeeAmount", true);
                component.set("v.disableAmount", true);
                var opts = [];
                opts.push({class: "optionClass", label: component.get("v.selectedAccType"),value: component.get("v.selectedAccType")});
                component.set("v.accTypeOptions", opts);
                component.set("v.disableAccountType", true);
                component.set("v.disableReference", true);
                opts = [];
                opts.push({class: "optionClass", label: component.get("v.selectedPaymentMethod"),value: component.get("v.selectedPaymentMethod")});
                component.set("v.paymentMethodOptions", opts);
                component.set("v.disablePaymentMethod", true);
                component.set("v.disableBankAccountNumber", true);
                component.set("v.selectedBankNameReadOnly", component.get("v.selectedBankName"));
                component.set("v.selectedBranchNameReadOnly", component.get("v.selectedBranchName"));
                component.set("v.showSavePaymentPlanButton", false);
                component.set("v.showBankNameReadOnly", true);
                component.set("v.showBankName", false);
                component.set("v.showBranchNameReadOnly", true);
                component.set("v.showBranchName", false);
                component.set("v.showSaveButton", false);
                component.set("v.showEditButton", true);
                component.set("v.showCancelButton", false);                
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
        this.hideSpinner(component);
        this.doInit(component);        
    },
    
    setBankingDetailsValidationStatus : function(component, bankingDetailsValidationStatus) {
        this.showSpinner(component);        
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
        this.hideSpinner(component);
    },
    
    fetchPaymentPlanDetails : function(component) {
        this.showSpinner(component);
        var action = component.get("c.selectByTypeByApplicationId");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "type": 'Will Drafting Fee'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();           
            if (state === "SUCCESS" ) {
                component.set("v.paymentPlan", response.getReturnValue());
                component.set("v.selectedPaymentMethod", component.get("v.paymentPlan.Method__c"));
                component.set("v.selectedPaymentAmount", component.get("v.paymentPlan.Amount__c"));
                component.set("v.selectedPaymentReference", component.get("v.paymentPlan.Reference__c"));
                component.set("v.selectedAccType", component.get("v.paymentPlan.Account_Type__c"));
                component.set("v.selectedBankNameReadOnly", component.get("v.paymentPlan.Bank_Name__c"));
                component.set("v.selectedBranchNameReadOnly", component.get("v.paymentPlan.Branch_Name__c"));
                component.set("v.selectedBranchCode", component.get("v.paymentPlan.Branch_Code__c"));
                component.set("v.selectedAccNumber", component.get("v.paymentPlan.Account_Number__c"));
                component.set("v.disableRadioButtonGroup", true);
                component.set("v.disableDraftingFeeAmount", true);
                component.set("v.disableAmount", true);                
                component.set("v.disableAccountType", true);
                component.set("v.disableReference", true);                
                component.set("v.disablePaymentMethod", true);                
                component.set("v.disableBankAccountNumber", true);
                component.set("v.showBankName", false);
                component.set("v.showBankNameReadOnly", true);
                component.set("v.showBranchName", false);
                component.set("v.showBranchNameReadOnly", true);
                component.set("v.validMethodType", true);
                if(component.get("v.paymentPlan.Reference__c") == null){
                    this.getReferenceNumber(component);
                }                
                var opts = [];
                opts.push({class: "optionClass", label: component.get("v.selectedAccType"),value: component.get("v.selectedAccType")});
                component.set("v.accTypeOptions", opts);
                opts = [];
                opts.push({class: "optionClass", label: component.get("v.selectedPaymentMethod"),value: component.get("v.selectedPaymentMethod")});
                component.set("v.paymentMethodOptions", opts); 
                this.setApplicableFieldsVisible(component);
            }
        });       
        $A.enqueueAction(action);
        this.hideSpinner(component);
    },
    
    checkIfOpportunityLineItemExists : function(component) {
        this.showSpinner(component);
        var action = component.get("c.existsOpportunityLineItem");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                if(response.getReturnValue()) {
                    this.fetchProductName(component);
                }
            }
        });       
        $A.enqueueAction(action);
        this.hideSpinner(component);
    },
    
    fetchProductName : function(component) {
        this.showSpinner(component);
        var action = component.get("c.getProductName");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                var productName = response.getReturnValue();
                var opts = [];
                
                opts.push({class: "optionClass", label: productName,value: productName});
                component.set("v.draftingFeeOptions", opts);
                component.set("v.draftingFeeDebitInstructionOptions", opts);
                component.set("v.disableDraftingFeeAmount", true);
                component.set("v.disableRadioButtonGroup", true);
                component.set("v.disableAmount", true);
                component.set("v.disableAccountType", true);
                component.set("v.disableReference", true);
                component.set("v.disablePaymentMethod", true);
                component.set("v.disableBankAccountNumber", true);
                component.set("v.showBankName", false);
                component.set("v.showBankNameReadOnly", true);
                component.set("v.showBranchName", false);
                component.set("v.showBranchNameReadOnly", true);
            }            
            this.hideSpinner(component);            
        });
        
        $A.enqueueAction(action);
        this.fetchDraftingFees(component);
    },
    
    checkBankOnAVSList : function(component) {
        this.showSpinner(component);
        var action = component.get("c.checkIfBankIsOnAVSList");
        action.setParams({
            bankName: component.get("v.selectedBankName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue()) {
                    component.set("v.bankOnAVSList", true);
                } else {
                    component.set("v.bankOnAVSList", false);
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
        this.hideSpinner(component);
    },
    
    validateBranchPayment : function (component) {
        this.showSpinner(component);        
        var allValid = true;
        var inValid = "";        
        var method = component.get("v.selectedPaymentMethod");
        var draftingFee = component.get("v.selectedDraftingFee");
        var amount = component.get("v.selectedPaymentAmount");
        var reference = component.get("v.selectedPaymentReference");        
        if (draftingFee == null){
            inValid = inValid + "Drafting Fee Amount , ";
            allValid = false;
        }
        if (amount == null) {
            inValid = inValid + "Amount, ";
            allValid = false;
        }
        if (reference == null || component.get("v.selectedPaymentReference").length == 0) {
            inValid = inValid + "Reference, ";
            allValid = false;
        }
        if (allValid) {
            //branch payment scenario where bank validations are not required            
            this.submitPaymentPlan(component);
            $A.get('e.force:refreshView').fire();
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "The following filed/s cannot be blank: "+inValid+"please correct before continuing." ,
                "type":"error"
            });
            toastEvent.fire();
            component.set("v.showSaveButton", true);
              
        }
        this.hideSpinner(component);
    },
    
    validateDebitInstruction : function (component) {
        this.showSpinner(component);
        var allValid = true;
        var inValid = "";
        var reference = component.get("v.selectedPaymentReference");
        var bankName = component.get("v.selectedBankName");
        var branchName = component.get("v.selectedBranchName");
        var accountNumber = component.get("v.selectedAccNumber");
        var method = component.get("v.selectedPaymentMethod");
        var draftingFee = component.get("v.selectedDraftingFee");
        var amount = component.get("v.selectedPaymentAmount");
        var accountType = component.get("v.selectedAccType");
        
        if (draftingFee == null){
            inValid = inValid + "Drafting Fee Amount , ";
            allValid = false;
        }
        if (reference == null || component.get("v.selectedPaymentReference").length == 0) {
            inValid = inValid + "Reference, ";
            allValid = false;
        }
        if (amount == null) {
            inValid = inValid + "Amount, ";
            allValid = false;
        }
        if (accountType == null || component.get("v.selectedAccType").length == 0) {
            inValid = inValid + "Account Type, ";
            allValid = false;
        }
        if (bankName == null || component.get("v.selectedBankName").length == 0) {
            inValid = inValid + "Bank Name, ";
            allValid = false;
        }
        if (branchName == null || component.get("v.selectedBranchName").length == 0) {
            inValid = inValid + "Branch Name, ";
            allValid = false;
        }
        if (accountNumber == null  || component.get("v.selectedAccNumber").length == 0) {
            inValid = inValid + "Bank Account Number, ";
            allValid = false;
        }
        if (accountNumber == null || component.get("v.selectedAccNumber").length == 0) {
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
                component.set("v.showSaveButton", true);
            }
        }
        if (allValid && component.get("v.selectedPaymentMethod") == 'Debit Instruction') {
            if (component.get("v.selectedBankName") == 'ABSA BANK LIMITED') {
                //Absa bank account validations
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
                            this.submitPaymentPlan(component);
                            component.set("v.bankDetailsValidated", true);
                            component.set("v.bankDetailsPendingValidation", false);
                            this.setBankingDetailsValidationStatus(component, "Valid");
                        } 
                        else {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error",
                                "message": "Invalid bank account details. Please correct before continuing." ,
                                "type":"Error"
                            }); 
                            toastEvent.fire();
                            component.set("v.showSaveButton", true);
                        }
                    }
                });       
                $A.enqueueAction(action);
            } 
            else {
                //first check if the bank is on the AVS list
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
                                            component.set("v.showSaveButton", true);
                                            this.updateDraftingFeeStatus(component, result);
                                            this.submitPaymentPlan(component);
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
                                            this.updateDraftingFeeStatus(component, result);
                                            this.submitPaymentPlan(component);
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
                                            component.set("v.showSaveButton", true);
                                            break;
                                            
                                        case "Fail-ServiceOffline":
                                            toastEvent.setParams({
                                                "title": "Warning",
                                                "message": "Unable to proceed with " + component.get("v.selectedBankName") + " verification, validation service temporarily unavailable. Please contact your System Administrator, however you may proceed with the Opportunity." ,
                                                "type":"Warning"
                                            });
                                            toastEvent.fire();
                                            component.set("v.showSaveButton", true);
                                            this.updateDraftingFeeStatus(component, result);
                                            this.submitPaymentPlan(component);
                                            this.setBankingDetailsValidationStatus(component, "Invalid");
                                            component.set("v.bankDetailsValidated", false);
                                            component.set("v.bankDetailsPendingValidation", true);
                                            break;
                                    }                                    
                                }                                                               
                            });                            
                            $A.enqueueAction(action);                            
                        } 
                        else {
                            //For all other banks do check digit bank account validation (CheckDigitVerification switch is set to true)
                            if (component.get("v.CheckDigitVerification")) {
                                var action = component.get("c.checkBankAccount");                                
                                var accountNumber = component.get("v.selectedAccNumber");
                                var branchCode = component.get("v.selectedBranchCode");
                                var accountTypeStr = component.get("v.selectedAccType");
                                var accountType;
                                if(accountTypeStr == 'Cheque') {
                                    accountType = '01';  
                                } 
                                else if(accountTypeStr == 'Savings') {
                                    accountType = '02';
                                } 
                                else if(accountTypeStr == 'Transmission') {
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
                                            this.submitPaymentPlan(component);
                                            $A.get('e.force:refreshView').fire();
                                        } 
                                        else {
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                "title": "Error",
                                                "message": "Invalid bank account details. Please correct before continuing." ,
                                                "type":"Error"
                                            }); 
                                            toastEvent.fire();
                                            component.set("v.showSaveButton", true);
                                        }
                                    }
                                });       
                                $A.enqueueAction(action);
                            } 
                            else {
                                //bank validations are not required (CheckDigitVerification switch is set to false)
                                component.set("v.showSavePaymentPlanButton", false);
                            }
                        }
                    } 
                    else if (state === "INCOMPLETE") {
                        component.set("v.showSaveButton", true);
                    } 
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " +
                                            errors[0].message);
                            }
                        } 
                        else {
                            
                            console.log("Unknown error");
                        }
                        component.set("v.showSaveButton", true);
                    }
                });
                $A.enqueueAction(action);
            }
        } 
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "The following filed/s cannot be blank: "+inValid+"please correct before continuing." ,
                "type":"error"
            });
            toastEvent.fire();
            component.set("v.showSaveButton", true);
        }
        this.hideSpinner(component);
    },
    
    checkCASAValidity : function (component) {
        this.showSpinner(component);
        var action = component.get("c.checkCASAValidity");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var casaValidity = response.getReturnValue();
                
                if(casaValidity != 'Valid') {
                    component.set("v.showCasaNotCompleted", true);
                } else {
                    component.set("v.showCasaCompleted", true);
                }
            }
            component.set("v.showCasaNotCompleted", false);
            component.set("v.showCasaCompleted", true);
        });
        $A.enqueueAction(action);
        this.hideSpinner(component);
    },
    
    setApplicableFieldsVisible : function (component) {
        this.showSpinner(component);
        var method = component.get("v.selectedPaymentMethod");
        if(method == "Branch Payment"){
            component.set("v.accountTypeRequired", false);
            component.set("v.showBankDetails", false);
            component.set("v.referenceFieldRequired", true);
            component.set("v.bankDetailsPendingValidation", false);
        }
        else{
            component.set("v.accountTypeRequired", true);
            component.set("v.showBankDetails", true);
            component.set("v.referenceFieldRequired", true);
        }
        this.hideSpinner(component);
        $A.get('e.force:refreshView').fire();
        
    },
    
    logApplication : function (component){
        console.log("logApplication Start");
        
        console.log("v.latestApplication.Fees_Waived__c:"+component.get("v.latestApplication.Fees_Waived__c"));
        console.log("v.latestApplication.Fee_For_Estate_Provider_Plan__c:"+component.get("v.latestApplication.Fee_For_Estate_Provider_Plan__c"));
        console.log("v.latestApplication.Fee_For_Staff__c:"+component.get("v.latestApplication.Fee_For_Staff__c"));
        console.log("v.latestApplication.Drafting_Banking_Details_Validated__c:"+component.get("v.latestApplication.Drafting_Banking_Details_Validated__c"));
        console.log("v.latestApplication.Drafting_Fee_Status__c:"+component.get("v.latestApplication.Drafting_Fee_Status__c"));
        
        console.log("logApplication End");
    },
    
    logPayplan : function (component){
        console.log("logPayplan Start");
        
        console.log("v.paymentPlan.Method__c:"+component.get("v.paymentPlan.Method__c"));
        console.log("v.paymentPlan.Amount__c:"+component.get("v.paymentPlan.Amount__c"));
        console.log("v.paymentPlan.Reference__c:"+component.get("v.paymentPlan.Reference__c"));
        console.log("v.paymentPlan.Account_Type__c:"+component.get("v.paymentPlan.Account_Type__c"));
        console.log("v.paymentPlan.Bank_Name__c:"+component.get("v.paymentPlan.Bank_Name__c"));
        console.log("v.paymentPlan.Branch_Name__c:"+component.get("v.paymentPlan.Branch_Name__c"));
        console.log("v.paymentPlan.Branch_Code__c:"+component.get("v.paymentPlan.Branch_Code__c"));
        console.log("v.paymentPlan.Account_Number__c:"+component.get("v.paymentPlan.Account_Number__c"));
        
        console.log("logPayplan End");
    },
    
    logVariables : function (component){
        console.log("logVariables Start");
        
        console.log("v.paymentPreferenceTypeIsSet:"+component.get("v.paymentPreferenceTypeIsSet"));
        console.log("v.bankDetailsValidated:"+component.get("v.bankDetailsValidated"));
        console.log("v.bankDetailsPendingValidation:"+component.get("v.bankDetailsPendingValidation"));
        console.log("v.paymentPreferenceType:"+component.get("v.paymentPreferenceType"));
        
        console.log("v.selectedDraftingFee:"+component.get("v.selectedDraftingFee"));
        console.log("v.selectedPaymentAmount:"+component.get("v.selectedPaymentAmount"));
        console.log("v.selectedPaymentMethod:"+component.get("v.selectedPaymentMethod"));
        console.log("v.selectedPaymentReference:"+component.get("v.selectedPaymentReference"));
        console.log("v.selectedAccType:"+component.get("v.selectedAccType"));        
        console.log("v.selectedAccNumber:"+component.get("v.selectedAccNumber"));
        console.log("v.selectedBankName:"+component.get("v.selectedBankName"));
        console.log("v.selectedBankNameReadOnly:"+component.get("v.selectedBankNameReadOnly"));
        console.log("v.selectedBranchName:"+component.get("v.selectedBranchName"));
        console.log("v.selectedBranchNameReadOnly:"+component.get("v.selectedBranchNameReadOnly"));
        console.log("v.selectedBranchCode:"+component.get("v.selectedBranchCode"));
        
        console.log("v.disableRadioButtonGroup:"+component.get("v.disableRadioButtonGroup"));
        console.log("v.disableDraftingFeeAmount:"+component.get("v.disableDraftingFeeAmount"));
        console.log("v.disableAmount:"+component.get("v.disableAmount"));
        console.log("v.disableAccountType:"+component.get("v.disableAccountType"));        
        console.log("v.disableReference:"+component.get("v.disableReference"));
        console.log("v.disablePaymentMethod:"+component.get("v.disablePaymentMethod"));
        console.log("v.disableBranch:"+component.get("v.disableBranch"));
        console.log("v.disableBank:"+component.get("v.disableBank"));
        console.log("v.disableBankAccountNumber:"+component.get("v.disableBankAccountNumber"));
        console.log("v.showBankName:"+component.get("v.showBankName"));
        console.log("v.showBankNameReadOnly:"+component.get("v.showBankNameReadOnly"));
        console.log("v.showBranchName:"+component.get("v.showBranchName"));
        console.log("v.showBranchNameReadOnly:"+component.get("v.showBranchNameReadOnly"));
        console.log("v.showSaveButton:"+component.get("v.showSaveButton"));        
        console.log("v.showEditButton:"+component.get("v.showEditButton"));
        console.log("v.showCancelButton:"+component.get("v.showCancelButton"));
        console.log("v.referenceFieldRequired:"+component.get("v.referenceFieldRequired"));
        console.log("v.showValidateButton:"+component.get("v.showValidateButton"));
        console.log("v.showSavePaymentPlanButton:"+component.get("v.showSavePaymentPlanButton"));
        console.log("v.draftingFeeOptions:"+component.get("v.draftingFeeOptions"));
        console.log("v.draftingFeeDebitInstructionOptions:"+component.get("v.draftingFeeDebitInstructionOptions"));
        console.log("v.paymentMethodOptions:"+component.get("v.paymentMethodOptions"));
        console.log("v.accTypeOptions:"+component.get("v.accTypeOptions"));
        console.log("v.showCasaNotCompleted:"+component.get("v.showCasaNotCompleted"));
        console.log("v.showCasaCompleted:"+component.get("v.showCasaCompleted"));
        console.log("v.validMethodType:"+component.get("v.validMethodType"));
        console.log("v.accountTypeRequired:"+component.get("v.accountTypeRequired"));
        console.log("v.CheckDigitVerification:"+component.get("v.CheckDigitVerification"));
        
        console.log("logVariables End");
    },
    
    onPicklistAccTypeChange : function(component, event) {
        component.set("v.selectedAccType", event.getSource().get("v.value"));
    },
    
    submitSave : function(component) {
        this.showSpinner(component);
        component.set("v.showSaveButton", false);
        var paymentPreferenceType = component.get("v.paymentPreferenceType");
        var method = component.get("v.selectedPaymentMethod");        
        if(paymentPreferenceType == undefined || paymentPreferenceType == '' ) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "To save please make a selection.",
                "type": "error"
            });
            toastEvent.fire();
            component.set("v.showSaveButton", true);
        } 
        else if (paymentPreferenceType == 'Fees Waived' || paymentPreferenceType == 'Fees for Estate Provider Plan' || paymentPreferenceType == 'Fees for Staff') {            
            this.submitApplicationData(component);
        } 
            else if (paymentPreferenceType == 'Fees Paid') {
                if (method == "Debit Instruction"){
                    this.validateDebitInstruction(component);
                }
                else if(method == "Branch Payment"){
                    this.validateBranchPayment(component);                
                }
        }
        this.hideSpinner(component);
    },
    
    submitEdit : function(component) {
        this.showSpinner(component);
        this.fetchPickListVal(component, 'Method__c', 'PaymentMethod');
        this.fetchPickListVal(component, 'Account_Type__c', 'AccountType');
        this.fetchDraftingFees(component);
        this.getReferenceNumber(component);
        component.set("v.selectedPaymentAmount", '');
        component.set("v.selectedAccNumber", '');
        component.set("v.selectedBranchCode", '');
        component.set("v.selectedAccType", '');
        component.set("v.selectedPaymentMethod", '');
        component.set("v.selectedDraftingFee",'');
        component.set("v.paymentPreferenceType",'');
        component.set("v.showBankName", true);
        component.set("v.showBankNameReadOnly", false);
        component.set("v.showBranchName", true);
        component.set("v.showBranchNameReadOnly", false);
        component.set("v.showSaveButton", true);
        component.set("v.showEditButton", false);
        component.set("v.showCancelButton", true);
        component.set("v.disableRadioButtonGroup", false);
        component.set("v.disableDraftingFeeAmount", false);
        component.set("v.disableAmount", false);
        component.set("v.disableAccountType", false);
        component.set("v.disableReference", false);
        component.set("v.disablePaymentMethod", false);
        component.set("v.disableBankAccountNumber", false);        
        component.set("v.paymentPreferenceTypeIsSet", false);
        component.set("v.validMethodType", false);
        this.hideSpinner(component);
    },
    
    onDraftingFeeChange : function(component) {
        this.showSpinner(component);
        var productName = component.get("v.selectedDraftingFee");
        if (productName == 'AS PAID IN - AN AMOUNT (NOT LISTED)') {
            component.set("v.disableAmount", false);
            component.set("v.selectedPaymentAmount", null);
        } 
        else {
            component.set("v.disableAmount", true);
            //Parse the amount from the drafting fee string
            var n = productName.indexOf("-");
            var amount = productName.substring(1, n);            
            if (amount.length > 7) {
                var nn = amount.indexOf(".");
                var amount2 = amount.substring(0, nn) + amount.substring(nn + 1, amount.length);
                component.set("v.selectedPaymentAmount", amount2);
            } 
            else {
                component.set("v.selectedPaymentAmount", amount);
            }
            
            if (productName == 'R0.00 - ESTATE PROVIDER PLAN' || productName == 'R0.00 - EXEMPTED - STAFF' || productName == 'R0.00 - WAIVED (ABSA EXECUTOR)') {
                component.set("v.disableAccountType", true);
                component.set("v.disablePaymentMethod", true);
                component.set("v.disableAccountType", true);
                component.set("v.disableBankAccountNumber", true);
                component.set("v.showBankName", false);
                component.set("v.showBankNameReadOnly", true);
                component.set("v.showBranchName", false);
                component.set("v.showBranchNameReadOnly", true);
                component.set("v.referenceFieldRequired", true); 
            } 
            else if (component.get("v.selectedPaymentMethod") == 'Debit Instruction') {
                component.set("v.disableAccountType", false);
                component.set("v.disablePaymentMethod", false);
                component.set("v.disableAccountType", false);
                component.set("v.disableBankAccountNumber", false);
                component.set("v.showBankName", true);
                component.set("v.showBankNameReadOnly", false);
                component.set("v.showBranchName", true);
                component.set("v.showBranchNameReadOnly", false);
                component.set("v.referenceFieldRequired", true);
            }
        }
        this.hideSpinner(component);
    },
    
    onPicklistPaymentMethodChange : function(component) {
        this.showSpinner(component);
        var paymentMethod = component.get("v.selectedPaymentMethod");
        this.fetchDraftingFees(component);
        if (paymentMethod == 'Branch Payment') {
        	component.set("v.disableBankAccountNumber", true);
            component.set("v.disableAccountType", true);
        	component.set("v.showBankName", false);
        	component.set("v.showBankNameReadOnly", true);
        	component.set("v.showBranchName", false);
        	component.set("v.showBranchNameReadOnly", true);
            component.set("v.referenceFieldRequired", true);
            component.set("v.validMethodType", true);
            component.set("v.accountTypeRequired", false);
            component.set("v.showBankDetails", false);
            component.set("v.selectedPaymentAmount", null);
            component.set("v.selectedDraftingFee", null);
            component.set("v.disableAmount", true);
        } 
        else if (paymentMethod == 'Debit Instruction') {
        	component.set("v.disableBankAccountNumber", false);
            component.set("v.disableAccountType", false);
            component.set("v.accountTypeRequired", true);
        	component.set("v.showBankName", true);
        	component.set("v.showBankNameReadOnly", false);
        	component.set("v.showBranchName", true);
        	component.set("v.showBranchNameReadOnly", false);
            component.set("v.referenceFieldRequired", true);
            component.set("v.validMethodType", true);
            component.set("v.showBankDetails", true);
            component.set("v.selectedPaymentAmount", null);
            component.set("v.selectedDraftingFee", null);
            component.set("v.selectedAccType", null);
            component.set("v.disableAmount", true);
        } 
        else {
        	component.set("v.validMethodType", false);
            component.set("v.selectedPaymentAmount", null);
            component.set("v.selectedDraftingFee", null);
            component.set("v.disableAmount", true);
        }
        this.hideSpinner(component);
    },
    
})