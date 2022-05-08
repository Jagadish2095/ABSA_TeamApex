({
    fetchopp : function(component) {
        component.set("v.showSpinner", true);
        var objectId = component.get("v.recordId");
        var action = component.get("c.getOpportunity"); 
        action.setParams({
            "accountId": objectId
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
              //  alert('success')
                var oppRec = response.getReturnValue();
                
                    if(oppRec.extOppId !=undefined){
                      //  alert('Existing Opp Id-->'+JSON.stringify(oppRec.extOppId))
                        component.set("v.existOpp",oppRec.extOppId);
                        $A.get('e.force:refreshView').fire();
                        component.set('v.isExistingOpp',true);
                        
                    } else if(oppRec.exstOppAssignId!=undefined){
                      //  alert('Existing Opp Assign Id-->'+JSON.stringify(oppRec.exstOppAssignId)) 
                        component.set("v.existOppAsgn",oppRec.exstOppAssignId);
                        component.set('v.isExistingOppAssign',true);
                    }
                
                else{
                        component.set('v.isNewOpp',true);
                    }
            }
            
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    navigateToEditCmp : function(component, event) {
        
           
            var accId = component.get("v.opportunityRecord.AccountId"); 
            var oppId = component.get("v.opportunityRecord.Id");  
            var processName = 'EditFormExistingOpportunity';
            var clientType = component.get("v.opportunityRecord.Entity_Type__c");
            
            console.log('clientType-->: '+ clientType);  
            if (accId != null && accId != '' && accId != undefined) {
                //Navigate to OnboardingClientDetails - Business Entities
                if(clientType != 'Individual' && clientType != 'Private Individual' && clientType != 'Sole Trader' && clientType != 'SOLE PROPRIETOR') {
                    console.log("In Business accId : " + accId);
                     var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:OnboardingClientDetails",
                        componentAttributes: {
                            accRecordId: accId,
                            ProcessName: processName,
                            opportunityRecordId : oppId 
                            
                        }
                    });
                    evt.fire();
                }
            
                //Navigate to OnboardingIndividualClientDetails - Individual and Sole Trader
                else{
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:OnboardingIndividualClientDetails",
                        componentAttributes: {
                            accRecordId: accId,
                            ProcessName: processName,
                            opportunityRecordId : oppId,
                            isSoleTrader: true
                        }
                    }); evt.fire();
                }
            }
            

    },
    
    
})