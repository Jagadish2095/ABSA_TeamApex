({
	doInit: function (component, event, helper) {
		component.set("v.showSpinner", true);

		helper.fetchBrands(component);
		helper.fetchData(component);
        //Simangaliso Mathenjwa: for VOICE
        if(component.get("v.processType") =='Voice Sales Product Onboarding'){
			component.set("v.isPersonalisedCard", "Yes");
		}
	},

	dataLoaded: function (component, event, helper) {
		component.set("v.showSpinner", true);
		helper.getCClistNominatableAccounts(component);
	},

	infoRecordLoaded: function (component, event, helper) {
		var combivalues = event.getParam("recordUi");
		var debitCardNumber = combivalues.record.fields["Debit_Card_Number__c"].value;
		var brandNumber = combivalues.record.fields["Brand_Number__c"].value;

		component.set("v.debitCardNumber", debitCardNumber);
		component.set("v.brandNumber", brandNumber);
	},

	infoRecordSubmit: function (component, event, helper) {
		event.preventDefault();
		var eventFields = event.getParam("fields");
		var debitCardNumber = component.get("v.debitCardNumber");
		var brandNumber = component.get("v.brandNumber");
		eventFields["Debit_Card_Number__c"] = debitCardNumber;
		eventFields["Brand_Number__c"] = brandNumber;
		component.find("DebitCardDetails").submit(eventFields);
	},

	onSubmitError: function (component, event, helper) {
		var eventName = event.getName();
		var eventDetails = event.getParam("error");
		alert("Error Event received" + JSON.stringify(eventDetails));
	},

	onSubmitSuccess: function (component, event, helper) {
		//alert('Success!');
	},

	handleSuccess: function (component, event, helper) {
		var payload = event.getParams().response;
		component.set("v.showSpinner", false);
	},

	handleNavigate: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		var globalId = component.getGlobalId();
		var combiCardIssued = component.get("v.combiCardIssued");
		switch (actionClicked) {
			case "NEXT":
			case "FINISH": {
				if (!combiCardIssued && helper.checkCardDetailsValidity(component)) {
					var promise = helper.issueCombiCard(component).then(
						$A.getCallback(function (result) {
							document.getElementById(globalId + "_debit_submit").click();
							component.set("v.combiCardIssued", true);
							helper.getCardDailyLimits(component);
						}),
						$A.getCallback(function (error) {})
					);
				}
				if (combiCardIssued && helper.checkCardLimitsValidity(component)) {
					var promise = helper.updCardDailyLimits(component).then(
						$A.getCallback(function (result) {
							var isPersonalisedCard = component.get("v.isPersonalisedCard");

							if (isPersonalisedCard == "No" && !component.get("v.pinpadComplete")) {
								component.set("v.doPinpad", true);
							} else {
								navigate(actionClicked);
							}
						}),
						$A.getCallback(function (error) {})
					);
				}
				break;
			}
			case "BACK": {
				navigate(actionClicked);
				break;
			}
			case "PAUSE": {
				navigate(actionClicked);
				break;
			}
		}
	},

	handleKeyUp: function (component, event, helper) {
		var isEnterKey = event.keyCode === 13;
		var queryTerm = component.find("DeliveryBranch").get("v.value");
		if (isEnterKey && queryTerm.length > 2) {
			var forOpen = component.find("searchRes");
			$A.util.addClass(forOpen, "slds-is-open");
			$A.util.removeClass(forOpen, "slds-is-close");

			helper.searchForDeliveryBranchByName(component, queryTerm);
		}
	},

	onblur: function (component, event, helper) {
		component.set("v.listOfRecords", null);
		var forclose = component.find("searchRes");
		var branchName = component.get("v.deliveryBranchName");

		$A.util.addClass(forclose, "slds-is-close");
		$A.util.removeClass(forclose, "slds-is-open");

		if (branchName == "") {
			component.set("v.deliveryBranch", "0");
		}
	},

	selectRecord: function (component, event, helper) {
		var selectedItem = event.currentTarget;
		var code = selectedItem.dataset.code;
		var name = selectedItem.dataset.name;

		component.set("v.deliveryBranch", code);
		component.set("v.deliveryBranchName", name);
	},

	pinpadComplete: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		component.set("v.doPinpad", false);
		var pinPadResponse = JSON.parse(component.get("v.pinPadResponse"));
		if (pinPadResponse.IsSuccessful && pinPadResponse.Message != null) {
			component.set("v.macCode", pinPadResponse.Message);
			component.set("v.pinpadComplete", true);
			navigate("NEXT");
		} else {
			component.find("branchFlowFooter").set("v.heading", "Error pinPadResponse");
			component.find("branchFlowFooter").set("v.message", JSON.stringify(pinPadResponse));
			component.find("branchFlowFooter").set("v.showDialog", true);
		}
	},

	closePinPad: function (component, event, helper) {
		component.set("v.doPinpad", false);
	}
});