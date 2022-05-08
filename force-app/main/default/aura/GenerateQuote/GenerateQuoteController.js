({
    doInit: function (component, event, helper) {

        helper.initializePicklist(component, event);

        var ProdId = component.get("v.appProdId");
        var action = component.get("c.generateQuote");
        action.setParams({
            "ProdId": component.get("v.appProdId"),
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
                console.log('quoteWrap.margin' + JSON.stringify(component.get('v.quoteWrap.margin')));
                if (results != null && results.LimitType != null) {
                    helper.limitTypeChange(component, results.LimitType);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log('Error' + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    saveQuote: function (component, event, helper) {
        var quote = component.get("v.quoteWrap");
        console.log("save Quote---" + JSON.stringify(quote));
        var action = component.get("c.saveQuotes");
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
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Quote Data Saved Successfully"
                });
                toastEvent.fire();
                //component.set("v.quoteWrap",results);
            }
        });
        $A.enqueueAction(action);
    },


    onSetTargetAmount: function (component, event, helper) {
        var overdraftlimit = component.get("v.quoteWrap.creditLimit");
        var accitems = component.get("v.quoteWrap.variablemap");
        var len = accitems.length;
        var itemId = event.getSource().get("v.name");
        var reduceamount = event.getSource().get("v.value");
        console.log('limit--' + overdraftlimit);
        console.log('accitems--' + accitems);
        console.log('len--' + len);
        var variablesAmount = 0;
        console.log('itemId---' + itemId);
        for (var i = 0; i < len; i++) {
            if (parseFloat(accitems[i].variableAmount) == 0) {
                continue;
            }
            //=  accitems[i].variableAmount;
            //variablesAmount =variablesAmount + parseFloat(accitems[i].variableAmount) ;
            variablesAmount = parseFloat(accitems[i].variableAmount);
            for (var j = 0; j < i; j++) {
                console.log('debug---' + accitems[j].variableAmount);
                variablesAmount = variablesAmount + parseFloat(accitems[j].variableAmount);

            }
            console.log('variablesAmount---' + variablesAmount);
            //if (accitems[i].Id == itemId) {
            accitems[i].targetAmount = overdraftlimit - variablesAmount;

            // } 




        }
        //console.log('accitems--'+accitems);
        component.set("v.quoteWrap.variablemap", accitems);
    },
    onSetMinDate: function (component, event, helper) {
        var accitems = component.get("v.quoteWrap.variablemap");
        var itemId = event.getSource().get("v.name");
        var currDate = event.getSource().get("v.value");
        var len = accitems.length;

        for (var i = 0; i < len; i++) {
            if (accitems[i].Id == itemId) {
                var nextDate = new Date((new Date(accitems[i + 1].VariableDate)).valueOf());
                var nowDate = new Date((new Date(currDate)).valueOf());

                if (nextDate != null && nextDate.getFullYear() == nowDate.getFullYear() && nextDate.getMonth() == nowDate.getMonth() && nextDate.getDate() < nowDate.getDate()) {
                    var toastEvent = helper.getToast("Error!", "Your dates must be in sequencial order!", "error");
                    toastEvent.fire();
                    event.getSource().set("v.value", null);
                }
                else {
                    for (var j = i; j < len; j++) {
                        if (j < (len - 1)) {
                            var newDate = new Date((new Date(currDate)).valueOf() + 86400000);
                            accitems[j + 1].MinDate = newDate.getFullYear() + "-" + (newDate.getMonth() + 1) + "-" + newDate.getDate();
                            //accitems[j + 1].MaxDate = (newDate.getFullYear() + 1) + "-" + (newDate.getMonth() + 1) + "-" + (newDate.getDate() - 2); //add year
                        }
                    }
                }

                break;
            }
        }

        component.set("v.quoteWrap.variablemap", accitems);
    },

    onLimitSelectChange: function (component, event, helper) {
        var target = event.getSource();
        //var selectedOptionValue = event.getParam("value");
        var selectCmp = target.get("v.value");  //which dropdownlist option is selected

        helper.limitTypeChange(component, selectCmp);
    },
})