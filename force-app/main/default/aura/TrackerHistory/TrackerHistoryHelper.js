({
    refreshTrackerHistoryHelp : function(component, event, helper) {
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.refreshTrackerHistoryRecords");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var Initresponse = response.getReturnValue();
            if (state === "SUCCESS") {
                
                if(Initresponse != 'No Asset'){
                    
                    var trackerResponse = JSON.parse(Initresponse);
                    console.log('trackerResponse'+trackerResponse);
                    component.set("v.showHistory",true);  
                    component.set("v.noHistory",false); 
                    var temp = [];
                    trackerResponse.forEach(function(record) {
                        if (record.trackerAction.length > 0 ) {
                            temp.push(record);
                        }
                    });
                    console.log('temp'+temp);
                    component.set("v.data", temp);
                    
                }
                else{
                   
                    component.set("v.noHistory",true);   
                    
                }
                
            } else if (state === "ERROR"){
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Submission Failed in Refresh Tracker History: " + response,
                    "type":"error"
                });
                toastEvent.fire();
                
            }
                $A.get('e.force:refreshView').fire();
        });
        
        $A.enqueueAction(action);
    }, 
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})