({

    //Load reasons to select for replacement card
    reasonToCancel : function(component) {
        var opts = [];
        opts.push({ class: "optionClass",label: "Dissatisfied with electronic banking",value: "Dissatisfied with electronic banking" });
        opts.push({class: "optionClass",label: "Dissatisfied with service at the branch", value: "Dissatisfied with service at the branch" });
        opts.push({class: "optionClass",label: "Service too expensive",value: "Service too expensive"});
        opts.push({class: "optionClass",label: "Service no longer required",value: "Service no longer required"});
        opts.push({class: "optionClass",label: "Other",value: "Other"});
        component.set("v.reasonsList" , opts);
        console.log('opts type: ' + opts); 
    },
    
    // method to cancel electronic banking
    submitYes : function(component) { 
               
        var action = component.get("c.cancelService"); 
        action.setParams({
            accessAccount : component.get("v.selectedAccountNumber"),
            cancellationReason : component.get("v.selectedReasons"), 
            cancellationDesc : component.get("v.description"),
            replacedByTelBankin: component.get("v.telephoneBanking"),
            replacedByAtm : component.get("v.atm"),
            replacedByMobile : component.get("v.mobile"),
            replacedByVendor : component.get("v.storeVender"),
            replacedByDebitOrde : component.get("v.debitOrder"),
            replacedByPicknpay : component.get("v.pickPay"),
            replacedByNothing : component.get("v.none"),
        });
        
        
        console.log('acc: ' + component.get("v.selectedAccountNumber"));
        console.log('selectedReasons: ' + component.get("v.selectedReasons"));
        console.log('description: ' + component.get("v.description"));
        console.log('telephoneBanking: ' + component.get("v.telephoneBanking"));
        console.log('atm: ' + component.get("v.atm"));
        console.log('mobile: ' + component.get("v.mobile"));
        console.log('storeVender: ' + component.get("v.storeVender"));
        console.log('debitOrder: ' + component.get("v.debitOrder"));
        console.log('pickPay: ' + component.get("v.pickPay"));
        console.log('none: ' + component.get("v.none"));
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if( results == 'SUCCESSFUL PROCESS'){
                    var msgString='';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "message": results,
                        "type":"Success"
                    });
                    toastEvent.fire();
                    console.log('results: ' + results);
                    var submitYesButton = component.find("submitYesButton");
                    submitYesButton.set("v.disabled", true);
                    component.set("v.showPaymentStatusSuccess",true);
                    component.set("v.showPaymentStatusError",false);
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message":'Unsuccessful: '+ results ,
                        "type":"Error"
                    });
                    toastEvent.fire();
                    var submitNoButton = component.find("submitNoButton");
                    submitNoButton.set("v.disabled", false);
                    component.set("v.showPaymentStatusError",true);
                    component.set("v.showPaymentStatusErrorMsg", results);             
                    
                }
                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    

})