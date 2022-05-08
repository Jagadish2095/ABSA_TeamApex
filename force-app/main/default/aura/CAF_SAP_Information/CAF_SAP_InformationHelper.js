({
    createCaseInBCMS: function (component, event, helper) {
        this.showSpinner(component);
        component.set("v.errorMessage", null);
        
        var appId = component.get("v.appId");
        var action = component.get("c.sendCaseToBCMS");

        action.setParams({
            applicationId: appId,
            sfCaseNumber: component.get("v.caseNoVal")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp =  response.getReturnValue();
                console.log('createCaseInBCMS resp >>>>' + resp);
                var bcmsCaseId;
                if (!$A.util.isEmpty(resp) && !$A.util.isEmpty(resp.CreateCaseResponse) && !$A.util.isEmpty(resp.CreateCaseResponse.createdCase)) {
                    bcmsCaseId = resp.CreateCaseResponse.createdCase.Id;
                }
                this.showToast("Success !", "Case Created Successfully in BCMS", "success");
                
                //update case in Salesforce with BCMS no
                helper.sfCaseUpdate(component, event, helper, bcmsCaseId);
                component.set("v.isReqConFromSSCBtnDisabled",false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errMess = component.set("v.errorMessage", "Error creating Case in BCMS. Error message: " + JSON.stringify(errors));
                this.showToast("Error!", errMess, "error");
                
                //Delete case from Salesforce
                helper.deleteSFCase(component, event, helper);
            } 
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    ///////////////////////////Update Case in BCMS///////////////////////////////////////////
    updateCaseInBCMS: function (component, event, helper) {
        this.showSpinner(component);
        component.set("v.errorMessage", null);
        
        var appId = component.get("v.appId");
        console.log('Application Id for Update : ' + appId);
        var action = component.get("c.caseUpdateInBCMS");

        action.setParams({
            applicationId: appId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var updatedDate;
                updatedDate =  response.getReturnValue();
                if (updatedDate!='undefined'){
                    console.log('Updated Date : ' + updatedDate);
                    this.showToast("Success!", "Application Successfully Updated in BCMS", "success");
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    var errMess = component.set("v.errorMessage", "Error updating the application in BCMS. Error message: " + JSON.stringify(errors));
                    this.showToast("Error!", errMess, "error");
                } 
                this.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },

    ///////////////////////////Update Case in Salesforce////////////////////////////////////
    sfCaseUpdate: function (component, event, helper, bcmsCaseId) {
        this.showSpinner(component);
        var appId = component.get("v.appId");
        var action = component.get("c.updateCase");
        
        action.setParams({
            caseNumber: component.get("v.caseNoVal"), 
            bcmsCaseId: bcmsCaseId,
            aPCId: appId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.showToast("Success!", "Fulfillment Case Successfully Updated in Salesforce", "success");
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errMess = component.set("v.errorMessage", "Error in updateCase method. Error message: " + JSON.stringify(errors));
                this.showToast("Error!", errMess, "error");
            } 
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },    
    ///////////////////////Create Case In Salesforce//////////////////////////////////////////
    createSFCase : function (component, event, helper) {
    	    this.showSpinner(component);
        	var appId = component.get("v.appId");
        	var action = component.get("c.createCase");
    
        		action.setParams({
            		applicationId: appId,
        		});
        
        	action.setCallback(this, function (response) {
            var state = response.getState();                
                    if (state === "SUCCESS") {
                        
						var caseNumberVal = response.getReturnValue();
                        component.set("v.caseNoVal", caseNumberVal);                                                 
                        this.showToast("Success!", "Fulfillment Case Created Successfully in Salesforce", "success");
                        
                        //Create case in BCMS
                        helper.createCaseInBCMS (component, event, helper);
                       
                    } else if (state === "ERROR") {
                        var errors = response.getError();
                        component.set("v.errorMessage", "Error in createCase method. Error message: " + JSON.stringify(errors));
                        this.showToast("Error!", "Error creating Fulfillment Case in Salesforce", "error");
                    } else {
                        component.set("v.errorMessage", "Unknown error in createCase method. State: " + state);
                    }
                    this.hideSpinner(component);
        });
        $A.enqueueAction(action);    
	},
    ////////////////////Delete Case in Salesforce
    deleteSFCase: function(component, event, helper){
      
        	var action = component.get("c.deleteCase");
        	    action.setParams({
            		caseNumber: component.get("v.caseNoVal")
        		});
        
        	action.setCallback(this, function (response) {
            var state = response.getState();               
            if (state === "SUCCESS") {
                //this.showToast("Success!", "Fulfillment case deleted sucessfully in Salesforce", "success");
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errMess = component.set("v.errorMessage", "Error in updateCase method. Error message: " + JSON.stringify(errors));
                //this.showToast("Error!", errMess, "error");
            } 
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
                
    },
    //dynamic toast message alert function
    //It will take dynamic input parameters from controller methods
    //We use this for displaying error and success
    showToast: function (title, message, error) {
        let toastParams = {
            title: title,
            message: message, // Error message
            type: error
        };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },

    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
});