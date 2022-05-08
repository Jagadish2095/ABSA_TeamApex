({
    doInit : function(component, event, helper) {
            helper.getContractInfo(component, event, helper);
            helper.getCustomerInfo(component, event, helper);
    },
    
    onPrevious : function(component, event, helper) {
       
            var navigate = component.get('v.navigateFlow');
            navigate("BACK");
       
    },
    onNext : function(component, event, helper) {
       
           if(component.find("vehicle").get("v.selectedLabel").includes('Select a value')){
            
              helper.fireToastEvent("Error", "Please verify vehicle", "error");
        }
        else{
            var navigate = component.get('v.navigateFlow');
            navigate("NEXT");
        }
    },
    handleChangeDealerAuth : function(component, event, helper) {
        var changeValue = event.getParam("value");
        component.set("v.isDealerVerified",false);
        if (changeValue === 'false3') {
            component.set("v.closeCase", true);
            component.set("v.isShowReason", true);
            component.set("v.isDealerVerified",false);
             component.set("v.showNextButton", false);
        } else if (changeValue === 'true3'){
            component.set("v.isDealerVerified",true);
            component.set("v.closeCase", false);
            component.set("v.isShowReason", false);
        }    
    },
    
    handleChangeCustomerConsent : function(component, event, helper) {
        
        var changeValue = event.getParam("value");
        component.set("v.showNextButton", false);
        
        if (changeValue === 'false2') {
            component.set("v.isShowReason", true);
            component.set("v.closeCase", true);
            component.set("v.showNextButton", false);
           
            
        } else if (changeValue === 'true2'){
            component.set("v.closeCase", false);
            component.set("v.isShowReason", false);
            component.set("v.showNextButton", true);
           
        }        
    },
    
    closeCase : function(component, event, helper) {
        helper.saveReasonandCloseCase(component, event, helper);
        
    },
    
    refreshView: function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
    }
})