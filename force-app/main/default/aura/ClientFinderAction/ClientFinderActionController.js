({    
    doInit : function(component, event, helper) {
        var actionGetObjName = component.get("c.getObjectName");
        var recordId =  component.get("v.recordId");

       actionGetObjName.setParams({
           "recordId" :recordId
       });
       
       
       
        actionGetObjName.setCallback(this, function(response) {
        var state = response.getState();
           if (state === "SUCCESS") {
                component.set("v.objectType", response.getReturnValue());
           }
        });     
       
       $A.enqueueAction(actionGetObjName);
       
   }, 
   
    //Method to get Client Record from setClientInfo Lightning Event
    setClientValue : function(component, event, helper){
        var eventValue = event.getParam("accountValue");
        if (eventValue != null && eventValue != undefined) {
            
            component.set("v.accountRecord", eventValue);
            
        }
        
        console.log("setAttribute.Id: " + component.get("v.accountRecord").Id);
        console.log("setAttribute.Name: " + component.get("v.accountRecord").Name);
        console.log("setAttribute.FirstName: " + component.get("v.accountRecord").FirstName);
        console.log("setAttribute.LastName: " + component.get("v.accountRecord").LastName);
    },
    
    //Method to get Contact Record from setContactInfo Lightning Event
    setContactValue : function(component, event, helper){
        //Get selected Contact
        var contactRecordIdEvent = event.getParam("contactRecordId");
        var contactRecordEvent= event.getParam("contactRecord");
        
        component.set("v.contactId", contactRecordIdEvent);
        component.set("v.contactRecord", contactRecordEvent);
        
        console.log("contactId: " + component.get("v.contactId"));
        console.log("contactRecord.Id: " + component.get("v.contactRecord").Id);
    },
    
    //Method to get Product Record from setProductInfo Lightning Event
    setProductValue : function(component, event, helper){
        //Get selected Contact
         var accNo = event.getParam("accountNumber");
        var accStatus = event.getParam("accountStatus");
        var accProduct = event.getParam("accountProduct");
        
        component.set("v.accountNumber", accNo);
        component.set("v.accountStatus", accStatus);
        component.set("v.accountProduct", accProduct);
    },
   
    
    //Method to update case with Client found with/without Contact
    updateCase : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var contactRecordId =  component.get("v.contactRecord").Id;
		var accRecord =  component.get("v.accountRecord");
        var selectedProductAccNo = component.get("v.accountNumber");
        var selectedProductStatus= component.get("v.accountStatus");
        var selectedProductName = component.get("v.accountProduct");

        if(accRecord.Name == '' || accRecord.Name == null){
            
            if (accRecord.LastName == '' || accRecord.LastName == null) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please search for an existing client or create a new client record",
                    "type":"warning"
                });
                
            	helper.hideSpinner(component);
            
                toastEvent.fire();
            
            	return null;
        }
        }
        
        var action = component.get("c.linkClientToCase");
        

        action.setParams({
            "caseRecordId" : component.get("v.recordId"),
            "clientRecord" : accRecord,
            "accNumber" : selectedProductAccNo,
            "accProduct" : selectedProductName,
            "accStatus" : selectedProductStatus,
            "selectedContactId" : contactRecordId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
       
            if (state === "SUCCESS") {
                
                var caseRecId = response.getReturnValue();
                
                if(caseRecId != 'validateAccountFail'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": component.get("v.objectType")+" successfully updated",                       
                         "type":"success"
                    }); 
                    
                    toastEvent.fire();
                    helper.hideSpinner(component);
                    
                    // refresh record detail
                    $A.get("e.force:refreshView").fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "No case found",
                        "message": "The client does not have case that is awaiting documents. Please contact the client and direct the email to the relevant queue or department. ",
                        "type":"error",
                        "mode":"sticky"
                    }); 
					helper.hideSpinner(component);                    
                    toastEvent.fire();
                }
                
                
           }else if(state === "ERROR"){
                
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action); 
	},
})