/**
 * This is the JavaScript Controller for the SiteLookup Component for the selection of Site records
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-03-07
 */

({
	//Added against W-005675 dated 13/09/2020 by Humbe
	doInit: function (component, event, helper) {
		helper.serviceGroupHelper(component);
		helper.salesGroupHelper(component); //Added by chandra dated 15/06/2021 against W-012959
	},

	onfocus: function (component, event, helper) {
		$A.util.addClass(component.find("mySpinner"), "slds-show");

		var forOpen = component.find("searchRes");

		$A.util.addClass(forOpen, "slds-is-open");
		$A.util.removeClass(forOpen, "slds-is-close");

		var inputKeyWord = "";

		//Added against W-002766 dated 31/08/2019 by Chandra
		let placeholder = component.get("v.placeholder");
		let whatDoYouWantToDoToday = $A.get("$Label.c.What_do_you_want_to_do_today");
		let siteCode = $A.get("$Label.c.Site_Code");
		//Added against W-003217 dated 27/11/2019 by Prasanna
		let SearchAbsaFinancialProduct = $A.get("$Label.c.Search_Absa_Financial_Product");
		let AddAbsaProduct = $A.get("$Label.c.Add_Absa_Product");
		if (
			!placeholder.includes(whatDoYouWantToDoToday) &&
			placeholder != siteCode &&
			placeholder != "franchiseCode" &&
			placeholder != SearchAbsaFinancialProduct &&
			placeholder != AddAbsaProduct
		) {
			helper.searchHelper(component, event, inputKeyWord);
		} else if (placeholder == siteCode) {
			helper.searchMetadataList(component, event, inputKeyWord);
		} else if (placeholder == "franchiseCode") {
			helper.searchMetadataListFranchisecode(component, event, inputKeyWord);
		} else if (placeholder == SearchAbsaFinancialProduct) {
			helper.searchKeywordforFinanProduct(component, event, inputKeyWord);
		} else if (placeholder == AddAbsaProduct) {
			helper.searchKeywordforProduct(component, event, inputKeyWord);
		} else {
			if (placeholder == whatDoYouWantToDoToday) {
				helper.searchKeywordforSales(component, event, inputKeyWord);
				helper.searchKeyword(component, event, inputKeyWord);
			} else {
				//Added by chandra dated 15/06/2021 against W-012959
				helper.searchKeywordforSales(component, event, inputKeyWord);
				helper.searchKeywordforOnboarding(component, event, inputKeyWord);
			}
		}
	},

	onblur: function (component, event, helper) {
		component.set("v.listOfSearchRecords", null);

		var forclose = component.find("searchRes");

		$A.util.addClass(forclose, "slds-is-close");
		$A.util.removeClass(forclose, "slds-is-open");
	},

	keyPressController: function (component, event, helper) {
		var inputKeyWord = component.get("v.SearchKeyWord");

		if (inputKeyWord.length > 0) {
			var forOpen = component.find("searchRes");

			$A.util.addClass(forOpen, "slds-is-open");
			$A.util.removeClass(forOpen, "slds-is-close");

			//Added against W-002766 dated 31/08/2019 by Chandra
			let placeholder = component.get("v.placeholder");
			let whatDoYouWantToDoToday = $A.get("$Label.c.What_do_you_want_to_do_today");
			//Added against W-003217 dated 27/11/2019 by Prasanna
			let SearchAbsaFinancialProduct = $A.get("$Label.c.Search_Absa_Financial_Product");
			let AddAbsaProduct = $A.get("$Label.c.Add_Absa_Product");
			let siteCode = $A.get("$Label.c.Site_Code");
			if (
				!placeholder.includes(whatDoYouWantToDoToday) &&
				placeholder != siteCode &&
				placeholder != "franchiseCode" &&
				placeholder != SearchAbsaFinancialProduct &&
				placeholder != AddAbsaProduct
			) {
				helper.searchHelper(component, event, inputKeyWord);
			} else if (placeholder == siteCode) {
				helper.searchMetadataList(component, event, inputKeyWord);
			} else if (placeholder == "franchiseCode") {
				helper.searchMetadataListFranchisecode(component, event, inputKeyWord);
			} else if (placeholder == SearchAbsaFinancialProduct) {
				helper.searchKeywordforFinanProduct(component, event, inputKeyWord);
			} else if (placeholder == AddAbsaProduct) {
				helper.searchKeywordforProduct(component, event, inputKeyWord);
			} else {
				if (placeholder == whatDoYouWantToDoToday) {
					//Added by chandra dated 15/06/2021 against W-012959
					helper.searchKeywordforSales(component, event, inputKeyWord);
					helper.searchKeyword(component, event, inputKeyWord);
				} else {
					//Added by chandra dated 15/06/2021 against W-012959
					helper.searchKeywordforSales(component, event, inputKeyWord);
					helper.searchKeywordforOnboarding(component, event, inputKeyWord);
				}
			}
		} else {
			component.set("v.listOfSearchRecords", null);

			var forclose = component.find("searchRes");

			$A.util.addClass(forclose, "slds-is-close");
			$A.util.removeClass(forclose, "slds-is-open");
		}
	},

	clear: function (component, event, helper) {
		helper.clearMethod(component, event, helper);
	},

	handleComponentEvent: function (component, event, helper) {
		var selectedsObjectGetFromEvent = event.getParam("recordByEvent");

		component.set("v.selectedRecord", selectedsObjectGetFromEvent);
		//changes against cmpChooseTask start
		var selectedJobValue = component.get("v.selectedRecord");
		if (selectedJobValue != undefined) {
			var cmpEvent = component.getEvent("selectedJobEvent");
			cmpEvent.setParams({
				selectedJob: selectedJobValue
			});
			cmpEvent.fire();
		}
		//changes against cmpChooseTask end

		var forclose = component.find("lookup-pill");

		$A.util.addClass(forclose, "slds-show");
		$A.util.removeClass(forclose, "slds-hide");

		var forclose = component.find("searchRes");

		$A.util.addClass(forclose, "slds-is-close");
		$A.util.removeClass(forclose, "slds-is-open");

		var lookUpTarget = component.find("lookupField");

		$A.util.addClass(lookUpTarget, "slds-hide");
		$A.util.removeClass(lookUpTarget, "slds-show");
	},

	executeClearMethod: function (component, event, helper) {
		helper.clearMethod(component, event, helper);
	}
});