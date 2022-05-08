({
    doInit : function(component, event, helper) {
        helper.getAppPrdctCpfRec(component, event, helper);
        helper.getAppFinAccCpfRec(component, event, helper);
        helper.getopplineitemRec(component, event, helper);
        helper.getAppOtherFeesRec(component, event, helper);
        
    },
    
    handleChangeIncludeVAT: function (component, event,helper) {
        var VATIncludechangeValue = event.getParam("value");
        var includeVATchargeoptionGiven = component.get("v.includeVATchargeoptionGiven") ;
        
        if(VATIncludechangeValue== 'N'){
            
            component.set("v.includeVATchargeoptionGiven", 'N');
            component.set("v.IsIncludeVAToncharges", false);
        }
        else if(VATIncludechangeValue=='Y'){
            
            component.set("v.includeVATchargeoptionGiven", 'Y');
            component.set("v.IsIncludeVAToncharges", true);
        }
    },
    /* handleChangeotheramtsincluded: function (component, event,helper) {
        var otheramtincludedchangeValue = event.getParam("value");
      	var otheramountsincludedintotalfacilityoptionGiven = component.get("v.otheramountsincludedintotalfacilityoptionGiven") ;
        
        if(otheramtincludedchangeValue== 'N'){
            
            component.set("v.otheramountsincludedintotalfacilityoptionGiven", 'N');
            component.set("v.Isotheramountsincludedintotalfacility", false);
        }
        else if(otheramtincludedchangeValue=='Y'){
            
            component.set("v.otheramountsincludedintotalfacilityoptionGiven", 'Y');
            component.set("v.Isotheramountsincludedintotalfacility", true);
            }
    },*/
    /*differenceclauseapplicablehandleChange: function (component, event,helper) {
        var differenceclausechangeValue = event.getParam("value");
      var DifferenceclauseapplicableoptionGiven = component.get("v.DifferenceclauseapplicableoptionGiven") ;
        if(differenceclausechangeValue== 'None'){
            
            component.set("v.DifferenceclauseapplicableoptionGiven", 'None');
            component.set("v.showdifferenceclausefields", 'None');
        }
        else if(differenceclausechangeValue== 'Standardclause'){
           
            component.set("v.DifferenceclauseapplicableoptionGiven", 'Standardclause');
            component.set("v.showdifferenceclausefields",'Standardclause');
            }
            else if(differenceclausechangeValue== 'Payoutintranches'){
            
            component.set("v.DifferenceclauseapplicableoptionGiven", 'Payoutintranches');
            component.set("v.showdifferenceclausefields",'Payoutintranches');
            }
    },*/
    IncludebalanceonexistingaccounthandleChange: function (component, event,helper) {
        var includebalanceexistingaccValue = event.getParam("value");
        var IncludebalanceonexistingaccountoptionGiven = component.get("v.IncludebalanceonexistingaccountoptionGiven") ;
        
        if(includebalanceexistingaccValue== 'N'){
            
            component.set("v.IncludebalanceonexistingaccountoptionGiven", 'N');
            component.set("v.showIncludebalanceonexistingacc", 'No');
        }
        else if(includebalanceexistingaccValue=='Y'){
            
            component.set("v.IncludebalanceonexistingaccountoptionGiven", 'Y');
            component.set("v.showIncludebalanceonexistingacc",'Yes');
        }
        
    },
    addNewAccount: function (component, event, helper) {
        component.set("v.showSpinner", true);
        //helper.addNewAccount(component, event);
        helper.addAccount(component, event);
        
    },
    handleSubmit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var IncludebalanceonexistingaccountoptionGiven= component.get("v.IncludebalanceonexistingaccountoptionGiven");
        var otheramountsincludedintotalfacilityValues= component.get("v.otheramountsincludedintotalfacilityValues");
        console.log("otheramountsincludedintotalfacilityValues" +otheramountsincludedintotalfacilityValues);
        if(component.find("drawdownamount").get("v.value")=='' || component.find("drawdownamount").get("v.value")==undefined ){ //|| component.find("retentionamount").get("v.value")=='' || component.find("retentionamount").get("v.value")==undefined ||
            //component.get("v.DifferenceclauseapplicableValues") =='' || component.get("v.DifferenceclauseapplicableValues") ==undefined
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please complete required fields."
            });
            toastEvent.fire();
            
        }else if(component.get("v.DifferenceclauseapplicableValues") =='Payout In Tranches'){
            if(component.find("amountofexistingmortgage").get("v.value")=='' || component.find("amountofexistingmortgage").get("v.value")==undefined || component.find("Remainingavailableamount").get("v.value")=='' || component.find("Remainingavailableamount").get("v.value")==undefined ){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please complete required fields."
                });
                toastEvent.fire();
            } else  if(IncludebalanceonexistingaccountoptionGiven =='Y'){
                var itemsToPass=component.get("v.newFacilityAccount");
                var item;
                var checkStatus = false;
                console.log('itemsToPass=== newFacilityAccount'+JSON.stringify(itemsToPass));
                for (var i=0; i< itemsToPass.length; i++)
                {
                    item = itemsToPass[i];
                    if(item.Existing_Account_Number__c=='' || item.Existing_Account_Number__c==undefined ||
                       item.Outstanding_Balance__c=='' || item.Outstanding_Balance__c==undefined || item.Balance_as_at__c=='' || item.Balance_as_at__c==null  ){
                        checkStatus = true;
                        console.log("Existing Aacct "+checkStatus);}
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
                }else{
                    helper.updateAppPrdctcpf(component, event, helper);
                }
            }else  if(otheramountsincludedintotalfacilityValues =='Yes'){
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
                }
                
            }
            
                else{
                    helper.updateAppPrdctcpf(component, event, helper);
                }
            
            
        }else if(component.get("v.DifferenceclauseapplicableValues") =='Standard Clause'|| component.get("v.DifferenceclauseapplicableValues") =='None' ){
            if(IncludebalanceonexistingaccountoptionGiven =='Y'){
                var itemsToPass=component.get("v.newFacilityAccount");
                var item;
                var checkStatus = false;
                console.log('itemsToPass=== newFacilityAccount'+JSON.stringify(itemsToPass));
                for (var i=0; i< itemsToPass.length; i++)
                {
                    item = itemsToPass[i];
                    if(item.Existing_Account_Number__c=='' || item.Existing_Account_Number__c==undefined ||
                       item.Outstanding_Balance__c=='' || item.Outstanding_Balance__c==undefined || item.Balance_as_at__c=='' || item.Balance_as_at__c==null  ){
                        checkStatus = true;
                        console.log("Existing Aacct "+checkStatus);}
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
                }else{
                        helper.updateAppPrdctcpf(component, event, helper);
                    }
            }
            if(otheramountsincludedintotalfacilityValues =='Yes'){
                console.log("comes here in Standard clause");
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
                }
                
            }
            }
            else{
                helper.updateAppPrdctcpf(component, event, helper);
            } 
        },
            handleApplicationEvent : function(component, event,helper) {
                var opportunityId = event.getParam("opportunityId");
                var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
                var AppFinAccId = event.getParam("AppFinAccId");
                var rowinex =event.getParam("RowIndex");
                
                var faclilitylist=component.get("v.newFacilityAccount");
                faclilitylist.splice(rowinex,1);
                component.set("v.newFacilityAccount",faclilitylist);
            },
                addOtherfees : function(component, event, helper) {
                    component.set("v.showSpinner", true);
                    helper.AddOtherFees(component, event);
                },
                    /*  handleOtherfeesSubmit : function(component, event, helper) {
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
        }
        
        
    },*/
        handleOthefeesApplicationEvent : function(component, event,helper) {
            var rowinex =event.getParam("RowIndex");
            var otherfeeslist=component.get("v.newOtherfees");
            otherfeeslist.splice(rowinex,1);
            component.set("v.newOtherfees",otherfeeslist);
        },
            
            
            
            
            
    })