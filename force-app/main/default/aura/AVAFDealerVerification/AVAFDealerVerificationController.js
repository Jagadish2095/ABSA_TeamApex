({
    handleSearch : function(component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.showDetails",true);
        helper.getDealerInfo(component, event, helper);
    },
    
    handleChange : function(component, event, helper) {
        var changeValue = event.getParam("value");
        
        if (changeValue === 'false') {
            component.set("v.isShowReason", true);
            component.set("v.closeCase", true);
             component.set("v.showNextButton", false);
           
            
        } else if (changeValue === 'true'){
            component.set("v.closeCase", false);
            component.set("v.isShowReason", false);
            component.set("v.showNextButton", true);
          
        }
    },
    
    closeCase : function(component, event, helper) {
        helper.saveReasonandCloseCase(component, event, helper);
        
    },
    
    onNext : function(component, event, helper) {
            var navigate = component.get('v.navigateFlow');
            navigate("NEXT");
    },
    
    onPrevious : function(component, event, helper) {
            var navigate = component.get('v.navigateFlow');
            navigate("BACK");
    },
    
    refreshView: function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
    }
    
})