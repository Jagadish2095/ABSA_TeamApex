({
    //Initialization method
    doInit: function (component, event, helper) {
        helper.doInit(component, event, helper);
        component.find("sourceAcc").set("v.disabled", true);
        component.find("targetBalance").set("v.disabled", true);
        component.find("sourceBalance").set("v.disabled", true);
        
    },
    
    handleCaseLoad: function (component, event, helper) {
        var EBCollectionsSG = 'Everyday Banking - Collections';
        var serviceGroups = $A.get("$Label.c.Show_Linked_Accounts_For_Service_Groups");
        if (serviceGroups.split(";").includes(component.find("serviceGroupField").get("v.value"))) {
            component.set("v.showToggleFlag", true);
        }
        // Sourabh : Interaccount sweep w-013364
        if ((EBCollectionsSG.includes(component.find("serviceGroupField").get("v.value")) || 'Inter Account Sweep Escalations'.includes(component.find("serviceGroupField").get("v.value"))) && 'Inter-Account Transfer (Sweep)'.includes(component.find("caseType__cField").get("v.value"))) {
            component.set("v.IsEBServiceGroupSweepServiceType", true); // IsEBServiceGroup&SweepServiceType
            var caseID = component.get("v.caseIdFromFlow");
            component.set("v.sourceBalance", helper.getAccountBalance(component, component.get("v.selectedAccountNumberFrom")));
            debugger;
            
            
            // functions to get data from static resources
            helper.getStaticResource(component, event, helper,"Inter-Account Transfer (Sweep)");
        }
        if(EBCollectionsSG.includes(component.find("originalServiceGroupId").get("v.value")) && 'Inter Account Sweep Escalations'.includes(component.find("serviceGroupField").get("v.value")) ){
            if(component.find("caseSubTypeField").get("v.value")=="Inter-Account Transfer (Sweep)"){
                component.set("v.IsEBServiceGroupSweepServiceType", true);  
            }else{
                component.set("v.IsEBServiceGroupSetOffServiceType", true);
            }
            component.find("reasonEV").set("v.disabled", true);
            component.find("amount").set("v.disabled", true);
            component.find("reference").set("v.disabled", true);
            component.find("accountSelect").set("v.disabled", true);
            component.find("submitButton").set("v.disabled", true);
            component.find("cancelSweep").set("v.disabled", true);
          
            
        }
        if (EBCollectionsSG.includes(component.find("serviceGroupField").get("v.value"))  && 'SET-OFF'.includes(component.find("caseType__cField").get("v.value"))) {
            console.log('Everyday Banking - Collections');
            component.set("v.IsEBServiceGroupSetOffServiceType", true);
            debugger;
            // Set-Off get static resources data for queueName
            helper.getStaticResource(component, event, helper,"Set-OFF");
        }
        // set off / sweep
        if(component.get("v.IsEBServiceGroupSweepServiceType") || component.get("v.IsEBServiceGroupSetOffServiceType")){
             helper.getCollectionPhaseAndCycle(component, event, helper);
            //  This has been done bcz business ask to swap the accounts
            component.find("sourceAcc").set("v.label", 'To Account');
           component.find("sourceBalance").set("v.label", 'Target Balance');
            component.find("accountSelect").set("v.label", 'From Account');
             component.find("targetBalance").set("v.label", 'Source Balance');
             component.set("v.reference", component.get("v.selectedAccountNumberFrom"));
            
             
            
        }
        component.set("v.caseLoaded", true);
        
    },
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        console.log('eventParams.changeType'+eventParams.changeType);
        if(eventParams.changeType === "LOADED") {
            if(component.get("v.sObjectRecord.Type__c") && component.get("v.sObjectRecord.Type__c") == "SET-OFF" &&
               component.get("v.sObjectRecord.Account.Rounded_Age__c") && component.get("v.sObjectRecord.Account.Rounded_Age__c") >60)
            {
                component.set("v.errorMessage",$A.get("$Label.c.Pensioner_not_eligible_for_set_off").replace("#clientname#",component.find("clientName").get("v.value")));
                component.set("v.showButton", false);
                var showModalWindow = component.find("closeCaseSetOff");
                $A.util.removeClass(showModalWindow, 'slds-hide');
                return;
                
            }
           
        }
    },
    
    toggleView: function (component, event, helper) {
        //Added by Chandra
        component.set("v.selectedAccountNumberFromType", '');
        component.set("v.selectedAccountNumberToType", '');
        //Change end by chandra
        var isChecked = component.find("toggleLinkedAcc").get("v.checked");
        if (isChecked) {
            component.set("v.useLinkedAccounts", true);
            component.find("PaymentVerification").set("v.checked", false);
            component.set("v.showButton", true);
            helper.getCombiAccounts(component, event, helper);
            helper.disableInterAccountButtons(component);
            helper.nullifyInterAccountFields(component);
        } else {
            component.set("v.useLinkedAccounts", false);
            helper.doInit(component, event, helper);
            
            component.set("v.selectedAccountNumberFrom", component.get("v.selectedAccountNumberToFlow"));
            //Added by Chandra
            var srcAccType = helper.getAccountTypeTranslatedValue(component, component.get("v.selectedAccountNumberFrom"));
            component.set("v.selectedAccountNumberFromType", srcAccType);
            //Change end by chandra
            helper.nullifyNonInterAccountFields(component);
            helper.disableNonInterAccountButtons(component);
            component.set("v.showButton", true);
            component.find("PaymentVerification").set("v.checked", false);
        }
    },
    
    validateRequiredFields: function (component, event, helper) {
        if (component.get("v.selectedAccountNumberTo") == component.get("v.selectedAccountNumberFrom")) {
            helper.fireToastEvent("Error!", "Source and target accounts cannot be the same", "Error");
            return;
        }
        
        if (!component.find("PaymentVerification").get("v.checked")) {
            helper.fireToastEvent("Error!", "Please confirm verfication of details", "Error");
            return;
        }
        // InterAccount Sweep w-013364  
        
        if (helper.allFieldsValid(component) && !component.get("v.IsEBServiceGroupSweepServiceType") && !component.get("v.IsEBServiceGroupSetOffServiceType")) {
            helper.submit(component);
            // InterAccount Sweep w-013364  
        } else if(helper.allFieldsValid(component) && component.get("v.IsEBServiceGroupSweepServiceType") || component.get("v.IsEBServiceGroupSetOffServiceType")){
            debugger;
            if ($A.util.isUndefinedOrNull(component.get("v.collectionPhase"))) {
            helper.fireToastEvent("Error!", "Collection phase missing", "Error");
            return;
            } 
            if(component.get("v.IsEBServiceGroupSweepServiceType")){
                 var amount = component.get("v.amount");
                if(parseInt(amount) > parseInt(component.get("v.targetBalance"))){
                    helper.fireToastEvent("Error!", "Insufficient funds to perform sweep. Please cancel the sweep and close the case.", "Error");
                    return;
                }
            var amountLimit= $A.get("$Label.c.InterAccount_Sweep_Amount_Limit_for_Approval_Mandate");
           
            if(parseInt(amount) < parseInt(amountLimit) || component.get("v.approvalStatus")=='Service Response Failed' ){
                helper.submit(component);
                
            }else{
                helper.submitForApproval(component, event, helper,"Inter-Account Transfer (Sweep)");
            } 
          }
            else if(component.get("v.IsEBServiceGroupSetOffServiceType")){
                var amount = component.get("v.amount");
                if(parseInt(component.get("v.targetBalance")) - parseInt(amount) < 3000 ){
                    var amountToDebit = parseInt(component.get("v.sourceBalance")) - 3000;
                    helper.fireToastEvent("Error!", "Can only debit up to"+amountToDebit, "Error");
                    return; 
                } 
            if(component.get("v.approvalStatus") == 'Service Response Failed' ){
                helper.submit(component);
            }else{
                helper.submitForApproval(component, event, helper,"Set-OFF");
            }
        }
        }
            else {
                helper.fireToastEvent("Error!", "Please ensure all required fields are populated", "Error");
            }
    },
    
    onSelectCombiAccount: function (component, event, helper) {
        helper.getCombiLinkedAccounts(component);
    },
    
    onSelectTBSourceAccount: function (component, event, helper) {
        component.set("v.sourceBalance", helper.getAccountBalance(component, component.get("v.tbSourceAccount")));
        component.set("v.selectedAccountNumberFrom", component.get("v.tbSourceAccount"));
        //Added by Chandra
        var srcAccType = helper.getAccountTypeTranslatedValue(component, component.get("v.tbSourceAccount"));
        component.set("v.selectedAccountNumberFromType", srcAccType);
        //Change end by chandra
    },
    
    onChange: function (component, event, helper) {
        //Added by Chandra
        var targAccType = helper.getAccountTypeTranslatedValue(component, component.get("v.selectedAccountNumberTo"));
        component.set("v.selectedAccountNumberToType", targAccType);
        //Change end by chandra
        component.set("v.targetBalance", helper.getAccountBalance(component, component.get("v.selectedAccountNumberTo")));
        // Set off 
        if(component.get("v.IsEBServiceGroupSweepServiceType") || component.get("v.IsEBServiceGroupSetOffServiceType")){
            component.set("v.sourceAccType", helper.getAccountType(component, component.get("v.selectedAccountNumberTo")));  
        }
        
    },
    // InterAccount sweep starts
    onChangeReason: function (component, event, helper) {
        console.log('Value'+component.find('reasonEV').get('v.value'));
        component.set("v.reason",component.find('reasonEV').get('v.value'));
    },
    onChangeCancelSweep: function (component, event, helper) {
        var sweepCancel =component.find("cancelSweep").get("v.checked");
        component.set("v.closeCase", sweepCancel);
    },
    closeCase: function (component, event, helper) {
         component.find("statusField").set("v.value", "Closed");
         component.find("descriptionField").set("v.value", "Insufficient Funds to perform Operation.");
         component.find("caseEditForm").submit();
         $A.get("e.force:refreshView").fire();
    },
    
    // InterAccount sweep ends
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
        component.set("v.isShowSpinnerSetOff", true);
        var selectedAccountNumberFrom= component.get("v.selectedAccountNumberFrom");
        while (selectedAccountNumberFrom.length < 16) selectedAccountNumberFrom = "0" + selectedAccountNumberFrom;
        var action = component.get("c.promisToPay");
        // Set the parameters
        action.setParams({
            clientAccountNum: selectedAccountNumberFrom
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var jsonResult = JSON.parse(result);
                if(jsonResult !=null && jsonResult.data !=null && jsonResult.statusCode == 200){
                    var data = jsonResult.data;
                    data.forEach(function (dataItem) {
                        if(dataItem.paymentScheduleStatusReference.valueText == 'CANCELED'){
                            component.set("v.paymentFrequency", dataItem.paymentScheduleFrequencyReference.valueText);
                            component.set("v.initialPaymentAmount", dataItem.downPaymentAmount);
                            component.set("v.initialPaymentDate", dataItem.downPaymentYMDDate);
                            component.set("v.scheduledStartDate", dataItem.startYMDDateInput);
                            component.set("v.scheduledNumberOfPayments", dataItem.numOfPayments);
                            component.set("v.scheduledPaymentAmount", dataItem.regularPaymentAmount.amount);
                            component.set("v.paymentFrequencyMonths", dataItem.numberOfMonthsInput);
                        }
                    });
                    
                } else {
                    console.log('null value resopnse');
                }

            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error retrieving customer hold", +JSON.stringify(errors));
            }
            component.set("v.isShowSpinnerSetOff", false); 
        });
        $A.enqueueAction(action);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    } ,
    // Inter Account Sweep
    handleCaseTransactionRecordLoad : function(component, event, helper) {
        debugger;
      
        if('Everyday Banking - Collections'.includes(component.find("originalServiceGroupId").get("v.value")) && 'Inter Account Sweep Escalations'.includes(component.find("serviceGroupField").get("v.value")) ){
           // swapping of account is done as business wants source account to be target acc
            component.find("sourceAcc").set("v.value", component.find("cttarAcc").get("v.value"));
            component.find("amount").set("v.value", component.find("ctamount").get("v.value"));
            component.find("accountSelect").set("v.value", component.find("ctsourAcc").get("v.value"));
            
            component.find("reference").set("v.value", component.find("ctreference").get("v.value"));
            component.find("reasonEV").set("v.value", component.find("ctreason").get("v.value"));
       
            component.set("v.approvalStatus",component.find("ctstatus").get("v.value"));
            component.set("v.selectedAccountNumberTo",component.find("cttarAcc").get("v.value"));
             helper.getCollectionPhaseAndCycle(component, event, helper);
        } 
        var jobName;
        if(component.get("v.IsEBServiceGroupSweepServiceType")){
            jobName=' Sweep ';
        }else{
            jobName=' Set OFF ';
        }
        if(!$A.util.isUndefinedOrNull(component.get("v.approvalStatus"))){
            if(component.get("v.approvalStatus")=='Approved'){
                component.set("v.approvalStatusMessage", jobName+'approved by Approver.');
              
            } 
            else if(component.get("v.approvalStatus")=='Rejected'){
                component.set("v.approvalStatusMessage", jobName+ 'approval request rejected by Approver');
            }
                else if(component.get("v.approvalStatus")=='Service Response Failed'){
                    component.set("v.approvalStatusMessage",jobName+'approved by Approvers but transaction failed. Please retry to Submit again.');
                    component.find("submitButton").set("v.label", 'Retry');
                      component.find("submitButton").set("v.disabled", false);
                }
                    else if(component.get("v.approvalStatus")=='Service Response Approved'){
                        component.set("v.approvalStatusMessage",jobName+'approved successfully.');
                    }else {
                        component.set("v.approvalStatusMessage",jobName+'Pending for Approval.');
                    }
            
        }
        
        
    } ,
});