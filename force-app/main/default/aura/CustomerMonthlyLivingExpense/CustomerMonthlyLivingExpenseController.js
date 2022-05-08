({
    doInit : function(component, event, helper) {
        component.set('v.validate', function()
        {
            console.log("saveData");
            helper.saveData(component, event);
        })
        helper.loadData(component,event);
    },

    updateLivingExpenses : function(component, event, helper)
    {
        console.log("updateLivingExpenses");
        var v = component.get("v.readOnly");

        if (v == true)
        {
            component.set("v.readOnly", false);
        }
        else {
            helper.saveData(component, event);
            helper.loadData(component,event);
            component.set("v.readOnly", true);
        }
    }
})