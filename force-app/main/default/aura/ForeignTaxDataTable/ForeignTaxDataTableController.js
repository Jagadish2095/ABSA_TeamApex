({
    doInit : function(component, event, helper) {
        helper.setupData(component);
    },

    dataChanged : function(component, event, helper) {
        helper.setupData(component);
    },

    addForeignTaxData : function(component, event, helper) {
        component.set("v.isLoading", true);
        helper.newTaxDocument(component);
    },

    removeForeignTaxData : function(component, event, helper) {
        component.set("v.isLoading", true);
        var rowIndex = event.getSource().get("v.value");
        helper.removeTaxDocument(component, rowIndex);
    },

    onInputChange : function(component, event, helper) {
        var field = event.getSource();
        var colValue = field.get("v.value");
        var colName = field.get("v.name");
        helper.updateTable(component, colName, colValue);
        helper.disableTaxData(component);
    },

    verityTaxData : function(component, event, helper) {
        return helper.verityTaxData(component);
    },
})