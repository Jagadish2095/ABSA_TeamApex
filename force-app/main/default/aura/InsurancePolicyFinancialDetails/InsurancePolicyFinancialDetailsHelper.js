({
    //Function for setting the table columns and setting the fields to be queried.
    getColumns: function (component) {
        component.set("v.columnList", [
            { label: "Transaction Number", fieldName: "Transaction_Number__c", type: "text" },
            { label: "Transaction Date", fieldName: "Transaction_Date__c", type: "date" },
            { label: "Transaction Type", fieldName: "Transaction_Type__c", type: "text" },
            { label: "Transaction Amount Excl VAT", fieldName: "Transaction_Amount_Excl_VAT__c", type: "text" },
            { label: "Premium Incl VAT", fieldName: "Premium_Incl_VAT__c", type: "text" },
            { label: "Cover To", fieldName: "Cover_To__c", type: "date" },
            { label: "Cover From", fieldName: "Cover_From__c", type: "date" },
            { label: "VAT Amount", fieldName: "VAT_Amount__c", type: "text" },
            { label: "Footprint Id", fieldName: "Footprint_Id__c", type: "text" },
            { label: "User Id", fieldName: "User_Id__c", type: "text" }
        ]);

        var queryFields =
            "Transaction_Number__c, Transaction_Date__c, Transaction_Type__c, Transaction_Amount_Excl_VAT__c, Premium_Incl_VAT__c,Cover_To__c, Cover_From__c, Footprint_Id__c, User_Id__c ";
        component.set("v.queryFieldsString", queryFields);
    },

    //Function for getting the data from the Apex controller
    getDataHelper: function (component, event) {
        var action = component.get("c.getFinancialDetails");
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");

        action.setParams({
            InsurancePolicyId: component.get("v.policyRecordId"),
            objectFields: component.get("v.queryFieldsString"),
            searchFilter: component.get("v.searchFilterString"),
            pageSize: pageSize,
            pageNumber: pageNumber
        });
        action.setCallback(this, function (response) {
            // store the response return value
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                if (resultData.length < component.get("v.pageSize")) {
                    component.set("v.isLastPage", true);
                } else {
                    component.set("v.isLastPage", false);
                }

                component.set("v.totalRows", resultData.length);
                component.set("v.financialDetailsData", resultData);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error InsurancePolicyFinancialDetailsCtrl.getFinancialDetails: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
        component.set("v.showLoadingSpinner", false);
    },

    search: function (component) {
        var maxDateFieldValidity = component.find("maxDate").get("v.validity");
        var minDateFieldValidity = component.find("minDate").get("v.validity");

        //Validate Date Fields
        if (!maxDateFieldValidity.valid || !minDateFieldValidity.valid) {
            component.set("v.showLoadingSpinner", false);
            component.find("notifLib").showToast({ variant: "error", message: "Please Enter a valid Date range" });
            return null;
        }

        this.setSearchCondition(component);
        this.getDataHelper(component);
    },

    setSearchCondition: function (component) {
        var searchConditionVar;
        if (component.get("v.minDateValue") != null && component.get("v.maxDateValue") != null) {
            searchConditionVar =
                "AND Transaction_Date__c >= " + component.get("v.minDateValue") + " AND " + "Transaction_Date__c <= " + component.get("v.maxDateValue");
        } else if (component.get("v.maxDateValue") == null && component.get("v.minDateValue") != null) {
            searchConditionVar = "AND Transaction_Date__c >= " + component.get("v.minDateValue");
        } else if (component.get("v.maxDateValue") != null && component.get("v.minDateValue") == null) {
            searchConditionVar = "AND Transaction_Date__c <= " + component.get("v.maxDateValue");
        }
        component.set("v.searchFilterString", searchConditionVar);
    },

    fireToastEvent: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    }
});