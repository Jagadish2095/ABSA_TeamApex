({
    setColumns : function(component) {
        component.set('v.applicationColumns', [ {label: 'Interview Label', fieldName: 'ApplicationName', type: 'text'},
                                                {label: 'Pause Reason', fieldName: 'PauseReason', type: 'text'},
                                                {label: 'Pause Date', fieldName: 'PauseDate', type: 'Text'},
                                                {label: 'Paused By', fieldName: 'PausedBy', type: 'Text'},
                                                {label: 'Action', fieldName: '', type: 'Text'}
                                            ]);
    },
    fetchApplicationsHelper : function(component) {
        var action = component.get("c.fetchCustomerApplications");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.applicationList", response.getReturnValue());
            }
            else{
                debugger;
            }
        });
        $A.enqueueAction(action);
    }
})