({
    
    doInit: function (component, event, helper) {
        helper.handleInit(component);
    },
    onRender: function (component, event, helper) {
        helper.handleOnRender(component);
    },
    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        var opportunityId = event.getParam("opportunityId");
        console.log('within the application event handler raised from ' + sourceComponent);
        // Condition to not handle self raised event
        if ((sourceComponent == 'NonScoredApprovedFacilities') && (opportunityId != null && opportunityId != '')) {
            //calling Init on App Event
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    }
})