/**
	 * method to declare the transactional history data table
	 */
({
	handleTransactionalHistory: function (component, event, helper) {
      
		component.find("startDate").set("v.value", "");
		component.find("endDate").set("v.value", "");
		component.set("v.transactionalHistoryColumns", [
			{ label: "Date", fieldName: "Transaction_Date__c", type: "text" },
			{ label: "Description", fieldName: "Reason__c", type: "text" },
			{ label: "Amount", fieldName: "Amount__c", type: "text" },
			{ label: "Balance", fieldName: "Balance__c", type: "text" }
		]);
		helper.handleTransactionalHistoryHelper(component, event, helper);
	},

	/**
	 * method to filter the transactional history data story
	 * filter the transactional history data within the date range.
	 */
	filterDateRange: function (component, event, helper) {
		var startDate = component.find("startDate").get("v.value");
		var endDate = component.find("endDate").get("v.value");
		if (endDate < startDate) {
			helper.fireToastEvent("Validation Warning", "End date cannot be in past", "warning");
		} else {
			helper.filterDateRangeHelper(component, event, helper);
		}
	},
    onNext: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onPrev: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onFirst: function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onLast: function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPageDataAsPerPagination(component);
    },
})