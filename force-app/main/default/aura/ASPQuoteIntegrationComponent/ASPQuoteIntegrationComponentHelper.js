({
    /**
    * @description function to show spinner.
    **/ 
        showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    /**
    * @description function to hide spinner.
    **/   
        hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
     
    /**
    * @ description function to do debi check PINPAD request 
    **/
    doXHRQuoteDisplayRequest: function(component, helper) 
        {    
            var toastEvent = $A.get("e.force:showToast");       
            var requestJSON = component.get('v.RequestJSON');                 
            const xhr = new XMLHttpRequest();
            const url = "http://localhost";
            
            xhr.open('POST', url+":3235", true);
            xhr.addEventListener('error', function(ex) {
                
                toastEvent.setParams({
                        "title": "Error!",
                         "message": "Error : "+ex,
                        "type":"error"
                    });
                toastEvent.fire(); 
                console.warn('Error: ', ex);
            });
    
            /*
            xhr.onerror = function (er) {  
                console.log("** An error occurred during the transaction:" + er);
              };
            */
            
            xhr.onload = function() {
                if(this.status === 200) {
                    const response = JSON.parse(this.responseText);
                    console.log(response);
                    
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": response,
                        "type":"success"
                    });
                    toastEvent.fire(); 
                }
             };            
            xhr.send(requestJSON);
            component.set("v.showSpinner", false);
        },
        
        pollApex : function(component, event, helper) {
            return new Promise(function(resolve, reject) {   
            helper.callApexMethod(component, helper);
            
            var pollId = window.setInterval(
                $A.getCallback(function() { 
                    helper.callApexMethod(component, helper, pollId);
                }), 5000
            );
                 if(pollId == null)
                 {
                     resolve("came out of polling loop");
                 }
          })           
        },
        
        callApexMethod : function (component, helper, pollId){    
            
            var action = component.get("c.getDeviceRefreshStatusUpdate");      
            action.setParams({
                   'requestId' : component.get('v.RequestId')              
                });
            action.setCallback(this, function(response) {
                console.log('refresh call :' + pollId);
                var retVal = response.getReturnValue();
                component.set("v.Status",retVal); 
                console.log('Status : '+ retVal);
                //logic to kill polling
                if(retVal === 'COMPLETED'){           
                    //This will kill the job            
                    console.log("Killing the job :" + pollId);
                    window.clearInterval(pollId);
                    
                   var promise = helper.handleResponse(response, component, helper)
                   .then(
                       // resolve handler
                          $A.getCallback(function(result) {
                              console.log("resolve handleResponse result :"+result);                                          
                          }),
                          // reject handler
                          $A.getCallback(function(error) {
                              console.log("reject handleResponse result :"+error);
                              alert('Error');
                              //add error code
                          })
                      )
                   }
                else if(retVal === 'EXPIRED')
                {
                    window.clearInterval(pollId);
                    alert('Session timed out. Retry again');
                }
            });
            $A.enqueueAction(action);      
        },
        
        handleResponse : function (response, component, helper){
             return new Promise(function(resolve, reject) {        
           
            var action = component.get("c.getDeviceResponseMetadata");       
            action.setParams({               
                   'requestId' : component.get('v.RequestId')              
                });
            action.setCallback(this, function(response) {
               // this.handleResponse(response, component, pollId);
                  var ResponseMetadata = response.getReturnValue() ;            
                console.log('Record values :' +ResponseMetadata);
                
                var cmpEvent = component.getEvent("deviceRequestEvent");            
                if (ResponseMetadata)
                {                
                    resolve('Continue');                               
                    cmpEvent.setParams({'status' : 'COMPLETED', 'responseMetadata': ResponseMetadata});
                   
                } else {               
                    reject('Failed');
                    cmpEvent.setParams({"status" : "EXPIRED"});
                }
                cmpEvent.fire();          
            });
            $A.enqueueAction(action);
           })
        }     
        
    })