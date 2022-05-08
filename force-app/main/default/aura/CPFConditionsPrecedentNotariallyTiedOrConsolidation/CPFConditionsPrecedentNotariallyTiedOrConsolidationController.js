({
    doInit : function(component, event, helper) {
        helper.getAppPrdctCpfRec(component, event);
        helper.getAppConClauseCpfRec(component, event);
        helper.getAppConClauseCpfRecForFurther(component, event);
        helper.getAppConClauseCpfRecForSpecial(component, event);
        helper.getopplineitemRec(component,event);
    },
    addNewLease: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isLease", true);
        helper.addLeaseItems(component, event);
    },
    handleleaseApplicationEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var leaseslist=component.get("v.newleases");
        leaseslist.splice(rowinex,1);
        component.set("v.newleases",leaseslist);
    },
    handleSubmit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var itemsToPass=component.get("v.newleases");
        var item;
        var checkStatus = false;
        if(component.get("v.ObligorincorpoutsideofSAvalues") == undefined || component.get("v.ObligorincorpoutsideofSAvalues") =='' || component.get("v.Environmentalpermitsvalues") == undefined || component.get("v.Environmentalpermitsvalues") =='' ||
           component.get("v.Financialassistancevalues") == undefined || component.get("v.Financialassistancevalues") =='' || component.get("v.Electricalcompliancecertificatevalues") == undefined || component.get("v.Electricalcompliancecertificatevalues") =='' ||
           component.get("v.Newlyformedcompanyvalues") == undefined || component.get("v.Newlyformedcompanyvalues") =='' || component.get("v.Preletvalues") == undefined || component.get("v.Preletvalues") =='' || 
           component.find("Borrowersconid").get("v.value") == undefined || component.find("Borrowersconid").get("v.value") =='' || component.find("purchasepriceId").get("v.value") == undefined || component.find("purchasepriceId").get("v.value") =='' || 
           component.get("v.Restraintagainstfreevalues") == undefined || component.get("v.Restraintagainstfreevalues") ==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please complete all Mandatory fields."
            });
            toastEvent.fire(); 
        }else if(component.get("v.Preletvalues") == 'Yes' ){
            if(component.get("v.Preletreviewvalues") == undefined || component.get("v.Preletreviewvalues") ==''){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please complete all Mandatory fields."
                });
                toastEvent.fire(); 
            }else if(component.get("v.Preletreviewvalues") == 'Yes'){
                for (var i=0; i< itemsToPass.length; i++)
                {
                    item = itemsToPass[i];
                    if(item.Description__c=='' || item.Description__c==undefined){
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
                    helper.updateAppPrdctcpfandInsertAppContract(component, event, helper);}
            }else {
                helper.updateAppPrdctcpfandInsertAppContract(component, event, helper);}
        } else {
            helper.updateAppPrdctcpfandInsertAppContract(component, event, helper);}
        
    },
    handleNotariallySubmit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var notariallyvalue=component.get("v.NotariallyTiedConsolidationValues");
        if(notariallyvalue=='Notarially Tied' || notariallyvalue=='Consolidated' ){
            if(component.find("Property1id").get("v.value") == undefined || component.find("Property1id").get("v.value") =='' || component.find("Property2id").get("v.value") == undefined || component.find("Property2id").get("v.value") ==''){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please complete all Mandatory fields."
                });
                toastEvent.fire(); 
            }else{
                helper.updateAppPrdctcpfforNotarially(component, event, helper);}}
        if(notariallyvalue=='Not Applicable'){
            helper.updateAppPrdctcpfforNotarially(component, event, helper)
        }
    },
    
    //My Code
    /* handleFurtherCondSubmit : function(component, event, helper) {
         component.set("v.showSpinner", true);
         var itemsToPass=component.get("v.otherTransactionalConvenants");
         helper.InsertFurtherConditions(component, event, helper);
    },*/
    
    handleFurtherApplicationEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var leaseslist=component.get("v.newFurtherCond");
        leaseslist.splice(rowinex,1);
        component.set("v.newFurtherCond",leaseslist);
    },
    
    handleFurtherSubmit : function(component, event, helper) {
        debugger;
        component.set("v.showSpinner", true);
        var itemsToPass=component.get("v.newFurtherCond");
        var checkStatus = false;  
        var item;        
        
        for (var i=0; i< itemsToPass.length; i++)
        {
            item = itemsToPass[i];
            if(item.Description__c=='' || item.Description__c==undefined){
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
            
            helper.furtherAppPrdctcpfandInsertAppContract(component, event, helper);
        }
        
        
    },
    
    addFurtherCond : function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddFurtherCond(component, event);
    },
    
    
    handleSpecialSubmit : function(component, event, helper) {
        debugger;
        component.set("v.showSpinner", true);
        var itemsToPass=component.get("v.newSpecialCond");
        var checkStatus = false; 
        var item;        
        
        for (var i=0; i< itemsToPass.length; i++)
        {
            item = itemsToPass[i];
            if(item.Description__c=='' || item.Description__c==undefined){
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
            
            helper.specialAppPrdctcpfandInsertAppContract(component, event, helper);
        }
        
    },
    
    addSpecialCond : function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddSpecialCond(component, event);
    },
    
    
    handleSpecialApplicationEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var leaseslist=component.get("v.newSpecialCond");
        leaseslist.splice(rowinex,1);
        component.set("v.newSpecialCond",leaseslist);
    },

})