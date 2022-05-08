({    
     getSTIRecordType : function (component)
    {
         var action = component.get("c.getSTIRecordTypeId");
          action.setCallback(this, function(response){
             
                        var state = response.getState();
                        if (state === "SUCCESS") {
                             console.log('Inside success'+response.getReturnValue());
                            var result = response.getReturnValue();
                            component.set("v.recordTypeSTI", result);
                        }
              else if (state === "ERROR") {
                  console.log('Inside error');
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
    createLead : function (component)
    {
        component.set("v.showSpinner", true);
        
        var action = component.get("c.createReferredLead");
        action.setParams({
            "salesLead": component.get("v.referralLead"),
            "opportunityId": component.get("v.recordId"),
            "campaignName": component.get("v.selectedcampaign")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var lead = response.getReturnValue();
                if(lead != null)
                {
                    
                    this.showToast("success", "Success", "Lead Creation was Successful!!");
                    //window.location.reload();
                    
                    /*
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": lead.Id,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    */
                }
                else
                {
                    this.showToast("error", "Error", "Lead Creation Failed");
                }
            }
            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    showToast : function (type, title, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type
            });
            toastEvent.fire();
        } else {
            alert(message);
        }
    }
})