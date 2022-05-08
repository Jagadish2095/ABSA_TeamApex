({
	saveDetails : function(component, event, helper) {
        var asst = component.get("v.selectedLookUpRecord").Name;
        console.log("The selected!!!!!!!!!!!!!!!!!" +asst );
		component.find("asset").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                component.set("v.recordSaveError","User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") { 
                var errMsg = "";
                // saveResult.error is an array of errors, 
                // so collect all errors into one message
                for (var i = 0; i < saveResult.error.length; i++) {
                    errMsg += saveResult.error[i].message + "\n";
                }
                component.set("v.recordSaveError", errMsg);
                
            } else {
                component.set("v.recordSaveError",'Unknown problem, state: ' + saveResult.state + ', error: ' + 
			      JSON.stringify(saveResult.error));
            }
        }));
	},
    recordUpdated : function(component, event, helper){
        var changeType = event.getParams().changeType;
		if (changeType === "CHANGED") {
            component.find("asset").reloadRecord();
        }
    },
      	getAppId : function(component, event, helper) {
        var oppId = component.get("v.recordId");
         console.log("OppId###" + oppId);
        var action = component.get("c.ApplicationId");
      
        action.setParams({
            'oppId': oppId
        }); 
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log("State-" +state);
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log("resultData#### " +JSON.stringify(resultData));
                if(resultData != undefined && resultData != null && resultData !=''){
                }  
            }  
        });
       
        $A.enqueueAction(action);
    },
    
   
    
    //dynamic toast message alert function
   //It will take dynamic input parameters from controller methods
   //We used this for displaying error and success 
    showToast : function(title, message, error) {
        let toastParams = {
            title: title,
            message: message, // Error message
            type: error
        };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },
        showSelectedVehicle : function(component, event, helper) {
        
        var action = component.get("c.getSelectedVehicleDetails");
        action.setParams({
            'ApplicationId': component.get("v.appId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('retrunValue' + JSON.stringify(returnValue));
                if (returnValue != null) {
                    console.log("we are withing");
                    component.set("v.selectedLookUpRecord", returnValue);
                    
                   console.log("DONE");
                  
                }
            }
        });
        $A.enqueueAction(action);
    },

})