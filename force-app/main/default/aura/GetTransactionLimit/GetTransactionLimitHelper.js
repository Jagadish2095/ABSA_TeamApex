({
	initMethod : function(component, event, helper) {
        //var clientAccountId = component.get('v.clientAccountIdFromFlow');
        
        var selectedAccNumber =  component.get('v.SelectedAccNumberFromFlow'); //00000004047451539
        // var maskedAccountNumber='';
        console.log('============'+selectedAccNumber);
        var action = component.get("c.getDailyLimits");
        
        action.setParams({selectedCombiNumber : selectedAccNumber});  
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('response state---'+state);
            if (component.isValid() && state === "SUCCESS") {
                console.log('response state123---'+state);
                var responseBean1 =JSON.parse(response.getReturnValue());
                console.log('message---'+JSON.stringify(responseBean1));
                component.set('v.responseBean', responseBean1);
                if(responseBean1 !=null){
                    console.log('Eneredddd');
                    var amtDue =responseBean1.amountDue;
                    console.log('amtDue'+amtDue);
                    component.set('v.AmountDueToflow',amtDue);
                   var amu = component.get('v.AmountDueToflow');
                    console.log('amu*****'+amu);
                    var maskedAccountNumber;
                 if(responseBean1.accountNbr == selectedAccNumber){
                     console.log('**Entered selectedAccNumber***'+selectedAccNumber);
                      maskedAccountNumber = responseBean1.accountNbr;
                 }else{
                     maskedAccountNumber = selectedAccNumber;
                 }
                 
                 maskedAccountNumber = maskedAccountNumber.replace(maskedAccountNumber.substring(0,maskedAccountNumber.length - 4), "*".repeat(maskedAccountNumber.length - 4));
        		console.log('***maskedAccountNumber***'+maskedAccountNumber);
                 component.set('v.maskedAccountNumberToFlow',maskedAccountNumber);
                      var mask = component.get('v.maskedAccountNumberToFlow');                                   
                 console.log('***mask***'+mask);

                }
                
            }else if(state === "ERROR"){
                
            }else{
                // console.log('***selectedAccNumber else***'+selectedAccNumber);
            }
            
        });     
        $A.enqueueAction(action);
   
		
	}
})