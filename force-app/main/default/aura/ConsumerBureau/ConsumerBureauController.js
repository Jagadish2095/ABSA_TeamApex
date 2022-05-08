({
    doInit: function (component, event, helper) {
        var bureauData = component.get("v.consBureauData");
        var appEvent = $A.get("e.c:creditOriginationEvent");

        Promise.all([helper.handleInit(component)]).then(function (results) {
            var p1Results = results[0];
            component.set("v.consBureauData",p1Results);
            helper.handleOnRender(component);
            if (p1Results != null) {
                if (appEvent) {
                    appEvent.setParams({ "sourceComponent": "ConsumerBureau" });
                    appEvent.setParams({ "consBureauData": p1Results });
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
        console.log("ConsumerBurea: Source is: " + sourceComponent + " should be: Validation03");

        // Condition to not handle self raised event
        if (sourceComponent == 'Validation03') {
            //calling Init on App Event
            component.set("v.showSpinner", true);

            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    }
})