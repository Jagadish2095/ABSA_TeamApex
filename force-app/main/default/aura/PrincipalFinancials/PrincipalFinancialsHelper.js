({
	handleInit : function(component) {
        component.set("v.showSpinner", true);
		var opportunityId = component.get("v.opportunityId");
		var action = component.get("c.getRelatedParties");
        action.setParams({
            "opportunityId": opportunityId
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.clientNames", data);
            } else {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Principle: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
	},
    handleClientSelection : function(component) {
		var clientName = component.find("clientSelect").get("v.value");
        component.set("v.selectedClient", clientName);
        
        var clientNames = component.get("v.clientNames");
        var indexValue = 0;
        
        if(clientNames != null){
            for(var i = 0; i < clientNames.length; i++){
                if(clientNames[i].Name == clientName){
                    if(String(clientNames[i].Account.Client_Type__c).toUpperCase() == 'INDIVIDUAL' || 
                       String(clientNames[i].Account.Client_Type__c).toUpperCase() == 'SOLE TRADER' || 
                       String(clientNames[i].Account.Client_Type__c).toUpperCase() == 'STAFF'){
                        component.set("v.clientType", "Individual");
                        component.set("v.clientIdNumber", clientNames[i].ID_Number__c);
                    	component.set("v.accountId", clientNames[i].AccountId);
                        component.set("v.clientCIF", clientNames[i].Account.CIF__c);
                    } else if(String(clientNames[i].Account.Client_Type__c).toUpperCase() == ''){
                        component.set("v.clientType", "");
                    } else {
                        component.set("v.clientType", "Business");
                        component.set("v.clientCIF", clientNames[i].Account.CIF__c);
                    }
                }
            }
        }
	}
})