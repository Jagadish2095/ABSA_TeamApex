({
    
    doInit :function (component, event, helper) {
        helper.getAppPrdctCpfRec(component, event, helper);
        
        component.set("v.earlyTermFeeYear1" ,"3");
        component.set("v.earlyTermFeeYear2" ,"2");
        component.set("v.earlyTermFeeYear3" ,"1");
        // component.find("earlyTermFeeYr1").set("v.DefaultEarlyTeminationFee", newTask);
        helper.getopplineitemRec(component, event, helper);
        helper.getAppOtherFeesRec(component, event, helper);
        
    },
    
    showHiddenFields :function(component, event, helper) {
        
        var adminFeeVal = component.find("adminFee").get("v.value");
        var valuationFeeVal = component.find("valFee").get("v.value");
        var earlyTermFeeVal = component.find("earlyTermFee").get("v.value");
        var prepaymentFeeVal = component.get("PrePaymentFee");
        
        if(adminFeeVal== "Yes" ){
            component.set("v.showAdminFee", true);
        }   
        else if(adminFeeVal == "No" ){
            component.set("v.showAdminFee", false);
        }
        if(valuationFeeVal== "Yes" ){
            component.set("v.showAValuationAmt", true);
        }   
        else if(valuationFeeVal == "No" ){
            component.set("v.showAValuationAmt", false);
        }
        
        if(earlyTermFeeVal== "Yes" ){
            component.set("v.showEarlyTermFields", true);
            component.set("earlyTermFee", "3");
        }   
        else if(earlyTermFeeVal == "No" ){
            component.set("v.showEarlyTermFields", false);
        }
        
        if( prepaymentFeeVal== "Yes" ){
            component.set("v.showPrepaymentFields", true);
        }   
        else if( prepaymentFeeVal == "No" ){
            component.set("v.showPrepaymentFields", false);
        }
    },
    
    handleSaveError: function (component, event, helper) {
        component.find('iApplicationRecord').showToast({
            "title": "Something has gone wrong!",
            "message": event.getParam("message"),
            "variant": "error"
        });
    },
    
    handleSaveSuccess: function (component, event, helper) {
        //   var clientName = component.get("v.clientName")
        component.find('iApplicationRecord').showToast({
            "title": "Record saved!",
            "message": "record saved successfully.",
            "variant": "success"
        });
    },
    handleSubmit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.updateAppPrdctcpf(component, event, helper); 
    },
    
    addOtherfees : function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddOtherFees(component, event);
    },
   
    handleOtherfeesSubmit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var itemsToPass=component.get("v.newOtherfees");
        var checkStatus = false;  
        var item;        
        
        for (var i=0; i< itemsToPass.length; i++)
        {
            item = itemsToPass[i];
            if(item.Fees_description__c=='' || item.Fees_description__c==undefined
              || item.Fees_value__c=='' || item.Fees_value__c==undefined){
                checkStatus = true;
            }
        }
        if(checkStatus ==true){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "error!",
                "type":"Error",
                "message": "Please complete all required fields"
            });
            toastEvent.fire();
            component.set("v.showSpinner", false);
        }else {
            
            helper.OtherFeesSaving(component, event, helper);
            helper.updateAppPrdctcpf(component, event, helper);
        }
        helper.updateAppPrdctcpf(component, event, helper);

        
    },

    handleOthefeesApplicationEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var otherfeeslist=component.get("v.newOtherfees");
        otherfeeslist.splice(rowinex,1);
        component.set("v.newOtherfees",otherfeeslist);
    },

    
})