({
    navigateToPersonalDataConsent: function (component, event) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:NewCCPresonalDataConsent",
        });
        evt.fire();
    },
})