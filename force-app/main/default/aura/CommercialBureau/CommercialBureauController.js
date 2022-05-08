({
    doInit: function (component, event, helper) {
        var comBureauData = component.get("v.commBureauData");
        var appEvent = $A.get("e.c:creditOriginationEvent");

        Promise.all([helper.handleInit(component)]).then(function (results) {
            console.log('results'+JSON.stringify(results));
            var p1Results = results[0];
            console.log('p1Results'+JSON.stringify(p1Results));
            component.set("v.commBureauData",p1Results);
            helper.handleOnRender(component);
            if (p1Results != null) {
                if (appEvent) {
                    appEvent.setParams({ "sourceComponent": "CommercialBureau" });
                    appEvent.setParams({ "commBureauData": p1Results });
                    appEvent.fire();
                }
            }
        }).catch(function (err) {
            helper.showToast("error", "Error!", err);
        });
        //helper.handleInit(component);
    },
    onRender: function (component, event, helper) {
        helper.handleOnRender(component);
    },

    //Adding the Application event handler to refresh the data after PCO success
    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");

        // Condition to not handle self raised event
        if (sourceComponent == 'Validation03') {
            //calling Init on App Event
            component.set("v.commBureauDataChanged", true);
            component.set("v.showSpinner", true);

            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    }
})