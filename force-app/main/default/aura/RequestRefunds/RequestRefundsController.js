({
    doInit: function(component, event, helper) {
        console.log(component.get("v.navigateFlow"))
        if(component.get("v.product") === 'CA'){
        let accountNumber = component.get("v.selectedAccountNumberFromFlow")
        accountNumber = accountNumber.slice(0, -2) + '00';
        component.set("v.selectedAccountNumberFromFlow", accountNumber);
        }
        let modalsToDisplay = component.get("v.modalsToDisplay");
        var modalObject = new Object();
        for (var element of modalsToDisplay) {
            console.log(element);
            modalObject[element] = true;
        }
        component.set("v.modalObject", modalObject);
        helper.checkRefund(component, event);
        helper.checkIfCustomerIsOnPTP(component, event);
    },

    getValueRefundDetails: function(component, event, helper) {
        component.set("v.showRefundDetails", event.getSource().get('v.checked'))
    },
})