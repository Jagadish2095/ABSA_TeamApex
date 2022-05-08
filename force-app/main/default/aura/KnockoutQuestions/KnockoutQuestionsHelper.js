({
	knockoutHelper: function (component, listType) {
		// call the apex class method
		var action = component.get("c.fetchKnockoutQuestions");
		// set param to method
		action.setParams({
			listType: listType
		});
		// set a callBack
		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				// set questionList with return value from server.
				component.set("v.questionList", storeResponse);
			} else {
				response.getError();
				var errorTxt;
				console.log("errors", errors);
				if (errors) {
					var errorMsgs = [];
					for (var index in errors) {
						errorMsgs.push(errors[index].message);
					}
					errorTxt = errorMsgs.join("<br/>");
				} else {
					errorTxt = "Something went wrong!";
				}
				component.set("v.Message", errorTxt);
			}
		});
		// enqueue the Action
		$A.enqueueAction(action);
	},

	SelectionCallback: function (component, event) {
		var compEvent = component.getEvent("branchProductSelectionEventcmp");
		var AttestationsValid = "reject";
		if (component.get("v.requireIDPORChecked") && component.get("v.casaClauseChecked")) {
			AttestationsValid = "accept";
            component.set("v.isAllClausesSet",true);
		}else{
            component.set("v.isAllClausesSet",false);
        }
		compEvent.setParams({
			QuestionResponse: AttestationsValid
		});
		compEvent.fire();
	}
});