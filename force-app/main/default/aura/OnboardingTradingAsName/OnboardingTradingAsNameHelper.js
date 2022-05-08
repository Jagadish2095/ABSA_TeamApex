({
	getTradingAsNames : function(component, event, helper) {
        
        var parentValue = event.getParam('arguments');
        var accountRecId = component.get("v.accRecId");
        if (parentValue) {
            var accountRecId = parentValue.accId;
            component.set("v.accRecId",accountRecId);
        }
		        
        console.log('++++accountRecId+++++'+accountRecId);
        
        var getTradingNameAction = component.get("c.getTradingAsNameRecords"); 
        getTradingNameAction.setParams({
            accRecId : accountRecId
        });
        
        // Add callback behavior for when response is received
        getTradingNameAction.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var addList = response.getReturnValue();
                component.set("v.tradingAsNamesList",addList); 
               
            }
        });     
        $A.enqueueAction(getTradingNameAction);
    },
    

    handleSaveEdition:function(component, event, helper) {
        component.set("v.tradingAsNamesList",[]); 
         component.set('v.columns', []);
        
        var draftValues = event.getParam('draftValues');
        console.log(draftValues);
        
        var updateTradingAsNameAction = component.get("c.updateTradingAsNameRecords");
        updateTradingAsNameAction.setParams({
            "tradingAsNameRecords" : draftValues,
            "accId" : component.get("v.accRecId")
            });
        updateTradingAsNameAction.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var toastEvent = this.getToast("Success!", 'Trading as Name has been Successfully Refreshed.', "success");
                toastEvent.fire();
            }
            else {
                var toastEvent = this.getToast("Error!", 'An error occured while updating Trading as Name, please try again.', "error");
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(updateTradingAsNameAction);       
    },    
    
   deleteTradingAsName: function (component, event, helper) {
       
        var action = component.get("c.deleteTradingAsName");
        action.setParams({
            "tradingAsNameId": component.get("v.tradingAsNameDeleteId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                
                if(responseValue == true) {
                    this.getTradingAsNames(component, event, helper);
                    var toastEvent = this.getToast("Success!", 'Trading as Name has been Deleted.', "success");
                    toastEvent.fire();
                } else {
                    var toastEvent = this.getToast("Error!", 'An error occured while deleting Trading as Name, please try again.', "error");
                	toastEvent.fire();
                }
                               
            }
            else {
                var toastEvent = this.getToast("Error!", state, "error");
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
     upsertTradingAsName: function (component, event, helper, isNewIdentifier) {
        this.showSpinner(component);
         
        var newTradingNameRecord = component.get("v.tradingNameRecord");
            
        //Calling the Apex Function to create Contact
        var createTradingNameAction = component.get("c.createNewTradingAsName");
    
         if(isNewIdentifier == true) {
             //Setting the Apex Parameter
             createTradingNameAction.setParams({
                 "tradingAsNameNew" : newTradingNameRecord,
                 "accId" : component.get("v.accRecId")
             });
         } else {
              //Setting the Apex Parameter
             createTradingNameAction.setParams({
                 "tradingAsNameUpdate" : newTradingNameRecord,
                 "accId" : component.get("v.accRecId")
             });
         }
        
    
        //Setting the Callback
        createTradingNameAction.setCallback(this, function(response) {
          var stateCase = response.getState();
          if (stateCase === "SUCCESS") {
            var addressList = response.getReturnValue();
            component.set("v.tradingAsNamesList",addressList);
            
            component.set("v.showNewTradingNameModal", false);
              component.set("v.tradingAsNameEditId", null);
              component.set("v.tradingNameRecId", null);
            var toastEvent = this.getToast("Success!", 'Trading as Name successfully updated', "Success");
            toastEvent.fire();
              
          } else if (stateCase === "ERROR") {
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
            } else {
              message += (message.length > 0 ? "\n" : "") + "Unknown error";
            }
    
            // show Error message
            var toastEvent = this.getToast("Error!", message, "Error");
            toastEvent.fire();

          }
            
            this.hideSpinner(component);
        });
    
        //adds the server-side action to the queue
        $A.enqueueAction(createTradingNameAction);
    },
    
    getSelectedTradingAsNameDetails: function (component, event, helper) {

        //Calling the Apex Function to create Contact
        var getTradingNameAction = component.get("c.getSelectedTradingAsNameRecord");
    
        //Setting the Apex Parameter
        getTradingNameAction.setParams({
          "tradingAsNameId" : component.get("v.tradingAsNameEditId")
        });
    
        //Setting the Callback
        getTradingNameAction.setCallback(this, function(response) {
          var stateCase = response.getState();
            if (stateCase === "SUCCESS") {
                var tradingNameRecord = response.getReturnValue();
                component.set("v.tradingNameRecord",tradingNameRecord);
                component.set("v.tradingNameRecId",component.get("v.tradingAsNameEditId"));
                
            } else if (stateCase === "ERROR") {
                
                //TO DO : Toastie fro error
          }
        });
    
        //adds the server-side action to the queue
        $A.enqueueAction(getTradingNameAction);
    },
                             
     //Function to show toast for Errors/Warning/Success
      getToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
    
        toastEvent.setParams({
          title: title,
          message: msg,
          type: type
        });
    
        return toastEvent;
      },
    
    //Function to show spinner when loading
    showSpinner: function(component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function(component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})