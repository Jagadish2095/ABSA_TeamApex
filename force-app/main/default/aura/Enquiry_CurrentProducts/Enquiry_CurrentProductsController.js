({
    doInit: function (component, event, helper) {
        helper.doBaseInit(component);
        helper.getClientAccountNumbers(component);
    },

    handleChequeAccountChange: function (component, event, helper) {
        let account = component.get('v.accountsNumbers').filter(function (e) {
            return e.value == event.getParam("value");
        })[0];

        component.set('v.accountType', account.accountType);
        helper.updateComponentData(component, helper);
    }
})