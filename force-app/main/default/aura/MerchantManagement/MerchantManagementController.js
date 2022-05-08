({
    init : function(component, event, helper) {
        helper.getIds(component, event, helper);
    },

    handleCreateCase : function (component, event, helper) {
        // Find the component whose aura:id is "flowId"
        var flow = component.find("flowId");
        var inputVariables = [{
               name : "OpportunityId",
               type : "String",
               value : component.get("v.recordId")
            }, {
               name : "CaseRecordTypeName",
               type : "String",
               value : "Merchant_Fulfillment"
            }, {
                name : "Subject",
                type : "String",
                value : "Merchant Fulfillment"
            }, {
                name : "ServiceTypeName",
                type : "String",
                value : "Merchant Onboarding QA Vetting"
            }];
        //launch the flow
        flow.startFlow("Merchant_Application_Create_Case", inputVariables);
    },

    handleStatusChange : function (component, event, helper) {
        if(event.getParam("status") === "FINISHED_SCREEN") {
            // Get the output variables and iterate over them
            var outputVariables = event.getParam("outputVariables");

            var currentOutputVariable;
            for(var i = 0; i < outputVariables.length; i++) {
                currentOutputVariable = outputVariables[i];

                if(currentOutputVariable.name === "ExistingCaseMessage") {
                    if (currentOutputVariable.value) {
                        //The flow returned the an error that the is an existing case open
                        component.set("v.errorMessage", currentOutputVariable.value);
                    } else {
                        //There are no Open Merchant Fulfillment Cases, the flow created the case the ExistingCaseMessage field is blank
                        component.set("v.errorMessage", null);
                        helper.fireToast("Success!", "Merchant Fulfillment Case has been created.", "success");
                        //refresh the view
                        $A.get('e.force:refreshView').fire();
                    }
                }
            }
        }
    },

    handleRetryFailuresBtn : function(component, event, helper) {
        helper.createMASSAccount(component, event, helper);
    },

    handleReviseApplicationBtn : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },

    handleIsAutoRefreshChange : function(component, event, helper) {
        if (component.get('v.isAutoRefresh')) {
            helper.turnOnAutoRefresh(component);
        }
    },

    handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        helper.reviseApplication(component, event, helper);
    },

    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationId = event.getParam("applicationId");
        var applicationProductMerchantId = event.getParam("applicationProductMerchantId");
        if (!$A.util.isEmpty(applicationId) && !$A.util.isEmpty(applicationProductMerchantId)) {
            component.set("v.applicationId", applicationId);
            component.set("v.appProdMerchId", applicationProductMerchantId);
            component.set("v.errorMessage", "");
            component.set('v.isAutoRefresh', true);

            component.find('applicationEditor').reloadRecord();
            component.find('appProdMerchEditor').reloadRecord();
        }
    }
})