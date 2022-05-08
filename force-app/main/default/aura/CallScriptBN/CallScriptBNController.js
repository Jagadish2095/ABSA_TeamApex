({
    
    recordUpdated: function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "CHANGED"){
         	  var action = component.get('c.doInit');
        	  $A.enqueueAction(action);
         }
    },
    
    doInit : function(component, event, helper) {
        var evt = $A.get("e.c:DisclosureConfirmationEvent");
        var caseIdValue = component.get("v.recordId");
        var action = component.get("c.getScriptsInfo");
        action.setParams({ CaseId : caseIdValue });
        action.setCallback(this, function(response){
             		var state = response.getState();
                    if(component.isValid() && state ==="SUCCESS") 
                        {
                           var callScripts = [];
                           callScripts = response.getReturnValue().callSCripts;
                           component.set("v.caseObj",response.getReturnValue().confirmation);
                            if(response.getReturnValue().confirmation.isDisclosureConfirmed__c === true){
                                evt.setParam("check", false); 
                                       evt.fire();
                                
                            }else if(response.getReturnValue().confirmation.isDisclosureConfirmed__c === false){
                                 evt.setParam("check", true); 
                                       evt.fire();
                            }
                           
                            component.set("v.consentChoice",response.getReturnValue().confirmation.Consent_Choice__c);
                            
                           var listLength =callScripts.length;
                           for (var i=0 ; i< listLength ; i++){
                                  if(callScripts[i].Section__c==="Disclosure (VA)" || callScripts[i].Section__c==="Disclosure (Agent)")
                                       {
                                           component.set("v.disclosureScript",callScripts[i])
                                       }
                                       else {
                                           component.set("v.consentScript",callScripts[i])
                                       	}
                                   } 
                                       
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
        
     },
    
    handleCheckboxChange: function(component, event, helper) {
        var scriptCheckVal = event.getSource().get("v.checked");
        
        var evt = $A.get("e.c:DisclosureConfirmationEvent");
        var caseIdValue = component.get("v.recordId");
        evt.setParam("check", !scriptCheckVal); 
        evt.fire();
                                
        var action = component.get("c.setScriptConfirmation");
       
        action.setParams({"scriptCheckVal" : scriptCheckVal ,"CaseId" :caseIdValue });
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(component.isValid() && state ==="SUCCESS") 
                               {
                                   console.log("success");
                                  
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
        
        
          
    },
    
    closeModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
   },
   
    handleNoConsent: function(component, event, helper) {
      component.set("v.consentChoice",null);
      component.set("v.isModalOpen", false);
   },
    
    handleConsentChange: function(component, event, helper) {
        var choice = component.get("v.consentChoice");
        var caseIdValue = component.get("v.recordId");
        var action = component.get("c.setAstuteConsent");
        console.log("choice: "+choice+" . caseid: "+caseIdValue);
        if(choice === "No"){
            component.set("v.isModalOpen", true);
        }
        action.setParams({"consentChoice" : choice ,"CaseId" :caseIdValue });
        action.setCallback(this, function(response){
            component.set("v.isLoading", false);
            var state = response.getState();
            if(component.isValid() && state ==="SUCCESS") 
            {
                console.log("success");
                
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
        component.set("v.isLoading", true);        
        
    }

})