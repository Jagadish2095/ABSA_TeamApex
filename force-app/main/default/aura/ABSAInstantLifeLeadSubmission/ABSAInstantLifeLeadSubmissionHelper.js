({
	fetchAccountRecord: function (component, event, helper) {
        
		var action = component.get("c.getAccount");
		action.setParams({
			recordId: component.get('v.accountRecordId')
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var conRec = JSON.stringify(response.getReturnValue());
                var conRec1 = response.getReturnValue();
                component.set("v.accRec", conRec1.Account);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                     "type":"Success",
                     "duration" : '5000',
                    "mode" : 'pester',
                    "message": "Call back date should be within 3 days and make sure the date is not a holiday or a weekend."
                });
                toastEvent.fire();
              //  return;
			} else {
				console.log("Failed with staterec: " + JSON.stringify(response.getReturnValue()));
			}
		});

		$A.enqueueAction(action);
	},
    fetchLeadSubmitservice: function(component) {
       var RecordId =component.get('v.accountRecordId');
        var action = component.get("c.submitAbsaInstantLifeLead");
        action.setParams({
			"recordId" : RecordId,
            "CallbackDate" : component.find("callbackdate").get("v.value"),
            "CallbackTime" : component.find("callbacktime").get("v.value")
		});
        action.setCallback(this, function (response) {
			var state = response.getState();
             var response = (response.getReturnValue());
			if (state === "SUCCESS") {
				 if(response == 'Success'){
                  var navigate = component.get("v.navigateFlow");
                  navigate("NEXT");
               }else{
                  component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Submission');
                  component.find('branchFlowFooter').set('v.message', response);
                  component.find('branchFlowFooter').set('v.showDialog', true);
               }
               
            }else{
                  component.find('branchFlowFooter').set('v.heading', 'Absa Instant Life Submission');
                  component.find('branchFlowFooter').set('v.message', 'Something went wrong');
                  component.find('branchFlowFooter').set('v.showDialog', true);
               }
            component.set("v.showSpinner", false);
             });

		$A.enqueueAction(action);
    },
 
})