({
    getComponentDataAttributes: function (component) {
        return [
            'accountType',
            'selectedChequeAccount',
        ];
    },

    getClientAccountNumbers: function (component) {
        component.set('v.showSpinner', true);
        let action = component.get('c.getClientAccountNumbers');
        let clientKey = component.get('v.clientKey');

        action.setParams({
            clientKey: clientKey
        });

        action.setCallback(this, function (response) {
            let state = response.getState();

            if (state === "SUCCESS") {
                let accountsNumbers = [];

                let outputTable = response.getReturnValue();

                outputTable.forEach(item => {
                    //TODO we need to add filtering by parametr from flow
                    if (item.status === undefined || item.status.toUpperCase() != "CLOSED") {
                        let accountNumber = +item.oaccntnbr;

                        accountsNumbers.push({
                            label: item.product + ' (' + accountNumber + ')',
                            value: item.oaccntnbr,
                            accountType: item.product
                        });
                    }
                });

                component.set('v.accountsNumbers', accountsNumbers);
                component.set('v.showSpinner', false);
            } else if (state === "ERROR") {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": response.getError()[0].message,
                    "mode": "sticky",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },
})