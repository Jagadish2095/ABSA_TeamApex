({
    //Method called from clicking the agreement checkbox
    showMCCData : function(component, event, helper){
        if(event.getSource().get("v.checked")){
            component.set("v.showMCCData", true);
        }else{
            component.set("v.showMCCData", false);
        }
    },

    validateProductRiskChecks: function(component, event, helper){
        if(component.find("oppApprovalStatus").get("v.value") == "Pending" && component.find("oppTriggerApprovalProcess").get("v.value") == "MATCH/TransUnion/Experian/MCC Risk Check"){
            helper.fireToast("Error", "There is already a pending Approval Process. ", "error");
        }else if(component.find("oppMCCPassed").get("v.value")){
            helper.fireToast("Error", "Risk Checks and Validation have already been completed. ", "error");
        }else{
            helper.getHighRiskMCC(component, event, helper);
        }
    },

    //Success
    handleSuccess: function(component, event, helper){
        if(component.find("oppMCCPassed").get("v.value") == true){
            helper.fireToast("Success!", "Saved Successfully and Validated", "success");
        }else{
            helper.fireToast("Success!", "Saved Successfully and Submitted for Approval", "success");
        }
    },

    //Load / Init
    handleLoad: function(component, event, helper){
        //Has a value in Opp.MCC_Code__c OR
        //Opp.Merchant_High_Risk_MCC_Passed__c OR
        //Currently in or passed the "MATCH/TransUnion/Experian/MCC Risk Check" Approval Process
        if(!$A.util.isEmpty(component.find("oppMccCode").get("v.value"))
        || component.find("oppMCCPassed").get("v.value")
        || (component.find("oppApprovalStatus").get("v.value") != null
        && component.find("oppTriggerApprovalProcess").get("v.value") == "MATCH/TransUnion/Experian/MCC Risk Check")) {

            component.set("v.showMCCData", true);
        }else{
            component.set("v.showMCCData", false);
        }
    },

    //Error
    handleError: function(component, event, helper){
        helper.fireToast("Error", "Unable to save record. Please contact your system administrator.", "error");
        var error = event.getParams();
        console.log("error: " + JSON.stringify(error));
    	// Get the error message
    	var errorMessage = event.getParam("message");
        console.log("errorMessage: " + errorMessage);
    }
})