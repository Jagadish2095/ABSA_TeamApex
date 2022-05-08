({
	doInit : function(component, event, helper) {
		var action = component.get("c.fetchLDPinfo"); 
        component.set("v.IsSpinner",true);
        action.setParams({
            caseId : component.get("v.recordId")
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {
                var serviceResponse = response.getReturnValue();
                console.log('serviceResponse'+JSON.stringify(serviceResponse));
                if(serviceResponse != null) {
                    var existingAccounts = serviceResponse['AppFinancials'];
                    console.log('existingAccounts'+JSON.stringify(existingAccounts));
                    var contracts=serviceResponse['Contracts'];
                    console.log('contracts'+JSON.stringify(contracts));
                    component.set("v.existingAccounts", existingAccounts);
                    component.set("v.existingBankGuarantees", serviceResponse['AppFinancials'].length);
                    component.set("v.contracts", contracts);
                    component.set("v.showSpinner", false);
                    helper.getManagedAccountsHelper(component);
                }
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    
	},
    
    handleShowModal: function (component, event, helper) {
        component.set("v.modRecordId", event.target.id);
        console.log('event.target.id'+event.target.id);
        component.set("v.isModalVisble", true);
        var childCmp = component.find("chqDetails");
        childCmp.reInit(component, event, helper);
        childCmp.toggleModal(component, event, helper);
        
    },
    
})