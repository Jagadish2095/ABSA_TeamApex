({
    handleConfirmDialog : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
    },
      
    handleConfirmDialogYes : function(component, event, helper) {
      
        component.set('v.showConfirmDialog', false);
        var recId = component.get('v.recordId');
        helper.deleteRow(component, event, helper, recId);
        //debugger;
        var p = component.get("v.onclick");
        $A.enqueueAction(p);
        //p.parentMethod();
       
        
    },
    initAction : function(component, event, helper) {
        alert('test!');
    },
    handleConfirmDialogNo : function(component, event, helper) {
        console.log('No');
        component.set('v.showConfirmDialog', false);
    },
})