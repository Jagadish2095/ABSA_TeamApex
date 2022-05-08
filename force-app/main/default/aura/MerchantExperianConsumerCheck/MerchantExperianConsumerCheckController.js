({
    doInit : function(component, event, helper) {
        helper.loadExistingExperianChecks(component, event, helper);
        //helper.loadOppRecord(component, event, helper);
    },

    onCheck: function(component, event, helper) {
        var experianButton= component.find("experianBtn");
        if(event.getSource().get("v.checked")){
            $A.util.removeClass(experianButton, 'slds-hide');
        }else{
            $A.util.addClass(experianButton, 'slds-hide');
        }
    },

    callExperianCheck: function(component, event, helper) {
        helper.callExperianCheckService(component, event, helper);
    },

    openCreditCheckModal : function(component, event, helper){
		var idx = event.target.getAttribute('data-index');
		var creditRiskCheck = component.get("v.experianData")[idx];
        console.log("creditRiskCheck: " + creditRiskCheck);
        component.set("v.selectedContact", creditRiskCheck.Id);
        console.log("selectedContact Id: " + component.get("v.selectedContact"));
		component.find('creditRiskCheckFormExperian').reloadRecord();
        var cmpTarget = component.find('experianModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },

    closeCreditCheckModal : function(component, event, helper){
        var cmpTarget = component.find('experianModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

    /*resubmitForApproval: function(component, event, helper) {
		component.find("resubmitForApprovalBtn").set("v.disabled", true);
		component.find("oppTrigApprovalProcessInput").set("v.value", "Experian Risk Check");
		component.find("oppApprovalStatusInput").set("v.value", "Pending");
		component.find('opportunityEditForm').submit();
    },*/

    handleSubmit : function(component, event, helper){
		helper.showSpinner(component);
	},

	handleSuccess : function(component, event, helper){
		helper.hideSpinner(component);
		//component.find("resubmitForApprovalBtn").set("v.disabled", false);
		helper.fireToast('Success', 'Experian has been resubmitted for Approval.', 'success');
    },

    handleError : function(component, event, helper){
        var componentName = 'MerchantExperianCustomerCheck';
        console.error(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
		helper.hideSpinner(component);
		//component.find("resubmitForApprovalBtn").set("v.disabled", false);
        helper.fireToast('Error!', 'Error saving Opportunity.', 'error');
    }
})