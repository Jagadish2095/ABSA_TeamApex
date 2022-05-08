({
    init : function(component, event, helper) {
        var spinner = component.find("spinner");
        component.set("v.showSpinner", true);
        var oppId = component.get("v.opportunityId");        

        //setup call
        var action = component.get("c.updateAccountHolds");
        action.setParams({
            oppId : oppId
        });
        
        // set a callBack    		
        action.setCallback(this, function(response) {		
            var state = response.getState();	
            var spinner = component.find("spinner");
            component.set("v.showSpinner", false);
            if(state == "SUCCESS"){
                var resp = response.getReturnValue();
                if (resp.includes("Error")) {
					component.find('branchFlowFooter').set('v.heading', 'Failed to update cheque holds');
        			component.find('branchFlowFooter').set('v.message', resp);
        			component.find('branchFlowFooter').set('v.showDialog', true);
                } else {
                    var navigate = component.get("v.navigateFlow");
                    navigate("NEXT");
                    navigate.fire();
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message){
						component.find('branchFlowFooter').set('v.heading', 'Failed to update cheque holds');
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
    },
    handleNavigate: function(component, event) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        
        switch(actionClicked) {
            case 'NEXT': 
            case 'FINISH': 
                // Retry init function	
                window.location.reload();
                break;
            case 'BACK':
                navigate(actionClicked);
                break;
            case 'PAUSE':
                navigate(actionClicked); 
                break;
        }
    }
})