({
	doInit : function(component, event, helper) {
	 
        helper.getAccountDetails(component);
        //helper.getOpportunityDetails(component);
        //helper.showProduct(component, event, helper); 
        helper.getEntitytype(component);
        //var Entitytype = component.get("v.account.Client_Type__c");
        //
        console.log('Fraud : ' + component.get("v.opportunityRecord.FraudRiskAlert__c"));
        
        if (component.get("v.opportunityRecord.Risk_Rating__c") != null) {
            component.set("v.showGenerateCIFButton", true);
        }
       
	},
    
    //Added by Masechaba Maseli for W-005269
    //Modified by Masechaba Maseli for W-005065
    showButtonCIF : function(component, event, helper){
        var submitButtonCIF= component.find("submitButtonCIF");
        var submitButtonCIFUpdate= component.find("submitButtonCIFUpdate");
        var caseId = component.get("v.opportunityRecord2.Case__c");
        var caseRec = component.get("v.opportunityRecord.Case__c");
        console.log("caseRec"+caseRec);
        var caseStatus = component.get("v.opportunityRecord.Case__r.Status");
        console.log("caseStatus::"+caseStatus);
        var Resolvedlabel = $A.get("$Label.c.Resolved");
        var processType = component.get("v.opportunityRecord.Process_Type__c")
        
        if(processType == 'Surety Onboarding') {
            var cmpTarget = component.find('CIFresultsDiv');
            $A.util.removeClass(cmpTarget, "slds-hide");
        } else if(caseId != null && caseStatus != Resolvedlabel){
            helper.SourceofWealthValidation(component, event, helper);
            helper.eddProcessValidation(component, event, helper);
        } else if(event.getSource().get("v.checked")){            
            // $A.util.removeClass(submitButtonCIF, 'slds-hide');
            var cmpTarget = component.find('CIFresultsDiv');
            var cmpTarget1 = component.find('CIFresultsDivUpdate');
            $A.util.removeClass(cmpTarget, "slds-hide");
            $A.util.removeClass(cmpTarget1, 'slds-hide');
            $A.util.removeClass(submitButtonCIFUpdate, 'slds-hide');
            
        }else{            
            $A.util.addClass(submitButtonCIF, 'slds-hide');
            $A.util.addClass(submitButtonCIFUpdate, 'slds-hide');
        }
        
    },
    
    /****************@ Author: Chandra********************************
 	****************@ Date: 22/11/2019********************************
 	****************@ Description: Method to handle account load******/
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            if(component.get("v.accountRecord.Name") != undefined){
                component.set("v.accountName",component.get("v.accountRecord.Name"));
            }
        }
    },

    createCIFHelper : function(component, event, helper){
        var caseRec = component.get("v.opportunityRecord.Case__c");
        console.log("caseRec"+caseRec);
        var caseStatus = component.get("v.opportunityRecord.Case__r.Status");
        console.log("caseStatus::"+caseStatus);
        // If No EDD process triggers
        if($A.util.isUndefinedOrNull(caseRec)){
            helper.createCIFHelper(component, event, helper);
        }
        // EDD process triggers
        else{
            if(component.get("v.opportunityRecord.RecordType.Name") != 'Credit Onboarding'){
              helper.SourceofWealthValidation(component, event, helper);
              helper.eddProcessValidation(component, event, helper);
            }
        }
        
    },
    handleFraudApplicationEvent : function(component, event, helper){
        if(event.getParam("fraudRiskAlertP")=='Clean'){
            component.set("v.showGenerateCIFButton", true);
        }
        if(event.getParam("fraudRiskActionP")=='False Positive'){
            component.set("v.showGenerateCIFButton", true);
        }
    },
    
        updateCIFRemediateHelper : function(component, event, helper){
        var caseRec = component.get("v.opportunityRecord.Case__c");
        console.log("caseRec"+caseRec);
        var caseStatus = component.get("v.opportunityRecord.Case__r.Status");
        console.log("caseStatus::"+caseStatus);
         console.log("caseStatus97::"+$A.util.isUndefinedOrNull(caseRec));
        // If No EDD process triggers
        if(($A.util.isUndefinedOrNull(caseRec) == false && caseStatus == 'Resolved') || $A.util.isUndefinedOrNull(caseRec) == true){
            helper.updateCIFRemediateHelper(component, event, helper);
        }
        // EDD process triggers
        else{
            if(component.get("v.opportunityRecord.RecordType.Name") == 'Remediate Existing Customer'){
              helper.SourceofWealthValidation(component, event, helper);
              helper.eddProcessValidation(component, event, helper);
            }
        }
        
    },
   
})