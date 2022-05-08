({
    doInit : function(component, event, helper) {
        helper.getAppPrdctCpfRec(component, event, helper);
        helper.getAppConClauseCpfRec(component, event, helper);
        helper.getAppConClauseCpfReclst(component, event, helper);
    },
    
    addOtherdrawdownbtn : function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddOtherdrawdown(component, event);
    },
    addOtherfinaldrawdownbtn: function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddOtherfinaldrawdown(component, event);
    },
    handleOtherfinaldrawdownSubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.SaveOtherfinaldrawdown(component, event);
    },
    
    
    handleOtheDrawdownAppEvent : function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var otherdrawdownlist=component.get("v.newOtherDrawDownConditions");
        otherdrawdownlist.splice(rowinex,1);
        component.set("v.newOtherDrawDownConditions",otherdrawdownlist);
    },
    handleOtherfinalDrawdownAppEvent: function(component, event,helper) {
        var rowinexfinal =event.getParam("RowIndex");
        var otherfinaldrawdownlist=component.get("v.newOtherFinalDrawDownConditions");
        otherfinaldrawdownlist.splice(rowinexfinal,1);
        component.set("v.newOtherFinalDrawDownConditions",otherfinaldrawdownlist);
    },
    handleSuccess : function(component, event, helper) {
        
        helper.fireToast("Success!", "Final Drawdown Conditions Saved Successfully.", "success");
        
        /*var toastEvent = $A.get("e.force:showToast");
toastEvent.setParams({
    title : 'Final Drawdown Conditions Saved Successfully',
    message: 'Final Drawdown Conditions Saved Successfully!',
    duration:' 4000',
    key: 'info_alt',
    type: 'success',
    mode: 'pester'
});
toastEvent.fire();*/
    },
    
    handleError : function(component, event, helper) {
        
        var componentName = 'cpfFinalDrawdownConditions';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.fireToast("Error!", "There has been an error saving the data.", "error");
    },
    
})