({
    doInit :function(component, event, helper) {
        helper.doInit(component, event, helper);
        component.set('v.importRestrictionColumns', [
            {label: 'Name', fieldName: 'ObjectID', type: 'text'},
            {label: 'Entity Type', fieldName: 'EntityType', type: 'text'},
            {label: 'Description', fieldName: 'Description', type: 'text'},
            {label: 'Start Date', fieldName: 'EffectiveStartDate', type: 'Date'},
            {label: 'End Date', fieldName: 'EffectiveEndDate', type: 'Date'}
        ]);
    },
    
    closeModal : function(component, event, helper) {
        component.destroy();
    },
    
    handleImport : function(component, event, helper) {
        var selectedRows = component.get("v.selectedRecords");
        if(selectedRows != undefined && selectedRows.length > 0){
            component.set("v.showConfirmationModal", true);
            component.set("v.body", "Are you sure you want to Import the Selected Group Restrictions(?)");
        }
        else{
            component.set("v.showConfirmationModal", true);
            component.set("v.body", "At least one Group Restriction must be selected for Import");
        }  
    },
    
    onToggle : function(component, event, helper) {
        helper.onToggle(component, event, helper);
    },
    
    updateSelectedRows : function(component, event, helper){
        helper.updateSelectedRows(component, event, helper);
    },
    
    closeConfirmModal : function(component, event, helper){
        component.set("v.showConfirmationModal", false);
    },
    
    confirmImport : function(component, event, helper){
        helper.import(component, event, helper);
        //component.destroy();
    },
    
    handleSearch : function(component, event, helper){
    }
})