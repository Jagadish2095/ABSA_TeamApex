({
	    doInit : function(component, event, helper) {
        
        var action = component.get("c.getCaseData");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                console.log("******Response Value*******" + responseValue);
                if(responseValue != null && responseValue.Id != null){
                    component.set("v.caseId", responseValue.Id);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getList : function(component, event, helper){
        var action = component.get("c.getCaseData");
        var recordId = component.get("v.recordId");
        //Set the parameters of function
        action.setParams({recordId : recordId});
        
        action.setCallback(this, function(a){
            if (a.getState() === 'SUCCESS') {
                var retObj = JSON.parse(a.getReturnValue());
                component.set("v.recordsList", retObj);
                //console.log(component.get("v.recordsList"));
            }
        });
        
        //Now enqueue action
        $A.enqueueAction(action);
    },
    
    
    
    getResponseList : function(component, event, helper){
        var action = component.get("c.getAllResponseRecords");
        var recordId = component.get("v.recordId");
        //Set the parameters of function
        action.setParams({recordId : recordId});
        
        action.setCallback(this, function(a){
            if (a.getState() === 'SUCCESS') {
                var retObj = JSON.parse(a.getReturnValue());
                component.set("v.responseList", retObj);
                //console.log(component.get("v.recordsList"));
            }
        });
        
        //Now enqueue action
        $A.enqueueAction(action);
    }
})