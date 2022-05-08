({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'File Name', fieldName: 'Title', type: 'text'},
            {label: 'File Extension', fieldName: 'FileExtension', type: 'text'},
            {label: 'File Type', fieldName: 'Description', type: 'text'},            
        ]);
    },    
    closeModal : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
})