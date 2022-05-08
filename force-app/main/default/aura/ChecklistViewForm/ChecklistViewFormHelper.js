({
	navigateToCaseForm : function(component, event, cmpName, templateId, caseId, readonly,submittedBy){        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:" + cmpName,
            componentAttributes: {
                templateId : templateId,
                caseId : caseId,
                readonly : true,
                submittedBy :submittedBy
            }
        });
        evt.fire();
    }
})