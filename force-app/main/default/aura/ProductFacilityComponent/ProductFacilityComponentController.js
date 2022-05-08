({
    doInit: function(component, event, helper) {
        helper.handleDoInit(component);
    },
    onRadioChange: function(component, event, helper) {
        var value = event.getParam("value");
        var name = event.getParam("name");
        var facilityWrapObj = component.get("v.facilityWrap");
        if (name == 'Signed') {
            facilityWrapObj.signed = value;
        }
        component.set("v.facilityWrap", facilityWrapObj);
    },
    onDateChange: function(component, event, helper) {
        var value = event.getParam("value");
        var name = event.getParam("name");
        var facilityWrapObj = component.get("v.facilityWrap");
        if (name == 'Date') {
            facilityWrapObj.signedDate = value;
        }
        component.set("v.facilityWrap", facilityWrapObj);
    },
    addressChange: function(component, event, helper) {
        var value = event.getParam("value");
        var name = event.getParam("name");
        var facilityWrapObj = component.get("v.facilityWrap");
        if (name == 'Addressee') {
            facilityWrapObj.Addressee = value;
        } else if (name == 'AddresseeOther') {
            facilityWrapObj.AddresseeOther = value;
        } else if (name == 'AddresseeTitle') {
            facilityWrapObj.Addresseetitle = value;
        }
        component.set("v.facilityWrap", facilityWrapObj);
    },
    saveFacility: function(component, event, helper) {
        var facility = component.get("v.facilityWrap");
        console.log("save facility---" + JSON.stringify(facility));
        var action = component.get("c.saveApplicationFacilityWrap");
        action.setParams({
            "facilityWrap": JSON.stringify(facility),
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('results quote generation---' + state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---' + JSON.stringify(results));
                //component.set("v.quoteWrap",results);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Quote Data Saved Successfully"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})