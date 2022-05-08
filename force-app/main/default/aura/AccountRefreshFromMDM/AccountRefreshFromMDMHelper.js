({
    showlastModifieddate : function(component) {
        var action = component.get("c.getAccount");
        action.setParams({
            "accountId": component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.account", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        
    },
    
    refreshdata :function(component){
        component.set("v.showSpinner", true);
        var action = component.get("c.UpdateAccountsFromMDM");
        action.setParams({
            "accountId": component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                if(resp == 'Success'){
                    
                    this.showlastModifieddate(component);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Account Successfully updated",
                        "type":"success" });
                    toastEvent.fire();
                    component.set("v.showSpinner", false);
                    $A.get('e.force:refreshView').fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Something Went Wrong while Updating the record",
                        "type":"Error!" });
                    toastEvent.fire();
                    component.set("v.showSpinner", false);
                    
                }
            }
        });
        $A.enqueueAction(action);
    },
})