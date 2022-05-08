({
	getAccountProductsHelper: function (component) {
		this.showSpinner(component);
		var getAccountProducts = component.get("c.getAccountProducts");
		getAccountProducts.setParams({
			accountId: component.get("v.recordId")
		});
		getAccountProducts.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				if (storeResponse.length == 0) {
					component.set("v.showNotification", true);
					component.set("v.errorMessage", "No results returned");
				} else {
					storeResponse.sort();
					var accList = [];
					for (var key in storeResponse) {
						if (storeResponse[key].productType != "CO") {
							accList.push(storeResponse[key]);
						}
					}
					component.set("v.listOfSearchRecords", accList);
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(getAccountProducts);
	},

	getGeneralPAHelper: function (component) {
		this.showSpinner(component);
		debugger;
		var getGeneralPA = component.get("c.getGeneralPA");
		getGeneralPA.setParams({
			accountnumber: component.get("v.selectedAccountNumber")
		});
		getGeneralPA.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				if (result.statusCode == 200) {
					if (result.CIgetGeneralPowerOfAttorneyV4Response.nbsmsgo3.msgEntry[0].msgErrInd == "E") {
						var msgText = result.CIgetGeneralPowerOfAttorneyV4Response.nbsmsgo3.msgEntry[0].msgTxt;
						if ((msgText != null) & (msgText != "GENERAL POWER OF ATTORNEY DOES NOT EXIST")) {
							this.getToast("Error", "General Power of Attorney : " + msgText, "error");
						}
					} else {
						var responseFinalTable = result.CIgetGeneralPowerOfAttorneyV4Response.cip081do.outputTable;
						responseFinalTable.PAType = "General Power of Attorney";
						responseFinalTable.customer = component.get("v.accountName");
						component.set("v.generalPAList", responseFinalTable);
						var data = component.get("v.data");
						data.push(responseFinalTable);
						component.set("v.data", data);
						component.set("v.showNotification", false);
					}
				} else {
					this.getToast("Error", "General Power of Attorney : " + result.StatusMessage, "error");
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(getGeneralPA);
	},

	getSpecialPAHelper: function (component, event, helper) {
		this.showSpinner(component);
		var getSpecialPA = component.get("c.getSpecialPA");
		getSpecialPA.setParams({
			accountnumber: component.get("v.selectedAccountNumber")
		});
		getSpecialPA.setCallback(this, function (response) {
			var state = response.getState();
			debugger;
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				if (result.statusCode == 200) {
					if (result.CIgetSpecialPowerOfAttorneyV4Response.nbsmsgo3.msgEntry.msgErrInd == "E") {
						var msgText = result.CIgetSpecialPowerOfAttorneyV4Response.nbsmsgo3.msgEntry.msgTxt;
						if ((msgText != null) & (msgText != "SPECIAL POWER OF ATTORNEY DOES NOT EXIST")) {
							this.getToast("Error", "Special Power of Attorney : " + msgText, "error");
						}
					} else {
						var responseFinalTable = result.CIgetSpecialPowerOfAttorneyV4Response.cip080do.outputTable;
						debugger;
						responseFinalTable.PAType = "Special Power of Attorney";
						responseFinalTable.customer = component.get("v.accountName");
						component.set("v.specialPAList", responseFinalTable);
						var data = component.get("v.data");
						data.push(responseFinalTable);
						component.set("v.data", data);
						component.set("v.showNotification", false);
					}
				} else {
					this.getToast("Error", "Special Power of Attorney : " + result.StatusMessage, "error");
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(getSpecialPA);
	},

	//Lightning toast
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});

		toastEvent.fire();
	},

	//Show lightning spinner
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	//Hide lightning spinner
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	}
});