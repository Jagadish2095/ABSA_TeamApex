({
	// getting value from data privacy flag field on account
    doInit_helper: function(component, event){
        var getBatchsAction = component.get("c.getPrivacyFieldValue");
        getBatchsAction.setParams({
            accountId : component.get("v.recordId")
        });
		getBatchsAction.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
                var list = [];
                for (var i = 0; i < result.list_DataPrivacy.length; i++) {
                    var obj = {};
                    obj.label = result.list_DataPrivacy[i];
                    obj.value = result.list_DataPrivacy[i];
                    list.push(obj);
                }      
                component.set("v.SelectedPickList", result.list_SelectedData);
                component.set("v.PicklistOptions", list);
			}
		})
        $A.enqueueAction(getBatchsAction);
    },    
    
    
    // Submiiting data flag to C1V
    // Updating account flag with the selected value
    handleSubmit_helper: function(component, event){
        this.showSpinner(component);
        var updateData = component.get("v.selectedValue");
        var setC1VDataAction = component.get("c.callC1VUpdateAPI");
        setC1VDataAction.setParams({
            accountId : component.get("v.recordId"),
            privacyData : component.get("v.selectedValue")
        });
        setC1VDataAction.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'Success'){
                    var setPrivacyDataAction = component.get("c.resetDataPrivacyFlag");
                    setPrivacyDataAction.setParams({
                        accountId : component.get("v.recordId"),
                        privacyData : component.get("v.selectedValue")
                    });
                    setPrivacyDataAction.setCallback(this, function (respnse) {
                        var state2 = respnse.getState();
                        if (state2 === "SUCCESS") {
                            this.fireToast("Data Privacy Flag","flag/flags reset successfully.","SUCCESS");
                            $A.get("e.force:closeQuickAction").fire(); 
                        }else{
                            var errors2 = respnse.getError();
                            component.set("v.errorMessage", errors2[0].message);
                        }
                    })
                    $A.enqueueAction(setPrivacyDataAction);
                }else{
                    component.set("v.errorMessage", response.getReturnValue());
                }
            } 
            if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", errors[0].message);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(setC1VDataAction);             
    },
    
    //Show Spinner
    showSpinner: function (component) {
    	component.set("v.isSpinner", true);
    },
    
    //Hide Spinner
    hideSpinner: function (component) {
    	component.set("v.isSpinner", false);
    },
    
    //Lightning toastie
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    }
})