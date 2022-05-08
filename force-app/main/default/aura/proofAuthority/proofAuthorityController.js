({
    initData: function(component, event, helper) {
        var recordId= component.get("v.recordId");
        const internetBankingUserIdNumbers = component.get("v.internetBankingUserIdNumbers");
        let internetBankingUserIds = internetBankingUserIdNumbers ? JSON.parse(internetBankingUserIdNumbers) : [];
        var action = component.get('c.getAccountWithContacts');
        action.setParams({
            accountId :recordId,
            internetBankingUserIdNumbers : internetBankingUserIds
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in wrapperList attribute on component.
                component.set('v.RequestJSON', JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
    },  
    HandleResponse: function(component, event, helper) {
        var ResponseMetadata = event.getParam('responseMetadata');
        component.set('v.proofOfAuthorityData',ResponseMetadata) 
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    }
})