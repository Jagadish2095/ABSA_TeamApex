({
	init: function (cmp, event, helper) {
		helper.showSpinner(cmp);
		var opportunityId = cmp.get("v.opportunityId");
		var switchIds = "";
		var participatingDebitOrders = [];
		var nonParticipatingDebitOrders = [];
		var nonParticipatingSalarySwitch = "";
		var nonParticipatingSalarySwitchId = "";

		var getSwitchesAction = cmp.get("c.getSwitchesFromOpprProduct");
		getSwitchesAction.setParams({
			opportunityId: opportunityId
		});

		getSwitchesAction.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS" && cmp.isValid()) {
				switchIds = response.getReturnValue();

				if (switchIds !== "") {
					var switches = switchIds.split(",");

					for (var i = 0; i < switches.length; i++) {
						if (switches[i] != "") {
							let action = cmp.get("c.getSwitch");
							action.setParams({
								switchId: switches[i]
							});
							action.setCallback(this, function (response) {
								var state = response.getState();
								if (state === "SUCCESS" && cmp.isValid()) {
									var switchItem = response.getReturnValue();
									if (switchItem.participation == "PARTICIPATING" && switchItem.switchType == "DEBIT_ORDER") {
										participatingDebitOrders.push(switchItem.institutionName);
									} else if (switchItem.switchType == "DEBIT_ORDER") {
										nonParticipatingDebitOrders.push(switchItem.institutionName);
									} else if (switchItem.switchType == "SALARY") {
										nonParticipatingSalarySwitch = switchItem.institutionName;
										nonParticipatingSalarySwitchId = switchItem.switchId;
									}
									cmp.set("v.participatingDebitOrders", participatingDebitOrders);
									cmp.set("v.nonParticipatingDebitOrders", nonParticipatingDebitOrders);
									cmp.set("v.nonParticipatingSalarySwitch", nonParticipatingSalarySwitch);
									cmp.set("v.nonParticipatingSalarySwitchId", nonParticipatingSalarySwitchId);
									if (i == switches.length) {
										helper.hideSpinner(cmp);
									}
								} else if (state === "ERROR") {
									var errors = response.getError();
									if (errors) {
										if (errors[0] && errors[0].message) {
											cmp.set("v.showDialog", true);
											cmp.set("v.headingDialog", "Error on Salary Letter");
											cmp.set("v.messageDialog", errors[0].message);
										} else {
											cmp.set("v.showDialog", true);
											cmp.set("v.headingDialog", "Error on Salary Letter");
											cmp.set("v.messageDialog", "unknown error");
										}
										helper.hideSpinner(cmp);
									}
								} else if (state === "INCOMPLETE") {
									cmp.set("v.showDialog", true);
									cmp.set("v.headingDialog", "Error on Salary Letter");
									cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
									helper.hideSpinner(cmp);
								}
							});
							$A.enqueueAction(action);
						}
					}
				} else {
					cmp.set("v.showSwitchingHeader", false);
					helper.hideSpinner(cmp);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						cmp.set("v.showDialog", true);
						cmp.set("v.headingDialog", "Error retrieving Switches");
						cmp.set("v.messageDialog", errors[0].message);
					} else {
						cmp.set("v.showDialog", true);
						cmp.set("v.headingDialog", "Error retrieving Switches");
						cmp.set("v.messageDialog", "unknown error");
					}
				}
				helper.hideSpinner(cmp);
			} else if (state === "INCOMPLETE") {
				cmp.set("v.showDialog", true);
				cmp.set("v.headingDialog", "Error retrieving Switches");
				cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
				helper.hideSpinner(cmp);
			}
		});
		$A.enqueueAction(getSwitchesAction);
	},
	printLetter: function (cmp, event, helper) {
		helper.showSpinner(cmp);
		var action = cmp.get("c.getSwitchesLetter");
		var switchId = cmp.get("v.nonParticipatingSalarySwitchId");

		action.setParams({
			switchId: switchId
		});

		action.setCallback(cmp, function (response) {
			var state = response.getState();
			if (state === "SUCCESS" && cmp.isValid()) {
				var switchLetter = response.getReturnValue();

				if (switchLetter.length > 1) {
					var element = document.createElement("a");
					element.setAttribute("href", "data:application/pdf;base64," + switchLetter);
					element.setAttribute("download", "switchesLetter");
					element.style.display = "none";
					document.body.appendChild(element);
					element.click();
					document.body.removeChild(element);
				}

				helper.hideSpinner(cmp);
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						cmp.set("v.showDialog", true);
						cmp.set("v.headingDialog", "Error retrieving Salary Letter");
						cmp.set("v.messageDialog", errors[0].message);
					} else {
						cmp.set("v.showDialog", true);
						cmp.set("v.headingDialog", "Error retrieving Salary Letter");
						cmp.set("v.messageDialog", "unknown error");
					}
				}
				helper.hideSpinner(cmp);
			} else if (state === "INCOMPLETE") {
				cmp.set("v.showDialog", true);
				cmp.set("v.headingDialog", "Error retrieving Salary Letter");
				cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
				helper.hideSpinner(cmp);
			}
		});
		$A.enqueueAction(action);
	},
	redirectToOpportunity: function (cmp, event, helper) {
        helper.showSpinner(cmp);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.opportunityId"),
            "slideDevName": "Detail"
        });
        navEvt.fire();
        helper.hideSpinner(cmp);
    },
	handleNavigate: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
			case "BACK":
			case "PAUSE":
				navigate(actionClicked);
				break;
		}
	}
});