({
    doInit: function (component, event, helper) {
        helper.doInit(component, event, helper);
    },

    addSourceOfFunds: function (component, event, helper) {
        helper.addRecord(component, event, helper);
    },

    removeRow: function (component, event, helper) {
        var sourceOfFundsList = component.get("v.applicationProduct.sourceOfFundsList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        sourceOfFundsList.splice(index, 1);
        component.set("v.applicationProduct.sourceOfFundsList", sourceOfFundsList);
    },

    save: function (component, event, helper) {
        var allValid = component.find('reqField').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            helper.save(component, event, helper);
        }

    }
})