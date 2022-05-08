({
	doInit : function(component, event, helper) {
		
	},
	submitSanctioning : function(component, event, helper) {
        
        let button = component.find('submit_sanctioning');
        button.set('v.disabled',false);
	},
 	btnSubmitSanctioning : function(component, event, helper) {
		
    	component.set("v.showSpinner",true);
        var oppId 	= component.get("v.oppId");
        var SWQR 	= component.find("SWQR").get("v.value");
        console.log('oppId '+oppId);
        console.log('SWQR '+SWQR);
        var action 	= component.get("c.submitForApproval");

        action.setParams({
            "oppId": oppId,
            "SWQR": SWQR
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                 console.log('In state success');
                 console.log('Return Value '+response.getReturnValue());
                var results = JSON.parse(response.getReturnValue()); 
                
                console.log('results in msg---', results);
                
                if(results.pass == 'true'){
                    helper.successMsg(component,results.msg);
                }else{
                    helper.infoMsg(component,results.msg);
                }
                               

            }
            else {
                console.log("Failed with state in orignation vertical: " + JSON.stringify(response));
                helper.errorMsg(component,results.msg);
            }
            
            component.set("v.showSpinner",false );
            
        });

        $A.enqueueAction(action);        
        
	},
 	refer2Sanctioning : function(component, event, helper) {
		var refer2SanctioningVal = component.set('v.refer2SanctioningVal',true);
	},
    handleOnSubmit: function (component, event, helper) {
        component.set("v.showSpinner",true);
    },
     handleSuccess: function (component, event, helper) {
        component.set("v.showSpinner",false);
        //helper.successMsg(component,'Application saved successfully');
    },   
})