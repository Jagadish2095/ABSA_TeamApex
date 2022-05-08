({
    doInit :function(component,event,helper) {
        helper.getCase(component,event,helper);
        helper.getDocumentsOrder(component,event,helper);
    },

     onRefreshView :function(component,event,helper) {
            helper.getCase(component,event,helper)
        },
    openReferralModal : function(component,event,helper) {
        component.set("v.openReferral", true);

    },
    closeFailModal : function(component,event,helper) {
        component.set("v.openFail", false);
    },

    closeReferralModal : function(component,event,helper) {
        component.set("v.openReferral", false);
    },

    openFailModal : function(component,event,helper) {
        component.set("v.openFail", true);
    },

    openPassModal : function(component,event,helper) {
       helper.ifDocumentAreFulfill(component,event,helper);
    },

    closePassModal : function(component,event,helper) {
        component.set("v.openPass", false);
    },

    handleReferralButton : function(component,event,helper) {
     helper.handleReferral(component,event,helper);
    },

    handleFailButton : function(component,event,helper) {
         helper.handleFail(component,event,helper);
     },

     handlePassButton : function(component,event,helper) {
              helper.handlePass(component,event,helper);
     },
})