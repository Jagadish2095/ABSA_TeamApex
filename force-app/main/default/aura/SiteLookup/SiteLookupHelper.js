/**
 * This is the JavaScript Helper for the SiteLookup Component for the selection of Site records
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-03-07
 */

({
	/****************@ Author: Humbe*********************************************
	 ****************@ Date: 13/09/2020********************************************
	 ****************@ Work Id: W-005675*******************************************
	 ****************@ Description: Method to handle retrieval of service groups associated with the current user**/
	serviceGroupHelper: function (component) {
		var action = component.get("c.getUserServiceGroups");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.userServiceGroup", response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors && errors[0] && errors[0].message) {
					console.log("Error message: " + errors[0].message);
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra*******************************************************************************
	 ****************@ Date: 15/06/2021******************************************************************************
	 ****************@ Work Id: W-012959*****************************************************************************
	 ****************@ Description: Method to handle retrieval of sales groups associated with the current user*****/
	salesGroupHelper: function (component) {
		var action = component.get("c.getUserSalesGroups");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.userSalesGroup", response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors && errors[0] && errors[0].message) {
					console.log("Error message: " + errors[0].message);
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	searchHelper: function (component, event, inputKeyWord) {
		var action = component.get("c.fetchSiteValues");

		action.setParams({
			searchKeyWord: inputKeyWord,
			objectName: component.get("v.objectAPIName")
		});

		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();

			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				if (storeResponse.length == 0) {
					component.set("v.Message", "No Result Found...");
				} else {
					component.set("v.Message", "");
				}
				component.set("v.listOfSearchRecords", storeResponse);
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra*********************************************
	 ****************@ Date: 02/09/2019********************************************
	 ****************@ Work Id: W-002766*******************************************
	 ****************@ Description: Method to handle search keyword functionality**/
	searchKeyword: function (component, event, getInputkeyWord) {
		// call the apex class method
		var action = component.get("c.fetchLookUpValues");
		// set param to method
		action.setParams({
			searchKeyWord: getInputkeyWord,
			objectName: component.get("v.objectAPIName"),
			userServiceGroupList: component.get("v.userServiceGroup")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				//Added by chandra dated 15/06/2021 against W-012959
				if (component.get("v.objectAPIName") == "Service_Group_Type__c") {
					let objArray = [];
					for (let key in storeResponse) {
						var serviceTypeobj = new Object();
						serviceTypeobj = storeResponse[key];
						serviceTypeobj.Group = storeResponse[key].Service_Group__r.Name;
						serviceTypeobj.Type = storeResponse[key].Service_Type__r.Name;
						serviceTypeobj.ObjectRef = "Service_Group_Type__c";
						objArray.push(serviceTypeobj);
					}
					let userSalesGroupProcessType = component.get("v.userSalesGroupProcessType");
					userSalesGroupProcessType.forEach(function (item) {
						objArray.push(item);
					});

					// if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
					if (objArray.length == 0) {
						component.set("v.Message", "No Result Found...");
					} else {
						component.set("v.Message", "");
					}
					// set searchResult list with return value from server
					component.set("v.listOfSearchRecords", objArray);
				} else {
					// if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
					if (storeResponse.length == 0) {
						component.set("v.Message", "No Result Found...");
					} else {
						component.set("v.Message", "");
					}
					// set searchResult list with return value from server
					component.set("v.listOfSearchRecords", storeResponse);
				}
			}
		});
		// enqueue the Action
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra*********************************************
 	 ****************@ Date: 02/09/2019********************************************
 	 ****************@ Work Id: W-002766*******************************************
 	 ****************@ Description: Method to handle search keyword functionality**
     for Onboarding***************************************************************/
	searchKeywordforOnboarding: function (component, event, getInputkeyWord) {
		// call the apex class method
		var action = component.get("c.fetchLookUpValuesforOnboarding");
		// set param to method
		action.setParams({
			searchKeyWord: getInputkeyWord,
			objectName: component.get("v.objectAPIName"),
			userServiceGroupList: component.get("v.userServiceGroup")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				let objArray = []; //Common Array List to combine sales and service types
				for (let key in storeResponse) {
					var serviceTypeobj = new Object();
					serviceTypeobj = storeResponse[key];
					serviceTypeobj.Group = storeResponse[key].Service_Group__r.Name;
					serviceTypeobj.Type = storeResponse[key].Service_Type__r.Name;
					serviceTypeobj.ObjectRef = "Service_Group_Type__c";
					objArray.push(serviceTypeobj);
				}
				let userSalesGroupProcessType = component.get("v.userSalesGroupProcessType");
				userSalesGroupProcessType.forEach(function (item) {
					objArray.push(item);
				});

				// if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
				if (objArray.length == 0) {
					component.set("v.Message", "No Result Found...");
				} else {
					component.set("v.Message", "");
				}
				// set searchResult list with return value from server
				component.set("v.listOfSearchRecords", objArray);
			}
		});
		// enqueue the Action
		$A.enqueueAction(action);
	},

	/****************@ Author: Prasanna*********************************************
 	 ****************@ Date: 27/11/2019********************************************
 	 ****************@ Work Id: W-003217*******************************************
 	 ****************@ Description: Method to handle search keyword functionality**
     for Financial Product***************************************************************/
	searchKeywordforFinanProduct: function (component, event, getInputkeyWord) {
		var action = component.get("c.fetchLookUpFinProductValues");

		// set param to method
		action.setParams({
			searchKeyWord: getInputkeyWord,
			ObjectName: component.get("v.objectAPIName")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();

				// if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
				if (storeResponse.length == 0) {
					component.set("v.Message", "No Result Found...");
				} else {
					component.set("v.Message", "");
				}
				// set searchResult list with return value from server
				component.set("v.listOfSearchRecords", storeResponse);
			}
		});
		// enqueue the Action
		$A.enqueueAction(action);
	},

	/****************@ Author: Diksha*********************************************
 	 ****************@ Date: 14/02/2020********************************************
 	 ****************@ Work Id: W-003506*******************************************
 	 ****************@ Description: Method to handle search keyword functionality**
     for Financial Product***************************************************************/
	searchKeywordforProduct: function (component, event, getInputkeyWord) {
		var action = component.get("c.fetchLookUpProductValues");

		// set param to method
		action.setParams({
			searchKeyWord: getInputkeyWord,
			ObjectName: component.get("v.objectAPIName")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();

				// if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
				if (storeResponse.length == 0) {
					component.set("v.Message", "No Result Found...");
				} else {
					component.set("v.Message", "");
				}
				// set searchResult list with return value from server
				var opp = component.get('v.opportunityRec');
				var productsToExclude = ['Batch Link','Master Pass','Virtual Terminal / Moto Merchant'];
				var updatedList = [];
				for(let i=0; i < storeResponse.length; i++){
					
					if(opp && opp.RecordType.Name != 'Digital Merchant Onboarding' && productsToExclude.includes(storeResponse[i].Name)){
						
					}
					else{
						updatedList.push(storeResponse[i]);
					}
				}
				component.set("v.listOfSearchRecords", updatedList);
		}
		});
		// enqueue the Action
		$A.enqueueAction(action);
	},

	clearMethod: function (component, event, helper) {
		var pillTarget = component.find("lookup-pill");
		var lookUpTarget = component.find("lookupField");

		$A.util.addClass(pillTarget, "slds-hide");
		$A.util.removeClass(pillTarget, "slds-show");
		$A.util.addClass(lookUpTarget, "slds-show");
		$A.util.removeClass(lookUpTarget, "slds-hide");

		component.set("v.SearchKeyWord", null);
		component.set("v.listOfSearchRecords", null);
		component.set("v.selectedRecord", {});
	},

	/****************@ Author: Chandra*********************************************
 	 ****************@ Date: 12/10/2019********************************************
 	 ****************@ Work Id: W-002766*******************************************
 	 ****************@ Description: Method for the SiteLookup Component for the****
     selection of Branch Site Code************************************************/
	searchMetadataList: function (component, event, inputKeyWord) {
		var action = component.get("c.fetchBranchSiteCodeValues");

		action.setParams({
			searchKeyWord: inputKeyWord
		});

		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();

			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				storeResponse.forEach(function (element) {
					var data = element;
					data["Name"] = element.Name;
				});
				if (storeResponse.length == 0) {
					component.set("v.Message", "No Result Found...");
				} else {
					component.set("v.Message", "");
				}
				component.set("v.listOfSearchRecords", storeResponse);
			}
		});
		$A.enqueueAction(action);
	},
	searchMetadataListFranchisecode: function (component, event, inputKeyWord) {
		var action = component.get("c.fetchFranchiserCodeValues");

		action.setParams({
			searchKeyWord: inputKeyWord
		});

		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();

			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				storeResponse.forEach(function (element) {
					var data = element;
					console.log("element.Name" + element.Franchise_Code__c);
					data["Name"] = element.Franchise_Code__c;
				});
				if (storeResponse.length == 0) {
					component.set("v.Message", "No Result Found...");
				} else {
					component.set("v.Message", "");
				}
				component.set("v.listOfSearchRecords", storeResponse);
			}
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra*******************************************************************************
	 ****************@ Date: 15/06/2021******************************************************************************
	 ****************@ Work Id: W-012959*****************************************************************************
	 ****************@ Description: Method to handle retrieval of sales type associated with the Sales Group********/
	searchKeywordforSales: function (component, event, getInputkeyWord) {
		// call the apex class method
		var action = component.get("c.fetchLookUpValuesforSales");
		// set param to method
		action.setParams({
			searchKeyWord: getInputkeyWord,
			userSalesGroupList: component.get("v.userSalesGroup")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();
			if (state === "SUCCESS") {
				var salesResponse = response.getReturnValue();
				let salesTypeobjArray = [];
				for (let key in salesResponse) {
					var salesTypeobj = new Object();
					salesTypeobj = salesResponse[key];
					salesTypeobj.Group = salesResponse[key].Sales_Group__r.Name;
					salesTypeobj.Type = salesResponse[key].Sales_Process_Type__r.Name;
					salesTypeobj.ObjectRef = "Sales_Group_Process_Type__c";
					salesTypeobjArray.push(salesTypeobj);
				}
				component.set("v.userSalesGroupProcessType", salesTypeobjArray);
			}
		});
		// enqueue the Action
		$A.enqueueAction(action);
	}
});