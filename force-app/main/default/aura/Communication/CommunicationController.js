({ 
    //Initialization method
    doInit: function(component, event, helper) {
        helper.getApplicationByOpportunity(component);
        helper.checkCommunicationPreferenceSet(component);
        helper.getEmailsList(component);
        helper.getPhonesList(component);
        helper.checkValidEmailPhone(component);
    },
    
    //onChange handler for all changeable markup
    onChange: function(component, event, helper) {
        switch (event.getSource().getLocalId()) {
            case "communicationPreferenceRadio":
                var communicationPreferenceType = event.getSource().get("v.value");
                switch (communicationPreferenceType) {
                    case "Email":
                        helper.checkValidEmailPhone(component);
        				helper.getEmailsList(component);
                        component.set("v.emailSelected", true);
                        component.set("v.smsSelected", false);
                        component.set("v.currentSMS", "");
                        component.set("v.showAltSMS", null);
                        component.set("v.altSMS", null);
                        break;
                    case  "SMS":
                        helper.checkValidEmailPhone(component);
        				helper.getPhonesList(component);
                        component.set("v.emailSelected", false);
                        component.set("v.smsSelected", true);
                        component.set("v.currentEmail", "");
                        component.set("v.showAltEmail", null);
                        component.set("v.altEmail", null);
                        break;
                }
                break;
            case "emailSelect":
                var altEmailCheckbox = component.find("altEmailCheckbox");
                if (event.getSource().get("v.value") == "") {
                    altEmailCheckbox.set("v.disabled", false);
                } else {
                    altEmailCheckbox.set("v.disabled", true);
                }
                break;
            case "smsSelect":
                var altSMSCheckbox = component.find("altSMSCheckbox");
                if (event.getSource().get("v.value") == "") {
                    altSMSCheckbox.set("v.disabled", false);
                } else {
                    altSMSCheckbox.set("v.disabled", true);
                }
                break;
            case "altEmailCheckbox":
                var emailSelect = component.find("emailSelect");
                if (event.getSource().get("v.value") == true) {
                    emailSelect.set("v.disabled", true);
                } else {
                    emailSelect.set("v.disabled", false);
                }
                break;
            case "altSMSCheckbox":
                var smsSelect = component.find("smsSelect");
                if (event.getSource().get("v.value") == true) {
                    smsSelect.set("v.disabled", true);
                } else {
                    smsSelect.set("v.disabled", false);
                }
                break;
        }
    },
    
    //Resets communication preference related attributes
    updateCommunicationPreference: function(component, event, helper) {
        component.set("v.communicationPreferenceSet", false);
        component.set("v.communicationPreferenceType", null);
        component.set("v.emailSelected", false);
        component.set("v.currentEmail", "");
        component.set("v.showAltEmail", null);
        component.set("v.altEmail", null);
        component.set("v.smsSelected", false);
        component.set("v.currentSMS", "");
        component.set("v.showAltSMS", "");
        component.set("v.altSMS", "");
        helper.getApplicationByOpportunity(component);
        helper.getEmailsList(component);
        helper.getPhonesList(component);
    },
    
    //Updates the opportunity record
    update: function(component, event, helper) {
        helper.updateApplication(component);
    },
    
    //Cancels current update action
    cancel: function(component, event, helper) {
        component.set("v.communicationPreferenceType", null);
        component.set("v.smsSelected", null);
        component.set("v.currentSMS", "");
        component.set("v.showAltSMS", null);
        component.set("v.altSMS", null);
        component.set("v.emailSelected", null);
        component.set("v.currentEmail", "");
        component.set("v.showAltEmail", null);
        component.set("v.altEmail", null);
        helper.checkCommunicationPreferenceSet(component);
    }
})