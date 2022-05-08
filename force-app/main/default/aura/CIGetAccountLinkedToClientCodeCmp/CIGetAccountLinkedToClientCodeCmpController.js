({
	doInit: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
	},

	getAccountNumbers: function (component, event, helper) {
		var selectedProdType = component.get("v.selectedProductValue");
		var respObj = component.get("v.responseList");

		var acc = [];
		var accNumList = [];

		//Changes added by chandra to show only active combi card dated 29/11/2021
        for (var key in respObj) {
            if (respObj[key].productType == selectedProdType && respObj[key].productType != "CO") {
                var accNumber = respObj[key].oaccntnbr.replace(/^0+/, "");
                acc.push(accNumber);
                accNumList.push({ label: accNumber, value: accNumber });
            }
            else if (respObj[key].productType == selectedProdType && respObj[key].status == "ACTIVE"){
                var accNumber = respObj[key].oaccntnbr.replace(/^0+/, "");
                accNumList.push({ label: accNumber, value: accNumber });
            }
        }
        
        if (selectedProdType == "AF" || selectedProdType == "AVAF") {
			component.set("v.isSpinner", true);
			helper.getAccountDescriptions(component, acc);
		} else {
			component.set("v.accNumList", accNumList);
		}
	},

	getSelectedAccount: function (component, event, helper) {
		var selectedAccountValue = component.get("v.selectedAccountNumber");
		var accBranchCode;
		var respObj = component.get("v.responseList");

		for (var key in respObj) {
			if (respObj[key].oaccntnbr == selectedAccountValue) {
				accBranchCode = respObj[key].branch;
			}
		}

		component.set("v.selectedAccountNumberToFlow", selectedAccountValue);
		component.set("v.selectedProductBranch", accBranchCode);
	}
});