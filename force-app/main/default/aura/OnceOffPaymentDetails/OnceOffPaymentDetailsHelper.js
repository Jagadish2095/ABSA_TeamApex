({
    
    addNewBankAccount: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getPayments");
        var caseId = component.get("v.recordId");
        
        action.setParams({
            "caseId": caseId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log('aa');
                var responseData = response.getReturnValue();
                var newAccounts = component.get("v.newAccounts");
                var newCreditCards = component.get("v.newCreditCards");
                
                if(responseData && responseData != null){
                    newCreditCards++;
                    newAccounts.push(responseData);
                    
                    component.set("v.newAccounts", newAccounts);
                    component.set("v.newCreditCards", newCreditCards);
                }
                component.set("v.showSpinner", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.log('bb'+JSON.stringify(errors));
                component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("CreditCard: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleSaveAndValidate : function (component,event,helper){
    	//component.set("v.showSpinner", true);
        var action = component.get("c.saveClass");
        var newAccounts = component.get("v.newAccounts");
        action.setParams({
            
            "newAccounts": newAccounts
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var responseData = response.getReturnValue();
            console.log('responseData'+responseData);
            console.log('responseData'+responseData.Journal_Required__c);
            if (state === "SUCCESS") {
                var toastEvent = this.getToast("Success! ", "Once Off Payment Details saved successfully", "Success");
        		toastEvent.fire(); 
                
            } else if (state === "ERROR") {
                var errors = response.getError();
               
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("CreditCard: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
        });

        return toastEvent;
    },
    getToastError: function (title,msg,duration,key,type,mode) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            duration:duration,
            key: key,
            type: type,
            mode: mode
        });

        return toastEvent;
    },
    handlePaymentSave:function(component,event,helper){
       
        var vaildationFailReason1 = '';
        var newAccounts = component.get("v.newAccounts");
        console.log('newAccounts'+JSON.stringify(newAccounts));
        for(var i in newAccounts){
            if($A.util.isEmpty(newAccounts[i].Once_Off_Payment_Required__c)){
                
                vaildationFailReason1 = "The field Once Off Payment Required cannot be empty!";
                var toastEvent = this.getToastError("Error! ",vaildationFailReason1,"4000",'info_alt','error','dismissible');
        		toastEvent.fire();
            }
            
        else if($A.util.isEmpty(newAccounts[i].Target_Account__c)){
                
                vaildationFailReason1 = "The field Target Account cannot be empty!";
                var toastEvent = this.getToastError("Error! ",vaildationFailReason1,"4000",'info_alt','error','dismissible');
        		toastEvent.fire();
            }
            
        else if($A.util.isEmpty(newAccounts[i].Target_Account_Type__c)){
                
                vaildationFailReason1 = "The field Target Account Type cannot be empty!";
                var toastEvent = this.getToastError("Error! ",vaildationFailReason1,"4000",'info_alt','error','dismissible');
        		toastEvent.fire();
            }
        else if($A.util.isEmpty(newAccounts[i].Statement_Reference__c)){
                
                vaildationFailReason1 = "The field statement reference cannot be empty!";
                var toastEvent = this.getToastError("Error! ",vaildationFailReason1,"4000",'info_alt','error','dismissible');
        		toastEvent.fire();
            }
            
        else if($A.util.isEmpty(newAccounts[i].Amount_Fullfillment__c)){
                
                vaildationFailReason1 = "The field Amount cannot be empty!";
                var toastEvent = this.getToastError("Error! ",vaildationFailReason1,"4000",'info_alt','error','dismissible');
        		toastEvent.fire();
            }
        
            else if (isNaN(newAccounts[i].Amount_Fullfillment__c)) {
                
                vaildationFailReason1 = "Please enter a numeric value for amount";
                
            var toastEvent = this.getToastError("Error! ",vaildationFailReason1,"4000",'info_alt','error','dismissible');
        		toastEvent.fire();
            
            }
            else if (isNaN(newAccounts[i].Target_Account__c)) {
                
                vaildationFailReason1 = "Please enter a numeric value for target account";
                
            var toastEvent = this.getToastError("Error! ",vaildationFailReason1,"4000",'info_alt','error','dismissible');
        		toastEvent.fire();
            }
            else if (isNaN(newAccounts[i].Target_Clearance_Code__c)) {
                
                vaildationFailReason1 = "Please enter a numeric value for target clearance code";
                var toastEvent = this.getToastError("Error! ",vaildationFailReason1,"4000",'info_alt','error','dismissible');
        		toastEvent.fire();
            }
            else{
            this.handleSaveAndValidate(component,event,helper); 
            
            }
            
        }
        
    },
})