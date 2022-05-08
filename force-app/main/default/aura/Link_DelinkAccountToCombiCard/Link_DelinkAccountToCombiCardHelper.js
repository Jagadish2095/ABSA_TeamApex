({
    getAccountDetailsHelper: function(component, event, helper){
        var action = component.get("c.getAccountName");
        action.setParams({caseId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(! $A.util.isUndefinedOrNull(respObj)) {
                   
                    component.set("v.fullName", respObj);
                }
            }
        });
        $A.enqueueAction(action);
    },
    linkDelinkUpdateHelper: function(component, event, helper){
        var action = component.get("c.linkDelinkUpdateCall");
        var selectedRows = component.get("v.selectedRows");
        var accountList =[];
        for(var key in selectedRows){
            accountList.push(selectedRows[key].accountNumber); 
        }
       
        action.setParams({caseId:component.get("v.recordId"),
                          actionItem:component.get("v.actionItem"),
                          accountList : accountList,
                          cbNumber :  component.get("v.selectedCBCard")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                if(respObj.isSuccess == 'true') {
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": respObj.successMessage
                    }); 
                }else{
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": respObj.errorMessage
                    });   
                }                
                toastEvent.fire();
                                
                if(component.get("v.actionItem") == 'DeLink'){
                var warningToastEvent = $A.get("e.force:showToast");
                    warningToastEvent.setParams({
                        "title": "WARNING!",
                        "type":"warning",
                        "message":"Internet / Banktel Services will also be closed, cancel to stop transaction"
                    });   
                warningToastEvent.fire();
                    
                }
            }
            
        component.set('v.isModalShow',false);
        });
        $A.enqueueAction(action);
    },
})