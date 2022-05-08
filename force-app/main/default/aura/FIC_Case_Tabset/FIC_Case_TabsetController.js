({
    tabSelected: function(component, event, helper) {
        let res = component.get("v.selTabId");
        let evt = $A.get("e.c:FIC_Case_Tabname");
        evt.setParams({
            "PassTabName": res
        });
        evt.fire();
    },

    // doInit: function(component, event, helper) {
    //     helper.getCase(component, event, helper)
    // }
})