({
	initialPage : function(component, event, helper) {
        var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
            window.history.back();
            return false;
    },
    
    getToast : function(title, msg, type) {
        
        $A.get('e.force:refreshView').fire();
        location.reload()
		 /*var toastEvent = $A.get("e.force:showToast");
        
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
         });
        $A.get('e.force:refreshView').fire();
        location.reload();
        return toastEvent;*/
	},
    
        caseCurrentCaseHelper : function(component, event, helper){
        var action = component.get("c.caseClose");
        action.setParams({caseId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var caseResponse = response.getReturnValue();
                debugger;
                if(caseResponse.isSuccess == 'true'){
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Case successfully closed!",
                        "type":"success"
                    });
                    
                    $A.get('e.force:refreshView').fire();
                }else{
                     toastEvent.setParams({
                        "title": "Error!",
                        "message": caseResponse.errorMessage,
                        "type":"error"
                    });  
                }
                
            }else if(state === "ERROR"){
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
            } 
            
            toastEvent.fire();
        });
        
        $A.enqueueAction(action);
        
    }
})