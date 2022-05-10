({
    fetchApplications : function(component, event, helper) {
        console.log(`Account: ${component.get("v.recordId")}`);

        helper.setColumns(component);

        helper.fetchApplicationsHelper(component);
    }
})