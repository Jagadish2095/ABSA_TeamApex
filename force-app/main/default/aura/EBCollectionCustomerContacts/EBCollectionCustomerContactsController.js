({
    getValueFromPicklist: function(component, event, helper) {
        console.log('Value' + component.find('picklist').get('v.value'));
    },
    getValueFromPicklistSMS: function(component, event, helper) {
        console.log('Value' + component.find('picklistSMS').get('v.value'));
        
    },
    closeCaseFunction: function(component, event, helper) {
        //close case
        component.find("statusField").set("v.value", "Closed");
        component.find("outOfSLA").set("v.value", "case closed");
        component.find("outOfSLAReason").set("v.value", "Turn-around Times/SLA");
        component.find("caseOutcome").set("v.value", component.get("v.valueCaseOutcome"));
       component.find("caseRecordEditForm").submit();
      // $A.get('e.force:refreshView').fire();
       window.location.reload();
    },
    createConsultantReminder: function(component, event, helper) {
        helper.createConsultantReminder(component, event, helper);
    },
    awaitingForResponse: function(component, event, helper) {
        helper.pauseAndAwaitResponse(component, event, helper);
    },
    getValueFromPicklistCaseOutcome: function(component, event, helper) {
        if(component.find('picklistCaseOutcome').get('v.value')){
            component.set("v.showNextButton", true);
        }
        
    },
    getDate: function(component, event, helper) {
        //console.log('Value' + component.find('getdate').get('v.getDate'))
        console.log(component.get("v.getDateFromCalendar"));
        component.set("v.createReminderButtonNext", true);
    },
    sendSMS: function(component, event, helper) {
        helper.handleSendSms(component, event);
    },
    handleCustomerContactMethod: function(component, event, helper) {
        var changeValue = event.getParam("value");
        if (changeValue === 'true') {
            component.set("v.showSelectNotificationNumber", false);
            component.set("v.showCaseOutcome", true);
            if(component.get("v.valueCaseOutcome") && component.get("v.getDateFromCalendar")){
                component.set("v.showNextButton", true);
            }
        } else {
            component.set("v.showNextButton", false);
            component.set("v.showCaseOutcome", false);
            component.set("v.showSelectNotificationNumber", true);
        }
    },
})