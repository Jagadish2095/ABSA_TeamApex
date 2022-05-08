({
    releaseSimHoldHandler: function(component, event, helper) {

        var maxCounts = $A.get("$Label.c.DBS_ActionMaxRepeats")
        component.set("v.maxRepeats", maxCounts);
        component.set("v.showOverlay", false);

		helper.disAbleActionButtons(component, event, 'true');

        helper.releaseSimHoldHelper(component, event);
    },
    cancelOverlay: function(component, event, helper) {
        component.set("v.showOverlay", false);
    },
})