({
    fetchExtendedData: function (component) {
        var objectId = component.get("v.recId");
        //var objectId = "5007Z00000Fz7NVQAZ";
        var action = component.get("c.getExtendedData");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data == null){
                    component.set("v.showStartSpinner",false);
                    component.set("v.isCapturingDetails",true);
                    component.set("v.isCapturedDetails",false);
                }
                else{
                    var extData = JSON.parse(response.getReturnValue());
                    component.set("v.isaccountOnHold",extData.accountHold);
                    component.set("v.selectedProduct",extData.closedProduct);
                    component.set("v.reasonForHold",extData.reasonForHold);
                    component.set("v.numberSARSTR",extData.referenceNumber);
                    component.set("v.debitList",extData.debitDetails);
                    component.set("v.creditList",extData.creditDetails);
                    component.set("v.showStartSpinner",false);
                    component.set("v.isCapturedDetails",true);
                    component.set("v.isCapturingDetails",false);
                }
            }
            else{
                component.set("v.showStartSpinner",false);
                component.set("v.showError",true);
                var errors = response.getError();
                component.set("v.errorMessage",errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    addDebitRowHelper: function (component) {
        var debitRowsList = component.get("v.debitRowsList");
        debitRowsList.push({
            'Name': '',
            'AccountNumber': '',
            'Amount':'',
            'rowNumber':debitRowsList.length + 1
        });
        component.set("v.debitRowsList", debitRowsList);
    },
    
    addCreditRowHelper: function (component) {
        var creditRowsList = component.get("v.creditRowsList");
        creditRowsList.push({
            'Name': '',
            'AccountNumber': '',
            'Amount':'',
            'rowNumber':creditRowsList.length + 1
        });
        component.set("v.creditRowsList", creditRowsList);
    },
    
    showToast : function(component, event, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "message": message
        });
        toastEvent.fire();
    },
    
    submitForClosure: function (component, event, isFileUploaded, file, fileContents) {
        
        var action = component.get("c.upsertAccountClosure");
        if (isFileUploaded) {
            action.setParams({
                caseId: component.get("v.recId"),
                //caseId: "5007Z00000Fz7NVQAZ",
                closedProduct: component.get("v.closedProduct"),
                accountHold: component.get("v.accountHold"),
                accountHoldReason: component.get("v.accountHoldReason"),
                debitDetails: JSON.stringify(component.get('v.debitRowsList')),
                creditDetails: JSON.stringify(component.get('v.creditRowsList')),
                referenceNumber: component.get("v.referenceNumber"),
                fileName: file.name,
                base64Data: encodeURIComponent(fileContents),
                contentType: file.type,
                isFileUploaded: isFileUploaded
            });
        }else {
            action.setParams({
                caseId: component.get("v.recId"),
                //caseId: "5007Z00000Fz7NVQAZ",
                closedProduct: component.get("v.closedProduct"),
                accountHold: component.get("v.accountHold"),
                accountHoldReason: component.get("v.accountHoldReason"),
                debitDetails: JSON.stringify(component.get('v.debitRowsList')),
                creditDetails: JSON.stringify(component.get('v.creditRowsList')),
                referenceNumber: component.get("v.referenceNumber"),
                fileName: "",
                base64Data: "",
                contentType: "",
                isFileUploaded: isFileUploaded
            });
        }
        action.setCallback(this, function (response) {
            var state = response.getState();
			var msg = response.getReturnValue();
			if (state === "SUCCESS" && msg === "SUCCESS") {
				this.fireToast("Success", "Request has been send to Queue!", "success");
                //this.fetchExtendedData(component);
                $A.get('e.force:refreshView').fire();
                component.set("v.showStartSpinner",false);
			} else if (state === "SUCCESS" && msg !== "SUCCESS") {
				component.set("v.showStartSpinner", false);
				this.fireToast("Error", msg, "error");
			} else if (state === "ERROR") {
				var message = "";
				var errors = response.getError();
				if (errors) {
					message = errors[0].message;
					component.set("v.showStartSpinner", false);
					this.fireToast("Error", message, "error");
				}
			}
        });
        $A.enqueueAction(action);
    },
    
    fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},
    
    
})