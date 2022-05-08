({
	doInit : function(component, event, helper) {
		helper.checkRefundApprovalStage(component);
	},
	submitApproval : function(component, event, helper) {
		helper.submitRefundApproval(component);
	},
})