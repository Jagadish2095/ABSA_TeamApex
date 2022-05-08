({
    setFields : function(component) {
        component.set('v.accountColumns', [
            {label: 'Account Number', fieldName: 'AccountNumber', type: 'text'},
            {label: 'Account Type', fieldName: 'ProductType', type: 'text'},
            {label: 'Account Balance', fieldName: 'Balance', type: 'Phone'},
            {label: 'Account Status', fieldName: 'Status', type: 'url '}
        ]);

        component.set('v.detailedViewColumns', [
            {label: 'Time', fieldName: 'ChargeTime', type: 'text'},
            {label: 'Date', fieldName: 'ChargeDate', type: 'text'},
            {label: 'Charge Indicator', fieldName: 'ChargeIndicator', type: 'text'},
            {label: 'From Account Number', fieldName: 'FromAccountNumber', type: 'text'},
            //{label: 'Target Account', fieldName: 'TargetAccount', type: 'text'},
            {label: 'Amount', fieldName: 'Amount', type: 'text'},
            //{label: 'Reference', fieldName: 'Reference', type: 'text'},
            {label: 'Transaction Type', fieldName: 'TransactionType', type: 'text'},
            {label: 'Charge', fieldName: 'Charge', type: 'text'},

        ]);

        
        component.set('v.summeryViewColumns', [
            {label: 'Transaction Type', fieldName: 'TransactionType', type: 'text'},
            {label: 'Volume', fieldName: 'Volume', type: 'Integer'},
            {label: 'Charge', fieldName: 'Charge', type: 'Double'}
        ]);

        console.log('setFields: fields set');
    },

    getCostAccount : function(component, event, helper) {
        var result;
        console.log('getCostAccount: getting accounts....');
        var action = component.get("c.getCostAccounts");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                result = response.getReturnValue();
                component.set("v.costAccount", result);
            }else{
                console.log('...');
            }

            component.set("v.showSpinner", false);
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },

    getAccountCharges : function(component, event, helper) {
        var result;
        console.log('getAllAccountCharges: getting account charges....');
        var action = component.get("c.getAccountChargesById");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                result = response.getReturnValue();
                component.set("v.accountCharges", result);
                helper.generateSummeryCharges(component);
                helper.filterCharges(component);
            }else{
                console.log('...');
            }

            component.set("v.showSpinner", false);
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },

    filterCharges : function(component) {
        var filteredCharges = [];
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");
        var accountCharges = component.get("v.accountCharges");

        if((startDate == null && endDate == null)
            || startDate == '' && endDate == ''){
                component.set("v.areChargesFiltered", false);
            return;
        }
        accountCharges.forEach(charge => {

            var chargeFromDate = new Date(charge.ChargeDate);
            if(new Date(chargeFromDate.toDateString())  >= new Date(new Date(startDate).toDateString()) &&
                new Date(chargeFromDate.toDateString())  <= new Date(new Date(endDate).toDateString())){
                filteredCharges.push(charge);
            }else{
                console.log(`Filtering out: ${JSON.stringify(chargeFromDate)}`);
            }
        });

        component.set("v.filteredAccountCharges", filteredCharges);
        component.set("v.areChargesFiltered", true);

    },

    generateSummeryCharges : function(component){
        var results = [];
        var charges = component.get("v.accountCharges");
        charges.forEach(charge => {
            var tempTypes = results.some(r => r.TransactionType === charge.TransactionType);
            console.log(`generateSummeryCharges: charge.TransactionType: ${charge.TransactionType}, tempTypes: ${tempTypes}`);
            if(tempTypes) {
                var sumCharge = results.find(x=>x.TransactionType == charge.TransactionType);
                sumCharge.Volume += 1;
                sumCharge.Charge +=  parseFloat(charge.Amount);
            }
            else{
                var temp = new Object();
                temp.TransactionType = charge.TransactionType.trim();
                temp.Volume = 1;
                temp.Charge = parseFloat(charge.Amount);
                results.push(temp);
            }
        });

        component.set("v.summeryCharges", results);

    },

    getAllAccounts : function(component, event, helper) {
        console.log(`case id: ${component.get("v.recordId")}`);
        var result;
        console.log('getAllAccounts: getting all accounts....');
        var action = component.get("c.getAllAccounts");
        action.setParams({
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                result = response.getReturnValue();
                component.set("v.accountList", result.Accounts);
                component.set("v.accountTypes", result.AccountTypes);
            }else{
                console.log('...');
            }
            component.set("v.showSpinner", false);
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },

    getAccountEmail : function(component, event, helper) {
        var action;
        var result;
        if(component.get("v.mode") == "update"){
            action = component.get("c.getAccountEmailFromCase");
        }else{
            action = component.get("c.getAccountEmail");
        }
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                result = response.getReturnValue();
                console.log(`Account email: ${JSON.stringify(result)}`);
                component.set("v.accountName", result.accountName);
                component.set("v.email", result.email);
                component.set("v.accountId", result.accountId);// Used to redirect to account

            }else{
                var errors = response.getError();
            }
        });
        $A.enqueueAction(action);
    }
    ,

    updateCostAccount : function(component, helper) {
        console.log(`updateCostAccount: starting...`);
        var selected = component.get("v.selectedAccount");
        var caseId = component.get("v.recordId");
        var result;
        console.log(`h.updateCostACcount: Updating TB cost account to: ${selected}`);

        var action = component.get("c.updateClientCostAccount");
        action.setParams({
            caseId: caseId,
            newAccount: selected
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                result = response.getReturnValue();
                //component.set("v.email", result);
                if(result){
                    component.set("v.isConfirmingAccountSelection", false);
                    component.set("v.stage", 2);
                    console.log(`updateCostACcount: done`);
                    helper.toast('Updated','Cost account successfully updated','success');
                }else{
                    console.error(`updateCostAccount: Something went wrong.`);
                }

            }else{
                var errors = response.getError();
                helper.toast('Updated',`Errors: ${JSON.stringify(errors)}`,'error');

                console.error(`updateCostAccount: Error: ${JSON.stringify(errors)}`);
            }
            component.set("v.showSpinner", false);
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);
    },


    closeCase : function(component, helper) {
        var result;
        var action = component.get("c.closeCaseAndEmailClient");
        action.setParams({
            caseId: component.get("v.recordId"),
            email: component.get("v.email")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                result = response.getReturnValue();
                debugger;

                if(result.isValid){
                    if(result.emailChangeSaved){
                        helper.toast('Case Closed and Updated','Account was updated, Case was closed and the "Update Cose Account" email has been sent','success');
                    }else{
                        helper.toast('Case Closed','Case was closed and the "Update Cost Account" email has been sent','success');
                    }
                    helper.redirectToAccount(component);
                }else{
                    helper.toast('Error','Something went wrong.','error');
                }
            }else{
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error(`getAccountEmail: ErroR: ${errors[0].message}`);
                        helper.toast('Error',JSON.stringify(errors),'error');
                    }
                }

            }
            component.set("v.showSpinner", false);
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);

    },

    createAndEmailTbCharges : function(component, helper) {
        var isFiltered = component.get("v.areChargesFiltered");
        var result;
        var action = component.get("c.buildAndSendTbChargesEmail");
        if(isFiltered){
            action.setParams({
                email: component.get("v.email"),
                name: component.get("v.accountName"),
                charges: component.get("v.filteredAccountCharges"),
            });
            console.log(`createAndEmailTbCharges: FILTERED`);
        }else{
            action.setParams({
                email: component.get("v.email"),
                name: component.get("v.accountName"),
                charges: component.get("v.accountCharges"),
            });
        }

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                result = response.getReturnValue();
                console.log(`createAndEmailTbCharges: Result: ${result}`);
                helper.toast('Email sent','TB Charges email sent','success');
                component.set("v.stage", 1);
            }else{
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error(`getAccountEmail: ErroR: ${errors[0].message} for ID ${component.get("v.accountId")}`);
                        helper.toast('Error',`${errors[0].message} for ID ${component.get("v.accountId")}`,'error');
                    }
                }

            }
            component.set("v.showSpinner", false);
        });
        component.set("v.showSpinner", true);
        $A.enqueueAction(action);

    },

    redirectToAccount: function (component) {
        component.set("v.showSpinner", true);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.accountId"),
            "slideDevName": "Detail"
        });
        navEvt.fire();
        component.set("v.showSpinner", true);
    },

    toast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type,
            duration:'8000',
		});

		toastEvent.fire();
	}
})