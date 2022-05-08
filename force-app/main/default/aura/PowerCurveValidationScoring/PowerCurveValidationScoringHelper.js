({
    //JQUEV
    getResponseData: function (component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.getData");
        var oppId = component.get("v.recordId");

        action.setParams({
            "oppID": oppId,
            "stageId": '1'
        });
        action.setCallback(this, function (response) {
            this.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.record", result);
                console.log("v.record " + result);
                console.log("v.record Val1 " + JSON.stringify(result));
                component.set('v.reprocessLowerLimit', false);
                component.set('v.reprocessLowerLimitDisable', true);
                if (result != null){
                    if (result.reprocessLowerLimit == 'Y') {
                        component.set('v.reprocessLowerLimit', true);
                        component.set('v.reprocessLowerLimitDisable', false);
                        this.getChequeAccountsData(component);
                    }
                    // previously the story said only display if the flag is Y but Santjie says in defect we must display irrespective
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error PowerCurveValidationScoringController.getData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, PowerCurveValidationScoringController.getData state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    //Tinashe
    getChequeAccountsData: function (component) {
        this.showSpinner(component);
        var action = component.get("c.getChequeAndOverdraft");
        var oppId = component.get("v.recordId");

        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            this.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null) {
                    //var data = JSON.parse(result);
                    //console.log('this is the >>' + data);
                    console.log('this is the result >>' + result);
                    console.log('this is the result >>' + JSON.stringify(result));
                    console.log('this is SevCurrentODLimit >>' + result.Current_Overdraft_Limit__c);

                    if (result.hasOwnProperty('Current_Overdraft_Limit__c')) {
                        component.set("v.currentODLimit", result.Current_Overdraft_Limit__c); //.replace("R ", "")
                    } else {
                        component.set("v.currentODLimit", 0);
                    }
                    if (result.hasOwnProperty('Id')) {
                    	component.set("v.appProductRecId", result.Id);
                    }
                    console.log('this is SevCurrentODLimit after replace >>' + component.get("v.currentODLimit"));
                    console.log('this is appProductRecId >>' + component.get("v.appProductRecId"));
                    this.getTriadPreAdvised(component);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error getChequeAccountsData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, getChequeAccountsData state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    getTriadPreAdvised: function (component) {
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        console.log('<<in getTriadPreAdvised this is the opp id >>' + oppId);
        var action = component.get("c.getApplicationTriadPreAdviced");

        action.setParams({
            "oppID": oppId
        });
        action.setCallback(this, function (response) {
            this.hideSpinner(component);
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('<<in getTriadPreAdvised this is the result >>' + result);
                console.log('<<in getTriadPreAdvised this is the result >>' + JSON.stringify(result));
                if (result != null && JSON.stringify(result) != '[]') {
                    if (result[0].hasOwnProperty('Additional_Overdraft_Limit__c')) {
                        component.set("v.additionalODLimit", result[0].Additional_Overdraft_Limit__c);
                    } else {
                        component.set("v.additionalODLimit", 0);
                    }
                }
                component.set("v.preApprovedAmount", parseFloat(component.get("v.additionalODLimit")) + parseFloat(component.get("v.currentODLimit")));
            }
            else {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error getTriadPreAdvised: " + JSON.stringify(errors));
                console.log('seems we have an error >> ' + JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
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
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    },

    pcoCall: function (component, event, helper) {
        var oppId  = component.get("v.recordId");
		var action = component.get("c.makePCOCall");
		action.setParams({
			"oppId" : oppId});
		action.setCallback(this,function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				$A.get('e.force:refreshView').fire();

				var respObj = response.getReturnValue();
				if (respObj != '' && !respObj.includes("Failed")) {
					helper.fireToast("Success!","Power Curve Service Submitted Successfully!", "success");
				} else {
					helper.fireToast("Error", "Power Curve Request Submitted, But Data was not sufficient!", "error");
				}
			}else {
				helper.fireToast("Error", "Error saving Reprocess Lower Limit details!!", "error");
			}
		});
		$A.enqueueAction(action);
    },
})