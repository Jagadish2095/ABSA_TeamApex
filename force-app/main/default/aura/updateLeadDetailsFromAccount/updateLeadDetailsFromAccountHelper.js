/**
 * @description       : updateLeadDetailsFromAccount helper
 * @author            : Mbuyiseni Mbhokane
 * @group             : ZyberFox
 * @last modified on  : 2021-08-23
 * @last modified by  : Monde Masiza
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   05-21-2021   Mbuyiseni Mbhokane   Initial Version
**/
({
	helperMethod : function() {
		
	},
	        //CALL updateLeadDetails service
			updateClientDetails :function (component, event, helper){
				debugger;
				//var oppId = component.get("v.recordId");
                //var accId = component.get("v.recordId");
				 var accId = component.get("v.accountRecord.AccountId");
				//var accId;
                var oppId;
				console.log('accId : '+ accId);
				console.log('oppId : '+ oppId);
				var action = component.get("c.leadDetailsUpdate");
				action.setParams({"opportunityId": oppId,"accountId": accId});
				action.setCallback(this, function(response) {
				debugger;
					var state = response.getState();
					console.log('state : '+ state);
					if (state === "SUCCESS") {
                        debugger;
						var data = JSON.parse(response.getReturnValue());
						console.log('data : '+ JSON.stringify(data));
						console.log('data message : '+ data.result[0].message);
	
						//toast
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"message": data.result[0].message
						});
						toastEvent.fire();
					}
					else {
						console.log("Failed with state: " + JSON.stringify(response));
						//toast
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"message": JSON.stringify(response)
						});
						toastEvent.fire();
					}
				});
				$A.enqueueAction(action);
			},
})