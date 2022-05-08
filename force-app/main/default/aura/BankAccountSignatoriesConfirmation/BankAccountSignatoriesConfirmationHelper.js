({
        doInit : function(component, event){
          // this.showSpinner(component);   
            
            var action = component.get("c.getInstruction");
            var clientAccountNumber = component.get("v.selectedAccountNumberToFlow");
            var accId=component.get("v.clientAccountIdFromFlow");
            console.log('clientAccountNUmber from Flow recieved: '+ clientAccountNumber);
            console.log('accId from Flow recieved: '+ accId);
            action.setParams({accountId: accId ,accNo:clientAccountNumber});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('-----SUCCESS  getInstruction-----');
                    var respObj = JSON.parse(response.getReturnValue());
                        
                    if(respObj !=null ){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "SUCCESS",
                            "message": "Signatories Confirmation Fetched",
                            "type":"SUCCESS"
                        });
                        toastEvent.fire();
                        console.log('--------getSignatories-------'+ JSON.stringify(respObj.cip082do.outputTable));
                        component.set("v.noofSignatories",respObj.cip082do.nbrSignRetrieved);
                        component.set("v.transactionData",respObj.cip082do.outputTable);
                    }else{
                        console.log('-----getInstructionResponse-----'+JSON.stringify(respObj.cip082do.outputTable) );
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "ERROR",
                            "message": "No Signatories Confirmation Fetched",
                            "type":"ERROR"
                        });
                        toastEvent.fire();
                                              
                    }
                }
                
               // this.hideSpinner(component);
            });
            $A.enqueueAction(action);
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