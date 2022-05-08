/**
	 * method to fetch the transactional history data
	 */
({
	handleTransactionalHistoryHelper: function (component, event, helper) {
     
		  this.showSpinner(component);
        
		var action = component.get("c.getTransactionalHistory");
		//setting params
		action.setParams({
			policyNumber: component.get("v.selectedAccountFromFlow"),
            caseId : component.get("v.caseId")
		});

		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
                let transactionList = JSON.parse(responseData);
					component.set("v.transactionalHistoryData",transactionList);
                     component.set("v.fData",transactionList);
					component.set("v.transactionalHistoryDataTable",transactionList);
                   // pagination starts here
                    this.preparePagination(component,transactionList);
				
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	/**
	 * @description to run the filter logic 
	 * @param component
	 * @param Event
	 * @param helper
	 
	 */
	filterDateRangeHelper: function (component, event, helper) {
		var startDate = component.find("startDate").get("v.value");
		var endDate = component.find("endDate").get("v.value");
		var transactionalHistoryData = component.get("v.transactionalHistoryData");
		var filterData = [];
		if ($A.util.isEmpty(startDate) || $A.util.isEmpty(endDate)) {
			helper.fireToastEvent("Validation Warning", "Missing start/end date", "warning");
		} else {
			for (var i = 0; i < transactionalHistoryData.length; i++) {
				if (startDate <= transactionalHistoryData[i].CreatedDate && endDate >= transactionalHistoryData[i].CreatedDate) {
					filterData.push(transactionalHistoryData[i]);
				}
			}
			component.set("v.transactionalHistoryDataTable", filterData);
		}
	},
    preparePagination: function (component, responseData) {
        let countTotalPage = Math.ceil(responseData.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.fData');
        let x = (pageNumber - 1) * pageSize;
        for (x; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        
        component.set("v.transactionalHistoryDataTable", data);
        
    },
    fireToastEvent: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},
    showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	}
   
})