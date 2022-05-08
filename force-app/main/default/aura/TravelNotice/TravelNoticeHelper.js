({
    
    doInit : function(component, event){
        var action = component.get("c.getAccountDetails");
        var clientAccountId = component.get('v.clientAccountIdFromFlow');
        console.log('ClientAccountId ' + clientAccountId);
        action.setParams({clientAccountId:clientAccountId});
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('RESPONSE ' + response.getReturnValue());
                var respObj = JSON.parse(response.getReturnValue());
                    
                component.set('v.responseAccList',respObj);

                var combiAccountList = [];
                var accountNumberList = [];
                
                
                for(var key in respObj){
                    if(respObj[key].productType == 'CO'){
                        combiAccountList.push(respObj[key].oaccntnbr);
                    }
                    
                }
                
                if(combiAccountList.length > 0){
                   component.set('v.combiCardsAccounts',combiAccountList)  
                }else{
                    component.set("v.noCombiMsg" , true);
                }
                             
                
            } else if(state === "ERROR"){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Account Details Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
               }
                else{
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                    "title": "Error!",
                    "message": state,
                    "type":"error"
                });
                toastEvent.fire();  
                }
        });
        $A.enqueueAction(action);
        
    },
    
    enquiryTravelNotice : function(component , event){
      this.showSpinner(component);
      var accountNumber = component.get('v.selectedAccountNumber');
      console.log('Account Number ' + accountNumber);
      var combiNumber = component.get('v.combiNumber');
      console.log('Combi ' + combiNumber);
      var action = component.get("c.getTravelEnquiry");
       
      action.setParams({accessNumber:accountNumber , language : 'E' , action : 'READ' , cardNbr : combiNumber });
       
      action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('RESPONSE ' + response.getReturnValue());
                var respObj = JSON.parse(response.getReturnValue());
                if(respObj != null){
                    if(respObj.rdesc == null){
                        component.set("v.pauseHold" , respObj.pauseHold == 'Y' ? true : false);
                    	component.set("v.atmHold" , respObj.iatmHold == 'Y' ? true : false);
                        component.set("v.posHold" , respObj.iposHold == 'Y' ? true : false);
                        component.set("v.latmHold" , respObj.latmHold == 'Y' ? true : false);
                        component.set("v.lposHold" , respObj.lposHold == 'Y' ? true : false);
                        component.set("v.cnpHold" , respObj.cnpHold == 'Y' ? true : false);
                        component.set("v.dwhIndicator" , respObj.digwHold == 'Y' ? true : false);
                        component.set("v.isEnquiry", true);
                        this.hideSpinner(component);
                    }else{
                        this.hideSpinner(component);
                        var toastEvent = $A.get("e.force:showToast");
                		toastEvent.setParams({
                    	"title": "Error!",
                    	"message": "Nhenquirypausecardv1 " + respObj.rdesc,
                    	"type":"error"
                		});
                		toastEvent.fire();
                        
                        
                    } 
                }  else {
                    this.hideSpinner(component);
                    var toastEvent = $A.get("e.force:showToast");
                		toastEvent.setParams({
                    	"title": "Error!",
                    	"message": "Nhenquirypausecardv1 Something went wrong! Try again later",
                    	"type":"error"
                		});
                		toastEvent.fire();
                        
                }
                

               
                
            } else if(state === "ERROR"){
                 this.hideSpinner(component);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Nhenquirypausecardv1 Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
               
               }
                else{
                  this.hideSpinner(component);
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                    "title": "Error!",
                    "message":  "Nhenquirypausecardv1 " + state,
                    "type":"error"
                });
                toastEvent.fire();  
                    
                }
        });
        $A.enqueueAction(action);
        
	}
    ,
    showSpinner: function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},
 
	hideSpinner : function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
	},
    
    updatePauseCard : function(component, events){
       var selectedProdType = component.get('v.selectedProductValue');
       var accountNumber = component.get('v.selectedAccountNumber');
      
       var combiNumber = component.get('v.combiNumber');
      
       var pauseDate = component.get("v.pauseDate");
     
       
       var atmHold = component.get("v.atmHold") == true ? 'Y': 'N';
       var posHold = component.get("v.posHold") == true ? 'Y': 'N';
       var localAtmHold = component.get("v.latmHold") == true ? 'Y': 'N';
       var localPosHold = component.get("v.lposHold") == true ? 'Y': 'N';
       var cnpHold = component.get("v.cnpHold") == true ? 'Y': 'N';
       var localAtmHold = component.get("v.dwhIndicator") == true ? 'Y': 'N';
       var action = component.get("c.updateTravelNotice");
       
         if(selectedProdType =='' || selectedProdType == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Product type cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(accountNumber =='' || accountNumber == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Account number cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(pauseDate =='' || pauseDate == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Pause date cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else{
            this.showSpinner(component);
        	action.setParams({accessNumber:accountNumber , pauseHold : 'N' , iatmHold : atmHold ,iposHold:posHold,latmHold:localAtmHold,lposHold:localPosHold ,cnpHold:cnpHold,digwHold:localAtmHold,pauseDate:pauseDate,language:'E', action:'UPDT', cardNbr : combiNumber });
       
      		action.setCallback(this, function(response) {
            	var state = response.getState();
            	if (state === "SUCCESS") {
                	console.log('RESPONSE ' + response.getReturnValue());
                	var respObj = JSON.parse(response.getReturnValue());
                	if(respObj != null){
                    	if(respObj.pauseUpdated == 'Y'){
                        	component.set("v.isEnquiry", true);
                        	this.hideSpinner(component);
                        	var toastEvent = $A.get("e.force:showToast");
                			toastEvent.setParams({
                    		"title": "Success",
                    		"message": "Updated Successfully",
                    		"type":"Success"
                		});
                		toastEvent.fire();
                    }else{
                        this.hideSpinner(component);
                        var toastEvent = $A.get("e.force:showToast");
                		toastEvent.setParams({
                    	"title": "Error!",
                    	"message": "Nhupdatepausecardv1 " + respObj.rdesc,
                    	"type":"error"
                		});
                		toastEvent.fire();
                        
                    } 
                } else {
                       this.hideSpinner(component);
                    var toastEvent = $A.get("e.force:showToast");
                		toastEvent.setParams({
                    	"title": "Error!",
                    	"message": "Nhupdatepausecardv1 Something went wrong! Try again later",
                    	"type":"error"
                		});
                		toastEvent.fire();
                }
                

               
                
            } else if(state === "ERROR"){
                this.hideSpinner(component);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Nhupdatepausecardv1 Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
               
               }
                else{
                  this.hideSpinner(component);
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                    "title": "Error!",
                    "message":  "Nhupdatepausecardv1 " + state,
                    "type":"error"
                });
                toastEvent.fire();  
                   
                }
        });
        $A.enqueueAction(action);
         }
    }
    
   

})