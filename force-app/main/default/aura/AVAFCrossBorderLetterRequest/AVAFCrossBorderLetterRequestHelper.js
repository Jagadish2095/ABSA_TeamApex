({
    /****************@ Author: Chandra**************************************
     ****************@ Date: 17/11/2020**************************************
     ****************@ Work Id: W-006962*************************************
     ***@ Description: Method Added by chandra for Lightning toastie********/

    fireToastEvent: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },

    /****************@ Author: Chandra**************************************
     ****************@ Date: 17/11/2020*************************************
     ****************@ Work Id: W-006962************************************
     ***@ Description: Method Added by chandra for hiding spinner***********/

    hideSpinner: function (component) {
        component.set("v.showSpinner", "false");
    },

    /****************@ Author: Chandra**************************************
     ****************@ Date: 17/11/2020*************************************
     ****************@ Work Id: W-006962************************************
     ***@ Description: Method Added by chandra for showing spinner**********/

    showSpinner: function (component, event, helper) {
        component.set("v.showSpinner", "true");
    },

    /****************@ Author: Chandra************************************************
     ****************@ Date: 17/11/2020***********************************************
     ****************@ Work Id: W-006962**********************************************
     ***@ Description: Method Added by chandra for sending Cross Border Letter********/

    callSendCrossBorderLetter: function (component, event, helper) {
        var travelStartDate = component.get("v.travelStartDate").replace(/-/g, "");
        var travelEndDate = component.get("v.travelEndDate").replace(/-/g, "");
        component.find("send").set("v.disabled", true);
        helper.showSpinner(component);

        var action = component.get("c.sendCrossBorderLetter");
        action.setParams({
            accountNumber: component.get("v.SelectedAccNumberFromFlow"),
            userEmail: component.get("v.emailAddress"),
            userIdNumber: component.get("v.idNumber"),
            userName: component.get("v.name"),
            userSurname: component.get("v.surName"),
            driverName: component.get("v.driverName"),
            driverIdNumber: component.get("v.driverId"),
            periodStart: travelStartDate,
            periodEnd: travelEndDate
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnResponse = response.getReturnValue();
                if (returnResponse.statusCode == "200" || returnResponse.statusCode == "202") {
                    helper.fireToastEvent("Success!", "Avaf Cross Border letter emailed successfully!", "success");
                    component.set("v.isCaseCloseShow", true);
                } else {
                    component.set("v.errorMessage", "Error Avaf Cross Border letter email. Service Response: " + JSON.stringify(returnResponse));
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in callSendCrossBorderLetter method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in callSendCrossBorderLetter method. State: " + state);
            }

            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    }
});