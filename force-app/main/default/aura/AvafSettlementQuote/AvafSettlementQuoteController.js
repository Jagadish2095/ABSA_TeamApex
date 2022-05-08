({
    sendAvafSettlement: function (component, event, helper) {
        if (helper.allFieldsValid(component)) {
            helper.sendAvafSettlementHelper(component, event, helper);
        }
    }
});