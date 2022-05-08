({
    doInit: function(component, event, helper){
        console.log('riderInstance' + JSON.stringify(component.get("v.riderInstance")));
    },
    handleRowSelect : function(component, event, helper){
        var selectedMenu = event.detail.menuItem.get("v.value");
        switch(selectedMenu) {
            case "edit":
                component.getEvent("editRowEvt").setParams({"indexVar" : component.get("v.rowIndex"),"raiderDetails" : component.get("v.riderInstance") }).fire(); 
                break;
            case "delete":
                component.getEvent("removeRowEvt").setParams({"indexVar" : component.get("v.rowIndex"),"raiderDetails" : component.get("v.riderInstance")}).fire();
                break;
        }
    },
    removeRow : function(component, event, helper){
        component.getEvent("removeRowEvt").setParams({"indexVar" : component.get("v.rowIndex"),"raiderDetails" : component.get("v.riderInstance") }).fire();
    },
    editRow:function(component, event, helper){
        component.getEvent("editRowEvt").setParams({"indexVar" : component.get("v.rowIndex"),"raiderDetails" : component.get("v.riderInstance") }).fire(); 
    }
})