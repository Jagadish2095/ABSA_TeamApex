({
	myAction : function(component, event, helper) {
		
	},
    handleCaptureMandate:function(component, event, helper){
        var policySession =  component.get('v.policyData');
        var policy = JSON.parse(policySession.Policy);
        
        component.set('v.debitOrderDay',policy.DebitDetails.DebitDay);
        component.set('v.accountNumber',policy.DebitDetails.DebitAccountNumber);
        component.set('v.clientReference',policy.MainMember.CifClientCode);
        
        component.set("v.isModalOpen", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    submitDetails : function(component, event, helper) {}
})