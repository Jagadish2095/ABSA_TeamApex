({
	initPickLisOptions : function(component) {
		// Initialize input select options
        var pickListValues = [
            { class: "optionClass", label: "--Please Select--", value: "" },
            { class: "optionClass", label: "No", value: "No" , selected: "true" },
            { class: "optionClass", label: "Yes", value: "Yes" }
              
        ];
        
        component.set("v.securityCessionList",pickListValues);
        component.set("v.landlordWaiver",pickListValues);
        component.set("v.Insurance",pickListValues);
        component.set("v.electronicTransfer",pickListValues);
        component.set("v.contractSigned",pickListValues);
	},
     
   
    updateConditions: function  (component) { 
         
         var landlordVal = component.get("v.selectedlandlordWaiver");
         
        if(landlordVal=='No'){
            landlordVal='N';
          }else if(landlordVal == 'Yes'){
         landlordVal='Y';
        }else{
            landlordVal='F';
        }
        
        
         var electTransferVal = component.get("v.selectedelectronicTransfer");
         if(electTransferVal=='No'){
            electTransferVal='N';
          }else if(electTransferVal == 'Yes'){
         electTransferVal='Y';
        }else{
            electTransferVal='F';
        }
         var insuranceVal = component.get("v.selectedInsurance");
         if(insuranceVal=='No'){
            insuranceVal='N';
          }else if(insuranceVal == 'Yes'){
         insuranceVal='Y';
        }else{
            insuranceVal='F';
        }
         var contractSignedVal = component.get("v.selectedcontractSigned");
        if(contractSignedVal=='No'){
            contractSignedVal='N';
          }else if(contractSignedVal == 'Yes'){
          contractSignedVal='Y';
        }else{
            contractSignedVal='F';
        }
         var mandNumVal = component.get("v.mandateNumber");
         var tellerVal = component.get("v.tellerNumber");
        // var abfaccresponse = component.get("v.ABFAcctStatusResponse");
        console.log("electTransferVal---"+electTransferVal);
         console.log("contractSignedVal---"+contractSignedVal);
         console.log("insuranceVal---"+insuranceVal);
         console.log("landlordVal---"+landlordVal);
        console.log("mandNumVal---"+mandNumVal);
         console.log("tellerVal---"+tellerVal);
         
         var action = component.get("c.updateConditionsOfAgreement");
        action.setParams({
            "appProdId": component.get("v.opportuntiyRecord.Application_Product_Id__c"),
            "landlordWaiverInd":landlordVal,
            "insuranceInd" : insuranceVal,
            "elecTransferInd" : electTransferVal,
            "contractSigned" : contractSignedVal ,
            "mandateNum":mandNumVal,
            "tellerNum":tellerVal
            
        });    
          action.setCallback(this, function (response) {
            var state = response.getState();
              console.log("response.getReturnValue()----"+response.getReturnValue());
            
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                
                if(result != null){
                    //component.set("v.calculationStatus",result);
                    //result == 'Success'
                    if(result == 'Success'){
                    component.set("v.calculationStatus",result);
                    }else{
                      var toastEvent = this.getToast("Error:!", result, "Error");
            		 toastEvent.fire();   
                    }  
                }
            }
              else{
            var toastEvent = this.getToast("Error:!", "Please update the invalid form entries and try again.", "Error");
            toastEvent.fire();
            }
         });
        
        $A.enqueueAction(action);
     
     },
  
    showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }
        
        // show error notification
        var toastEvent = this.getToast("Error:" + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
    
 getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
        });
        
        return toastEvent;
    },   
})