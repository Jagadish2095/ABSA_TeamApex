({
    doInit: function (component, event, helper) {
        helper.initializeOptions(component);
        helper.getFacilities(component);
    },

    saveFacilities: function (component, event, helper) {
        helper.saveFacilities(component);
    },

    onRadioChange: function (component, event, helper) {
        var value = event.getParam("value");
        helper.selectDefaultRadioValue(component, value);
    },

    onAmtChange: function (component, event, helper) {
        var accName = event.getSource().get("v.name");
        var itemsObject = component.get("v.nonfacData");

        var totalEx = 0, totalInt = 0;
        for (var i = 0; i < itemsObject.length; i++) {

            //based on which item rows to add
            if (i < 7 || (i > 7 && i < 15) || (i > 15 && i < 23)
                || (i > 23 && i < 31) || (i > 31 && i < 39) || (i > 39 && i < 47)) {
                var child = itemsObject[i];
                if (child.ExposureNonScored) {
                    totalEx += parseFloat(child.ExposureNonScored);
                }
                if (child.InstallmentsNonScored) {
                    totalInt += parseFloat(child.InstallmentsNonScored);
                }
            }

            //based on where the total row is
            if (i == 7 || i == 15 || i == 23 || i == 31 || i == 39 || i == 47) {
                var childTotal = itemsObject[i];
                if (accName == "ExposureNonScored") {
                    childTotal.ExposureNonScoredTotal = totalEx.toFixed(2);
                }
                else {
                    childTotal.InstallmentsNonScoredTotal = totalInt.toFixed(2);
                }
                //clear total for new rows
                totalEx = 0, totalInt = 0;
            }
        }
        component.set("v.nonfacData", itemsObject);
    },
    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        var opportunityId = event.getParam("opportunityId");
        
        // Condition to not handle self raised event
        if ((sourceComponent == 'SolePropSpouseDetail' || sourceComponent == 'CheckAndOverdraft' ) && (opportunityId != null && opportunityId != '')) {
            //calling Init on App Event 'SolePropSpouseDetail'
            console.log('App event subscribed here'+sourceComponent);
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    }
})