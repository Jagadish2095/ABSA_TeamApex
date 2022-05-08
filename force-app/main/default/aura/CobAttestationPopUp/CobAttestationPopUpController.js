({
    
    doInit : function(component, event, helper) {
        helper.loadOpportunity(component, event, helper);
    },
    
    closeAttestationModal : function(component, event, helper) {
        var selectedJob = 'NewCreditProduct';
        var evt = $A.get("e.force:navigateToComponent");
        component.set("v.showAttestationModal",false);
        evt.setParams({
            componentDef : "c:CreditProductOnboarding",
            componentAttributes: {
                jobname:selectedJob
            }});
        evt.fire();
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: serType.Name
            });
        })
        
        //close the Opportunity when declined Attestation
        var OpportunityId = component.get("v.recordId");
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var action = component.get("c.closeOppRecord");
        action.setParams({
            oppId : OpportunityId
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state==="SUCCESS"){
                var oppRec = res.getReturnValue();
                component.set('v.oppRecord',oppRec);
                $A.get('e.force:refreshView').fire();
            }
        });       
        $A.enqueueAction(action);   
    },
    
    submitAttestation : function(component, event, helper) {
        event.preventDefault();
        var fields = event.getParam("fields");
        console.log('Date Value' +component.find("attestHistory").get("v.value"));
        //fields["Attestation_History__c"] = 'hello';//component.find("oDateTime").get("v.value");
        var attestationAcceptance = component.find("attestHistory").get("v.value");
        component.find("attestHistory").set("v.value", 'Accepted '+attestationAcceptance);
        component.find("attestModal").submit(fields);
        component.set("v.showAttestationModal",false);
    },
    
    
})