({
    doInit: function (component, event, helper) {
        var conItem = component.get("v.conItem");

        if (conItem) {
            helper.getClientConductDetails(component, conItem);
        }
    }
})