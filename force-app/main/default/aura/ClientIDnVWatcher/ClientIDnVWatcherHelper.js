({
    updateOpportunitySalesSubStatus : function(component) {
          var action = component.get("c.updateSalesSubStatus");
        // set param to method
        action.setParams({
            opportunityId : component.get("v.recordId")
        });
        // set a callBack
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(`Sales_Sub_Status__c updated for ${component.get("v.opportunityId")}`);
                this.fireToast("Call Dropped", "Opportunities Sales Sub Status updated to 'Call Dropped'.", "warning","dismissible", 10000);
            } else {
                console.error(`ERROR... : ${JSON.stringify(response.getError())}`);
                this.fireToast("Error", "Something went wrong.", "error");
            }

        });

        //enqueue the Action
        $A.enqueueAction(action);
    },


    //Lightning toastie
	fireToast: function (title, msg, type,mode , duration) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type,
            mode: mode,
            duration: duration
		});

		toastEvent.fire();
        console.log(`${type} toast: ${msg}`);
	}
})