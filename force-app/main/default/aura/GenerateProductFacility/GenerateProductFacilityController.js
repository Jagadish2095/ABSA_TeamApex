({
    doInit: function (component, event, helper) {
        helper.initializePicklist(component, event);


        var RegpayDateOptions = [
            { label: '1', value: '1', selected: "true" },
            { label: '2', value: '2' },
            { label: '3', value: '3' },
            { label: '4', value: '4' },
            { label: '5', value: '5' },
            { label: '6', value: '6' },
            { label: '7', value: '7' },
            { label: '8', value: '8' },
            { label: '9', value: '9' },
            { label: '10', value: '10' },
            { label: '11', value: '11' },
            { label: '12', value: '12' },
            { label: '13', value: '13' },
            { label: '14', value: '14' },
            { label: '15', value: '15' },
            { label: '16', value: '16' },
            { label: '17', value: '17' },
            { label: '18', value: '18' },
            { label: '19', value: '19' },
            { label: '20', value: '20' },
            { label: '21', value: '21' },
            { label: '22', value: '22' },
            { label: '23', value: '23' },
            { label: '24', value: '24' },
            { label: '25', value: '25' },
            { label: '26', value: '26' },
            { label: '27', value: '27' },
            { label: '28', value: '28' },
            { label: '29', value: '29' },
            { label: '30', value: '30' },
            { label: '31', value: '31' }
        ];
        component.set('v.RegpayDateOptions', RegpayDateOptions);

        var action = component.get("c.getProductFacility");
        action.setParams({
            "prodId": component.get("v.appProdId"),
            "oppId": component.get("v.recordId")

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('results success or error---' + JSON.stringify(state));
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---' + JSON.stringify(results));
                component.set("v.facilityWrap", results);

                if (results.facilitiesSelected != null) {
                    var stringSelected = results.facilitiesSelected;
                    console.log('stringSelected---' + stringSelected);
                    var selectedOptions = [];
                    selectedOptions = stringSelected.split(',');
                    component.set("v.facilitiesSelected", selectedOptions);
                } if (results.specialConditionsSelected != null) {
                    var stringSelected = results.specialConditionsSelected;
                    console.log('stringSelected---' + stringSelected);
                    var selectedOptions = [];
                    selectedOptions = stringSelected.split(',');
                    component.set("v.specialConditionsSelected", selectedOptions);
                }
            }
        });
        $A.enqueueAction(action);


    },

    saveFacility: function (component, event, helper) {


        var facility = component.get("v.facilityWrap");

        console.log("save facility---" + JSON.stringify(facility));

        var action = component.get("c.saveFacilityWrap");
        action.setParams({
            "facilityWrap": JSON.stringify(facility),
            "ProdId": component.get("v.appProdId")

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('results quote generation---' + state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---' + JSON.stringify(results));
                //component.set("v.quoteWrap",results);
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
    },

    //
    generalFacilitySelection: function (component, event) {
        var selectedOptionValue = event.getParam("value");

        component.set('v.isGeneralFacilityValue', selectedOptionValue);

    },

    onSetTargetAmount: function (component, event, helper) {
        var overdraftlimit = component.get("v.facilityWrap.creditLimit");
        var accitems = component.get("v.facilityWrap.variablemap");
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
        component.set("v.facilityWrap.variablemap", accitems);
    },

    onSetMinDate: function (component, event, helper) {
        var accitems = component.get("v.facilityWrap.variablemap");
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

        component.set("v.facilityWrap.variablemap", accitems);
    },

    onLimitSelectChange: function (component, event, helper) {
        var target = event.getSource();
        //var selectedOptionValue = event.getParam("value");
        var selectCmp = target.get("v.value");  //which dropdownlist option is selected

        helper.limitTypeChange(component, selectCmp);
    },
})