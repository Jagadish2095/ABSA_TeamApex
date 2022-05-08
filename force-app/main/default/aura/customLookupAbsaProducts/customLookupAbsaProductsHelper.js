({
    //Function for setting the table columns and setting the fields to be queried.
    getColumns: function (component) {
        component.set("v.columnList", [
            { label: "Product", fieldName: "product", type: "text" },
            { label: "Product Type", fieldName: "productType", type: "text" },
            { label: "Account Number", fieldName: "accNor", type: "text" },
            { label: "Branch", fieldName: "branch", type: "text" },
            {
                label: "Action", type: "button", typeAttributes: {
                    label: 'View',
                    name: 'View',
                    disabled: false,
                    value: 'View',
                    iconPosition: 'Right'
                }
            },
        ]);
    },

    searchHelper: function (component, event, getInputkeyWord) {

        var action = component.get("c.getProductsList");
        var accountId = component.get("v.recordId");
        console.log("Account " + accountId);
        action.setParams({
            'AccountId': accountId,

        });

        action.setCallback(this, function (response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {

                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen. 
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...Please try again !!!');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                storeResponse.sort();
                component.set("v.listOfSearchRecords", storeResponse);
                component.set("v.displayList", storeResponse);
                component.set("v.clientProductSize", storeResponse.length);
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);

    },
    //Function for getting the data from the Apex controller
    getAccountDetails: function (component, accountNumber) {
        var oProduct = component.get("v.oProduct");
        var productType = oProduct.product;

        var action = component.get("c.getContactInfoRequest");
        if (accountNumber.length > 10) {
            if (accountNumber.substr(0, 6) == "000000")
                accountNumber = accountNumber.substr(6);
        }
        action.setParams({
            I_ACCOUNT: accountNumber

        });
        action.setCallback(this, function (response) {
            // store the response return value 
            var state = response.getState();
            var resultData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (resultData == null || resultData.BAPI_SF_IF22 == null) {
                    this.fireToastEvent("Error", " Blank response received from service", "error");
                }
                //check the response statusCode
                if (resultData.statusCode != 200) {
                    this.fireToastEvent("Error", resultData.message, "error");
                } else {
                    if (resultData.BAPI_SF_IF22.E_RESPONSE != 0) {
                        this.fireToastEvent("Error", resultData.BAPI_SF_IF22.E_RESPONSE_DESC, "error");
                    }

                    this.hideSpinner(component);
                    component.set("v.accountDetails", resultData.BAPI_SF_IF22.E_ACC_DETAILS);
                }
            }
        });
        $A.enqueueAction(action);


        //Get the response from BAPI_SF_IF42AccountInformation
        var getAction = component.get("c.getAccFinInformation");
        getAction.setParams({
            accountNo: accountNumber
        });
        getAction.setCallback(this, function (response) {
            // store the response return value 
            var state = response.getState();
            var resultData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (resultData == null || resultData.BAPI_SF_IF42 == null) {
                    this.fireToastEvent("Error", " Blank response received from service", "error");
                }
                //check the response statusCode
                if (resultData.statusCode != 200) {
                    this.fireToastEvent("Error", resultData.message, "error");
                } else {
                    if (resultData.BAPI_SF_IF42.E_RESPONSE != 0) {
                        this.fireToastEvent("Error", resultData.BAPI_SF_IF42.E_RESPONSE_DESC, "error");
                    }

                    this.hideSpinner(component);
                    component.set("v.financialInformation", resultData.BAPI_SF_IF42.E_FI_DETAILS);
                }
            }
        });
        $A.enqueueAction(getAction);


    },

    showSpinner: function (component) {
        component.set("v.showSpinner", true);
    },

    hideSpinner: function (component) {
        component.set("v.showSpinner", false);
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
})