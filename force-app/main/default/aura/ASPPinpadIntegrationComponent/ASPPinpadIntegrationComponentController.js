({    
 	CreatePinPadRequest : function(component,event, helper){
         return new Promise(function(resolve, reject) { 
        component.set("v.showSpinner", true);
       	var toastEvent = $A.get("e.force:showToast");
         
        var deviceRequestAction = component.get("c.CreateRequest");                     
        
        deviceRequestAction.setParams({ customerID : component.get('v.CustomerId'),
                          deviceFunction :  "Pin Pad",
                          requestMetadata : component.get('v.metaDataRequestJSON')});                         
       
        //call to create the device record     
        deviceRequestAction.setCallback(this, function(response) {          
            var state = response.getState();            
            if (state === "SUCCESS") {             
                var requestJSON = response.getReturnValue();
                var JSONObject =JSON.parse(requestJSON);
                
                console.log('JSON Object:'+ requestJSON);
                component.set("v.RequestJSON", requestJSON);
                
                var requestId = JSONObject["Id"];
                component.set('v.RequestId',requestId);
                
                //Call to make the XHR call
				helper.doDebiCheckXHRPinPadRequest(component, event, helper);
                
                //Polling the request until it is complete
                 var pollingPromise = helper.pollApex(component, event, helper)
                 .then(
                     // resolve handler
                     $A.getCallback(function(result) {
                         
                     }),
                     $A.getCallback(function(error) {})
                 )                
            }
            else if (state === "INCOMPLETE") {
                // do something
                alert("failed");
            }
            else if (state === "ERROR") {
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
            
           component.set("v.hideSpinner", false); 
        });

        $A.enqueueAction(deviceRequestAction);
         })
    } ,
    
   
})