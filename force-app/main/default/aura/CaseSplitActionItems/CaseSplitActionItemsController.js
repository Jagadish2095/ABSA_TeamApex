({
    addNewRow : function(component, event, helper){
        var serviceGroup = component.get("v.CaseInstance.Service_Group_Search__c");
        console.log('Service Group : ' + serviceGroup);
        component.getEvent("AddRowEvt").fire();     
    },
    removeRow : function(component, event, helper){
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }
})