({
    removeNewAccount: function (component) {
        component.getEvent("CPFApplicationFinancialAccCreation").setParams({
            "RowIndex" : component.get("v.rowindex")
        }).fire();
        
        var appFinRectoDel= component.get("v.appFinAccRecId");
        console.log('appFinRectoDel'+appFinRectoDel);
        var action = component.get("c.delAppFinRec");
        var toastEvent = $A.get("e.force:showToast");
        
        action.setParams({
            "appFinRectoDel": component.get("v.appFinAccRecId")
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
            }
            else if (state == 'ERROR') {
                var errors = response.getError();
            }
        });
        $A.enqueueAction(action);
    },
})