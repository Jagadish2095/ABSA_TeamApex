({
    initialize : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Salutation', fieldName: 'Salutation', type: 'text'},
            {label: 'Contact Person', fieldName: 'Name', type: 'Text'},
            {label: 'Mobile No.', fieldName: 'MobilePhone', type: 'Text'},
            {label: 'Operational Role', fieldName: 'Roles', type: 'text', wrapText: true}]);
        helper.fetchOpportunityLineItemId(component, event, helper);
        helper.fetchAccountContactRelation(component, event, helper);
    },

    onload : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
        var val = component.find('contactPerson').get('v.value');
        component.set("v.selectedRows", val);
    },

    handleSuccess : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        helper.fireToast("Success!", "Contact Person has been updated successfully.", "success");
    },

    handleError : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        helper.fireToast("Error!", "Contact Person has not been updated successfully. Please contact your System Administrator.", "error");
    },

    UpdateSelectedRows: function (component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        var selectedValue = selectedRows[0].Id;
        var emailMap = component.get("v.emailMap");
        var mobileMap = component.get("v.mobileMap");
        var salutationMap = component.get("v.salutationMap");
        if (emailMap.get(selectedValue) != null && emailMap.get(selectedValue) != ""
           && mobileMap.get(selectedValue) != null && mobileMap.get(selectedValue) != ""
           && salutationMap.get(selectedValue) != null && salutationMap.get(selectedValue) != "") {
            component.set('v.isButtonActive',false);
            if (selectedValue != component.find('contactPerson').get('v.value')) {
                component.find('contactPerson').set('v.value', selectedValue);
            }
        } else {
            component.set('v.isButtonActive',true);
        }

    },

    handleApplicationEvent : function(component, event, helper) {
        var opportunityProductId = event.getParam("opportunityProductId");
        if (!$A.util.isEmpty(opportunityProductId)) {
            component.set("v.opportunityProductId", opportunityProductId);
            helper.fetchAccountContactRelation(component, event, helper);
        }
    },

    // PJAIN: 20200630
    opportunityRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var approvalStatus = component.get("v.opportunityRecord.Approval_Status__c");
            if (approvalStatus === "Pending") {
                component.set("v.isApprovalPending", true);
            } else {
                component.set("v.isApprovalPending", false);
            }
        } else if(eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            var changedFields = eventParams.changedFields
            if (changedFields) {
                var approvalStatusChanged = changedFields.Approval_Status__c;
                if (approvalStatusChanged) {
                    if (approvalStatusChanged.value === "Pending") {
                        component.set("v.isApprovalPending", true);
                    } else {
                        component.set("v.isApprovalPending", false);
                    }
                }
            }
        }
    }
})