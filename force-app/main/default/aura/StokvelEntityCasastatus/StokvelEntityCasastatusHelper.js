({
	getStokvelCasastatus: function (component, event, helper) {
		component.set("v.isSpinner", true);
		var action = component.get("c.getEntityCasastatus");
		action.setParams({
			accountRecId: component.get("v.accountRecId")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			component.set("v.isSpinner", false);
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state == "SUCCESS") {
				component.set("v.EntityCasastatus", resp.mainAccount);
				component.set("v.RelatedParties", resp.relatedparty);

				component.set("v.casaStatus", resp.mainAccount[0].status);
				if (resp.mainAccount[0].status == "PENDING APPROVAL" || resp.mainAccount[0].status =="DECLINED") {
					component.set("v.isCasaStatusPending", true);
					component.set("v.errorMessage","We need to conduct further controls, expect the delay in the processing your application");
				} else {
					component.set("v.isCasaStatusPending", false);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				alert(JSON.stringify(errors));
			}
		});
		$A.enqueueAction(action);
	},
	getrelatedPartystatus: function (component, event, helper) {
		component.set("v.isSpinner", true);
		var action = component.get("c.getrelatedCasastatus");
		action.setParams({
			accountRecId: component.get("v.accountRecId")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			component.set("v.isSpinner", false);
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state == "SUCCESS") {
				//component.set("v.EntityCasastatus", resp.mainAccount);
				component.set("v.RelatedParties", resp.relatedparty);

			} else if (state === "ERROR") {
				var errors = response.getError();
				alert(JSON.stringify(errors));
			}
		});
		$A.enqueueAction(action);
	},
	stokvelCIFCreation: function (component, helper) {
		return new Promise(function (resolve, reject) {
			var accountRecId = component.get("v.accountRecId");
			// alert('yellow');
			var action = component.get("c.createstokvelCIF");
			action.setParams({
				accountId: component.get("v.accountRecId")
			});

			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = JSON.parse(response.getReturnValue());
				if (state == "SUCCESS") {
					if (screenRespObj != null && screenRespObj.statusCode != null && screenRespObj.statusCode == 200 && screenRespObj.statusMessage == null) {
						helper.fireToast(
							"Success",
							"The CIF " +
								screenRespObj.body.CIB003O.CIcreateClientV22Response.outputClientKey +
								" for the stokvel has been successfully created",
							"success"
						);
						resolve(screenRespObj.body.CIB003O.CIcreateClientV22Response.outputClientKey);
					} else if (screenRespObj != null && screenRespObj.statusCode == 200) {
						if (screenRespObj.statusMessage != null) {
							if (screenRespObj.statusMessage.error != null) {
								if (Object.keys(screenRespObj.statusMessage.error).length > 0) {
									var arrayLength = screenRespObj.statusMessage.error;
									var arr = new Array();
									for (var i = 0; i < screenRespObj.statusMessage.error.length; i++) {
										arr.push(screenRespObj.statusMessage.error[i].field + " " + screenRespObj.statusMessage.error[i].reason);
									}

									var error = arr.join();
									helper.fireToast("Error", "The entity  was an error while trying to  create CIF for the entity." + error, error);
									console.log("The entity  was an error while trying to  create CIF createstokvelCIF the entity" + error);
									reject(error);
								}
							}
						}
					}
				} else if (state === "ERROR") {
					var error = response.getError();

					helper.fireToast("Error", "The entity  was an error while trying to create CIF for  the entity.", error);
					reject(error);
				}
			});
			$A.enqueueAction(action);
		});
	},

	checkiftheCIFexist: function (component, helper) {
		return new Promise(function (resolve, reject) {
			//setup call
			var action = component.get("c.checkifCIFExist");
			action.setParams({
				accountId: component.get("v.accountRecId")
			});
			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();
				if (state == "SUCCESS" && screenRespObj != null) {
					resolve(screenRespObj.cifKey);
				} else {
					reject("Failed to get CIF key");
				}
			});
			// enqueue the Action
			$A.enqueueAction(action);
		});
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},
	showError: function (component, fieldName) {
		$A.util.addClass(component.find(fieldName), "slds-has-error");
		var error = component.find("err" + fieldName);
		$A.util.removeClass(error, "slds-hide");
		$A.util.addClass(error, "slds-form-element__help");
		return true;
	}
});