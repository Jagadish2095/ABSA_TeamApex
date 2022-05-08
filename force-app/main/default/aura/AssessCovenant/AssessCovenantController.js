({
    doInit : function(component, event, helper){
        helper.fetchAuditData(component);
         //helper.showSpinner(component);
    },
	Submit : function(component, event, helper) {
        helper.showSpinner(component);
        helper.fetchAuditData(component);
        console.log('AMC ID --->' + component.find("AreaManagerCoverage").get("v.value"));
        /*
        var action = component.get("c.getDocAuditHistoryEmail");
        
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data:' + data);
                //component.set("v.dataAuditList", data);
                console.log('Data 1-------->'+ component.get("v.dataAuditList").length);
                if(data.length > 0){
                    alert('Inside Response');
                    component.set("v.documentsUploaded", true);
                 }
                    
            }
            else {
                console.log("Failed with state: " + state);
            }
          
        });
           $A.enqueueAction(action);
        */
        helper.invokeProcess(component,helper);
	}
})