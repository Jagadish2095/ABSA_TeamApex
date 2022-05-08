({
    doInit:function(component, event, helper)
    {
        var action = component.get("c.checkSatgeAsNew");
        action.setParams({
            "CaseId": component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result =='TRUE'){
                    component.set('v.chkCase', 'TRUE');
                }else{
                     component.set('v.chkCase', 'FALE');
                }
            }else if(state === "ERROR"){
                console.log('in error');
            }
            
            
        });
        $A.enqueueAction(action);
    }
})