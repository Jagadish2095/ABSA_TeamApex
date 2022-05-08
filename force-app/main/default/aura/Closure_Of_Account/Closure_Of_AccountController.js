({
    doInit : function(component, event, helper) {
        helper.fetchExtendedData(component);
        helper.addDebitRowHelper(component);
        helper.addCreditRowHelper(component);
    },
    
    selectedProduct : function(component, event, helper) {
        var productSelected = component.get("v.closedProduct");
        if(productSelected == ""){
            component.set("v.accountOnHold",false);
            component.set("v.isAccountHold",false);
            component.set("v.isjournalDetails",false);
        }
        else{
            component.set("v.accountOnHold",true);
        }
    },
    
    holdChange : function(component, event, helper) {
        var holdRequest = component.get("v.accountHold");
        if(holdRequest == 'Yes'){
            component.set("v.isAccountHold",true);
            component.set("v.isjournalDetails",false);
        }else{
            component.set("v.isAccountHold",false);
            component.set("v.isjournalDetails",true);
        }
    },
    
    reasonForHold : function(component, event, helper) {
        var accountHoldReason = component.get("v.accountHoldReason");
        if(accountHoldReason == ""){
            component.set("v.isjournalDetails",false);
            var message = 'Please select a reason for hold';
            var type = 'info';
            helper.showToast(component, event, message, type);
        }else if(accountHoldReason == "Cash focus"){
            component.set("v.isjournalDetails",false);
            var message = 'Inform the Cash focus department to remove the hold';
            var type = 'info';
            helper.showToast(component, event, message, type);
        }else{
            component.set("v.isjournalDetails",true);
        }
    },
    
    expandDebitDetails : function(component, event, helper) {
        component.set("v.isexpandDebitDetails",!component.get("v.isexpandDebitDetails"));
    },
    
    expandCreditDetails : function(component, event, helper) {
        component.set("v.isexpandCreditDetails",!component.get("v.isexpandCreditDetails"));
    },
    
    addDebitRecord : function(component, event, helper) {
        helper.addDebitRowHelper(component);
    },
    
    addCreditRecord : function(component, event, helper) {
        helper.addCreditRowHelper(component);
    },
    
    deleteDebitRecord : function(component, event, helper) {
        var debitRowsList = component.get("v.debitRowsList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        debitRowsList.splice(index, 1);
        component.set("v.debitRowsList", debitRowsList);
    },
    
    deleteCreditRecord : function(component, event, helper) {
        var creditRowsList = component.get("v.creditRowsList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        creditRowsList.splice(index, 1);
        component.set("v.creditRowsList", creditRowsList);
    },
    
    /*handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File "+fileName+" Uploaded successfully."
        });
        toastEvent.fire();
        
        /*$A.get('e.lightning:openFiles').fire({
            recordIds: [documentId]
        });
        
    }, */
    
    handleFilesChange: function (component, event, helper) {
        var fileName = "No File Selected..";
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]["name"];
        }
        component.set("v.fileName", fileName);
    },
    
    validateJournalDetails : function (component, event, helper) {
        component.set("v.showStartSpinner",true);
        var files = component.find("fileid").get("v.files");
        var file;
        var fileContents;
        var debitRowsList = component.get("v.debitRowsList");
        var creditRowsList = component.get("v.creditRowsList");
        var debitList;
        var creditList;
        var debitAmount = 0;
        var creditAmount = 0;
        var isCheck = true;
        for(var index = 0; index < debitRowsList.length; index++) {
            if(debitRowsList[index].Amount == 0 || debitRowsList[index].AccountNumber == '' || debitRowsList[index].Name == ''){
                isCheck = false
            }
            debitAmount += parseFloat(debitRowsList[index].Amount);
        }
        //component.set("v.debitList", debitList);
        for(var index = 0; index < creditRowsList.length; index++) {
            if(creditRowsList[index].Amount == 0 || creditRowsList[index].AccountNumber == '' || creditRowsList[index].Name == ''){
                isCheck = false
            }
            creditAmount += parseFloat(creditRowsList[index].Amount);
        }
        //component.set("v.creditList", creditList);
        if(isCheck){
            if(creditAmount == debitAmount){
                if (files != null && files.length > 0) {
                    file = files[0];
                    var objFileReader = new FileReader();
                    objFileReader.onload = $A.getCallback(function () {
                        component.set("v.showSpinner", true);
                        fileContents = objFileReader.result;
                        var base64 = "base64,";
                        var dataStart = fileContents.indexOf(base64) + base64.length;
                        fileContents = fileContents.substring(dataStart);
                        helper.submitForClosure(component, event, true, file, fileContents);
                    });
                    objFileReader.readAsDataURL(file);
                }else {
                    component.set("v.showSpinner", true);
                    helper.submitForClosure(component, event, false, file, fileContents);
                }
            }else{
                var message = 'The Debit Amount and the Credit Amount should be equal';
                var type = 'info';
                helper.showToast(component, event, message, type);
                component.set("v.showStartSpinner",false);
            }
        }else{
            var message = 'Please fill in all the necessary Credit and Debit details';
            var type = 'info';
            helper.showToast(component, event, message, type);
            component.set("v.showStartSpinner",false);
        }
    },
    
    expandAccountDetails : function(component, event, helper) {
        component.set("v.isexpandAccountDetails",!component.get("v.isexpandAccountDetails"));
    },
    
    outputDebitDetails : function(component, event, helper) {
        component.set("v.isOutputDebitDetails",!component.get("v.isOutputDebitDetails"));
    },
    
    outputCreditDetails : function(component, event, helper) {
        component.set("v.isOutputCreditDetails",!component.get("v.isOutputCreditDetails"));
    },
})