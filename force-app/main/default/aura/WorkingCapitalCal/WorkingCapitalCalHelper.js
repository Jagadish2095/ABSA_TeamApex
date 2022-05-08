({
	getWorkingcapitalProcessDataResponse: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.callRestAPI_ProcessData");
        var workingCapitalCalculatorsInputs = component.get('v.workingCapitalCalculatorsInputs');
        action.setParams({
            jsonData : JSON.stringify(workingCapitalCalculatorsInputs)
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                component.set("v.calculateResponse", response.getReturnValue());
                console.log('v.calculateResponse -> '+JSON.stringify(response.getReturnValue()));
                if(response.getReturnValue() !== null && response.getReturnValue().length > 0) {
                	component.set("v.firstResponseElement", response.getReturnValue()[0]);
                	component.set("v.apiResponseElement", JSON.parse(JSON.stringify(response.getReturnValue()[0])));
                }    
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    saveReceivableHelper : function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.callRestAPI_AdjustedAverageReceivableCollectionPeriod");
        var capturedInputWrapper = component.get('v.apiResponseElement');
        action.setParams({
            days : capturedInputWrapper.calculations.averageReceivableCollectionPeriod,
            dailySales : capturedInputWrapper.calculations.dailySales
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                console.log('saveReceivableHelper -> response.getReturnValue() -> '+response.getReturnValue());
                capturedInputWrapper.adjustedCalculations.adjustedAverageReceivableCollectionPeriod = response.getReturnValue();
                component.set("v.apiResponseElement", capturedInputWrapper);
                console.log('v.apiResponseElement -> '+JSON.stringify(capturedInputWrapper));
            }
            component.set("v.showSpinner", false);
            this.retrieveAdjustedWorkingCapitalNeed(component);
        });
        $A.enqueueAction(action);
    },
	saveInventoryHelper : function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.callRestAPI_AdjustedAverageInventoryProcesssingPeriod");
        var capturedInputWrapper = component.get('v.apiResponseElement');
        action.setParams({
            days : capturedInputWrapper.calculations.averageInventoryProcesssingPeriod,
            dailyCostOfSales : capturedInputWrapper.calculations.dailyCostOfSales
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                console.log('saveInventoryHelper -> response.getReturnValue() -> '+response.getReturnValue());
                capturedInputWrapper.adjustedCalculations.adjustedAverageInventoryProcesssingPeriod = response.getReturnValue();
                component.set("v.apiResponseElement", capturedInputWrapper);
                console.log('v.apiResponseElement -> '+JSON.stringify(capturedInputWrapper));
            }
            component.set("v.showSpinner", false);
            this.retrieveAdjustedWorkingCapitalNeed(component);
        });
        $A.enqueueAction(action);
    },
    savePayableHelper : function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.callRestAPI_AdjustedPayablesPaymentPeriod");
        var capturedInputWrapper = component.get('v.apiResponseElement');
        action.setParams({
            days : capturedInputWrapper.calculations.payablesPaymentPeriod,
            dailyCostOfSales : capturedInputWrapper.calculations.dailyCostOfSales
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                console.log('savePayableHelper -> response.getReturnValue() -> '+response.getReturnValue());
                capturedInputWrapper.adjustedCalculations.adjustedPayablesPaymentPeriod = response.getReturnValue();
                component.set("v.apiResponseElement", capturedInputWrapper);
                console.log('v.apiResponseElement -> '+JSON.stringify(capturedInputWrapper));
            }
            component.set("v.showSpinner", false);
            this.retrieveAdjustedWorkingCapitalNeed(component);
        });
        $A.enqueueAction(action);
    },
    retrieveAdjustedWorkingCapitalNeed : function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.callRestAPI_AdjustedWorkingCapitalNeed");
        var capturedInputWrapper = component.get('v.apiResponseElement');
        action.setParams({
            adjustWCNReceiveAverage : capturedInputWrapper.adjustedCalculations.adjustedAverageReceivableCollectionPeriod,
            adjustWCNInventoryAverage : capturedInputWrapper.adjustedCalculations.adjustedAverageInventoryProcesssingPeriod,
            adjustWCNPayablesAverage : capturedInputWrapper.adjustedCalculations.adjustedPayablesPaymentPeriod
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                console.log('retrieveAdjustedWorkingCapitalNeed -> response.getReturnValue() -> '+response.getReturnValue());
                capturedInputWrapper.adjustedCalculations.adjustedWorkingCapitalNeed = response.getReturnValue();
                let updatedCashConversionCycle = new Number(capturedInputWrapper.calculations.averageInventoryProcesssingPeriod);
                updatedCashConversionCycle += new Number(capturedInputWrapper.calculations.averageReceivableCollectionPeriod);
                updatedCashConversionCycle -= new Number(capturedInputWrapper.calculations.payablesPaymentPeriod);
                capturedInputWrapper.calculations.cashConversionCycle = updatedCashConversionCycle;
                
                component.set("v.apiResponseElement", capturedInputWrapper);
                console.log('v.apiResponseElement -> '+JSON.stringify(capturedInputWrapper));
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    validateInputEntries: function (cmp, evt, helper) {
        let allValid = [].concat(cmp.find('numberInput')).reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
		if (allValid) {
            return true;
        } else {
            alert('Please update the invalid form entries and try again.');
            return false;
        }
    }
})