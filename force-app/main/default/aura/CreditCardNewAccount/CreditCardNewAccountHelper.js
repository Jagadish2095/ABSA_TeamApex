({
    handleOnRemoveAccountCheck : function (component, event, helper) {
        component.set("v.enableRemoveAccBtn", false);
        var checkBoxId = event.target.id;
        var checkBox = document.getElementById(checkBoxId);
        var checkBoxIndex = String(checkBoxId).split('_')[1];
        var btnRmvAccId = "removeAccountBtn_" + checkBoxIndex;
        var btnRmvAcc = document.getElementById(btnRmvAccId);
        
        if(checkBox.checked == true){
            btnRmvAcc.disabled = false;
        } else{
            btnRmvAcc.disabled = true;
        }
    },
    handleRemoveAccount : function (component, event, helper){
        var btnRmvAccId = event.target.id;
        var btnRmvAcc = document.getElementById(btnRmvAccId);
        var btnRmvAccIndex = String(btnRmvAccId).split('_')[1];
        var accountFieldId = "appProductId_" + btnRmvAccIndex;
        var appProductId = document.getElementById(accountFieldId).value;
        var newCreditCards = component.get("v.newCreditCards");
        var newAccounts = component.get("v.newAccounts");
        
        component.set("v.showSpinner", true);
        var action = component.get("c.deleteAccount");
        
        action.setParams({
            "appProductId": appProductId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                
                if(responseData && responseData != null){
                    newCreditCards--;
                    newAccounts.splice(btnRmvAccIndex, 1);
                    
                    component.set("v.newCreditCards", newCreditCards);
                    component.set("v.newAccounts", newAccounts);
                }
                component.set("v.showSpinner", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("CreditCardNewAccount: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})