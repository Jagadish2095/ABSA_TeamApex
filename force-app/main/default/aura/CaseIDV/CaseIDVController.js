({
      recordUpdated: function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "CHANGED"){
         	  var action = component.get('c.doInit');
        	  $A.enqueueAction(action);
         }
    },

    doInit: function(component, event, helper) {
        
        helper.getAdvisorTypeInitValues(component, event, helper);
        
    },
    
    handleRecordLoad: function(component, event, helper) {
       var changeType = event.getParams().changeType;
       if (changeType === "LOADED") { 
        	helper.enableSubmit(component,event);
       }
   },
   
    openModel: function(component, event, helper) {
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },
  
   submitDetails: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },
    
   handleCheckbox:function(component, event, helper) {
       console.log("Inside handle checkbox");
  	  helper.enableSubmit(component,event);
   },
    
  handleSaveRecord: function(component, event, helper) {
      //component.set("v.loaded",true);
      //var evt = $A.get("e.c:buttonNotificationEvent");
      var checkedArray = [];
      checkedArray.push(component.get("v.caseFields").ID_Number__c);
      checkedArray.push(component.get("v.caseFields").Full_Name_Checkbox__c);
      checkedArray.push(component.get("v.caseFields").Email_Address__c);
      checkedArray.push(component.get("v.caseFields").Postal_Address_Checkbox__c);
      checkedArray.push(component.get("v.caseFields").Physical_Address_Checkbox__c);
      var checkedFieldsCount = checkedArray.filter(function(obj){ return obj===true; }).length;
       
      component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                if(checkedFieldsCount>=3){
                    
                    component.set("v.isSubmitEnabled",true);
                    component.set("v.isCheckboxEnabled",true);
                    //component.set("v.isVerificationSuccess",true); commented for cif
                   // evt.fire(); commented for cif
                    //helper.saveIDVStatus(component, event, helper); commented for cif
                    //console.log('Inside controller for CIFprocess'); commented for cif
                    helper.handleCIFProcess(component,event,helper);
                     helper.saveIDVStatus(component, event, helper);
                     //component.set("v.loaded",true);
                    //helper.saveAdvisorType(component, event,helper);
                }
             
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' +
                           JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
     
  },
    
    handleChange: function (component, event,helper) {
        helper.handleChangeHelper(component, event,helper);
      
		
    }
    
  
})