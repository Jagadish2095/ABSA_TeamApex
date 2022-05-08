({
    doInit : function(component, event, helper) {
        var selectedProdType = component.get('v.selectedProductValue')
        console.log("selectedProdType: " + selectedProdType);
        if(selectedProdType ==='SA'){
            helper.getSavingHolds(component,event,helper);
            component.set("v.showSVHolds",true);
            component.set("v.showChequeHolds",false);
        }
        if(selectedProdType ==='CQ'){
            helper.getChequeHolds(component, event, helper);
            component.set("v.showSVHolds",false);
            component.set("v.showChequeHolds",true);
        }
    },

    handleClickUpdate : function(component, event, helper) {
        var selectedProdType = component.get('v.selectedProductValue');
        var result = component.get("v.savingList");

        if(selectedProdType ==='SA'){
            component.set("v.updateSavingHolds", true);
        }
        if(selectedProdType ==='CQ'){
          component.set("v.updateChequeHolds", true);
        }
    },

    updateSavingHolds : function(component, event, helper) {
        helper.updateSavingHolds(component, event, helper);
    },

    updateChequeHolds : function(component, event, helper) {
        helper.updateChequeHolds(component, event, helper);
    },

    cancel : function(component, event, helper) {
        component.set("v.updateSavingHolds", false);
    },

    cancelCheque : function(component, event, helper) {
        component.set("v.updateChequeHolds", false);
    },

})