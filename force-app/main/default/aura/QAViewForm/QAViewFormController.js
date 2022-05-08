({
	doInit : function(component, event, helper) {
		var recordId = component.get("v.recordId");
        var templateId = component.get("v.simpleRecord")["QA_Template__c"];
        var caseId = component.get("v.simpleRecord")["Related_Case__c"];
        var submittedBy = component.get("v.simpleRecord")["Submitted_By__c"];
        
        helper.navigateToCaseForm(component, event, 'lscCaseQaForm', templateId, caseId, true,submittedBy);
	}
})