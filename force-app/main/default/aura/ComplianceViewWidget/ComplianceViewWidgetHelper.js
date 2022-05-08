({
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        var objectId = component.get("v.recordId");
        var action = component.get("c.getData");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.message == null){
                    component.set("v.healthStatus", data.complianceStatus);
                    //component.set("v.lastRefreshDate", data.lastRefreshDate);
                    component.set("v.nextRefreshDate", data.nextRefreshDate);
                    // Updating the last refresh date as a part of home loans fix
                    component.set("v.FICAAddressAttestedDate", data.FICAAddressAttestedDate);
                    component.set("v.IdentificationAttestedDate", data.IdentificationAttestedDate);
                    //Added for Home Loans --Start
                    if(data.serviceGroup === true){
                        
                        var compEvent = component.getEvent("setComplianceStatus");
                        if(data.complianceStatus !=null && data.complianceStatus !=''){
                        compEvent.setParams({
                            "complianceStatus" : data.complianceStatus 
                        });
                        compEvent.fire();
                        }
                        
                        if(Date.parse(data.FICAAddressAttestedDate)>=Date.parse(data.IdentificationAttestedDate)){
                            component.set("v.lastRefreshDate", data.IdentificationAttestedDate);
                        }else{
                            component.set("v.lastRefreshDate", data.FICAAddressAttestedDate);
                        }
                            //Added for Home Loans --Start
                    }else{
                        component.set("v.lastRefreshDate", data.lastRefreshDate);
                    }
                }else if(data != null && data.message != null){
                    component.set("v.dataFound", false);
                    var errors = data.message;
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors);
                }else{
                    component.set("v.dataFound", false);
                    var errors = 'There is no data found for this Account';
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors);
                }
            }else { //Made changes to display appropriate error messages for non 200 status
                console.log("Failed with state: " + state);
                component.set("v.dataFound", false);
                //var errors = 'There is no data found for this Account';
                component.set("v.showError",true);
                var errors = response.getError();
                component.set("v.errorMessage",errors[0].message);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    helperMethod : function() {

    }
})