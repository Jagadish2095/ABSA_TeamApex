({
    doInit: function (component, event, helper) {
        helper.getAppId(component, event, helper);
        helper.showSelectedVehicle(component, event, helper);
        component.set("v.showVehicleSearch", false);
    },

    saveDetails: function (component, event, helper) {
        helper.saveDetails(component, event, helper);
    },

    saveVehicleRecord: function (component, event, helper) {
        var asst = component.get("v.selectedLookUpRecord").Id;
        var appId = component.get("v.appId");
        //set the default accountId is null
        // conObj.AccountId = null ;
        // check if selectedLookupRecord is not equal to undefined then set the accountId from
        // selected Lookup Object to Contact Object before passing this to Server side method
        if (asst == undefined) {
            helper.showToast("Something Wrong !", "Please select atleast one Vehiche Details", "error");
        } else {
            var vehicleName = component.get("v.selectedLookUpRecord").Name;

            //call apex class method
            var action = component.get("c.saveVehicleDetails");
            action.setParams({
                ApplicationId: appId,
                selectedVehicle: vehicleName
            });
            action.setCallback(this, function (response) {
                //store state of response
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.showToast("Success !", "Record Inserted Successfully", "success");
                    //$A.get("e.force:closeQuickAction").fire();
                    $A.get("e.force:refreshView").fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    assetTypeSelector: function (component, event, helper) {
        // component.set("v.applicationData",null);
        var assetType = component.get("v.Asset_Type__c");
        if (assetType == "Motor Vehicle" || assetType == "Light Duty Vehicle") {
            component.set("v.showVehicleSearch", true);
            component.set("v.showMotoBikeSize", false);
            component.set("v.Asset_Type__c", assetType);
            // component.set("v.applicationData",null);
        } else if (assetType == "Motorbikes") {
            component.set("v.showVehicleSearch", true);
        } else if (assetType == "Other") {
            // component.set("v.applicationData",null);
            component.set("v.showMotoBikeSize", false);
            component.set("v.Asset_Type__c", assetType);
            // component.set("v.applicationData",null);
        } else {
        }
    }
});