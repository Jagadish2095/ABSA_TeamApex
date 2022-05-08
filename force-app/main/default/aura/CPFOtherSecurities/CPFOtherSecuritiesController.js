({
	doInit : function(component, event, helper) {
      helper.getSecurityofferedCpfRec(component, event, helper);
    },
    addOtherSecurityCessions: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
            helper.addNewSecurityCessions(component, event);
        },
   handleApplicationEventAction : function(component, event,helper) {
        var appProductCpfRecId = event.getParam("appProdctCpfRecId");
        var otherSecuritiesRowIndex =event.getParam("RowIndex");//"rowIndex"
        var otherSecuritiesList=component.get("v.newOtherSecurities");
        otherSecuritiesList.splice(otherSecuritiesRowIndex,1);
         component.set("v.newOtherSecurities",otherSecuritiesList);
    },
    handleSecuritiesSubmit : function(component, event, helper) {
         component.set("v.showSpinner", true);
         var itemsToPass=component.get("v.newOtherSecurities");
           helper.InsertOtherSecurityOfferedCpf(component, event, helper);
    },
    
})