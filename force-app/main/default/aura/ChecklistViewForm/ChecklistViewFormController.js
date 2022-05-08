({
	doInit : function(component, event, helper) {
        var templateId = component.get("v.simpleRecord")["Case_Checklist_Template__c"];
        var caseId = component.get("v.simpleRecord")["Related_Case__c"];
         var submittedBy = component.get("v.simpleRecord")["Submitted_By__c"];
		helper.navigateToCaseForm(component, event, 'lscCaseChecklistForm', templateId, caseId,true,submittedBy);
	}
})