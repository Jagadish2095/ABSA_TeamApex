({
    sendAvafPaidUp: function (component, event, helper) {
        if (helper.allFieldsValid(component)) {
            helper.sendAvafPaidUpHelper(component, event, helper);
        }
    }
});