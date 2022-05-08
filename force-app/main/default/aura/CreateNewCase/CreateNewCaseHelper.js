({
    fetchPicklistValues: function(component,event,helper) {
            // call the server side function            
            var action = component.get("c.getSubject");           
            //set callback
            action.setCallback(this, function(response) {
                if (response.getState() == "SUCCESS") {
                    //store the return response from server (map<string,List<string>>)
                    var StoreResponse = response.getReturnValue();
                    var ControllerField = []; // to store picklist value to set on lightning:select.
                    for (var i = 0; i < StoreResponse.length; i++) {
                        ControllerField.push(StoreResponse[i]);
                    }
                    // set the ControllerField variable values to country(controller picklist field)
                    component.set("v.listSubject", ControllerField);
                }else{
                    console.log('Something went wrong..'+JSON.stringify(response.getError()));
                }
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