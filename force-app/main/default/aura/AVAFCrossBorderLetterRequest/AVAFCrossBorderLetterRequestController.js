({
    /****************@ Author: Chandra*************************************
     ****************@ Date: 17/11/2020************************************
     ****************@ Work Id: W-006962***********************************
     ***@ Description: Method Added by chandra to send cross border letter*/

    handleSendCrossBorderLetter: function (component, event, helper) {
        helper.callSendCrossBorderLetter(component, event, helper);
    },

    /****************@ Author: Chandra*************************************
     ****************@ Date: 17/11/2020************************************
     ****************@ Work Id: W-006962***********************************
     ***@ Description: Method Added by chandra to handle record update*****/

    recordUpdate: function (component, event, helper) {
        var record = component.get("v.currentAccount");
        component.set("v.idNumber", record.ID_Number__pc);
        component.set("v.name", record.FirstName);
        component.set("v.surName", record.LastName);
        component.set("v.emailAddress", record.PersonEmail);
    },

    /****************@ Author: Chandra****************************************
     ****************@ Date: 17/11/2020***************************************
     ****************@ Work Id: W-006962**************************************
     ***@ Description: Method Added by chandra to handle input validation******/

    handleInputValidation: function (component, event, helper) {
        var accountNumber = component.get("v.SelectedAccNumberFromFlow");
        var emailAddress = component.get("v.emailAddress");
        var idNumber = component.get("v.idNumber");
        var name = component.get("v.name");
        var surName = component.get("v.surName");
        var driverName = component.get("v.driverName");
        var driverId = component.get("v.driverId");
        var travelStartDate = component.get("v.travelStartDate");
        var travelEndDate = component.get("v.travelEndDate");
        
        if (accountNumber && emailAddress && idNumber && name && surName && driverName && driverId && travelStartDate && travelEndDate) {
            component.set("v.isShowSendButton", true);
            component.set("v.isShowValidateButton", false);
            component.set("v.errorMessage", "");
        } else {
            component.set("v.isShowSendButton", false);
            component.set("v.isShowValidateButton", true);
            component.set("v.errorMessage", "Required to fill all mandatory fields.");
        }
    }
});