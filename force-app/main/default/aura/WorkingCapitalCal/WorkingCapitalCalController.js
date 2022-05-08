({
	doInit : function(component, event, helper) {
        helper.getWorkingcapitalProcessDataResponse(component);        
	},
       
    printComponent :function(component,event,helper){
            window.print();
    },
    
    handleSelect : function(component, event, helper) {
	},
    
    changeHandler : function(component, event, helper) {
    },
    
    handleSave : function(component, event, helper) {
    },
    
    handleCancle : function(component, event, helper) {
    },
    
    handleExportToPDF : function(component, event, helper) {
    },
    
    editReceivable : function(component, event, helper) {
        component.set("v.isEditableReceivable", true);
    },
	editInventory : function(component, event, helper) {
        component.set("v.isEditableInventory", true);
    },
    editPayable : function(component, event, helper) {
        component.set("v.isEditablePayable", true);
    },
    saveReceivable : function(component, event, helper) {
        if(helper.validateInputEntries(component, event, helper)) {
            helper.saveReceivableHelper(component);
            component.set("v.isEditableReceivable", false);
        }
    },
	saveInventory : function(component, event, helper) {
        if(helper.validateInputEntries(component, event, helper)) {
            helper.saveInventoryHelper(component);
            component.set("v.isEditableInventory", false);
        }
    },
    savePayable : function(component, event, helper) {
        if(helper.validateInputEntries(component, event, helper)) {
            helper.savePayableHelper(component);
            component.set("v.isEditablePayable", false);
        }
    },
    saveAsPdf: function(component,event,helper){
        window.print();
    }
})