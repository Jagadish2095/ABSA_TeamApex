({
    
    // function call on component Load
    doInit: function(component, event, helper) {
        // by call this helper function  
        // helper.createObjectData(component, event);
        
        var recordId  = component.get("v.recordId");
        var action = component.get("c.AddViewChargeLoad");
        
        action.setParams({
            model : '',
            recordId: recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            helper.hideSpinner(component, event, helper);
            if (state === "SUCCESS") {   
                
                var model = JSON.parse(response.getReturnValue());              
                component.set("v.model", model);
                console.log("model",model);
                var collection  = model.chargeWrapperList;
                var RowItemList = component.get("v.chargeList");
                for (var i = 0; i < collection.length; i++) { 
                    
                    RowItemList.push({
                        'sobjectType': 'Charge__c',
                        'Charge_Account_No__c': collection[i].charge.Charge_Account_No__c,
                        'Charge_Amount__c': collection[i].charge.Charge_Amount__c,
                        'Transaction_Code__c': collection[i].charge.Transaction_Code__c,
                        'Corp_Code__c':collection[i].charge.Corp_Code__c,
                        'Cost_Centre__c':collection[i].charge.Cost_Centre__c,
                        'Sub_ledger__c':collection[i].charge.Sub_ledger__c,
                        'CR_Ref__c':collection[i].charge.CR_Ref__c,
                        'DR_Ref__c':collection[i].charge.DR_Ref__c,
                        'CR_Account_No__c':collection[i].charge.CR_Account_No__c,
                        'Effective_Date__c':collection[i].charge.Effective_Date__c,
                        'Id':collection[i].charge.Id,
                        'Case__c':recordId
                        
                    });
                    console.log("Item no : "+i,collection[i]);
                }
                
                // set the updated list to attribute (contactList) again    
                component.set("v.chargeList", RowItemList);
                if(model.errorMsg != null && model.errorMsg != ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": model.errorMsg,
                        "type":"error"
                    });
                    
                    toastEvent.fire();
                }
            }else if (state === "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "INCOMPLETE!",
                    "message": response.getReturnValue(),
                    "type":"error"
                });
                
                toastEvent.fire();
            }else if (state === "ERROR") {
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": errors[0].message,
                            "type":"error"
                        });
                        
                        toastEvent.fire();
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": 'An error ocured',
                            "type":"error"
                        });
                        
                        toastEvent.fire();
                    }
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Unknown error",
                        "type":"error"
                    });
                    
                    toastEvent.fire();
                }
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        var model = component.get("v.model");
        if(model.currentCase.Charge_Locked__c){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Locked!",
                "message": "Charges have already been locked and approved. Please contact your administrator to unlock.",
                "type":"warning"
            });
            
            toastEvent.fire();
            return;
        }
        helper.validateRequired(component, event)
        
        
        if(helper.validateRequired(component, event)){
            // call the apex class method for save the Contact List
            // with pass the contact List attribute to method param.  
            var action = component.get("c.SaveNewCharges");
            action.setParams({
                "chargeList": JSON.stringify(component.get("v.chargeList"))
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var isSuccess = response.getReturnValue();
                    if(isSuccess){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success",
                            "message": "Charges have been saved/Updated",
                            "type":"Success"
                        });
                        
                        toastEvent.fire();                        
                    }
                    
                }
                helper.hideSpinner(component, event, helper);
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        }
        
        
    },
    
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        
        var model = component.get("v.model");
        if(model.currentCase.Charge_Locked__c){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Locked!",
                "message": "Charges have already been locked and approved. Please contact your administrator to unlock.",
                "type":"warning"
            });
            
            toastEvent.fire();
            return;
        }
        helper.createObjectData(component, event);
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        
        var model = component.get("v.model");
        if(model.currentCase.Charge_Locked__c){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Locked!",
                "message": "Charges have already been locked and approved. Please contact your administrator to unlock.",
                "type":"warning"
            });
            
            toastEvent.fire();
            return;
        }
        
        var index = event.getParam("indexVar");
        
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.chargeList");
        
        var chargeId = AllRowsList[index].Id;
        
        var action = component.get("c.DeleteCharge");
        
        action.setParams({
            chargeId: chargeId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
                helper.hideSpinner(component, event, helper);
                var isSuccess = response.getReturnValue();
                
                if(!isSuccess){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "charge failed to delete. Please contact your System Administrator.",
                        "type":"error"
                    });
                    
                    toastEvent.fire();
                    return;
                }
            }
        });
        
        
        if(chargeId){
            $A.enqueueAction(action);
        }
        
        
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        console.log("list", AllRowsList);
        component.set("v.chargeList", AllRowsList);
    },
    unlock  : function(component, event, helper) {
        
        helper.showSpinner(component, event, helper);          
        
        console.log(component.get("v.model"))
        var recordId  = component.get("v.recordId");
        var action = component.get("c.unlock11");
        
        action.setParams({
            recordId: '',
            model : JSON.stringify(component.get("v.model"))
        });
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
                helper.hideSpinner(component, event, helper);
                
                var model = JSON.parse(response.getReturnValue());
                
                component.set("v.model", model);
                
                if(model.errorMsg != null && model.errorMsg != ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": model.errorMsg,
                        "type":"error"
                    });
                    
                    toastEvent.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "message": 'Case unlocked',
                        "type":"Success"
                    });
                    
                    toastEvent.fire();
                }
            }else if (state === "INCOMPLETE") {
                helper.hideSpinner(component, event, helper);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "INCOMPLETE!",
                    "message": response.getReturnValue(),
                    "type":"error"
                });
                
                toastEvent.fire();
            }else if (state === "ERROR") {
                    helper.hideSpinner(component, event, helper);
                    
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": errors[0].message,
                                "type":"error"
                            });
                            
                            toastEvent.fire();
                        }else{
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": 'An error ocured',
                                "type":"error"
                            });
                            
                            toastEvent.fire();
                        }
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Unknown error",
                            "type":"error"
                        });
                        
                        toastEvent.fire();
                    }
                }
        });
        
        $A.enqueueAction(action);
        
    },
    lockRecord  : function(component, event, helper) {
        
        var charges = component.get("v.chargeList");
        var foundUnsaved = 1==2;
        for(var i = 0; i < charges.length; i++){            
            foundUnsaved = charges[i].Id == null || charges[i].Id == '';
            if(foundUnsaved) {
                break;
            }
            
        }
        
        if (foundUnsaved && !confirm('There are unsaved chages on the grid, you will loose the data if you continue')) { 
            return;
        }
        
        
        helper.showSpinner(component, event, helper);          
        
        var recordId  = component.get("v.recordId");
        var action = component.get("c.lockCharges");
        
        action.setParams({
            recordId: recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
                helper.hideSpinner(component, event, helper);
                alert("Found");
                var isSuccess = response.getReturnValue();
                
                alert(isSuccess);
                if(!isSuccess){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "Charges cannot be locked. Please contact your System Administrator.",
                        "type":"error"
                    });
                    
                    toastEvent.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "message": 'Case locked',
                        "type":"Success"
                    });
                    
                    toastEvent.fire();
                }
            }
            
            
        });
        
        $A.enqueueAction(action);
        
        $A.get("e.force:refreshView").fire();
    }
})