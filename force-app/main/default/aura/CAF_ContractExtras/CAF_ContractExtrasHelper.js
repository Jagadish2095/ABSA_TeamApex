({
    fetchContractExtras: function (component, event, helper, recordId) {
        //alert('recordId>>'+recordId);
        component.set("v.showSpinner", true);
        var action = component.get("c.getContractExtras");
        var oppId = component.get("v.oppId");
        //var recordId 	= component.get("v.recId");
        action.setParams({
            oppId: oppId,
            recordId: recordId
        });

        action.setCallback(this, function (response) {
            //debugger;
            var state = response.getState();

            if (state === "SUCCESS") {
                var extrasVal = response.getReturnValue();
                var actions = [
                    { label: "Edit", name: "edit" },
                    { label: "Delete", name: "delete" }
                ];

                component.set("v.columns", [
                    { label: "Type Extra", fieldName: "Type_Extra__c", type: "text" },
                    { label: "Additional Fee Amount", fieldName: "Additional_Fee_Amount__c", type: "text" },
                    { type: "action", typeAttributes: { rowActions: actions } }
                ]);

                component.set("v.extraslength", extrasVal.length);
                component.set("v.dataList", extrasVal);
                component.set("v.showSpinner", false);
            } else {
            }
        });
        $A.enqueueAction(action);
    },

    getTypeExtraPicklistValues: function(component, event, helper) {
        var fieldName = "OpportunityLineItem.Type_Extra__c";
        var action = component.get("c.getMultipleSelectOptions");
        var fieldList = [fieldName];
        action.setParams({
            fieldList: fieldList
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.typeExtraOptions", resp[fieldName]);
            } else if (state === "ERROR") {
                helper.errorMsg(JSON.stringify(response.getError().message));
            }
        });
        $A.enqueueAction(action);
    },

    editExtra: function (cmp, event, helper, recId) {
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.getContractExtraToEdit");
        action.setParams({
            recId: recId
        });
        //debugger;
        action.setCallback(this, function (response) {
            var state = response.getState();
            var extrasVal = response.getReturnValue();
            console.log("extrasVal: " + JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                cmp.set("v.extrasValId", extrasVal.Id);
                cmp.set("v.typeExtra", extrasVal.Type_Extra__c);
                if(extrasVal.Type_Extra__c == 'OTHER'){
                    cmp.set("v.extraOtherDescriptionField",true);
                    cmp.set("v.otherExtraDescription", extrasVal.Other_Extra_Description__c);
                }
                
                cmp.set("v.additionalFeeAmount", extrasVal.Additional_Fee_Amount__c);
                cmp.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },

    confirmDelete: function (cmp, event, helper, recId) {
        component.set("v.showConfirmDialog", true);
    },

    successMsg: function (component, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "success",
            title: "Success!",
            message: msg
        });
        toastEvent.fire();
    },

    errorMsg: function (msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "error",
            title: "Error!",
            message: msg
        });
        toastEvent.fire();
    },
    editableController: function (component, event, helper) {
       // helper.hideChildCmp(component, event); // Hide all components and show only selected child component
        var isEditable = component.get("v.isEditable");
        console.log("value is" + isEditable);
        if (isEditable == false) {
            var btnaddNewExtra = component.find("btnaddNewExtra");
            $A.util.addClass(btnaddNewExtra, "slds-hide");
        }else {
            $A.util.removeClass(btnaddNewExtra, "slds-hide");
            //  block of code to be executed if the condition1 is false and condition2 is false
        }
    },
});