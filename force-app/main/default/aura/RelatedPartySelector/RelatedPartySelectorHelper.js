({
    getRelatedParties: function (component) {
        var oppId;
        var SUCCESS_STATE = "SUCCESS";
        if(component.get("v.recordId") == undefined) {
            oppId = component.get("v.accRecId"); //when the component is on the NTB form
        } else {
            oppId = component.get("v.recordId") //when the component is on the Account form
        }
        
        var action = component.get("c.getRelatedParties");
        console.log("Opp Id 12 " + oppId);
        action.setParams({
            "oppId" : oppId,
            "submitForCasa" : false
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS") {
                var relatedParties = response.getReturnValue();
                component.set("v.relatedParties", relatedParties);
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    },
    
    selectedPrincipal: function(component, event, helper){
        var SUCCESS_STATE = "SUCCESS";
        var action = component.get("c.getSelectedRelatedParty");
        var relatedParty = component.find('relatedParties').get('v.value');
        console.log("relatedParty 34 " + JSON.stringify(relatedParty));
        
        action.setParams({
            "acrId": component.find('relatedParties').get('v.value')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log("state " + state);
            if (state == "SUCCESS") {
                var data = response.getReturnValue();
                
                var updateEvent = $A.get("e.c:onboardingOpportunityIdsCreated");
                updateEvent.setParams({"relatedPartyID": data.Id});
                updateEvent.fire();
                component.set('v.relatedPartyID', data.Id);
               	console.log("relatedPartyID 48 " + component.get('v.relatedPartyID'));
            }
            else {
                console.log("Failed with state: " + response.getState());
            }
        });
        $A.enqueueAction(action);
    }
})