({
	doInit : function(component, event, helper) {
		helper.initMethod(component, event, helper);
        
        
	},
    
    updateLimit : function(component, event, helper) {
        
        var cardCashLimit = component.get("v.inpcardCshLim");
        var cardTransferLimit = component.get("v.inpcardTrfLim");
        var cardPointofSaleLimit = component.get("v.inpcardPosLim");
        var combiAccount = component.get('v.SelectedAccNumberFromFlow');
        
        component.set('v.inpcardCshLim', cardCashLimit);
        component.set('v.inpcardTrfLim', cardTransferLimit);
        component.set('v.inpcardPosLim', cardPointofSaleLimit);
        
        if(isNaN(cardCashLimit)){
            alert(cardCashLimit + " is not a number");
        }else if(isNaN(cardTransferLimit)){
            alert(cardTransferLimit + " is not a number");
        }else if(isNaN(cardPointofSaleLimit)){
            alert(cardPointofSaleLimit + " is not a number");
        }else{
        	var showConfirmationDiv = document.getElementById("confirmation "+combiAccount);
        	var hideLimitsDiv = document.getElementById("limits "+combiAccount);
        	console.log("Combi Number" + combiAccount);
        	console.log("ID Limit" + hideLimitsDiv);
        	$A.util.removeClass(showConfirmationDiv, "slds-hide");
        	$A.util.addClass(hideLimitsDiv, "slds-hide");
        }
    },
    
     ConfirandUpdate : function(component, event, helper) {
        var cardCashLimit = component.get("v.inpcardCshLim");
        var cardTransferLimit = component.get("v.inpcardTrfLim");
        var cardPointofSaleLimit = component.get("v.inpcardPosLim");
        var selectedAccNumber = component.get('v.SelectedAccNumberFromFlow'); 
         
        console.log("Cash Card Limit" +  cardCashLimit);
        console.log("Cash Transfer Limit" +  cardTransferLimit);
        console.log("Cash POS Limit" +  cardPointofSaleLimit);
        var action = component.get("c.updateDailyLimits"); 
         
        action.setParams({combiNbr : selectedAccNumber , cardCshLim : cardCashLimit, cardTrfLim : cardTransferLimit , cardPosLim : cardPointofSaleLimit, cardCntLim : '0'}); 
        //console.log('combi'+component.get('v.SelectedAccNumberFromFlow'));
      
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('response state---'+state);
            if (component.isValid() && state === "SUCCESS") {
                console.log('response state123---'+state);
                console.log('response ---'+response);
                var responseBean1 =JSON.parse(response.getReturnValue());
                console.log('message---'+JSON.stringify(responseBean1));
                var servicerResults = JSON.stringify(responseBean1);
                
                 var json = JSON.parse(servicerResults);
                
                
                if(json["ccp321o"] != null){
                    component.set('v.ServiceResponse', 'Limit Updated Successfully');
                    component.set('v.updateServiceResponse', '');
                }else{
                    component.set('v.updateServiceResponse', responseBean1);
                    component.set('v.ServiceResponse', '');
                }
                
                /*
                component.set('v.responseBean', responseBean1);
                if(servicerResults != 'null'){
                    component.set('v.ServiceResponse', 'Limit successully updated');
                    component.set('v.validationResponse', '');
                }else{
                    component.set('v.validationResponse', 'Captured Limit 0000000000001 should be a multiple of ten');
                    component.set('v.ServiceResponse', '');
                }
                */
                
            }else if(state === "ERROR"){
                
            }else{
                // console.log('***selectedAccNumber else***'+selectedAccNumber);
            }
            
        });     
        $A.enqueueAction(action);
        
        var showOutComeDiv = document.getElementById("outcome "+selectedAccNumber);
        var showConfirmationDiv = document.getElementById("confirmation "+selectedAccNumber);
        console.log("Combi Number" + selectedAccNumber);
        console.log("ID Limit" + showOutComeDiv);
        $A.util.removeClass(showOutComeDiv, "slds-hide");
        $A.util.addClass(showConfirmationDiv, "slds-hide");
        
         
      },
        Done : function(component, event, helper) {
            var cardCashLimit = component.get("v.inpcardCshLim");
            
            console.log("Cash Limit" + cardCashLimit);
            helper.initMethod(component, event, helper);
            var combiAccount = component.get('v.SelectedAccNumberFromFlow');
         	var showOutComeDiv = document.getElementById("outcome "+combiAccount); 
            var hideLimitsDiv = document.getElementById("limits "+combiAccount);
            $A.util.addClass(showOutComeDiv, "slds-hide");
            $A.util.removeClass(hideLimitsDiv, "slds-hide");
        },
         Cancel : function(component, event, helper) {
           var combiAccount = component.get('v.SelectedAccNumberFromFlow');
           var showConfirmationDiv = document.getElementById("confirmation "+combiAccount);
           var hideLimitsDiv = document.getElementById("limits "+combiAccount);
           $A.util.addClass(showConfirmationDiv, "slds-hide");
           $A.util.removeClass(hideLimitsDiv, "slds-hide");
           
         }
})