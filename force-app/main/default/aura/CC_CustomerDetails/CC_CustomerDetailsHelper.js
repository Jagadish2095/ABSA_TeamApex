({
	handleMinimumCIFInformation: function (component, event) {
		var identityInfoAction = component.find('ccIdentityInformation');
		identityInfoAction.collectInformation();
		var residentialInformation = component.find('ccResidentialInformation');
		residentialInformation.collectResidentialInformation();
		var contactInformation = component.find('ccContactInformation');
		contactInformation.collectContactInformation();
		var maritalInformation = component.find('ccMaritalInformation');
		maritalInformation.collectCMaritalInformation();
		var nextKinInformation = component.find('ccNextKinInformation');
		nextKinInformation.collectKinInformation();
		var personalInformation = component.find('ccPersonalInformation');
		personalInformation.collectPersonalInformation();

		var collectionInformation = new Map();
		collectionInformation['identityInformation'] = component.get('v.creditIdentityInformation');
		collectionInformation['residentialInformation'] = component.get('v.creditResidentialInformation');
		collectionInformation['contactInformation'] = component.get('v.creditContactInformation');
		collectionInformation['nextKinInformation'] = component.get('v.creditNextKinInformation');
		collectionInformation['maritalInformation'] = component.get('v.creditMaritalInformation');
		collectionInformation['personalInformation'] = component.get('v.creditPersonalInformation');
		component.set('v.minimumCIFInformationCollection', collectionInformation);
		component.set('v.cifInformationSerialized', JSON.stringify(collectionInformation));
		this.updateCustomerDetails(component, event);
	},

	callPickListValues: function(component, event){
		this.getPickListByObjectAndFields(component, event, 'Account', 'Marital_Status__pc');
        this.getPickListByObjectAndFields(component, event, 'Account', 'Marital_Contract_Type__pc');
        this.getPickListByObjectAndFields(component, event, 'Account', 'Gender__pc');
        this.getPickListByObjectAndFields(component, event, 'Account', 'ID_Type__pc');
	},

	getPickListByObjectAndFields: function(component, event, objectName, fieldName) {
		var action = component.get('c.getPicklistByObject');
		action.setParams({
			'objectName': objectName,
			'fieldName': fieldName
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			var responseData = response.getReturnValue();
			if(state === 'SUCCESS'){
				if(fieldName === 'Marital_Status__pc'){
					component.set('v.maritalStatusList', responseData);
				} else if (fieldName === 'Marital_Contract_Type__pc'){
					component.set('v.maritalStatusContractList', responseData);
				} else if (fieldName === 'Gender__pc') {
					component.set('v.genderList', responseData);
				} else if (fieldName === 'ID_Type__pc') {
					component.set('v.IdTypeList', responseData);
				}
			}
		});
		$A.enqueueAction(action);
	},

	updateCustomerDetails: function (component, event) {
		var self = this;
		var action = component.get('c.updateCustomerDetails');
		var cifInformationUpdate = component.get('v.cifInformationSerialized');
		var applicationNum = component.get('v.applicationNumber');
		action.setParams({
			'recordId': component.get('v.recordId'),
			'modifiedData': cifInformationUpdate,
			'applicationNumber': applicationNum
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var data = response.getReturnValue();
			if (state === 'SUCCESS') {
				self.hideSpinner(component);
				component.set("v.isEditMode", true);
                self.helperGetAccountByIdNumber(component, event)
				//self.helperUpdateClientCIF(component, event);
				self.getToast('success', 'Record Updated', 'success');
			} else {
				helper.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	helperUpdateClientCIF: function(component, event) {
		var action = component.get('c.updateClientCIF');
		action.setParam({
			accountId: component.get('v.recordId')
		});
		action.setCallback(this, function(response){
			var data, state = response.getState();
			if(state === 'SUCCESS') {
				data = response.getReturnValue();
			}
		});
		$A.enqueueAction(action);
	},

	helperNavigate: function (component, event, helper) {
		var activeSection = [];
		var isEditMode = component.get("v.isEditMode");
		var navigate = component.get('v.navigateFlow');
		var actionClicked = event.getParam('action');
		var ccIdentity = component.find("ccIdentityInformation");
		var ccContactInfo = component.find("ccContactInformation");
		var ccMaritalInfo = component.find("ccMaritalInformation");
		var ccPersonalInfo = component.find("ccPersonalInformation");
		ccIdentity.validateFields();
		ccContactInfo.validateContact();
		ccMaritalInfo.validateMarital();
		ccPersonalInfo.validatePersonal();
		var identitySection = component.get('v.identitySection');
		var contactSection = component.get('v.contactSection');
		var maritalSection = component.get('v.maritalSection');
		var personalSection = component.get('v.personalSection');		  
		if ( actionClicked === 'NEXT' && identitySection && contactSection && maritalSection && personalSection) {
			helper.handleMinimumCIFInformation(component, event);
			navigate(actionClicked);
		} else if (actionClicked === 'PAUSE' && identitySection && contactSection && maritalSection && personalSection) {
			helper.showSpinner(component);
			helper.handleMinimumCIFInformation(component, event);
		} else if (actionClicked === 'BACK') {
			navigate(actionClicked);
		}
		switch(false) {
			case identitySection:
				activeSection.push('identity');
			  break;
			case contactSection:
			    activeSection.push('contact');
			  break;
			case maritalSection:
			  activeSection.push('marital');
			  break;
			case personalSection:
				activeSection.push('personal');
			  break;
			default:
				activeSection.push('identity');
		  }
		component.set('v.activeSection', activeSection);
	},

	helperGetAccountByIdNumber: function (component, event) {
		var self =  this;
		self.showSpinner(component);
		var action = component.get('c.getAccountByIdNumber');
		var accounts = [];
		action.setParams({
			recordId: component.get('v.opportunityRecordId'),
			'idNumber': component.get('v.IdNumber')
		});
		action.setCallback(this, function (response) {
			self.showSpinner(component);
			if (response.getState() === 'SUCCESS') {
				accounts = response.getReturnValue();
				component.set('v.identityInformation', accounts[0]);
				component.set('v.recordId', accounts[0].Id);
				component.set('v.residentialInformation', accounts[0].Addresses__r[0]);
				self.hideSpinner(component);
				if (accounts.length <= 0) {
					self.showSpinner(component);
					self.helperGetCIFByAccountId(component, event);
				}
			} else {
				self.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	helperGetCIFByAccountId: function (component, event) {
		var self = this;
		self.showSpinner(component);
		var action = component.get('c.retriveAccountsById');
		action.setParams({
			'accountId': component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			self.showSpinner(component);
			var state = response.getState();
			var responseDate = response.getReturnValue();
			if (state === 'SUCCESS') {
				if (responseDate) {
					self.hideSpinner(component);
					component.set("v.searchType", 'CIF No');
					component.set("v.searchValue", responseDate[0].CIF__c);
					component.set("v.IdNumber", responseDate[0].ID_Number__pc);
					// this.handlerCustomerDetails(component, event); // commented for current requirement, will enable later
				}
			} else {
				self.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	handlerCustomerDetails: function (component, event) {
		this.showSpinner(component);
		var toastEvent;
		var action = component.get("c.getClientDetailsBean");
		var selectedSearchType = component.get("v.searchType");
		var selectedSearchValue = component.get("v.searchValue");
		action.setParams({
			searchType: selectedSearchType,
			searchValue: selectedSearchValue
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var responseData = response.getReturnValue();
			if (state === 'SUCCESS') {
				if (responseData) {
					if (responseData.length == 0) {
						this.retrieveMDMClient(component); //Set MDM Client Bean
					} else {
						component.set("v.clientDetails", JSON.parse(responseData)); //Set Adapt360 Client Bean
						this.retrieveMDMClient(component); //Set MDM Client Bean
					}
				}
			} else {
				toastEvent = this.getToast("No Results!", "No Client found in CIF and MDM", "Warning");
				toastEvent.fire();
				this.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	retrieveMDMClient: function (component) {
		this.showSpinner(component);
		var toastEvent;
		var selectedSearchType = component.get("v.searchType");
		var selectedSearchValue = component.get("v.searchValue");
		var action = component.get("c.getMDMClientDetailsBean");
		action.setParams({
			searchType: selectedSearchType,
			searchValue: selectedSearchValue
		});
		//Callback that is executed after the server-side action returns
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				//Display Error Message if no results are returned
				if (storeResponse != null) {
					if (storeResponse.length == 0) {
						this.getClientFromJSONBean(component);
					} else {
						component.set("v.mdmClientDetailsBean", JSON.parse(storeResponse));
						this.getClientFromJSONBean(component);
					}
				} else {
					this.getClientFromJSONBean(component);
				}
			} else if (state === "ERROR") {
				var message = "";
				var errors = response.getError();
				if (errors) {
					for (var i = 0; i < errors.length; i++) {
						for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
						}
						if (errors[i].fieldErrors) {
							for (var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for (var j = 0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
								}
							}
						}
						if (errors[i].message) {
							message += (message.length > 0 ? "\n" : "") + errors[i].message;
						}
					}
				} else {
					message += (message.length > 0 ? "\n" : "") + "Unknown error";
				}
				// show error notification
				toastEvent = this.getToast("Error!", message, "Error");
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action); //Add the server-side action to the queue.
	},

	getClientFromJSONBean: function (component) {
		this.showSpinner(component);
		//Generate Client Account Information using the response bean
		//Get Search Type and Search Value
		var toastEvent;
		var selectedSearchType = component.get("v.searchType");
		var selectedSearchValue = component.get("v.searchValue");
		var IdNumber = component.get("v.IdNumber");
		var clientDetailsBean = component.get("v.clientDetails");
		var clientMDMDetailsBean = component.get("v.MDMclientDetailsBean");
		var action = component.get("c.getGIResponseAccount");
		action.setParams({
			cifKey: selectedSearchValue,
			accountIdNumber: IdNumber
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				//Display Error Message if no results are returned
				if (storeResponse != null) {
					if (storeResponse.length == 0) {
						toastEvent = this.getToast("No Results!", "No Client found in CIF and MDM", "Warning");
						toastEvent.fire();
						this.hideSpinner(component);
					} else {
						//Process results
						const clientResult = storeResponse.find(element => element.CIF__c == selectedSearchValue);
						component.set('v.identityInformation', clientResult);
						component.set("v.accountsReturned", storeResponse);
						this.hideSpinner(component);
					}
				} else {
					toastEvent = this.getToast("No Results!", "No Client found in CIF and MDM", "Warning");
					toastEvent.fire();
					this.hideSpinner(component);
				}
			} else if (state === "ERROR") {
				var message = "";
				var errors = response.getError();
				if (errors) {
					for (var i = 0; i < errors.length; i++) {
						for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
						}
						if (errors[i].fieldErrors) {
							for (var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for (var j = 0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
								}
							}
						}
						if (errors[i].message) message += (message.length > 0 ? "\n" : "") + errors[i].message;
					}
				} else {
					message += (message.length > 0 ? "\n" : "") + "Unknown error";
				}
				// show error notification
				toastEvent = this.getToast("Error!", message, "Error");
				toastEvent.fire();
			}
		});
		//Add the server-side action to the queue.
		$A.enqueueAction(action);
	},

	//Function to show spinner when loading
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	//Function to hide spinner after loading
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},

	//Function to show toast for Errors/Warning/Success
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		return toastEvent;
	},

})