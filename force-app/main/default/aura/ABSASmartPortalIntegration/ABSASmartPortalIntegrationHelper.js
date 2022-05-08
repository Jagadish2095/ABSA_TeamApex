({
// Function that calls ASP over local host
    ASPRequest: function(component, helper){
        return new Promise(function(resolve, reject){
        var toastEvent = $A.get("e.force:showToast");       
        var requestJSON = component.get('v.RequestJSON');                 
        const xhr = new XMLHttpRequest();
        const url = "https://localhost";
        xhr.open('POST', url+":443", true);
        xhr.onload = function() {
            if(this.status === 200) {
                toastEvent.setParams({
                    "title": "ABSA Smart Portal",
                    "message": "Request Reached ASP",
                    "type":"success"
                });
                toastEvent.fire();   
            }
         };            
        xhr.send(requestJSON);
        resolve("xhr.send");
        })
	 },
    
    callApexMethod : function (component,helper){
        var action = component.get("c.getDeviceRefreshStatusUpdate");      
        action.setParams({ 
               'requestId' : component.get('v.RequestId')              
            });
        action.setCallback(this, function(response) {
          	var retVal = response.getReturnValue();
            component.set("v.Status",retVal); 
            console.log('Status : '+ retVal);
            if(retVal === 'COMPLETED'){           
                helper.handleResponse(response, component, helper);
               }
            else if(retVal === 'EXPIRED')
            {
                  component.set("v.IsPolling","false"); 
            }else 
            {
               // setTimeout(function () {
                    helper.callApexMethod(component,helper);
               // }, 5000); 
            }
        });
        $A.enqueueAction(action);      
    },
    
    handleResponse : function (response, component, helper){
        var action = component.get("c.getDeviceResponseMetadata");       
        action.setParams({               
               'requestId' : component.get('v.RequestId')              
            });
        action.setCallback(this, function(response) {
          	var ResponseMetadata = response.getReturnValue();            
            console.log('Record values :' +ResponseMetadata);
            
            var cmpEvent = component.getEvent("deviceRequestEvent");            
            if (ResponseMetadata)
            {                                             
                cmpEvent.setParams({'status' : 'COMPLETED', 'responseMetadata': ResponseMetadata});
                cmpEvent.fire();   
            } else {
                console.error('Error on getting deviceRequestEvent');
                cmpEvent.setParams({"status" : "EXPIRED"});
            }     
        });
        $A.enqueueAction(action);
    },   
    
    CheckIfResponseCompeteStatus : function (component,event, helper){
        var action = component.get("c.CheckIfResponseCompeteStatus");      
        action.setParams({
               'requestId' : component.get('v.RequestId')              
            });
            action.setCallback(this, function(response){
            helper.callApexMethod(component,helper); 
        });
        $A.enqueueAction(action);         
    },
})