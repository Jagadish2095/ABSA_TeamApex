({
    doInit : function(component, event, helper) {
        component.set('v.validate', function() 
        {
           helper.saveData(component, event);
        })
        
        helper.loadData(component,event);
                
        //helper.updateExpense(component,event);
		

    },

    updateExpenses : function(component, event, helper)
    {        
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