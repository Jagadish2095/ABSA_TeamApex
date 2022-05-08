({
    doInit: function (component, event, helper) {
        var action = component.get("c.getRequestedProducts");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---' + JSON.stringify(results));
                component.set("v.prodrecList", results);
                for (var i in results) {
                    if (results[i].Product_Name__c === 'Cheque') {
                        component.set('v.prodName', results[i].Product_Name__c);
                    }
                    if (results[i].Product_Name__c === 'Credit Card') {
                        component.set('v.prodName', results[i].Product_Name__c);
                    }
                    if (results[i].Product_Name__c === 'Bank Guarantee') {
                        component.set('v.prodName', results[i].Product_Name__c);
                    }
                }

            }
        });
        $A.enqueueAction(action);
    },

    handleSelect: function (component, event, helper) {
        var selected = event.getParam('name');
        component.set("v.selectedTab", selected);
    }
})