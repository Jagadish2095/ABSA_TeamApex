({
    handleSearch : function(component, event, helper) {
        component.set("v.errorMessage", null);
        component.set("v.showDetails",true);
        helper.getDealerInfo(component, event, helper);
    },
    
    handleChange : function(component, event, helper) {
        var changeValue = event.getParam("value");
        component.set("v.showNextButton", false);
        
        if (changeValue === 'false') {
            component.set("v.isShowReason", true);
            component.set("v.closeCase", true);
            component.set("v.showNextButton", false);
            component.set("v.showPrevious", false);
            
        } else if (changeValue === 'true'){
            component.set("v.closeCase", false);
            component.set("v.isShowReason", false);
            component.set("v.showNextButton", true);
            component.set("v.showPrevious", true);
        }
    },
    closeCase : function(component, event, helper) {
        helper.saveReasonandCloseCase(component, event, helper);
        
    },
    showCustomerandContractInfo : function(component, event, helper) {
        
        var indexvalue = component.get("v.index");
        indexvalue++;
        component.set("v.index",indexvalue);
        
        if(indexvalue == 1){
            helper.getContractInfo(component, event, helper);
            helper.getCustomerInfo(component, event, helper);
        }
        else if(component.find("vehicle").get("v.selectedLabel").includes('Select a value')){
            
              helper.fireToastEvent("Error", "Please verify vehicle", "error");
        }
        else{
            var navigate = component.get('v.navigateFlow');
            navigate("NEXT");
        }
    },
    
    onPrevious : function(component, event, helper) {
        var indexvalue = component.get("v.index");
        if(indexvalue == 0){
            var navigate = component.get('v.navigateFlow');
            navigate("BACK");
        }else {
            component.set("v.index",0);
            component.set("v.closeCustomerandContractInfo", true);
            component.set("v.closeDealerInfo", false);
            component.set("v.showSection", true);
            component.set("v.showPrevious", false);
            component.set("v.showNextButton", false);
            component.set("v.isDealerVerified",false);
        }
    },
    
    handleChangeCustomerConsent : function(component, event, helper) {
        
        var changeValue = event.getParam("value");
        component.set("v.showNextButton", false);
        
        if (changeValue === 'false2') {
            component.set("v.isShowReason", true);
            component.set("v.closeCase", true);
            component.set("v.showNextButton", false);
            component.set("v.showPrevious", false);
            
        } else if (changeValue === 'true2'){
            component.set("v.closeCase", false);
            component.set("v.isShowReason", false);
            component.set("v.showNextButton", true);
            component.set("v.showPrevious", true);
        }        
    },
    handleChangeDealerAuth : function(component, event, helper) {
        var changeValue = event.getParam("value");
        component.set("v.isDealerVerified",false);
        if (changeValue === 'false3') {
            component.set("v.closeCase", true);
            component.set("v.isShowReason", true);
            component.set("v.isDealerVerified",false);
        } else if (changeValue === 'true3'){
            component.set("v.isDealerVerified",true);
            component.set("v.closeCase", false);
            component.set("v.isShowReason", false);
        }    
    },
    
    refreshView: function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
    }
    
    
})