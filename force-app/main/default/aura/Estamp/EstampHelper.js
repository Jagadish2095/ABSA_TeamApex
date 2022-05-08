({
        
        getAccountNumber : function(component, event, helper) {
            
            var allValid = component.find('estampForm').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                inputCmp.focus();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            
            if (allValid) {
                
                this.showSpinner(component); 
                
                var estempRefno=component.get("v.eStampRefNum");
                var tranYY= component.get("v.transactionYear");
                var tranMM= component.get("v.transactionMonth");
                var tranDD= component.get("v.transactionDay");
                var tranHr = component.get("v.transactionHour");
                var tranmin = component.get("v.transactionMinute");
                
                var action = component.get("c.getAccountDetails");
                
                action.setParams({
                    estempRefno: component.get("v.eStampRefNum"), 
                    tranYY: component.get("v.transactionYear"),
                    tranMM: component.get("v.transactionMonth"),
                    tranDD: component.get("v.transactionDay"),
                    tranHr: component.get("v.transactionHour"),
                    tranmin: component.get("v.transactionMinute")
                });
                
                action.setCallback(this, function(response) {
                    
                    component.set("v.showEstampForm",false);
                    component.set("v.AccountNumber",response.getReturnValue());
                    var respObj = response.getReturnValue();
                    console.log('Account number ' + respObj);
                    this.getAccountInfo(component, event, helper)
                    
                    this.hideSpinner(component);
                });
                
                $A.enqueueAction(action);
                
            } 
        },
        getAccountInfo : function(component, event, helper) {
            
            
            
            var accNum= component.get("v.AccountNumber");
            
            var action = component.get("c.getAccountInfo");
            
            action.setParams({ accNumber: accNum });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    if(storeResponse!=null){
                    component.set("v.clientDetailsBean",JSON.parse(storeResponse));
                    var clientDetails = component.get("v.clientDetailsBean");
                    var productList = [];
                    
                    clientDetails.ClientDetails.forEach(function(record) {
                        
                        if( record.account != null ) {
                            
                            if (record.account != null) {
                                record.account.forEach(function(record) {
                                    productList.push(record);
                                });
                                
                            }
                        }
                    });
                    
                    
                    console.log('productList' +JSON.stringify( productList));
                    
                    if (productList.length != 0) {
                        productList.forEach(function(record) {
                            console.log('Inside Productlist');
                            console.log('############  AccountNumber' + JSON.stringify(record.accountNumber.value ));
                            console.log('Account Number' + accNum);
                            var accno = record.accountNumber.value;
                            if( accno.slice(1) == accNum ){
                                
                                component.set("v.AccountType", record.productType.value);
                                component.set("v.AccountName",record.product.value);
                                console.log(' ############## Accounttype' + component.get("v.AccountType"));
                                console.log('############  AccountName' + component.get("v.AccountName"));
                            }
                            
                        });
                    }
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "title": "ERROR",
                            "message": "Please input the correct account number and date range for the required statement",
                            "type":"ERROR"
                        });
                        toastEvent.fire();
                    }
                    
                } else if (state === "ERROR") {
                    var message = "";
                    var errors = response.getError();
                    if (errors) {
                        for (var i = 0; i < errors.length; i++) {
                            for (
                                var j = 0;
                                errors[i].pageErrors && j < errors[i].pageErrors.length;
                                j++
                            ) {
                                message +=
                                    (message.length > 0 ? "\n" : "") +
                                    errors[i].pageErrors[j].message;
                            }
                            if (errors[i].fieldErrors) {
                                for (var fieldError in errors[i].fieldErrors) {
                                    var thisFieldError = errors[i].fieldErrors[fieldError];
                                    for (var j = 0; j < thisFieldError.length; j++) {
                                        message +=
                                            (message.length > 0 ? "\n" : "") +
                                            thisFieldError[j].message;
                                    }
                                }
                            }
                            if (errors[i].message) {
                                message += (message.length > 0 ? "\n" : "") + errors[i].message;
                            }
                        }
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "title": "ERROR",
                            "message": "Please input the correct account number and date range for the required statement" + errors,
                            "type":"ERROR"
                        });
                        toastEvent.fire();
                    } else {
                        message += (message.length > 0 ? "\n" : "") + "Unknown error";
                    }
                    
                } 
                
                
                
            });
            
            $A.enqueueAction(action);
            
        },
        
        getToast : function(title, msg, type) {        
            var toastEvent = $A.get("e.force:showToast");        
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
            }); 
            console.log('toastEvent : '+'title : '+title+' - message : '+msg+' - type : '+type);
            return toastEvent;
        },
        
        showSpinner: function (component) {
            var spinner = component.find("TheSpinner");
            $A.util.removeClass(spinner, "slds-hide");
        },
        
        hideSpinner: function (component) {
            var spinner = component.find("TheSpinner");
            $A.util.addClass(spinner, "slds-hide");
        }
        
    })