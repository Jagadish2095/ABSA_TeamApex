({
	getDirectors : function(component,helper) {
        var accountId = component.get("v.recordId");
         console.log("AcountID###" + accountId);
        var action = component.get("c.getContactinfomation");
      
        action.setParams({
            'recordId': accountId
        }); 
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log("State-" +state);
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log("resultData 15 " +JSON.stringify(resultData));
                if(resultData != undefined && resultData != null && resultData !=''){
                    var data = 	component.set("v.conlist",resultData);
                    
                    component.set("v.idNumber", resultData[0].Contact.ID_Number__c);
                    component.set("v.surname", resultData[0].Contact.LastName);
                    //component.set("v.xdsverificationstatus", resultData[0].Account.AuthMessage__c);
                    console.log("Verification Status>>>>>>>>>>>>>" +  component.set("v.xdsverificationstatus", resultData[0].Account.AuthMessage__c ));
                    
                }
                /**  
                if(resultData[0].Account.AuthMessage__c == '' || resultData[0].Account.AuthMessage__c == null){
                    component.set("v.showNextbutton", true);
                }
                **/
            }  
        });
        $A.enqueueAction(action);
    },
    
    	getContacts : function(component,helper) {
        var accountId = component.get("v.recordId");
         console.log("AcountID###" + accountId);
        var action = component.get("c.getContact");
        
        
        action.setParams({
            'recordId': accountId
        }); 
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log("State-" +state);
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log("resultData SoleTrader " +JSON.stringify(resultData));
                if(resultData != undefined && resultData != null && resultData !=''){
                    var data = 	component.set("v.conlist",resultData);
                    //component.set("v.xdsverificationstatus", resultData[0].AuthMessage);
                    for (var i = 0; i < resultData.length; i++) {
                        if(resultData[i].AuthMessage != '' || resultData[i].AuthMessage != Undefined || resultData[i].AuthMessage != null){
                            component.set("v.xdsverificationstatus", resultData[i].AuthMessage);
                        }   
                    }
                }
        ;
                /**
                if(resultData[0].Account.AuthMessage__c == '' || resultData[0].Account.AuthMessage__c == null){
                    component.set("v.showNextbutton", true);
                }
                **/
            }  
        });
        $A.enqueueAction(action);
    },
    getRelatedInformation : function(component,helper) {
        var oppId = component.get("v.recordId");
         console.log("OppID###" + oppId);
        var action = component.get("c.getRelatedParties");
        
        
        action.setParams({
            'oppId': oppId
        }); 
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            console.log("State-" +state);
            var resultData = response.getReturnValue();
            console.log("resultData SoleTrader " +JSON.stringify(resultData));
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log("resultData SoleTrader " +JSON.stringify(resultData));
                if(resultData != undefined && resultData != null && resultData !=''){
                    var data = 	component.set("v.conlist",resultData);
                    component.set('v.accId',resultData[0].AccountId);
                      for (var i = 0; i < resultData.length; i++) {
                        if(resultData[i].AuthMessage != '' || resultData[i].AuthMessage != null){
                            component.set("v.xdsverificationstatus", resultData[i].AuthMessage);
                        }else if(resultData[i].AuthMessage != '' && resultData[i].AuthMessage != null){
                            component.set("v.showNextbutton",false)
                        }if(resultData.length == 1 && resultData[0].AuthMessage != '' && resultData[0].AuthMessage != null && resultData[0].AuthMessage != 'undefined'){
                            component.set("v.showNextbutton",false)
                        }
                    
                      }
                    
                }
                /**
                if(resultData[0].Account.AuthMessage__c == '' || resultData[0].Account.AuthMessage__c == null){
                    component.set("v.showNextbutton", true);
                }
                **/
            } else{
               
                $A.log("callback error", response.getError());
            } 
        });
        $A.enqueueAction(action);
    },
    
    getEntityType : function(component,helper) {
         var accountId = component.get("v.recordId");
        var action = component.get("c.getEntityType");
        
        
        action.setParams({
            'recordId': accountId
        }); 
          action.setCallback(this,function(response) {
            var state = response.getState();
            console.log("State-" +state);
            if (state === "SUCCESS") {
                component.set("v.EntityType", response.getReturnValue());
                console.log("Helper Entity Type" + component.get("v.EntityType"));
                component.set("v.EntityType",component.get("v.EntityType"));
                
    
            }  
        });
        $A.enqueueAction(action);
    },
    
     saveAttribute: function(component,event,helper){
     //Call the update method
     var action = component.get("c.updateAuthMessage");
        action.Setparams({
            'info'   : component.get("v.eventValue"),
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
             var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    console.log("Succesfully updated");
                }
        });
        $A.enqueueAction(action);
    }
})