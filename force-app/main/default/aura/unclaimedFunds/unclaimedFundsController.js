/**
 * Unclaimed funds controller js
 * @Author: Mbuyiseni Mbhokane
 * @Since: 20/10/2020
 */
({
	doInit: function (component, event, helper) {
		//helper.getCustomerAccounts(component, event, helper);
		component.set("v.progressIndicatorFlag", "stepOne");
	},

	//HANDLE SELECTED ROW OF THE DATATABLE
	handleSelection: function (component, event, helper) {
		var selectedRow = event.getParam("selectedRows");
		component.set("v.showSelectedDetails", selectedRow);
		component.find("viewAccount").set("v.disabled", false);
		for (var i = 0; i < selectedRow.length; i++) {
			console.log("selected row data : " + JSON.stringify(selectedRow));
			component.set("v.selectedAccountNumber", selectedRow[i].oaccntnbr);
			component.set("v.selectedProductType", selectedRow[i].productType);
		}
	},

	/**
	 * START OF THE BUTTON NAVIGATION
	 * ADDED BY MBUYISENI MBHOKANE
	 */
	goToStepTwo: function (component, event, helper) {
		component.set("v.progressIndicatorFlag", "stepTwo");
		component.set("v.isStepOne", "false");
		component.set("v.isStepTwo", "true");

		//set the block param value
		component.set("v.holdIndicator", "Y");

		if (component.get("v.selectedProductType") == "SA") {
			helper.savingsViewAccount(component, event, helper);
			console.log("goToStepTwo: helper.savingsViewAccount: Block==Y");
		} else if (component.get("v.selectedProductType") == "CQ") {
			//helper.chequeViewAccount(component, event, helper);
			console.log("goToStepTwo: helper.chequeViewAccount: Block==Y");
			//get cheque account closure amount:
			helper.cqCloseAccountDetails(component, event, helper);
		}
	},

	goToStepThree: function (component, event, helper) {
		component.set("v.progressIndicatorFlag", "stepThree");
		component.set("v.isStepTwo", "false");
		component.set("v.isStepThree", "true");

		//set the block param value
		component.set("v.holdIndicator", "N");

		if (component.get("v.selectedProductType") == "SA") {
			helper.savingsViewAccount(component, event, helper);
			console.log("goToStepThree: helper.savingsViewAccount: Block==N");
		} else if (component.get("v.selectedProductType") == "CQ") {
			helper.chequeViewAccount(component, event, helper);
			console.log("goToStepThree: helper.chequeViewAccount: Block==N");
			//call updateClosureAccountDetails
			helper.cqUpdateAccountClosureDetails(component, event, helper);
		}
		//helper.savingsViewAccount(component, event, helper);
	},

	goToStepOne: function (component, event, helper) {
		//component.set('v.progressIndicatorFlag', 'stepFour');
		component.set("v.progressIndicatorFlag", "stepOne");
		component.set("v.isStepThree", "false");
		component.set("v.isStepOne", "true");
		//We display the confirmation

		/*component.set('v.holdIndicator', 'N');

        if (component.get('v.selectedProductType') == 'SA') {
            helper.savingsViewAccount(component, event, helper);
            console.log('Call Savings Digital Hold');

        } else if(component.get('v.selectedProductType') == 'CQ'){
            helper.chequeViewAccount(component, event, helper);
            console.log('Call cheque Digital Hold');
        }*/
	},

	/*goToStepFive: function (component, event, helper) { 
        component.set('v.progressIndicatorFlag', 'stepFive');
        component.set('v.isStepFour', 'false');
        component.set('v.isStepFive','true');  
    },*/

	goBackToStepOne: function (component, event, helper) {
		component.set("v.progressIndicatorFlag", "stepOne");
		component.set("v.isStepOne", "true");
		component.set("v.isStepTwo", "false");
		component.set("v.showSavings", false);
		component.set("v.showCheque", false);
	},

	goBackToStepTwo: function (component, event, helper) {
		component.set("v.progressIndicatorFlag", "stepTwo");
		component.set("v.isStepTwo", "true");
		component.set("v.isStepThree", "false");
	},

	goBackToStepThree: function (component, event, helper) {
		component.set("v.progressIndicatorFlag", "stepThree");
		component.set("v.isStepThree", "true");
		component.set("v.isStepFour", "false");
	},

	goBackToStepFour: function (component, event, helper) {
		component.set("v.progressIndicatorFlag", "stepFour");
		component.set("v.isStepFour", "true");
		component.set("v.isStepFive", "false");
	},
	//end of navigation buttons

	handleRecordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
		if (eventParams.changeType === "LOADED") {
			console.log("You loaded a record ID " + component.get("v.caseRecordFields.AccountId"));
			var accountRecordId = component.get("v.caseRecordFields.AccountId");
			component.set("v.accountRecordId", accountRecordId);
			console.log("SET Account Id: " + component.get("v.accountRecordId"));
			if (!$A.util.isEmpty(component.get("v.accountRecordId"))) {
				console.log("Call the service");
				helper.getCustomerAccounts(component, event, helper);
			}
		}
	},

	handleUploadFinished: function (component, event, helper) {
		var uploadedFiles = event.getParam("files");
		console.log("Files uploaded : " + uploadedFiles.length);
		var documentList = [];
		for (var i = 0; i < uploadedFiles.length; i++) {
			documentList.push(uploadedFiles[i].documentId);
		}
		component.set("v.documentIds", documentList);
		console.log("SET Document IDS: " + component.get("v.documentIds"));
	},

	//use on the button to test the response
	handleCloseAccountService: function (component, event, helper) {
		helper.cqCloseAccountDetails(component, event, helper);
	},

	//START OF PAGINATION
	//FOR ACCOUNTS THAT CANNOT BE CLOSED
	onNext: function (component, event, helper) {
		var pageNumber = component.get("v.currentPageNumber");
		component.set("v.currentPageNumber", pageNumber + 1);
		helper.setPageDataAsPerPagination(component);
	},

	onPrev: function (component, event, helper) {
		var pageNumber = component.get("v.currentPageNumber");
		component.set("v.currentPageNumber", pageNumber - 1);
		helper.setPageDataAsPerPagination(component);
	},

	onFirst: function (component, event, helper) {
		component.set("v.currentPageNumber", 1);
		helper.setPageDataAsPerPagination(component);
	},

	onLast: function (component, event, helper) {
		component.set("v.currentPageNumber", component.get("v.totalPages"));
		helper.setPageDataAsPerPagination(component);
	},

	/*onPageSizeChange: function(component, event, helper) {        
        helper.preparePagination(component, component.get('v.viewCustomerAccountDetails'));
    },*/

	//FOR ACCOUNTS THAT CAN BE CLOSED
	onNextPage: function (component, event, helper) {
		var pageNumber = component.get("v.currentPageNo");
		component.set("v.currentPageNo", pageNumber + 1);
		helper.accsetPageDataAsPerPagination(component);
	},

	onPrevPage: function (component, event, helper) {
		var pageNumber = component.get("v.currentPageNo");
		component.set("v.currentPageNo", pageNumber - 1);
		helper.accsetPageDataAsPerPagination(component);
	},

	onFirstPage: function (component, event, helper) {
		component.set("v.currentPageNo", 1);
		helper.accsetPageDataAsPerPagination(component);
	},

	onLastPage: function (component, event, helper) {
		component.set("v.currentPageNo", component.get("v.totalNoPages"));
		helper.accsetPageDataAsPerPagination(component);
	}

	/*onPageRecordSizeChange: function(component, event, helper) {        
        helper.accpreparePagination(component, component.get('v.customerAccountDetails'));
    },*/
	//END OF PAGINATION
	//
});