({
    doInit: function (component, event, helper) {
        //alert('Hello1');
        helper.getPickListItems(component);
        helper.getNewChequeAndOverdraft(component);
        helper.getChequeAccounts(component);
    },

    proceedWithSelectedAccs: function (component, event, helper) {
        var conItems = component.get("v.conductData");

        if (conItems == '') {
            var toastEvent = helper.getToast("Error!", "Please Select Primary and Additional Conducts", "Error");
            toastEvent.fire();
        }
        /*else if (component.get("v.additionalConductSelected") == null && helper.totalNumAccounts(component) < 1) {
            var toastEvent = helper.getToast("Error!", "Please Select Additional Conduct", "Error");
            toastEvent.fire();
        }*/
        else if (conItems || (component.get("v.additionalConductSelected") == null && helper.totalNumAccounts(component) < 1)) {
            helper.getAndSaveClientConductDetails(component, conItems);
        }
    },

    addNewAccount: function (component, event, helper) {
        if (helper.totalNumAccounts(component) < 5) {
            helper.addNewAccount(component, event);
            component.set("v.isActiveNewAccount", true);
        }
        else {
            var toastEvent = helper.getToast("Error!", "The maximum number of accounts that can be done in a single application is 5", "Error");
            toastEvent.fire();
        }
    },

    saveChqAndOverdraft: function (component, event, helper) {
        helper.saveChequeAndOverdraft(component);
    },

    onCheckedFacility: function (component, event, helper) {
        var target = event.getSource();
        var chValue = target.get("v.value"); //is checkbox selected
        var chText = target.get("v.text"); //id of account selected
        helper.selectFacilityAccounts(component, target, chValue, chText);
    },

    onRadioChangePrimary: function (component, event, helper) {
        var target = event.getSource();
        var rdPValue = target.get("v.value");
        var rdPText = target.get("v.text");
        var rdAText = component.get("v.additionalConductSelected");

        component.set("v.primaryConductSelected", [{ "PrimaryAccount": rdPText, "Selected": rdPValue }]);

        helper.eventHander(component, rdAText);
    },

    onRadioChangeAdditional: function (component, event, helper) {
        var target = event.getSource();
        var rdAText = target.get("v.text");

        component.set("v.additionalConductSelected", rdAText);
        helper.eventHander(component, rdAText);
    },

    handleShowModal: function (component, event, helper) {
        component.set("v.modRecordId", event.target.id);
        component.set("v.isModalVisble", true);

        var childCmp = component.find("chqDetails")
        childCmp.reInit(component, event, helper);
        childCmp.toggleModal(component, event, helper);
    },

    //Saurabh : 2021/04/23
    handleConfirmDialog: function (component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },

    handleConfirmDialogYes: function (component, event, helper) {
        console.log('Yes');
        //call the delete helper from here
        helper.deleteFacilityAccountsAndReset(component);
        component.set('v.showConfirmDialog', false);
    },

    handleConfirmDialogNo: function (component, event, helper) {
        console.log('No');
        component.set('v.showConfirmDialog', false);
    },

})