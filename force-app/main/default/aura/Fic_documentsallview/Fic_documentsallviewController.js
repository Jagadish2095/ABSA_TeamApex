({
    doInit: function(component, event, helper) {
        var action = component.get("c.getdocumentS");
        var caseId = component.get("v.caseId");
        action.setParams({
            'caseId': caseId
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                component.set('v.Documents',response);
                component.set('v.Editmode',false);
                component.set('v.IsAlldocs',true);
            }
            else{
            }
        });
        $A.enqueueAction(action);
        helper.getCase(component, event, helper);
    },
    Clicked : function(component, event, helper) {
        helper.showSpinner(component);
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        console.log(id_str);
        helper.getDocumentData(component, event,helper, id_str);
        var action = component.get("c.specificDoc");
        action.setParams({
            'docId': id_str
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                component.set('v.Documents',response);
                component.set('v.Editmode',true);
                component.set('v.IsAlldocs',false);
                helper.hideSpinner(component);
            }
            else{
            }
        });
        $A.enqueueAction(action);
    },
    showSecondModel : function(component, event, helper) {
        
    }
})