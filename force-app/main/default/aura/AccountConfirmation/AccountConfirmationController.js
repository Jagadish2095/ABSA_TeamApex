({
    doInit : function(component, event, helper) {
       
    },
    
    getAccountNumbers : function(component, event, helper) {
       
        var selectedProdType = component.get('v.selectedProductValue');
        var respObj = component.get('v.responseList');
        
        var acc = [];
        
        for(var key in respObj){
            if(respObj[key].productType == selectedProdType){
                acc.push(respObj[key].oaccntnbr);
                
            }
        }
        component.set('v.accNumList',acc);
    },
    getSelectedAccount : function(component, event, helper) {
        var selectedAccountValue = component.get('v.selectedAccountNumber');
       
        component.set('v.selectedAccountNumberToFlow',selectedAccountValue);
        
        var respObj = component.get('v.responseList');
        var accBalance;
        for(var key in respObj){
            if(respObj[key].oaccntnbr == selectedAccountValue){
                accBalance= respObj[key].availableBalance;
            }
        }
      
        component.set('v.selectedAccountBalance',accBalance);
    },
    
    generateDoc :function(component, event, helper) {
       	console.log('Get the Document ');
        helper.showSpinner(component);
        var action = component.get("c.getDocument");
        var clientAccountNumber = component.get("v.selectedAccountNumberToFlow");
        var accId =component.get("v.clientAccountIdFromFlow");
        var branch =component.get("v.branch");
        var accountType =component.get("v.accountType");
        
        console.log('clientAccountNUmber from Flow recieved: '+ clientAccountNumber);
        console.log('accId: '+ accId);
        console.log('branch : '+ branch);
        console.log('accountType : '+ accountType);
        action.setParams({accountId: accId , accNo:clientAccountNumber, templateName:component.get("v.templateName") , caseId:component.get("v.caseId") , branch:branch ,accountType:accountType});
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.hideSpinner(component);
                console.log('-----SUCCESS-----');
                var respObj = JSON.parse(response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS",
                    "message": "Account Confirmation  Letter Fetched",
                    "type":"SUCCESS"
                });
                toastEvent.fire();
                
            }else if (state === "ERROR") {

				helper.hideSpinner(component);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toast = helper.getToast("Error", errors[0].message, "error");
               			toast.fire();
                		
                    }
                }
            }
            
        });
        $A.enqueueAction(action);
    }
    
})