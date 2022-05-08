({
	helperMethod : function() {
		
	},
    
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var product = component.get("v.productName");
        var action = component.get("c.getDirectDeliveryMaterialDisclosureData");
        action.setParams({
            "oppId": oppId,
            "productName": product
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.data", data);   
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkOnInitValidity: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var product = component.get("v.productName");
        var action = component.get("c.checkInitValidityOnQuote");
        action.setParams({
             "oppId": oppId,
             "productName": product
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                if(validity == 'Valid'){
                    //component.set("v.showMaterialScreen", false);
        			component.set("v.showFinishedScreen", true);
                    component.set("v.showRevalidate", false);
                }
                else if(validity == 'Incomplete'){
                    component.set("v.showFinishedScreen", false);
                    component.find("validateButton").set("v.disabled", true);
                    //Added By Divya
                    if(product !='AIP')
                    {
                       component.set("v.showRevalidate", true); 
                    }
                }
                else{
                    //component.set("v.showMaterialScreen", true);
        			component.set("v.showFinishedScreen", false);
                    component.find("validateButton").set("v.disabled", true);
                    component.set("v.showRevalidate", false);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    saveData: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var clauses = component.get("v.allClauses");
        var product = component.get("v.productName");
        
        var action = component.get("c.saveDirectDeliveryMaterialDisclosureData");
        action.setParams({
            "oppId": oppId,
            "clauses": clauses,
            "productName": product
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				// show success notification
                var toastEvent = $A.get("e.force:showToast");
                // Date : 2021-06-15 
                // Added new if condition for AHP Product. This helps to show different sucess message 
                // Pravin W.
                if( component.get("v.productName") == "Absa Home Loan Protector Plan" )
                {
                	toastEvent.setParams({
                    "title": "Success!",
                    "message":  "Material Disclosures Successfully Validated. Sale Sucessful. Email and SMS sent",
                    "type":"success"
                });    
                }else if( product == 'AIP' ){
                   toastEvent.setParams({
                    "title": "Success!",
                    "message": "Material Disclosures Successfully Validated. ",
                    "type":"success"
                }); 
                }  else{
                   toastEvent.setParams({
                    "title": "Success!",
                    "message": "Material Disclosures Successfully Validated. Email and SMS sent",
                    "type":"success"
                }); 
                }    
                
                
                toastEvent.fire();
            }
            else {
                console.log("Failed with state: " + state);
                var errors = response.getError();
                var errorMessage = 'An error has occurred: \n' + errors[0].message;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": errorMessage,
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
        var a = component.get('c.Init');
        $A.enqueueAction(a);
        $A.get('e.force:refreshView').fire();
    },
    
})