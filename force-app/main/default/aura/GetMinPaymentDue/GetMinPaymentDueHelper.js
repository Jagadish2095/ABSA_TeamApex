({
    initMethod : function(component, event, helper) {
        var clientAccountId = component.get('v.clientAccountIdFromFlow');
        var selectedAccNumber = component.get('v.SelectedAccNumberFromFlow'); //00000004047451539
        var action = component.get("c.getMinimumPayDueCHQ");
        
        action.setParams({selectedAccNumber : selectedAccNumber});  
        action.setCallback(this, function(response) {
            var state = response.getState();
          if (component.isValid() && state === "SUCCESS") {
              var responseBean1 =JSON.parse(response.getReturnValue());
                component.set('v.responseBean', responseBean1);
                if(responseBean1 !=null){
                    var amtDue =responseBean1.amountDue;
                   component.set('v.AmountDueToflow',amtDue);
                   var amu = component.get('v.AmountDueToflow');
                    var maskedAccountNumber;
                 if(responseBean1.accountNbr == selectedAccNumber){
                    maskedAccountNumber = responseBean1.accountNbr;
                 }
                    else{
                        maskedAccountNumber = selectedAccNumber;
                    }
                 
                 maskedAccountNumber = maskedAccountNumber.replace(maskedAccountNumber.substring(0,maskedAccountNumber.length - 4), "*".repeat(maskedAccountNumber.length - 4));
        		component.set('v.maskedAccountNumberToFlow',maskedAccountNumber);
                 var mask = component.get('v.maskedAccountNumberToFlow');                                   
                 }
                
            }else if(state === "ERROR"){
                
            }else{
                }
            
        });     
        $A.enqueueAction(action);
    },
     sendEmailNotf : function(component, event, helper, accNumber, minAmountDue) {
        var action2 = component.get("c.sendEmailNotifications"); 
        accNumber = accNumber.replace(accNumber.substring(0,accNumber.length - 4), "*".repeat(accNumber.length - 4))
        action2.setParams({accNumber:accNumber,minAmountDue:minAmountDue});
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
            } else if(state === "ERROR"){
                
            } else{
                
            }
         });
         $A.enqueueAction(action2);
    }
    
    
})