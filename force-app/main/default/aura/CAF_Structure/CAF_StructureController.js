({
    handleComponentEvent: function (component, event, helper) {
        var selectedBankNameFromChildEvent = event.getParam("recordByEvent");
        component.set("v.selectedBankName", selectedBankNameFromChildEvent);
    }
});