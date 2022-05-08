({
    
   doInit: function(component, event, helper) {
      helper.doInitHelper(component, event, helper);
   },
    
   openModel: function(component, event, helper) {
       component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
       component.set("v.isModalOpen", false);
   },
    
   handlePreviousEvent: function(component, event, helper) {
       helper.doInitHelper(component, event, helper);
       component.set("v.isComponentVisible", true);
   },
    
   handleNextEvent: function(component, event, helper) {
       component.set("v.isComponentVisible", false);
   },
    
   handleFinishEvent: function(component, event, helper) {
       component.set("v.isComponentVisible", true);
        $A.get('e.force:refreshView').fire();
   },
  
   saveContactNumber: function(component, event, helper) {
       var newContact = component.get("v.alternateContact");
       if(!$A.util.isUndefinedOrNull(newContact)){
           console.log("inside save"+newContact);
           var caseID=component.get("v.recordId");
       var action = component.get("c.saveNewContact");
       action.setParams({"newContact" : newContact, "caseID" : caseID});
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (component.isValid() && state === "SUCCESS"){
               console.log("Inside success");
               component.set("v.isRefresh",false);
               component.set("v.isRefresh",true);
                component.set("v.isNewContactVisible",true);
      			component.set("v.isModalOpen", false);            
            }
            else if (state === "ERROR") {
                console.log("Inside error");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
       "title": "Error!",
            "type" : "Error",
        "message": errors[0].message
    });
    toastEvent.fire();
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });        
        $A.enqueueAction(action);
       }
      else{
        var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        "title": "Error!",
            "type" : "Error",
        "message": "Please enter valid phone number."
    });
    toastEvent.fire();
       } 
   },
    
    handleClick: function(component, event, helper) {
       component.set("v.isEditMode",true);
        
   },
    
    handleSuccess: function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
        component.set("v.isEditMode",false);
    },
    
    handleCancel: function(component, event, helper) {
        component.set("v.isEditMode",false);
    },
    handlePreDelete: function(component, event, helper) {
        component.set("v.isConfirmModalOpen",true);
    },
    closeConfirmModal: function(component, event, helper) {
        
         component.set("v.isConfirmModalOpen",false);
    },
    handleDelete: function(component, event, helper) {
       var caseID=component.get("v.recordId");
       var action = component.get("c.deleteNewContact");
       action.setParams({"caseID" : caseID});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
               component.set("v.isNewContactVisible",false);
                 component.set("v.isConfirmModalOpen",false);
      	    }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                         
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });        
        $A.enqueueAction(action);
       
    }
})