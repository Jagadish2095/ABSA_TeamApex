({
    doInit : function(component, event, helper) {
        helper.getAccountDetailsHelper(component, event, helper);
        
        var action = component.get("c.getAccountDetails");
        var caseId = component.get("v.recordId");
        console.log('clientAccountId ******'+ caseId);
        action.setParams({caseId:caseId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                var respObj = JSON.parse(response.getReturnValue());
                console.log('--------getSourceAccountDetails-------'+respObj);
                component.set('v.responseList',respObj);
                
                var prodList = [];
                var prodSet = new Set();
                for(var key in respObj){
                    console.log('==='+respObj[0].productType);
                    if (!prodList.includes(respObj[key].productType)) {
                        prodList.push(respObj[key].productType);
                    } 
                }
                component.set('v.prodTypesList',prodList);
                
            } else if(state === "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
            } else{
                
            }
        });
        $A.enqueueAction(action);
    },
      getAccountNumbers : function(component, event, helper) {
        console.log('Selected Product Value'+component.get('v.selectedProductValue'));
        var selectedProdType = component.get('v.selectedProductValue');
        
        var respObj = component.get('v.responseList');
        console.log(respObj);
        var acc = [];
         
        for(var key in respObj){
            if(respObj[key].productType == selectedProdType){
                acc.push(respObj[key].oaccntnbr);
            }
        }
        component.set('v.accNumList',acc);
        component.set('v.selectedAccountNumber','');
    },
    getSelectedAccount : function(component, event, helper) {
        var selectedAccountValue = component.get('v.selectedAccountNumber');
    },
    
    submitRequest : function(component, event, helper) {
        
        if(component.get("v.actionType") == "register"){
            
            helper.createNewOrAddReceipient(component, event, helper);
            
            
        }else if(component.get("v.actionType") == "update"){
          
            helper.updateNotifyMe(component, event, helper);
            
        }else if(component.get("v.actionType") == "cancel"){
            
            helper.cancelNotifyMe(component, event, helper);
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Action Type Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
        }
    },
    selectAll: function(component, event, helper) {
        if(component.get('v.all')){
       		component.set('v.payment',true);
        	component.set('v.withDrawal',true);
        	component.set('v.deposit',true);
        	component.set('v.transfer',true);
        	component.set('v.returned',true);
        	component.set('v.scheduled',true);
        	component.set('v.purchase',true);
        }else{
            component.set('v.payment',false);
        	component.set('v.withDrawal',false);
        	component.set('v.deposit',false);
        	component.set('v.transfer',false);
        	component.set('v.returned',false);
        	component.set('v.scheduled',false);
        	component.set('v.purchase',false);
        }
    },
    
    executeActionType : function(component, event, helper) {
         if(component.get("v.actionType") == "register"){
            component.set("v.isUpdate" , true);
            component.set("v.isCancel" , true);
            
        }else if(component.get("v.actionType") == "update"){
            helper.getReceipientRegistered(component,event);
            component.set("v.isUpdate" , true);
            component.set("v.isCancel" , true);
        }else if(component.get("v.actionType") == "cancel"){
            component.set("v.isUpdate" , false);
            component.set("v.isCancel" , false);
        }
    }
})