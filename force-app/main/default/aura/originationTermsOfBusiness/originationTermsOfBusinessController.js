({
    doInit : function(component, event, helper) {
        
        helper.getSelProduct(component, event);
       
        
        
    },
    
    loadTOBAgain  : function(component, event, helper) {
        component.set("v.showSpinner",true);  
        
        /*setTimeout(
            $A.getCallback(function () {
                //helper.getTOB(component,event);
            }),
            7000
        );*/
        
    },
    showDecision : function(component, event, helper) {
        
        var buttonlabel = event.getSource().get("v.label");
        
        console.log("buttonlabel---"+buttonlabel);
        if(buttonlabel == 'Decline'){
            component.set('v.showDecline',true);
            component.set('v.showApprove',false);
        }else if(buttonlabel == 'Approved'){
            component.set('v.showApprove',true);
            component.set('v.showDecline',false);
        }
    } ,
    
    handleSuccess : function(component, event, helper){
        component.find('notifLib').showToast({
            "title": "Decision Saved!",
            "message": "Decision has been saved successfully.",
            "variant": "success"
        });
    },
    
    saveAll : function(component, event, helper){
        
        component.find('tobEdit').forEach(form=>{form.submit();
                                                 
                                                });
                                                 
                                                 component.find('notifLib').showToast({
                                                 "title": "Adjustment Saved!",
                                                 "message": "Adjustment has been saved successfully.",
                                                 "variant": "success"
                                                });                                  
    },
})