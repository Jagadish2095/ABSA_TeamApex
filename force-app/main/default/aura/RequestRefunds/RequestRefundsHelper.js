({
        fireToastEvent: function(title, msg, type) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: title,
                message: msg,
                type: type
            });
            toastEvent.fire();
        },

    checkRefund : function(component, event){
                var action = component.get("c.getClientRefundRequest");
                // Set the parameters
                action.setParams({
                    caseId: component.get("v.caseIdFromFlow")
                })
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log(response.getReturnValue())
                    if (state === "SUCCESS") {
                      component.set("v.refund30Days", 'Yes')
                       component.set("v.refundObject", response.getReturnValue());
               } else if (state === "ERROR") {
             component.set("v.refund30Days", 'No')
          }
           component.set("v.showSpinner", false);
       });
       $A.enqueueAction(action);
    },
      checkIfCustomerIsOnPTP : function(component, event){
               if(component.get("v.customerOnPTP")===false){
                    this.fireToastEvent("Success", 'Please note that the selected product does NOT have a Promise-To-Pay', "Success");
               }
               if(component.get("v.refund30Days")==='Yes'){
                    this.fireToastEvent("Success", 'Please not the that the customer was refunded in the last 30 days', "Success");
               }
               if(component.get("v.refund30Days")==='Yes' && component.get("v.customerOnPTP")==='Yes'){
                    this.fireToastEvent("Success", 'Please note that this account has already been refunded in the last 30 days and has no Promise-to Pay Agreement', "Success");
               }
    },
})