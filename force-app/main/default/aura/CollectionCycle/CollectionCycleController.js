({
    handleCaseLoad: function(component, event, helper) {

        if (component.find("originalServiceGroupId").get("v.value") === 'Everyday Banking - Collections' &&
            (component.find("type").get("v.value") === 'Request Refunds' ||
                component.find("type").get("v.value") === 'Early risk detection- High Over limit' ||
                component.find("type").get("v.value") === 'Early risk detection- Runaway High over limit' ||
                component.find("type").get("v.value") === 'Early risk detection- Possible fraud detection'
            )
        ) {
            component.set("v.showSpinner", true);
            helper.cacheResponseData(component, event,helper);

        } else {
            helper.getJson(component, event);
            component.set("v.firstFraud", true);
        }

    },

    openModal: function(component, event, helper) {
        helper.openModal(component, event, helper);
    },

    closeTransactionHistoryModal: function(component, event, helper) {
        component.set("v.openTransactionHistory", false)
    },

    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    closeRefund: function(component, event, helper) {
        component.set("v.showRefund", false);
    },
    openRefund: function(component, event, helper) {
        component.set("v.showRefund", true);
    },
    openTransactionHistory: function(component, event, helper) {
        component.set("v.openTransactionHistory", true);
    },
    closeTransactionHistory: function(component, event, helper) {
        component.set("v.openTransactionHistory", false);
    },
});