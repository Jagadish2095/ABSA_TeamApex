/**
* @author  Chenna
* @version v1.0
* @since   2020-09-11
**/

({
    
    inlineEditName : function(component,event,helper){   
        component.set("v.nameEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId").focus();
        }, 100);
    },
    
    closeNameBoxandSave : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
        component.set("v.nameEditMode", false); 
        var action = component.get("c.saveCurrentRec");
        action.setParams({
            'contentVsnObj': component.get("v.singleRec")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.singleRec", storeResponse);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Info Message',
                    message: 'Document has been Saved Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})