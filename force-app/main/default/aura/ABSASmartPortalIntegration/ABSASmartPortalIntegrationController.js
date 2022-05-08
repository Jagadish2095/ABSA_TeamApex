({    
    init: function(component, event, helper){
        component.CreateASPRequest(component, event, helper) 
      },
    
    RefreshPoll: function(component, event, helper){
        helper.CheckIfResponseCompeteStatus(component, event, helper);
      },

 	CreateASPRequest : function(component,event, helper){
        return new Promise(function(resolve, reject){
       	var toastEvent = $A.get("e.force:showToast");
        var deviceRequestAction = component.get("c.CreateRequest");    
        deviceRequestAction.setParams({
        customerID: component.get("v.CustomerId"), 
        deviceFunction: component.get("v.function"),
        requestMetadata: component.get("v.RequestJSONMetadate")
      });
        //call to create the device record     
        deviceRequestAction.setCallback(this, function(response){       
            var state = response.getState();            
            if (state === "SUCCESS") {             
                var requestJSON = response.getReturnValue();
                var JSONObject =JSON.parse(requestJSON);
                console.log('JSON Object:'+ requestJSON);
                component.set("v.RequestJSON", requestJSON);
                component.set('v.RequestId',JSONObject["Id"]);
                //ASP Call
				var polling = helper.ASPRequest(component, event, helper)
                .then(
                    // resolve handler
                       $A.getCallback(function(result) {
                        component.set("v.IsPolling","true");
                        helper.callApexMethod(component,helper);
                        console.log("resolve handleResponse result :"+result);                                          
                       }),
                       // reject handler
                       $A.getCallback(function(error) {
                           console.log("reject handleResponse result :"+error);
                           alert('Error');
                           //add error code
                       })
                   )                         
            }else{
                alert('Something went wrong');
            }  
         });
           $A.enqueueAction(deviceRequestAction);
         })
    },       
})