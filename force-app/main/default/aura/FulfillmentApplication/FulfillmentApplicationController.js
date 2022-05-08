({
	//Function called when component loads
	//Setting column structures and document lists
	initializeCmpData: function (component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
		component.set("v.userId", userId);
		helper.showSpinner(component, event, helper);


		//Set Columns clientCodeReviewColumns
		component.set("v.clientCodeReviewColumns", [
			{ label: "Client Name", fieldName: "clientName", type: "text" },
			{ label: "ID/Registration Number", fieldName: "clientIdRegNumber", type: "text" },
			{ label: "Client Code", fieldName: "clientCode", type: "text" },
			//{ label: "Onboarding Status", fieldName: "onboardingStatus", type: "text" }
		]);

		//Set Columns productsForFulfillmentColumns
		component.set("v.productsForFulfillmentColumns", [
			{ label: "Product", fieldName: "productName", type: "text" },
			{ label: "Product Type", fieldName: "productType", type: "text" },
			{ label: "Account Number", fieldName: "productAccountNumber", type: "Number" },
			{ label: "Amount", fieldName: "productAmount", type: "currency", cellAttributes: { alignment: "left" } },
			{ label: "Status", fieldName: "productStatus", type: "text" }
		]);

		//Set Columns for requiredDoc -  W-011452
		component.set("v.requiredApplicationDocsColumns", [
			{ label: "Product", fieldName: "productName", type: "text" },
			{ label: "Account / Unique #", fieldName: "account_Unique_No", type: "text" },
			{ label: "Application Forms", fieldName: "applicationForms", type: "text" }
		]);
		component.set("v.requiredAgreementDocsColumns", [
			{ label: "Product", fieldName: "productName", type: "text" },
			{ label: "Account / Unique #", fieldName: "account_Unique_No", type: "text" },
			{ label: "Quote's/ Agreements", fieldName: "agreements", type: "text" }
		]);
		component.set("v.requiredSecurityDocsColumns", [
			{ label: "Security Type", fieldName: "securityType", type: "text" },
			{ label: "Provider Name", fieldName: "providerName", type: "text" },
			{ label: "Security Document", fieldName: "document", type: "text" }
		]);

		//W-011452 end

		//call helper functions to retrieve data
		helper.fetchClientData(component, event, helper);
		helper.fetchProductData(component, event, helper);
		helper.fetchUserData(component, event, helper);

		helper.hideSpinner(component, event, helper);
	},

	//Function called when the confirmCheckboxGroup checkbox is checked
	//Shows the Submit to Fulfillment button when true and hides if false
	handleConfirmation: function (component, event, helper) {
		//Show-Hide the Submit for Fulfillment Button
		if (event.getParam("value").includes("submit")) {
			$A.util.removeClass(component.find("submitFulfillment"), "slds-hide");
		} else {
			$A.util.addClass(component.find("submitFulfillment"), "slds-hide");
		}
	},
	//Added By Himani Joshi
	handleCompliance: function (component, event, helper) {
		if (event.getParam("value").includes("submit")) {
			component.set('v.checkboxValue', true);
		}
		if ($A.util.isEmpty(event.getParam("value"))) {
			component.set('v.checkboxValue', false);
		}
		helper.updateCompliance(component, event, helper);

	},
	//handles the action when a row option is selected from the lightning:datatable
	handleRowAction: function (component, event, helper) {
		var selectedRow = event.getParam("selectedRows")[0];
        console.log("row selection:---"+selectedRow.productStatus);
		console.log("Row selected: " + selectedRow.Id);
        if(selectedRow.productStatus == 'FulFilled'){
         	 helper.fireToast("Error", "Error!", "You cannot edit a Fulfilled product.", "");
			component.find("prodFulfillDatatable").set("v.selectedRows", []);  
        }
		else if (selectedRow.productState == 'New') {
			component.set("v.applicationProductId", selectedRow.Id);
			helper.openModalHelper(component);
		} else {
			helper.fireToast("warning", "Attention!", "You cannot edit an existing account.", "");
			component.find("prodFulfillDatatable").set("v.selectedRows", []);
		}
	},

	//Open Modal
	openModal: function (component, event, helper) {
		helper.openModalHelper(component);
	},

	//Close Modal
	closeModal: function (component, event, helper) {
		helper.closeModalHelper(component);
	},

	/*@ Author: Danie Booysen
	  **@ Date: 08/04/2020
	  **@ Description: Method that controls component load time actions*/
	handleOnLoad: function (component, event, helper) {
		var currentProductId = component.get("v.applicationProductId");
		var productsForFulfillment = component.get("v.productsForFulfillmentData");
		for (var i = 0; i < productsForFulfillment.length; i++) {
			if (productsForFulfillment[i].Id == currentProductId) {
				console.log('productsForFulfillment[i].Product_Name__c---' + productsForFulfillment[i].Product_Name__c);
				if (productsForFulfillment[i].productName == 'Credit Card') {
					component.set("v.isCCProd", true);

				}else if (productsForFulfillment[i].productName == 'Bank Guarantee') {
					component.set("v.isLDPProd", true);

				} else {
					component.set("v.isCCProd", false);
                    component.set("v.isLDPProd", false);
				}
				break;
			}
		}
		component.set("v.isModalSpinner", false);

	},

	/*@ Author: Danie Booysen
	  **@ Date: 08/04/2020
	  **@ Description: Method that controls component success time actions*/
	handleSuccess: function (component, event, helper) {

		var accountNumber = component.find("productAccountNumbers").get("v.value");
		var productsForFulfillment = component.get("v.productsForFulfillmentData");
		var currentProductId = component.get("v.applicationProductId");
		for (var i = 0; i < productsForFulfillment.length; i++) {
			if (productsForFulfillment[i].Id == currentProductId) {
				productsForFulfillment[i].productAccountNumber = accountNumber;
				break;
			}
		}
		component.set("v.productsForFulfillmentData", productsForFulfillment);
		helper.closeModalHelper(component, event, helper);
		helper.fireToast("success", "Success!", "Account number updated", "");
	},

	/*@ Author: Danie Booysen
	  **@ Date: 08/04/2020
	  **@ Description: Method that controls component error time actions*/
	handleError: function (component, event, helper) {
		console.log("FulfillmentApplication edit account modal error: " + JSON.stringify(event.getParams()));
		helper.fireToast("error", "Error!", "There has been an error saving the data.", "");
	},

	/*@ Author: Danie Booysen
	  **@ Date: 25/01/2021
	  **@ Description: Method that retrieves securities offered and does the validation that the Application is ready for fulfillment*/
	validateAndSubmit: function (component, event, helper) {
		//the validation is called from in this function after the securities offered data is retrieved
		helper.securitiesOfferedData(component, event, helper);
	}
})