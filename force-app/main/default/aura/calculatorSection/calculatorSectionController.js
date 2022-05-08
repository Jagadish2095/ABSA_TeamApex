({
    doInit: function (component, event, helper) {       
        helper.fetchTableData(component);
    },

    onSelectToolChange: function (component, event, helper) {
        helper.fetchTableData(component);
    },
    
	clickCheckBox: function (component, event, helper) {
    	helper.rerenderCalculateButton(component);
    },
    
	clickCalculate: function (component, event, helper) {    	
    	helper.passCalculateListToChildComponent(component);
    },
    
    clickEdit: function (component, event, helper) {
        helper.editFinancialDataHelper(component, event);
        helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.showPopupHelper(component,'backdrop','slds-backdrop--');
    },
    noOfDaysToEdit: function (component, event, helper) {
        helper.editNoOfDays(component, event);
	},
 	/*
    clickDelete: function (component, event, helper) {
    	helper.deleteFinancialDataHelper(component, event);
    },
    */
    newFinancialData: function (component, event, helper) {
        helper.newFinancialDataHelper(component, event);
        helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.showPopupHelper(component,'backdrop','slds-backdrop--');
    },
    
    saveWorkingCapital: function (component, event, helper) {
        if(helper.validateInputEntries(component, event, helper)) {
            helper.saveFinancialDataHelper(component, event);
            helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
            helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
        }
    },
    
    showPopup: function (component, event, helper) {
        helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.showPopupHelper(component,'backdrop','slds-backdrop--');
    },
    
    hidePopup: function (component, event, helper) {
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
		helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');
    },
    resetCalculator: function (component,event,helper){
        component.set("v.isCalculateSuccess", false);
    }
})