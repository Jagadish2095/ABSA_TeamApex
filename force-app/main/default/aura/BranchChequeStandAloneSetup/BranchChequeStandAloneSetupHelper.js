({
    SetupStandAloneCheque : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");  
		var opportunityId = component.get("v.opportunityId"); 
		var flowName = component.get("v.flowName"); 

        //setup call
        var action = component.get("c.setupStandAloneCheque");
        action.setParams({
            'recordId' : recordId,
			'opportunityId' : opportunityId,
			'flowName' : flowName
        });
        
        // set a callBack    		
        action.setCallback(this, function(response) {		
            var state = response.getState();	
            component.set("v.showSpinner", false);
            if(state == "SUCCESS"){
                var newOpportunityId = response.getReturnValue();
				component.set("v.opportunityId", newOpportunityId); 
                var navigate = component.get("v.navigateFlow");
                navigate("NEXT"); 
            } else if(state === "ERROR"){
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message){
                        component.find('branchFlowFooter').set('v.heading', 'Failed to start stand alone cheque flow');
        			    component.find('branchFlowFooter').set('v.message', errors[0].message);
        			    component.find('branchFlowFooter').set('v.showDialog', true);
                    }
                    else{
                        console.log("unknown error");
                    }
                }
            }
            else if(state === "INCOMPLETE"){
                component.find('branchFlowFooter').set('v.heading', 'Incomplete action');
        		component.find('branchFlowFooter').set('v.message', 'The server might be down or the client might be offline.');
        		component.find('branchFlowFooter').set('v.showDialog', true);
            } 
        });		

        // enqueue the Action  		
        $A.enqueueAction(action);
    }
})