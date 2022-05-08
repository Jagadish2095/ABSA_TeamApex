({
	
    populateContracts: function (component) {
        var recordId=component.get("v.recordId");
        console.log('recordId'+recordId);
        var action = component.get("c.getLinkedContracts");
        action.setParams({
            recordId: recordId,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    component.set("v.contracts", result);
                    var contracts=component.get("v.contracts");
                    console.log('contracts'+contracts);
                    
                }
            }
            /*
            else {
                this.showError(response, "getLinkedChequeAccounts");
            }
            */
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    toggleModal: function (component) {
        $A.util.toggleClass(component.find("modal"), "slds-fade-in-open");
        $A.util.toggleClass(component.find("backdrop"), "slds-backdrop_open");
    }

})