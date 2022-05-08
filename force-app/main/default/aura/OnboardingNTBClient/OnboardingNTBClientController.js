({
    doInit : function(component, event, helper) {
    },
    NavigateComponent : function(component, event, helper) {
        var cmpTarget = component.find('clientFinderDiv');
        $A.util.addClass(cmpTarget, "slds-hide");
        if(event.getParam("navigate") == "true")  {
            $A.createComponent("c:OnboardingNTBCFlow", {
                    "accRec" : event.getParam("accountId"),
                    "conRec" : event.getParam("contactId")
                }, function(newCmp) {
                    if (component.isValid()) {
                        component.set("v.body", newCmp);
                    }
                });
        }
    }
})