({
    enableSubmit : function(component,event) {
        console.log("Inside handle checkbox helper");
        var IDVStatus = component.get("v.isVerificationSuccess");
        if(IDVStatus === true){
            component.set("v.isSubmitEnabled",true);
        }else{
            var checkedArray = [];
            checkedArray.push(component.get("v.caseFields").ID_Number__c);
            checkedArray.push(component.get("v.caseFields").Full_Name_Checkbox__c);
            checkedArray.push(component.get("v.caseFields").Email_Address__c);
            checkedArray.push(component.get("v.caseFields").Postal_Address_Checkbox__c);
            checkedArray.push(component.get("v.caseFields").Physical_Address_Checkbox__c);
            var checkedFieldsCount = checkedArray.filter(function(obj){ return obj===true; }).length;
            if((component.get("v.caseFields").ID_Number__c)===true && checkedFieldsCount>=3){
                component.set("v.isSubmitEnabled",false);
            }
            else{
                component.set("v.isSubmitEnabled",true);
            }
        }
        
        
    },
    
    
    saveIDVStatus: function(component, event, helper) {
        var caseID=component.get("v.recordId");
        var IDVStatus = component.get("v.isVerificationSuccess");
        var action = component.get("c.saveIDVStatus");
        action.setParams({"caseID" : caseID, "IDVStatus" : IDVStatus});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log("IDVStatus Saved");
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
    
    getAdvisorTypeInitValues: function(component, event, helper) {
        var evt = $A.get("e.c:advisorTypeChangeEvent");
        var caseID=component.get("v.recordId");
        var action = component.get("c.getAdvisorTypeInitValues");
        action.setParams({"caseID" : caseID});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
               
                console.log("id type in response is"+response.getReturnValue().ID_Type__c);
                if(response.getReturnValue().ID_Type__c === 'SA ID' ){
                    console.log("Inside SA ID");
                    component.set("v.isIdTypeSAId",true);  
                    
                } else if(response.getReturnValue().ID_Type__c === "Passport"){
                    component.set("v.isIdTypeSAId",false);
                } 
                component.set("v.cifNumber",response.getReturnValue().CIF_Custom__c);                 
                component.set("v.userName",response.getReturnValue().Customer_Full_Name__c);
               
                if(response.getReturnValue().Virtual_Advisor_Selected__c === "FA" ){
                                     
                    evt.setParam("advisorType", false);
                    evt.fire();
                    
                    component.set("v.isIDVEnabled",false);
                    
                }else if(response.getReturnValue().Virtual_Advisor_Selected__c === "VA" && response.getReturnValue().ID_V_Completed__c===true){
                    component.set("v.AdvisorCheck",response.getReturnValue().Virtual_Advisor_Selected__c);
                    component.set("v.isVerificationSuccess",true);
                    component.set("v.isCheckboxEnabled",true);
                    component.set("v.isSubmitEnabled",true);
                
                    evt.setParam("advisorType", false);
                    evt.fire();
                     
                    component.set("v.isIDVEnabled",true);
                } else if (response.getReturnValue().Virtual_Advisor_Selected__c === "VA" && response.getReturnValue().ID_V_Completed__c===false){
                    component.set("v.AdvisorCheck",response.getReturnValue().Virtual_Advisor_Selected__c);
                    component.set("v.isVerificationSuccess",false);
                 
                    component.set("v.isCheckboxEnabled",false);
                    
                    evt.setParam("advisorType", true);
                    evt.fire();
                    component.set("v.isIDVEnabled",true);
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
    
    handleChangeHelper: function(component, event, helper) {
        console.log("Inside helper");
        var evt = $A.get("e.c:advisorTypeChangeEvent"); 
        var advcheck = component.get("v.AdvisorCheck");
        console.log("Inside helper"+advcheck);
        if(component.get("v.AdvisorCheck")==="VA"){
             console.log('Hi IF1');
            if(component.get("v.isVerificationSuccess")===true){
                 console.log('Hi IF2');
                component.set("v.isCheckboxEnabled",true);
                component.set("v.isSubmitEnabled",true);
                evt.setParam("advisorType", false);
                evt.fire(); 
            }else{
                console.log('Hi Else1');
                component.set("v.isCheckboxEnabled",false);
                evt.setParam("advisorType", true);
                evt.fire();
            }
            
            component.set("v.isIDVEnabled",true);
        }else if(component.get("v.AdvisorCheck")==="FA"){
             console.log('Hi Else2');
            evt.setParam("advisorType", false);
            evt.fire();
            component.set("v.isIDVEnabled",false);
        }
    },
    
    handleCIFProcess : function(component, event, helper) {
        var evt = $A.get("e.c:buttonNotificationEvent");
        var caseID=component.get("v.recordId");
        var action = component.get("c.getAdapt360ClientBean");
        action.setParams({"caseID" : caseID});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if ( state === "SUCCESS"){
                console.log('Inside handleCIFProcess helper success');
                 if(!$A.util.isUndefinedOrNull(response.getReturnValue())){
                     component.set("v.isSubmitEnabled",true);
                     component.set("v.isCheckboxEnabled",true);
                     component.set("v.isVerificationSuccess",true);
                     helper.saveIDVStatus(component, event, helper);
                    console.log('The account obj response'+response.getReturnValue());
                    
                    component.set("v.accObj",response.getReturnValue()); 
                      component.set("v.isInvalidUser",false);
                     console.log('The account obj'+component.get("v.accObj"));
                    helper.handleCifUpsertHelper(component, event,helper);
                     evt.fire();
            }
                else{
                     console.log('Inside handleCIFProcess helper fail');
                     helper.handleSFSearchHelper(component,event,helper);
                }
            }      
            else if (state === "ERROR") {
                 //console.log('Inside handleCIFProcess helper error');
                helper.handleSFSearchHelper(component,event,helper);
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
    
    handleCifUpsertHelper : function(component, event,helper) {
       if(!$A.util.isUndefinedOrNull(component.get("v.accObj"))){
          var action = component.get("c.createClientFromCIF");
        action.setParams({"acc" : component.get("v.accObj")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log('Inside cifupserthelper success'+response.getReturnValue());
                 if(!$A.util.isUndefinedOrNull(response.getReturnValue())){
                      console.log('Inside cifupserthelper response success');
                      component.set("v.loaded",false);
                     component.set("v.upsertedAccId",response.getReturnValue()); 
                    helper.handleCifUpdateHelper(component,event,helper);
            }
            }      
            else if (state === "ERROR") {
                 component.set("v.loaded",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("ciftest Error message upsert: " + errors[0].message);
                    }
                }
            }
        });        
        $A.enqueueAction(action);
            }
    },
        handleSFSearchHelper : function(component,event, helper) {
            console.log('Inside handleSFSearchHelper' );
             var evt = $A.get("e.c:buttonNotificationEvent");
            //var evt = $A.get("e.c:InvalidUserNotificationEvent");
        var action = component.get("c.searchInSalesforce");
        action.setParams({"caseID": component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                   if(!$A.util.isUndefinedOrNull(response.getReturnValue())){
                       
                         component.set("v.isSubmitEnabled",true);
                     component.set("v.isCheckboxEnabled",true);
                     helper.saveIDVStatus(component, event, helper);
                     evt.fire();
                    component.set("v.isVerificationSuccess",true);
                        
                      
                    component.set("v.upsertedAccId",response.getReturnValue()); 
                    helper.handleCifUpdateHelper(component,event,helper);
            }
                else{
                     component.set("v.loaded",false);
                   
                    component.set("v.isInvalidUser",true);
                    
                        var toastEvent = $A.get("e.force:showToast");
   						 toastEvent.setParams({
       						"title": "Error!",
           					 "type" : "Error",
                             "message": "Invalid User : User not found in CIF or SF. Cannot continue with Case"
    						});
    					toastEvent.fire();
                }
            }      
            else if (state === "ERROR") {
                 component.set("v.loaded",false);
             //console.log('Inside fail of SFsearch');
                   // component.set("v.isSubmitEnabled",false);
                    //component.set("v.isCheckboxEnabled",false);
                    //component.set("v.isVerificationSuccess",false);
                component.set("v.isInvalidUser",true);
                   // evt.fire();
                        var toastEvent = $A.get("e.force:showToast");
   						 toastEvent.setParams({
       						"title": "Error!",
           					 "type" : "Error",
                             "message": "Invalid User : Can't find the User. Please make sure CIF number or ID number is correct to continue with the Case"
    						});
    					toastEvent.fire();
            }
        });        
        $A.enqueueAction(action);
    },
    handleCifUpdateHelper : function(component,event, helper) {
        var evt = $A.get("e.c:buttonNotificationEvent");
        var action = component.get("c.updateClientFromCIF");
        action.setParams({"accId" : component.get("v.upsertedAccId"),"caseID": component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                evt.fire();
                 component.set("v.loaded",false);
                 component.set("v.isSubmitEnabled",true);
                component.set("v.isVerificationSuccess",true);
                    component.set("v.isCheckboxEnabled",true);
                helper.saveIDVStatus(component, event, helper);
                 //console.log('ciftest Inside success for CIF update method'); 
                $A.get('e.force:refreshView').fire();
            }      
            else if (state === "ERROR") {
                 component.set("v.loaded",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("ciftest Error message upsert: " + errors[0].message);
                    }
                }
            }
        });        
        $A.enqueueAction(action);
    }
})