({
    fetchCases: function (component, event, helper) {
        var relatedAccountId = component.get("v.leadRecord.FinServ__RelatedAccount__c");

        if (relatedAccountId != null) {
            component.set("v.hasRelatedAccount", true);

            var accAction = component.get("c.fetchClientCases");

            accAction.setParams({
                accountId: relatedAccountId
            });

            accAction.setCallback(this, function (response) {
                var accActionState = response.getState();

                if (accActionState === "SUCCESS") {
                    component.set("v.clientCases", response.getReturnValue());
                } else if (accActionState === "ERROR") {
                    var errors = response.getError();
                    component.set("v.errorMessage", "Apex error AccountRelatedItemsExt.fetchClientCases: " + JSON.stringify(errors));
                } else {
                    component.set("v.errorMessage", "Unexpected error occurred, state returned: " + accActionState);
                }
            });

            $A.enqueueAction(accAction);
        } else {
            component.set("v.hasRelatedAccount", false);
        }

        $A.enqueueAction(action);
    },

    leadRecordUpdated: function (component, event, helper) {
        var eventParams = event.getParams();
        if (eventParams.changeType === "LOADED") {
            var leadRecord = component.get("v.leadRecord");
            if (leadRecord) {
                var relatedAccountId = component.get("v.leadRecord.FinServ__RelatedAccount__c");
                if (relatedAccountId) {
                    component.set("v.hasRelatedAccount", true);
                    $A.enqueueAction(component.get("c.refreshView"));
                } else {
                    component.set("v.hasRelatedAccount", false);
                }
            }
        } else if (eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            var changedFields = eventParams.changedFields;
            var relatedAccountId = changedFields.FinServ__RelatedAccount__c;
            if (relatedAccountId) {
                helper.showSpinner(component);
                $A.enqueueAction(component.get("c.refreshView"));
            } else {
                component.set("v.hasRelatedAccount", false);
            }
        }
    },

    naviteToCaseRecord: function (component, event, helper) {
        var recordId = event.target.dataset.caseid;

        var event = $A.get("e.force:navigateToSObject");

        if (event) {
            event.setParams({ recordId: recordId }).fire();
        }
    },

    refreshView: function (component, event, helper) {
        helper.showSpinner(component);
        $A.enqueueAction(component.get("c.fetchCases"));
        helper.hideSpinner(component);
    }
});