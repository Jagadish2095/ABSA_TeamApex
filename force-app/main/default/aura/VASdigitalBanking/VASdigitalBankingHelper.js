({
	checkIsDigitalBankingDisabled : function (component) {
		let isStokvel = this.checkIsStokvel(component);
		if (isStokvel) {
			return this.checkIsDigitalBankingDisabledForNotClubAccount(component);
		}
		return false;
	},

	checkIsStokvel : function (component) {
		const initialAnswerId = component.get("v.initialAnswerId");
		let isStokvel = initialAnswerId === 'SAVINGS_OR_INVESTMENT';
		component.set("v.isStokvel", isStokvel);
		return isStokvel;
	},

	checkIsDigitalBankingDisabledForNotClubAccount : function(component) {
		const productCode = component.get("v.productCode");
		const digitalBankingContainer = component.find('digitalBankingContainer');
		let isDigitalBankingDisabled = (productCode !== $A.get("$Label.c.Club_Account_Product_Code"));
		if (isDigitalBankingDisabled) {
			component.set("v.isDisabled", true);
			this.showServiceResponse(component,"Digital banking is not enabled for non-club accounts", false);
			$A.util.removeClass(digitalBankingContainer, "slds-theme_default");
			$A.util.addClass(digitalBankingContainer, "slds-theme_shade");
		}

		return isDigitalBankingDisabled;
	},

	checkInternetBankingAllowed : function (component) {
		const oppId = component.get("v.opportunityId");

		var checkIBaction = component.get("c.checkForInternetBanking");
		checkIBaction.setParams({
			oppId: oppId
		});
		component.set("v.isLoading", true);
		checkIBaction.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var hasInternetBanking = response.getReturnValue();
				if (hasInternetBanking) {
					component.set("v.digitalBankingIconName", "utility:success");
					this.showServiceResponse(component,"The customer is already registered for Digital Banking.", false);
					this.fireFulfilmentEvent(component, "Y");
					component.set("v.isLoading", false);

				} else {
					this.getRvnPhone(component);
					// component.set("v.digitalBankingIconName", "utility:add");
					// component.set("v.isDisabled", false);
					// this.fireFulfilmentEvent(component, "N");
				}
			} else if (state === "ERROR") {
				component.set("v.digitalBankingIconName", "utility:clear");
				component.set("v.isDisabled", false);
				let errorMessage = this.getErrorMessageFromInternetBankingResponse(
					response,
					'Something went wrong checking for existing Digital Banking linked to customer.'
				);
				this.showServiceResponse(component, errorMessage, true);
				component.set("v.isLoading", false);
			} else if (state === "INCOMPLETE") {
				console.log("Incomplete action. The server might be down or the client might be offline.");
				component.set("v.isLoading", false);
			}
		});
		$A.enqueueAction(checkIBaction);
	},

	fireFulfilmentEvent : function (component, digitalBankingInd) {
		let compEvent = component.getEvent("vasFulfilmentEvent");
		compEvent.setParams({
			digitalBankingInd: digitalBankingInd
		});
		compEvent.fire();
	},

	showServiceResponse : function (component, responseMessage, isRed) {
		component.set("v.serviceResponse",  responseMessage);
		component.set("v.showServiceResponse", true);
		this.showResponseInRed(component, isRed);
	},

	getErrorMessageFromInternetBankingResponse : function (response, messageStart) {
		const errors = response.getError();
		let errorMessage;
		if (errors) {
			if (errors[0] && errors[0].message) {
				console.log("Error message: " + errors[0].message);
				errorMessage = messageStart + " \n " + errors[0].message;

			} else {
				console.log("unknown error");
				errorMessage = "unknown error";
			}
		} else {
			errorMessage = messageStart;
		}
		return errorMessage
	},

	showResponseInRed: function (component, showAsRed) {
		const responseText = component.find("responseText");
		if (showAsRed) {
			$A.util.addClass(responseText, "error-color");
			$A.util.removeClass(responseText, "success-color");
		} else {
			$A.util.addClass(responseText, "success-color");
			$A.util.removeClass(responseText, "error-color");
		}
	},

	validateRequiredFieldsForSetupIB : function (component) {
		let isNumberOfAuthValid = this.validateNumberOfAuth(component);
		return isNumberOfAuthValid;
	},

	validateNumberOfAuth : function (component) {
		const isStokvel = component.get("v.isStokvel");
		let isValid = true;
		if (isStokvel) {
			return isValid;
		}

		// var numberOfAuths = component.find("numberOfAuths");
		// var numberOfAuthsValue = numberOfAuths.get("v.value");
		// if (numberOfAuthsValue != null) {
		// 	$A.util.removeClass(numberOfAuths, 'slds-has-error');
		// 	numberOfAuths.set("v.errors", [{message: ""}]);
		// } else {
		// 	$A.util.addClass(numberOfAuths, 'slds-has-error');
		// 	numberOfAuths.set("v.errors", [{message: "Please select number of authorizations"}]);
		// 	isValid = false;
		// }

		return isValid;
	},

	setupInternetBanking : function (component) {
		component.set("v.digitalBankingIconName", "utility:rotate");
		component.set("v.isDisabled", true);
		component.set("v.isLoading" , true);

		let isStokvel = component.get("v.isStokvel");
		let oppId = component.get("v.opportunityId");
		let rvnCellphone = component.get("v.rvnCellphone");
		let numberOfAuths = this.getNumberOfAuths(component);

		let ibo = {
			isStokvel : isStokvel,
			oppId : oppId,
			rvnCellphone : rvnCellphone,
			numberOfAuths : numberOfAuths
		};

		const action = component.get("c.enableInternetBanking");
		action.setParams({
			ibo: JSON.stringify(ibo)
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				if (result !== "SUCCESS") {
					component.set("v.digitalBankingIconName", "utility:clear");
					this.showServiceResponse(component, "Error registering for digital banking " + result, true)
					this.fireFulfilmentEvent(component,"N");

				} else {
					component.set("v.digitalBankingIconName", "utility:success");
					this.allowMaintenance(component, isStokvel);
					this.fireFulfilmentEvent(component,"Y");
					this.showServiceResponse(component, "Customer successfully registered for Digital Banking.", false)
				}
			} else if (state === "ERROR") {
				component.set("v.digitalBankingIconName", "utility:clear");
				let errorMessage = this.getErrorMessageFromInternetBankingResponse(
					response,
					'Something went wrong applying for Digital Banking.'
				);
				this.showServiceResponse(component, errorMessage, true);
			} else if (state === "INCOMPLETE") {
				console.log("Incomplete action. The server might be down or the client might be offline.");
			}

			component.set("v.isLoading" , false);
		});
		$A.enqueueAction(action);
	},

	getNumberOfAuths : function (component) {
		const isStokvel = component.get("v.isStokvel");
		if (isStokvel) {
			return 2;
		} else {
			return component.find("numberOfAuths").get("v.value");
		}
	},

	addUserRecord: function (component) {
		const count = component.get("v.relatedPartiesCount");
		let selectUserComponents = component.get("v.selectUserComponents");

		if (selectUserComponents.length < count) {
			let userNumber = selectUserComponents.length + 1;
			let selectedUsers = component.get("v.selectedUsers");
			selectUserComponents.push(userNumber);
			selectedUsers.push({
				userNumber : userNumber
			})
			component.set("v.selectUserComponents", selectUserComponents);
			component.set("v.selectedUsers", selectedUsers);
			if (selectUserComponents.length >= count) {
				$A.util.addClass(component.find("addAnotherUser"), "slds-hide");
			}
		}
	},

	getRelatedPartyData: function (component) {
		const oppId = component.get("v.opportunityId");
		const action = component.get("c.getRelatedPartiesDetails");

		action.setParams({
			oppId: oppId
		});

		action.setCallback(this, function (response) {
			const state = response.getState();
			if (state == "SUCCESS") {
				let resp = response.getReturnValue();
				component.set("v.relatedUsers", resp);
				component.set("v.relatedPartiesCount", resp.length);
				this.setUserOptions(component);
				component.set("v.isMaintenanceAllow", true);
				component.set("v.isLoading", false);
			} else {
				component.set("v.isLoading", false);
				this.showServiceResponse(component, response.getReturnValue(), true)
			}
		});
		$A.enqueueAction(action);
	},

	setUserOptions : function(component) {
		let userOptions = [];
		const users = component.get("v.relatedUsers");
		users.forEach(user => {
			userOptions.push({ value: user.idNumber, label: user.username, cellphoneNumber : user.cellphoneNumber});
		});
		//this.setSelectedUserComponents(component);
		component.set("v.selectedUserIds", []);
		component.set("v.userOptions", userOptions);
		this.addUserRecord(component);
	},

	setSelectedUserComponents : function (component) {
		let userNumber = 1;
		let selectUserComponents = [];
		let selectedUsers = [];
		selectUserComponents.push(userNumber);
		selectedUsers.push({
			userNumber : userNumber
		})
		component.set("v.selectUserComponents", selectUserComponents);
		component.set("v.selectedUsers", selectedUsers);
	},

	setSelectedUser: function (component, event) {
		const previousUserId = event.getParam("previousUserId");
		const selectedUserId = event.getParam("selectedUserId");
		let selectedUserIds = component.get("v.selectedUserIds");

		selectedUserIds.push(selectedUserId);

		if (selectedUserIds.length > 1) {
			component.set("v.isNumberAuthUserNotValid", false);
		}

		if (previousUserId) {
			selectedUserIds = selectedUserIds.filter(userId => userId !== previousUserId);
		}
		component.set("v.selectedUserIds", selectedUserIds);
	},

	validateUserValue : function (component) {
		const username = component.find("username");
		const usernameValue = username.get("v.value");
		let isValid = true;

		if (usernameValue != null) {
			$A.util.removeClass(username, "slds-has-error");
			username.setCustomValidity("");
			username.reportValidity();
		} else {
			$A.util.addClass(username, "slds-has-error");
			username.setCustomValidity("Please enter user name.");
			username.reportValidity();
			isValid = false;
		}

		const idNumber = component.find("idNumber");
		let idNumberValue = idNumber.get("v.value");
		if (idNumberValue == null) {
			idNumberValue = "";
		}
		const idNumberPattern = new RegExp("^[0-9]{13}$");
		if (idNumberValue.match(idNumberPattern)) {
			$A.util.removeClass(idNumber, "slds-has-error");
			idNumber.setCustomValidity("");
			idNumber.reportValidity();
		} else {
			$A.util.addClass(idNumber, "slds-has-error");
			idNumber.setCustomValidity("Please enter valid ID number.");
			idNumber.reportValidity();
			isValid = false;
		}

		return isValid;
	},

	allowMaintenance : function (component, isStokvel) {
		if (isStokvel) {
			this.getRelatedPartyData(component);
		} else {
			this.setSelectedUserComponents(component);
			component.set("v.isMaintenanceAllow", true);
			component.set("v.isLoading", false);
		}
	},

	setUpSelectedUsersInBranchComponent : function (component) {
		const isStokvel = component.get("v.isStokvel");
		if (isStokvel) {
			var cmpEvent = component.getEvent("setUpSelectedUsersEvent");
			const selectedUserIds = component.get("v.selectedUserIds");
			
			cmpEvent.setParams({
				"selectedUserIds" : JSON.stringify(selectedUserIds)
			});
			cmpEvent.fire();
		}
	},

	maintainUser : function (component, event) {
		let userData = event.getParam("userData");
		let selectedUsers = component.get("v.selectedUsers");
		let user = JSON.parse(userData);
		let userSelected = selectedUsers.find(selectedUser => selectedUser.userNumber === user.userNumber);
		userSelected.idNumber = user.userId;
		userSelected.username = user.userName;
		userSelected.cellphoneNumber = user.cellphoneNumber;
		component.set("v.selectedUsers",selectedUsers);
		this.validateUsers(component);
	},

	validateUsers : function (component) {
		let selectedUsers = component.get("v.selectedUsers");
		let isValid = true;
		selectedUsers.forEach(selectedUser => {
			isValid = isValid && (!!selectedUsers.username || !!selectedUser.cellphoneNumber || !!selectedUser.idNumber);
		});
		component.set("v.isUsersInvalid", !isValid);
	},

	maintainUsers : function (component) {
		let action = component.get("c.maintainUserDetails");
		let users = component.get("v.selectedUsers");
		const oppId = component.get("v.opportunityId");
		const isStokvel = component.get("v.isStokvel");

		component.set("v.isLoading" , true);

		var ibo = {
			isStokvel: isStokvel,
			oppId: oppId,
			users: users
		};
		action.setParams({
			ibo: JSON.stringify(ibo)
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				if (result !== "SUCCESS") {
					component.set("v.digitalBankingIconName", "utility:clear");
					this.showServiceResponse(component, "Error Maintain Users for digital banking " + result, true)
					this.fireFulfilmentEvent(component,"N");
				} else {
					component.set("v.digitalBankingIconName", "utility:success");
					component.set("v.isMaintainSuccess", true);
					this.setUpSelectedUsersInBranchComponent(component);
					$A.util.addClass(component.find("maintainUsers"), "slds-hide");
					this.fireFulfilmentEvent(component,"Y");
					this.showServiceResponse(component, "successfully Maintained Users for Digital Banking.", false)
				}
			} else if (state === "ERROR") {
				component.set("v.digitalBankingIconName", "utility:clear");
				let errorMessage = this.getErrorMessageFromInternetBankingResponse(
					response,
					'Something went wrong applying for Digital Banking.'
				);
				this.showServiceResponse(component, errorMessage, true);
			} else if (state === "INCOMPLETE") {
				console.log("Incomplete action. The server might be down or the client might be offline.");
			}

			component.set("v.isLoading" , false);
		});
		$A.enqueueAction(action);
	},

	getRvnPhone : function (component) {
		const opportunityId = component.get("v.opportunityId");
		const getRvnPhone = component.get("c.getAccountPhone");
		getRvnPhone.setParams({
			opportunityId: opportunityId
		});
		getRvnPhone.setCallback(this, function (response) {
			const state = response.getState();
			if (state === "SUCCESS") {
				const rvnPhone = response.getReturnValue();
					component.set("v.rvnCellphone", rvnPhone);
					component.set("v.digitalBankingIconName", "utility:add");
					component.set("v.isDisabled", false);
					this.fireFulfilmentEvent(component, "N");
					component.set("v.isLoading", false);
			} else {
				component.set("v.digitalBankingIconName", "utility:clear");
				let errorMessage = this.getErrorMessageFromInternetBankingResponse(
					response,
					'Something went wrong applying for Digital Banking.'
				);
				this.showServiceResponse(component, errorMessage, true);
				component.set("v.isLoading", false);
			}
		});
		$A.enqueueAction(getRvnPhone);
	}

});