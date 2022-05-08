({
    doInit: function (component, event, helper) {
        var recordId = component.get("v.recId");
        var isEditable = component.get("v.isEditable");
        console.log("ContractExtra isEditable doInit " + isEditable);
        helper.fetchContractExtras(component, event, helper, recordId);
        helper.getTypeExtraPicklistValues(component, event, helper);
       // helper.editableController(component, event, helper);
        
    },

    addNewExtra: function (component, event, helper) {
        var sanctioningStatus = component.get("v.opportunityRecord2.CAF_Sanctioning_Status__c");
        console.log("sanctioningStatus 2 " + sanctioningStatus);

        if (sanctioningStatus == "Submitted" || sanctioningStatus == "Allocated To Sanctioner") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: "This opportunity is currently awaiting sanctioning, please wait for the decision before making changes."
            });
            toastEvent.fire();
        } else {
            component.set("v.openNewExtraBlockValue", "Yes");
        }
    },

    btnSaveExtras: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var msg = "";
        var err = 0;
        var recordId = component.get("v.recId");
        var extrasValId = component.get("v.extrasValId");
        var oppId = component.get("v.oppId");
        var typeExtra = component.get("v.typeExtra");
        var otherExtraDescription = '';
        
        if(component.get("v.extraOtherDescriptionField")){
            
            otherExtraDescription = component.get("v.otherExtraDescription");
            if (otherExtraDescription == "") {
                err++;
                msg += "Enter Extra Description<br/>";
            }
            
        }

        var additionalFeeAmount = component.find("additionalFeeAmount").get("v.value");

        if (typeExtra == "") {
            err++;
            msg += "Select Type Extra<br/>";
        }
        if (additionalFeeAmount == "") {
            err++;
            msg += "Select Additional Fee Amount<br/>";
        }
        //debugger;
        if (err == 0) {
            var action = "";
            if (extrasValId == "") {
                action = component.get("c.addContractExtras");
                action.setParams({
                    oppId: oppId,
                    recordId: recordId,
                    typeExtra: typeExtra,
                    otherExtraDescription:otherExtraDescription,
                    additionalFeeAmount: additionalFeeAmount
                });
            } else {
                action = component.get("c.updateContractExtras");
                action.setParams({
                    recordId: extrasValId,
                    typeExtra: typeExtra,
                    otherExtraDescription:otherExtraDescription,
                    additionalFeeAmount: additionalFeeAmount
                });
            }

            action.setCallback(this, function (response) {
                //debugger;
                var state = response.getState();
                var extrasVal = response.getReturnValue();
                //debugger;
                if (state === "SUCCESS") {
                    msg = "Saved Successfully";

                    helper.fetchContractExtras(component, event, helper, recordId);
                    $A.enqueueAction(component.get("c.btncancel"));
                    helper.successMsg(component, extrasVal);
                } else {
                    helper.errorMsg(msg);
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        } else {
            helper.errorMsg(msg);
            component.set("v.showSpinner", false);
        }
    },

    handleRowAction: function (cmp, event, helper, recId) {
        var action = event.getParam("action");
        var row = event.getParam("row");
        var recId = row.Id; //'00k3N000006lsaxQAA';

        switch (action.name) {
            case "edit":
                helper.editExtra(cmp, event, helper, recId);
                cmp.set("v.openNewExtraBlockValue", "Yes");

                break;
            case "delete":
                cmp.set("v.recordId", recId);
                cmp.set("v.showConfirmDialog", "true");
                /*
                    var viewRecordEvent = $A.get("e.force:navigateToURL");
                    viewRecordEvent.setParams({
                        "url": "/" + recId
                    });
                    viewRecordEvent.fire();
                    */
                break;
        }
    },

    btncancel: function (component, event, helper) {
        component.set("v.recordId", "");
        component.set("v.typeExtra", "");
        component.set("v.otherExtraDescription", "");
        component.set("v.extrasValId", "");
        component.set("v.additionalFeeAmount", "");
    },

    callChildMethodExtras: function (component, event, helper) {
        var params = event.getParam("arguments");
        console.log("recordId>>" + params.appId);
        helper.fetchContractExtras(component, event, helper, params.appId);
        //alert("mehtod called from parent");
    },

    contractExtras: function (component, event, helper) {
        var Contract_Extras = component.get("v.typeExtra");
        //alert('Statement delivery method :'+Contract_Extras);
    },

    onPickListTypeExtraChange: function (component, event, helper) {
        component.set("v.typeExtra", event.getSource().get("v.value"));
        var typeExtraval = component.get("v.typeExtra");
        component.set("v.extraOtherDescriptionField",false);
        if(typeExtraval == 'OTHER'){
            component.set("v.extraOtherDescriptionField",true);
        }
        //console.log('typeExtraval==='+typeExtraval);
    }
});