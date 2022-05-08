/**
* 
* Rudolf Niehaus - CloudSmiths
* 
**/
({
	doInit : function(component, event, helper){
        
         helper.showSpinner(component);
        
        var parentCase = component.get("v.recordId");
        var action = component.get("c.getRelatedCase");
        
        action.setParams({ 
          "parentCaseId":parentCase
        });
        
        action.setCallback(this, function(a){
           component.set("v.relatedCaseList", a.getReturnValue());
           helper.hideSpinner(component); 
        });
         
        $A.enqueueAction(action);
        
    },
    clickSearch : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.searchCases");

        action.setParams({
            "caseId":component.get("v.recordId"),
            "searchCaseNumber":component.get("v.caseNr"),
            "searchSubject":component.get("v.caseSub"),
            "searchFrom":component.get("v.caseFrom"),
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
            var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {
                
                component.set("v.relatedCaseList", response.getReturnValue());
                
                helper.hideSpinner(component);
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    clickLink : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.linkEmailToCase");
		
        action.setParams({
            "selectedCaseId":component.get("v.relatedCaseId"),
            "linkCaseId":component.get("v.recordId")
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
            var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {
    
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Email linked to selected related Case",
                    "type":"success"
                });
                
                toastEvent.fire();
                helper.hideSpinner(component);
                
                //helper.closeFocusedTab(component);
                helper.navHome(component, event, helper);
               //Refresh the related list after the home navigation
               $A.get("e.force:refreshView").fire();
                
            }else{
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "There was an error linking to the selected Case",
                    "type":"error"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
       });

        // Send action off to be executed
        if(!component.get("v.relatedCaseId")){
            
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "There was no Case selected, please select a Case and then click the Link button",
                    "type":"warning"
                });
                
                toastEvent.fire();
             
            helper.hideSpinner(component);
        
        }else{
            
             $A.enqueueAction(action);
        
        	component.set("v.isOpen", false);
        }
        
       
    },
    openNewTab : function(component, event, helper){
         var caseId = event.getSource().get("v.title");
         helper.openTab(component, event, caseId);
    },
    logId : function(component, event, helper){
        var selectedCaseId = event.getSource().get("v.text");
        component.set("v.relatedCaseId", selectedCaseId);
    },
    
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
})