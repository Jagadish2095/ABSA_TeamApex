({
    init : function(component, event, helper) {
		helper.loadExistingTransUnionChecks(component, event, helper);
	},

	//Method to show or hide the TransUnion btn if the checkbox is selected
    onCheck: function(component, event, helper) {
        var transUBtn= component.find("transUnionBtn");
		if(event.getSource().get("v.checked")){
			$A.util.removeClass(transUBtn, 'slds-hide');
		}else{
			$A.util.addClass(transUBtn, 'slds-hide');
		}

	},

    callTransUnion: function(component, event, helper) {
    	helper.callTransUnionCheckService(component, event, helper);
	},

	handleSubmit : function(component, event, helper){
		helper.showSpinner(component);
	},

	handleSuccess : function(component, event, helper){
		helper.hideSpinner(component);
    },

    handleError : function(component, event, helper){
        var componentName = 'MerchantTransUnionCustomerCheck';
        console.error(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
		helper.hideSpinner(component);
        helper.fireToast('Error!', 'Error saving Opportunity.', 'error');
    },

	openCreditCheckModal : function(component, event, helper){
		var idx = event.target.getAttribute('data-index');
		var creditRiskCheck = component.get("v.creditRiskCheckData")[idx];
		console.log("creditRiskCheck: " + creditRiskCheck);
		component.set("v.selectedContact", creditRiskCheck.Id);
		component.find('creditRiskCheckForm').reloadRecord();
        var cmpTarget = component.find('transunionModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
	},

    closeCreditCheckModal : function(component, event, helper){
        var cmpTarget = component.find('transunionModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    }
})