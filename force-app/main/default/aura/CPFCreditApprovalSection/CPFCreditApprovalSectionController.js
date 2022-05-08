({
	itemsChange : function(component, event, helper) {
		var isCreditReqApproves = component.get("v.isCreditReqApproves");
        if(isCreditReqApproves == 'NO'){
            alert('Upload the Credit approval to access your final documentation');
        }
        component.find("wasTheCreditRequestApproved").set("v.value",isCreditReqApproves);
    },

    /**
     * @description handleUploadFinished function.
     **/
    handleFilesChange: function (component, event, helper) {
        var fileName = "No File Selected..";
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]["name"];
        }
        component.set("v.fileName", fileName);
    },

    /**
   * @description doSave function.
   **/
    doSave: function (component, event, helper) {
        //alert('component.get("v.fileType").length ' + component.get("v.fileType").length);
        if (
            component.find("fileId").get("v.files") &&
            component.find("fileId").get("v.files").length > 0
        ) {
            if (component.get("v.fileType").length > 0) {
                helper.upload(component, event);
                component.find('wasTheCreditRequestApprovedForm').submit();
            } else {
                alert("Please Select File Type");
            }
        } else {
            alert("Please Select a Valid File");
        }
    },

    onload : function(component, event, helper){
        //$A.util.addClass(component.find("spinner"), "slds-hide");
        var creditApprovedVal = component.find("wasTheCreditRequestApproved").get("v.value");
        if (creditApprovedVal == 'YES' || creditApprovedVal == 'NO') {
            component.set("v.isCreditReqApproves", creditApprovedVal);
        }
    },

    handleSuccess : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        //helper.fireToast("Success!", "Contact Person has been updated successfully.", "success");
    },

    handleError : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        //helper.fireToast("Error!", "Contact Person has not been updated successfully. Please contact your System Administrator.", "error");
    },
})