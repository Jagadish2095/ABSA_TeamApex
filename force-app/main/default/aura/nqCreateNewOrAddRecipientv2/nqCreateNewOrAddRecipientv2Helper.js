({
    getProductInfo : function(component, event, helper) {
        var action = component.get("c.getAccountNumberDetails");
        action.setParams({caseId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                component.set('v.responseList',respObj);
                
                var prodList = [];
                var prodSet = new Set();
                for(var key in respObj){
                    if (!prodList.includes(respObj[key].productType)) {
                        prodList.push(respObj[key].productType);
                    } 
                }
                component.set('v.prodTypesList',prodList);
                
            } else if(state === "ERROR"){
                
            } else{
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getWrapperClass  : function(component, event, helper){
       var wrapper = [];
        wrapper.push({"accountNumber":"",    
                      "all":false,  
                      "payment":false, 
                      "withDrawal":false, 
                      "deposit":false, 
                      "transfer":false, 
                      "returned":false, 
                      "scheduled":false, 
                      "purchase":false,
                      "notifyTimes":"",
                      "balanceUpdates":"",
                      "minimumAmount":"",
                      "cellPhone" : "",
                      "lng":"",
                      "contactPref": "",                     
                      "email": "",
                      "productType": ""});
        
        component.set('v.accWrapper',wrapper);
    },
    
    getAccountDetailsHelper: function(component, event, helper){
        var action = component.get("c.getAccountName");
        action.setParams({caseId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
             var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(! $A.util.isUndefinedOrNull(respObj)) {
                    debugger;
                    component.set("v.fullName", respObj);
                }
            }
             });
        $A.enqueueAction(action);
    },
    
    createNewOrAddReceipient: function(component, event, helper){
         
         var selectedProdType = component.find("myProductselection").get("v.value");
         console.log('Selected Product' + selectedProdType );
         var selectedAccountValue = component.get('v.selectedAccountNumber');
         var actionType = component.get('v.actionType');
         var fullname = component.get('v.fullName');
         var language = component.get('v.language');
       
         var email = component.get('v.email');
         var deposit = component.get('v.deposit');
         var payment = component.get('v.payment');
         var withDrawal = component.get('v.withDrawal');
         var transfer = component.get('v.transfer');
         var returned = component.get('v.returned');
         var scheduled = component.get('v.scheduled');
         var purchase = component.get('v.purchase');
         var contactPref = component.get('v.contactPref');
         var cellPhone = component.get('v.cellPhone');
         var notifyTimes = component.get('v.notifyTimes');
         var balanceUpdate = component.get('v.balanceUpdates');
         var minimumAmount = component.get('v.minimumAmount');
         
         console.log(payment);
         console.log(withDrawal);
         console.log(cellPhone);
         console.log(notifyTimes);
         
         if(selectedProdType =='' || selectedProdType == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Product Type Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(selectedAccountValue =='' || selectedAccountValue == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Account Number Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(actionType =='' || actionType == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Action Type Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }  else if(fullname =='' || fullname == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Full name Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         } else if(language =='' || language == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Language Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }  else if(contactPref =='' || contactPref == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Preferred Notification Language Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }  else if(contactPref == 'E' && (email == '' || email == null)){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Email Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }  else if(contactPref == 'S' && (cellPhone == '' || cellPhone == null)){
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                "title": "Error!",
                "message": "Mobile Number Cannot Be Blank.",
                "type":"error"
               });
               toastEvent.fire();
         } else if(notifyTimes =='' || notifyTimes == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Notify Times Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         } else if(balanceUpdate =='' || balanceUpdate == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Balance Updates Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         } else if(minimumAmount =='' || minimumAmount == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Minimum Amount Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         } else{
             this.showSpinner(component,event);
             var proArea;
             switch(selectedProdType) {
  					case 'CQ':
                        proArea = 'CHEQUE';
    					break;
  					case 'SA':
                     	proArea = 'SAVINGS';
    					break;
                     case 'CA':
                     	proArea = 'CREDIT CARD';
    					break;
                     case 'PL':
                     	proArea = 'PERSONAL LOAN';
    					break;
                     case 'DP':
                     	proArea = 'DEPOSITOR PLUS';
    					break;
                     case 'FV':
                     	proArea = 'AVAF';
    					break;
                     case 'TD':
                     	proArea = 'TERM DEPOSIT';
    					break;
                     case 'LI':
                     	proArea = 'LIFE';
    					break;
                     case 'ML':
                     	proArea = 'MORTGAGE LOANS';
    					break;
                     case 'SI':
                     	proArea = 'INSURANCE';
    					break;
              }
            
             var action = component.get("c.registerNotifyMe");
        	 action.setParams({ accountNumber:selectedAccountValue,
                               caseId:component.get("v.recordId"),
                               payment:payment,
                               withDrawal:withDrawal,
                               deposit:deposit,
                               transfer:transfer,
                               returned:returned,
                               scheduled:scheduled,
                               purchase:purchase,
                               notifyTimes:notifyTimes,
                               balanceUpdates:balanceUpdate,
                               minimumAmount:minimumAmount,
                               recipName:fullname,
                               cellPhone:cellPhone,
                               lng:language,
                               contactPref:contactPref,
                               email:email,
                               productType:proArea
                              });
             action.setCallback(this, function(response) {
             var state = response.getState();
               if (state === "SUCCESS") {
                  var respObj = JSON.parse(response.getReturnValue());
                    if(! $A.util.isUndefinedOrNull(respObj)) {
                        if(respObj.nqp906o.rcode == '0'){
                            this.hideSpinner(component,event);
                            var toastEvent = $A.get("e.force:showToast");
                    		toastEvent.setParams({
                    		"title": "Success!",
                    		"message": "Successfully registered for notify me",
                    		"type":"Success"           
                			});
                			toastEvent.fire();
                        }else{
                            this.hideSpinner(component,event);
                            var toastEvent = $A.get("e.force:showToast");
                    		toastEvent.setParams({
                    		"title": "Error!",
                    		"message": respObj.nbsmsgo.msgEntry.msgTxt,
                    		"type":"error!"           
                			});
                			toastEvent.fire();
                        }
                   }else{
                        this.hideSpinner(component,event);
                		var toastEvent = $A.get("e.force:showToast");
                		toastEvent.setParams({
                    	"title": "Error!",
                    	"message": "Something went wrong! Please try again later",
                    	"type":"error"
                	});
                	toastEvent.fire();
            		}
              }else if(state === "ERROR"){
                this.hideSpinner(component,event);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
             }
             });
            $A.enqueueAction(action);
         }                                                   
        
    },
    updateNotifyMe: function(component, event, helper){
         
         var selectedProdType = component.find("myProductselection").get("v.value");
         console.log('Selected Product' + selectedProdType );
         var selectedAccountValue = component.get('v.selectedAccountNumber');
         var actionType = component.get('v.actionType');
         var deposit = component.get('v.deposit');
         var payment = component.get('v.payment');
         var withDrawal = component.get('v.withDrawal');
         var transfer = component.get('v.transfer');
         var returned = component.get('v.returned');
         var scheduled = component.get('v.scheduled');
         var purchase = component.get('v.purchase');
         var contactPref = component.get('v.contactPref');
         var cellPhone = component.get('v.cellPhone');
         var notifyTimes = component.get('v.notifyTimes');
         var balanceUpdate = component.get('v.balanceUpdates');
         var minimumAmount = component.get('v.minimumAmount');
         var fullName = component.get('v.fullName');
         var contactPref = component.get('v.contactPref'); 
         var language = component.get('v.language');
         var email = component.get('v.email');
         var cellPhone = component.get('v.cellPhone');
         
         if(selectedProdType =='' || selectedProdType == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Product type cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(selectedAccountValue =='' || selectedAccountValue == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Account number cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(actionType =='' || actionType == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Action type cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(fullName == '' || fullName == null){
              var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Full name cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(contactPref == '' || contactPref == null){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": " Prefered contact method cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(contactPref == 'S' && (cellPhone == '' || cellPhone == null)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Mobile number cannot be blank.",
                "type":"error"
            });
            toastEvent.fire(); 
         }else if(contactPref == 'E' && (email == '' || email == null)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Email address cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();  
         }else if(language == '' || language == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Language cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();  
         }else if(notifyTimes =='' || notifyTimes == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Notify times cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         } else if(balanceUpdate =='' || balanceUpdate == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Balance updates cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         } else if(minimumAmount =='' || minimumAmount == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Minimum amount cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
         } else{
             this.showSpinner(component,event);
             var proArea;
             switch(selectedProdType) {
  					case 'CQ':
                        proArea = 'CHEQUE';
    					break;
  					case 'SA':
                     	proArea = 'SAVINGS';
    					break;
                     case 'CA':
                     	proArea = 'CREDIT CARD';
    					break;
                     case 'PL':
                     	proArea = 'PERSONAL LOAN';
    					break;
                     case 'DP':
                     	proArea = 'DEPOSITOR PLUS';
    					break;
                     case 'FV':
                     	proArea = 'AVAF';
    					break;
                     case 'TD':
                     	proArea = 'TERM DEPOSIT';
    					break;
                     case 'LI':
                     	proArea = 'LIFE';
    					break;
                     case 'ML':
                     	proArea = 'MORTGAGE LOANS';
    					break;
                     case 'SI':
                     	proArea = 'INSURANCE';
    					break;
              }
             
             var action = component.get("c.updateNotifyMe");
        	 action.setParams({ accountNumber:selectedAccountValue,
                               caseId:component.get("v.recordId"),
                               payment:payment,
                               withDrawal:withDrawal,
                               deposit:deposit,
                               transfer:transfer,
                               returned:returned,
                               scheduled:scheduled,
                               purchase:purchase,
                               notifyTimes:notifyTimes,
                               balanceUpdates:balanceUpdate,
                               minimumAmount:minimumAmount,
                               productType:proArea
                              });
             action.setCallback(this, function(response) {
             var state = response.getState();
               if (state === "SUCCESS") {
                  var respObj = JSON.parse(response.getReturnValue());
                    if(! $A.util.isUndefinedOrNull(respObj)) {
                        if(respObj.nqp204o.rc == '0'){
                            this.updateNotifymeContactDetails(component,event);
                            this.hideSpinner(component,event);
                            var toastEvent = $A.get("e.force:showToast");
                    		toastEvent.setParams({
                    		"title": "Success!",
                    		"message": "Record updated successfully",
                    		"type":"Success"           
                			});
                			toastEvent.fire();
                        }else{
                            this.hideSpinner(component,event);
                            var toastEvent = $A.get("e.force:showToast");
                    		toastEvent.setParams({
                    		"title": "Error!",
                    		"message": respObj.nbsmsgo.msgEntry.msgTxt,
                    		"type":"error!"           
                			});
                			toastEvent.fire();
                        }
                   }else {
                        this.hideSpinner(component,event);
                		var toastEvent = $A.get("e.force:showToast");
                		toastEvent.setParams({
                    	"title": "Error!",
                    	"message": "Something went wrong! Please try again later",
                    	"type":"error"
                	});
                	toastEvent.fire();
            		}
              }else if(state === "ERROR"){
                this.hideSpinner(component,event);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
             }
             });
            $A.enqueueAction(action);
         }                                                   
        
    }
    ,
    updateNotifymeContactDetails: function(component, event){
         var fullName = component.get('v.fullName');
         var contactPref = component.get('v.contactPref'); 
         var language = component.get('v.language');
         var email = component.get('v.email');
         var cellPhone = component.get('v.cellPhone');
        
         var action = component.get("c.updateRecipientRegistered");
        	 action.setParams({caseId:component.get("v.recordId"),
                               recipNm:fullName,
                               contactPref:contactPref,
                               language:language,
                               email:email,
                               cellphone:cellPhone              
                              });
             action.setCallback(this, function(response) {
             var state = response.getState();
               if (state === "SUCCESS") {
                  var respObj = JSON.parse(response.getReturnValue());
                   console.log('Results ' + response.getReturnValue());
                    if(! $A.util.isUndefinedOrNull(respObj)) {
                        if(respObj == '0'){
                            
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                    		toastEvent.setParams({
                    		"title": "Error!",
                    		"message": respObj,
                    		"type":"error"           
                			});
                			toastEvent.fire();
                        }
                    }else{
                       	var toastEvent = $A.get("e.force:showToast");
                		toastEvent.setParams({
                    	"title": "Error!",
                            "message": "NQREPLACERECIPIENTSACROSSALLACNTSV1: Something went wrong! Please try again later",
                    	"type":"error"
                		});
                		toastEvent.fire(); 
                    }
              }else if(state === "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "NQREPLACERECIPIENTSACROSSALLACNTSV1: Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
             }
             });
            $A.enqueueAction(action);
         }                                                  
        
    ,
    cancelNotifyMe: function(component, event, helper){
         var selectedProdType = component.find("myProductselection").get("v.value");
         console.log('Selected Product' + selectedProdType );
         var selectedAccountValue = component.get('v.selectedAccountNumber');
         var actionType = component.get('v.actionType');
         
         if(selectedProdType =='' || selectedProdType == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Product Type Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(selectedAccountValue =='' || selectedAccountValue == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Account Number Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }else if(actionType =='' || actionType == null  ){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Action Type Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
         }  else{
             
             this.showSpinner(component,event);
             
             var action = component.get("c.cancelNotifyMe");
        	 action.setParams({ accountNumber:selectedAccountValue,
                               caseId:component.get("v.recordId")
                              });
             action.setCallback(this, function(response) {
             var state = response.getState();
               if (state === "SUCCESS") {
                  var respObj = JSON.parse(response.getReturnValue());
                    if(! $A.util.isUndefinedOrNull(respObj)) {
                        if(respObj.nqp207o.rc == '0'){
                            this.hideSpinner(component,event);
                            var toastEvent = $A.get("e.force:showToast");
                    		toastEvent.setParams({
                    		"title": "Success!",
                    		"message": "Cancelled successfully",
                    		"type":"Success"           
                			});
                			toastEvent.fire();
                        }else{
                            this.hideSpinner(component,event);
                            var toastEvent = $A.get("e.force:showToast");
                    		toastEvent.setParams({
                    		"title": "Error!",
                    		"message": respObj.nbsmsgo.msgEntry.msgTxt,
                    		"type":"error!"           
                			});
                			toastEvent.fire();
                        }
                    }else{
                        this.hideSpinner(component,event);
                        var toastEvent = $A.get("e.force:showToast");
                		toastEvent.setParams({
                    	"title": "Error!",
                    	"message": "Something went wrong! Please try again later",
                    	"type":"error"
                		});
                		toastEvent.fire(); 
                    }
              }else if(state === "ERROR"){
                this.hideSpinner(component,event);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
             }
             });
            $A.enqueueAction(action);
         }                                                   
        
    }
    ,
    sumitCreateRequest  : function(component, event, helper){
        var wrapper = component.get("v.accWrapper");
        var action = component.get("c.getRequestSubmitInfo");
        action.setParams({"accountNumber":wrapper[0].accountNumber, 
                          "caseId" : component.get("v.recordId"),
                          "all":wrapper[0].all,  
                          "payment":wrapper[0].payment, 
                          "withDrawal":wrapper[0].withDrawal, 
                          "deposit":wrapper[0].deposit, 
                          "transfer":wrapper[0].transfer, 
                          "returned":wrapper[0].returned, 
                          "scheduled":wrapper[0].scheduled, 
                          "purchase":wrapper[0].purchase,
                          "notifyTimes":wrapper[0].notifyTimes,
                          "balanceUpdates":wrapper[0].balanceUpdates,
                          "minimumAmount":wrapper[0].minimumAmount,
                          "cellPhone" : wrapper[0].cellPhone,
                          "lng":wrapper[0].lng,
                          "contactPref":wrapper[0].contactPref,
                          "email":wrapper[0].email,
                          "productType" : wrapper[0].productType,
                          "actionType" : component.get("v.actionType")});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().state =='success'){
                    this.showToast(response.getReturnValue().state, response.getReturnValue().message,response.getReturnValue().state);
                   // component.set("v.isFirstScreen", false);                    
                }else{
                    this.showToast(response.getReturnValue().state, response.getReturnValue().message,response.getReturnValue().state);
                }
                
                
                
                            }
        });        
        $A.enqueueAction(action);
    },
    
    showToast : function(type, message, title){
       var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        "type" : type,
        "title": title,
        "message": message
    });
    toastEvent.fire();  
    },
    
    getReceipientRegistered : function(component, event){
        this.showSpinner(component,event);
        var action = component.get("c.getRecipientRegistered");
        console.log('Case Id ' + component.get("v.recordId"));
        action.setParams({caseId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('STATE ' , state);
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                console.log('Results ' + response.getReturnValue());
                if(! $A.util.isUndefinedOrNull(respObj)) {
                    if(respObj.sbuCd != null){
                    	component.set("v.fullName", respObj.dets.recipNm);
                    	component.set("v.contactPref", respObj.dets.contactPref);
                    	component.set("v.language", respObj.dets.lngPref);
                    	component.set("v.cellPhone", respObj.dets.cellPhone);
                    	component.set("v.email", respObj.dets.email);
                    	console.log('Email ', respObj.dets.email);
                    	this.hideSpinner(component,event);
                    }else{
                        this.hideSpinner(component,event);
                        this.showToast('error', 'Error','Something went wrong! Account not registered for notify me');
                    }
                }else{
                    this.hideSpinner(component,event);
                    this.showToast('error', 'Error','Something went wrong! Try again later');
                }
            }else if (state === "ERROR") {
                   this.hideSpinner(component,event);
                   this.showToast('error', 'Error','Service Issue ..Please try again');	
            }
          
             });
        $A.enqueueAction(action);
    },
    showSpinner: function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
	},
 
	hideSpinner : function(component) {
		var spinnerMain =  component.find("Spinner");
		$A.util.addClass(spinnerMain, "slds-hide");
	},
    
    
})