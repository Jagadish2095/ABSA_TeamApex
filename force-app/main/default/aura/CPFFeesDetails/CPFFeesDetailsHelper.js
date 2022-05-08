({
    
    getAppPrdctCpfRec: function(component, event, helper) {
        var action = component.get("c.getAppProdctCpfRec");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appPrdctCpfRecId = response.getReturnValue();
                component.set("v.appPrdctCpfRec", appPrdctCpfRecId);
                console.log("appPrdctCpfRecId123456: " + JSON.stringify(appPrdctCpfRecId.Admin_fee__c));
                if(appPrdctCpfRecId.Admin_fee__c == 'No' ){
                    component.set("v.AdminFeeValue", 'No');
                }else if(appPrdctCpfRecId.Admin_fee__c == 'Yes' ){
                    component.set("v.AdminFeeValue", 'Yes');
                }
                if(appPrdctCpfRecId.Include_admin_fee_in_total_facility__c == 'No' ){
                    component.set("v.IncludeAminTotFacility", 'No');
                }else if(appPrdctCpfRecId.Include_admin_fee_in_total_facility__c == 'Yes' ){
                    component.set("v.IncludeAminTotFacility", 'Yes');
                }
                if(appPrdctCpfRecId.Valuation_fee__c == 'No' ){
                    component.set("v.ValuationFee", 'No');
                }else if(appPrdctCpfRecId.Valuation_fee__c == 'Yes' ){
                    component.set("v.ValuationFee", 'Yes');
                }
                if(appPrdctCpfRecId.Include_admin_fee_in_total_facility2__c == 'No' ){
                    component.set("v.IncludeAminTotFacility2", 'No');
                }else if(appPrdctCpfRecId.Include_admin_fee_in_total_facility2__c == 'Yes' ){
                    component.set("v.IncludeAminTotFacility2", 'Yes');
                }
                if(appPrdctCpfRecId.Early_termination_fee__c == 'No' ){
                    component.set("v.EarlyTerminationFee", 'No');
                }else if(appPrdctCpfRecId.Early_termination_fee__c == 'Yes' ){
                    component.set("v.EarlyTerminationFee", 'Yes');
                }
                if(appPrdctCpfRecId.Prepayment_fee__c == 'No' ){
                    component.set("v.PrePaymentFee", 'No');
                }else if(appPrdctCpfRecId.Prepayment_fee__c == 'Yes' ){
                    component.set("v.PrePaymentFee", 'Yes');
                }
                if(appPrdctCpfRecId.Cancellation_after_acceptance_clause__c == 'No' ){
                    component.set("v.Cancellationafteracceptanceclauseval", 'No');
                }else if(appPrdctCpfRecId.Cancellation_after_acceptance_clause__c == 'Yes' ){
                    component.set("v.Cancellationafteracceptanceclauseval", 'Yes');
                }
                if(appPrdctCpfRecId.Late_bond_registration_penalty__c == 'No' ){
                    component.set("v.Latebondregpenaltyval", 'No');
                }else if(appPrdctCpfRecId.Late_bond_registration_penalty__c == 'Yes' ){
                    component.set("v.Latebondregpenaltyval", 'Yes');
                }
                if(appPrdctCpfRecId.Other_fees_applicable__c == 'No' ){
                    component.set("v.otherfeesapplicableval", 'No');
                }else if(appPrdctCpfRecId.Other_fees_applicable__c == 'Yes' ){
                    component.set("v.otherfeesapplicableval", 'Yes');
                }
                if(appPrdctCpfRecId.Valuation_fee__c == 'No' ){
                    component.set("v.ValuationFee", 'No');
                }else if(appPrdctCpfRecId.Valuation_fee__c == 'Yes' ){
                    component.set("v.ValuationFee", 'Yes');
                }
            }
            else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRecId));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    updateAppPrdctcpf: function(component, event, helper) {
        var AdminFeeVal = component.get("v.AdminFeeValue");
        var cancellation =  component.find("cancelFee").get("v.value");
        var adminFeeAmount;
        if(component.find("adminAmt") == undefined){
            adminFeeAmount=null;
        }else{
            adminFeeAmount = component.find("adminAmt").get("v.value");
        }
        var payableVal;var accountType ;var restructureFeeVal;var commitmentFeeVal;
        var valuationFeeVal;var flexiFeeVal;var earlyTermFeeVal;var earlyTermFeeFYVal; var valuationFeeVal; var valuationFeeAmtVal ;
        var earlyTFeeYr1;var earlyTFeeYr2;var earlyTFeeYr3;var earlyPFeeYr1;var earlyPFeeYr2;var earlyPFeeYr3;var earlyPFeeFurtherYrs;
        if(component.find("payable") == undefined){
            payableVal=null;}else{ payableVal = component.find("payable").get("v.value"); }
        if(component.find("accType") == undefined){
            accountType=null;}else{ accountType = component.find("accType").get("v.value"); }
        if(component.find("restruFee") == undefined){
            restructureFeeVal=null;}else{ restructureFeeVal = component.find("restruFee").get("v.value"); }
        if(component.find("commFee") == undefined){
            commitmentFeeVal=null;}else{ commitmentFeeVal = component.find("commFee").get("v.value"); }
        /*if(component.find("ValuationFee") == undefined){
            valuationFeeVal=null;}else{ valuationFeeVal = component.find("ValuationFee").get("v.value"); } */
        if(component.find("flexiFacility") == undefined){
            flexiFeeVal=null;}else{ flexiFeeVal = component.find("flexiFacility").get("v.value"); }
        /* if(component.find("EarlyTerminationFee") == undefined){
            earlyTermFeeVal=null;}else{ earlyTermFeeVal = component.find("EarlyTerminationFee").get("v.value"); }*/
        if(component.find("earlyTermFeeFurtherYrs") == undefined){
            earlyTermFeeFYVal=null;}else{ earlyTermFeeFYVal = component.find("earlyTermFeeFurtherYrs").get("v.value"); }
        if(component.get("v.ValuationFee") == undefined){
            valuationFeeVal=null;}else{ valuationFeeVal = component.get("v.ValuationFee"); }
        if(component.find("valFeeAmt") == undefined){
            valuationFeeAmtVal=null;}else{ valuationFeeAmtVal = component.find("valFeeAmt").get("v.value"); }
        if(component.find("earlyTermFeeYr1") == undefined){
            earlyTFeeYr1=null;}else{ earlyTFeeYr1 = component.find("earlyTermFeeYr1").get("v.value"); }
        if(component.find("earlyTermFeeYr2") == undefined){
            earlyTFeeYr2=null;}else{ earlyTFeeYr2 = component.find("earlyTermFeeYr2").get("v.value"); }
        if(component.find("earlyTermFeeYr3") == undefined){
            earlyTFeeYr3=null;}else{ earlyTFeeYr3 = component.find("earlyTermFeeYr3").get("v.value"); }
        if(component.find("earlyPrepFeeYr1") == undefined){
            earlyPFeeYr1=null;}else{ earlyPFeeYr1 = component.find("earlyPrepFeeYr1").get("v.value"); }
        if(component.find("earlyPrepFeeYr2") == undefined){
            earlyPFeeYr2=null;}else{ earlyPFeeYr2 = component.find("earlyPrepFeeYr2").get("v.value"); }
        if(component.find("earlyPrepFeeYr3") == undefined){
            earlyPFeeYr3=null;}else{ earlyPFeeYr3 = component.find("earlyPrepFeeYr3").get("v.value"); }
        if(component.find("earlyprepaymentFeeFurtherYrs") == undefined){
            earlyPFeeFurtherYrs=null;}else{ earlyPFeeFurtherYrs = component.find("earlyprepaymentFeeFurtherYrs").get("v.value"); }
        if(valuationFeeVal == 'No')
        {
            valuationFeeAmtVal = undefined;
            IncludeAdminFeeInTotFacVal = undefined;
        }
        var IncludeAdminFeeInTotFacVal= component.get("v.IncludeAminTotFacility");
        var valuationFeeVal= component.get("v.ValuationFee");
        
        var action = component.get("c.updateAppPrdctcpf");        
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "adminFeeAmt":adminFeeAmount,
            "payable" : payableVal ,
            "adminFee" : AdminFeeVal,
            "accType" :accountType,
            "cancelFee" :cancellation,
            "commitFee":commitmentFeeVal,
            "restrucFee": restructureFeeVal,
            "flexiFac" : flexiFeeVal,
            "valFee":valuationFeeVal,
            "valFeeAmt":valuationFeeAmtVal,
            "incAdminFeeTotFacility": IncludeAdminFeeInTotFacVal,
            "incAdminFeeTotFacility2" :component.get("v.IncludeAminTotFacility2"),
            "earlyTermFee" : component.get("v.EarlyTerminationFee"),//earlyTermFeeVal,
            "earlyTermFeeY1" : earlyTFeeYr1,
            "earlyTermFeeY2" :  earlyTFeeYr2,
            "earlyTermFeeY3": earlyTFeeYr3, 
            "earlyPreFeeY1" : earlyPFeeYr1,
            "earlyPreFeeY2" : earlyPFeeYr2,
            "earlyPreFeeY3" : earlyPFeeYr3,
            "earlyPreFeeFurtherYrs" : earlyPFeeFurtherYrs,
            "earlyTermFeeFurthrYrs":earlyTermFeeFYVal ,
            "cancelAtrAccept" :  component.get("v.Cancellationafteracceptanceclauseval"),
            "lateBondPnlty" :  component.get("v.Latebondregpenaltyval"),
            "prepFee" : component.get("v.PrePaymentFee"), 
            "otherfeesapplicable" : component.get("v.otherfeesapplicableval"),
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Product CPF record updated Successfully"
                });
                toastEvent.fire();
            } 
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var getprodNamelst = response.getReturnValue();
                console.log(":getprodName " + JSON.stringify(getprodNamelst));
                component.set("v.prodName",getprodNamelst[0].Product_Name__c);
                
            }else {
                console.log("Failed with state: " + JSON.stringify(getprodNamelst));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    AddOtherFees : function(component, event) {
        var otherFeesdetails = component.get("v.newOtherfees");
        otherFeesdetails.push({
            'sobjectType' : 'Application_Fees__c',
            
        });
        component.set("v.newOtherfees",otherFeesdetails);   
        component.set("v.showSpinner", false);
    },
    
    OtherFeesSaving : function(component, event, helper) {
        console.log('newOtherfees=='+JSON.stringify(component.get("v.newOtherfees")));
        var action = component.get("c.OtherFeesDetailUpdate");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "otherfeesdetaillist" : component.get("v.newOtherfees")
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                console.log('oppRec---'+JSON.stringify(oppRec));
                /*   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Other fees details saved Successfully"
                });
                toastEvent.fire(); */
            } 
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
         $A.enqueueAction(action);
         
     },
    
    handleApplicationEvent : function(component, event,helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
        var otherfeeslist=component.get("v.newOtherfees");
        otherfeeslist.splice(unlimitedrowinex,1);
        component.set("v.newOtherfees",otherfeeslist);
        
    },
    
    getAppOtherFeesRec :function(component, event, helper) {
        var action = component.get("c.getApplicationFeesRec");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appFeesRec = response.getReturnValue();
                console.log("newOtherfees: " + JSON.stringify(appFeesRec));
                component.set("v.newOtherfees",response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + JSON.stringify(appFeesRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
});