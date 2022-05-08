({
    //JQUEV 2020-10-20
    doInit: function (component, event, helper) {
        //Set Columns
        component.set("v.columns", [
            { label: "Name", fieldName: "firstName", type: "text" },
            { label: "Surname", fieldName: "surname", type: "text" },
            { label: "Role Type", fieldName: "roleType", type: "text" },
            { label: "Benefit Description", fieldName: "benefitDescriptionEnglish", type: "text" },
            { label: "Relationship", fieldName: "relationshipCode", type: "text" },
            { label: "Premium Cover", fieldName: "benefitPremium", type: "text" }
        ]);

        //Get Account/Policy Number and call LAListPolicyDetailsByPolicyV7 Service
        var selectedAccountNumber = component.get("v.selectedAccountNumber");
        if ($A.util.isEmpty(selectedAccountNumber)) {
            component.set("v.errorMessage", "Please select an Account/Policy Number on the previous page. ");
        } else {
            helper.getPolicyDetails(component, event, helper, selectedAccountNumber);
        }
    },

    //Close Case
    closeCase : function(component, event, helper){
        helper.showSpinner(component);
        component.find("statusField").set("v.value", "Closed");
        component.find("caseEditForm").submit();
    },

	//Success - Case
    handleSuccess : function(component, event, helper){
		helper.hideSpinner(component);
		helper.fireToast("Success!", "Case successfully closed. ", "success");
    },


	//Error - Case
    handleError : function(component, event, helper){
		helper.hideSpinner(component);
		helper.fireToast("Error!", "There has been an error saving the data. ", "error");
		component.set("v.errorMessage", "There has been an error saving the data: "  + JSON.stringify(event.getParams()));
	},
});