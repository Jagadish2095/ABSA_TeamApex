({
    doInit: function (component, event, helper) {

        // helper.initializePicklist(component,event);

        var CardTypeOptions = [
            { label: "--None--", value: "--None--", selected: "true" },
            { label: "VISA", value: "VISA" },
            { label: "MASTER", value: "MASTER" }


        ];
        component.set('v.CardOptions', CardTypeOptions);


        var action = component.get("c.generateCCQuoteFunction");
        action.setParams({
            "prodId": component.get("v.appProdId"),
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('results quote generation---' + state);
            //alert('results quote generation---'+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---' + JSON.stringify(results));
                component.set("v.quoteWrap", results);
            }
        });
        $A.enqueueAction(action);
    },
    calculateQ: function (component, event, helper) {
        var quote = component.get("v.quoteWrap");
        console.log("save Quote---" + JSON.stringify(quote));

        var action = component.get("c.calculateQuotes");
        action.setParams({
            "QuoteWrap": JSON.stringify(quote),
            "ProdId": component.get("v.appProdId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('results quote generation---' + state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---' + JSON.stringify(results));
                component.set("v.quoteWrap", results);
                component.set("v.showQuote", true);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Quote Data Saved Successfully"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})