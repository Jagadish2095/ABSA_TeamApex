({
    doInit : function(component, event, helper) {
        helper.getCCTOB(component,event);
    },
    checkValidation : function(component, event, helper){
      var target = event.getSource();
        var fieldName = target.get("v.fieldName");
        var fieldVal = target.get("v.value");
        if(fieldName) {
            if(fieldName == "Adjusted_Number__c") {  
             var recordval = component.get("v.appTOB"); 
             var recordReqVal = recordval["Requested__c"].value;
             var recordReqValNum = Number(recordReqVal); 
                if( recordReqValNum < fieldVal){
                    component.set("v.adjustedRequestedError",true);
                    console.log("error give diff value");
                }
                else{
                   component.set("v.adjustedRequestedError",false); 
                }
            }
        }
    },
    onLoad: function (component, event, helper) {
        if (event.getParam("recordUi").record) {
            component.set("v.recordUiCache", event.getParam("recordUi"));
            
            var recordval = JSON.parse(JSON.stringify(event.getParam("recordUi").record.fields));
            console.log('tobgul%%%'+JSON.stringify(recordval));
            if(recordval["Tob_Description__c"].value=='Limit'){
              component.set("v.appTOB", recordval);
              console.log('tob%%'+JSON.stringify(component.get("v.appTOB")));  
            }
            
            
        }
    },
    showDecision : function(component, event, helper) {
       
       var approver = component.get("v.simpleRecord");
           var approverId= approver.Approval_Owner__c;
           var userId = $A.get("$SObjectType.CurrentUser.Id");
        var errorcheck = component.get("v.adjustedRequestedError");
         if(errorcheck){
             var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Adjusted Amount should not be greater than requested amount"
            });
             toastEvent.fire();
         }
         else if(approverId==null || approverId!=userId ){//|| approverId!=userId
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();     
        }
        else{ 
            
        var buttonlabel = event.getSource().get("v.label");
        
        console.log("buttonlabel---"+buttonlabel);
        if(buttonlabel == 'Decline'){
            component.set('v.showDecline',true);
            component.set('v.showApprove',false);
        }else if(buttonlabel == 'Approved'){
            component.set('v.showApprove',true);
            component.set('v.showDecline',false);
        }
        }
    } ,
    
    handleSuccess : function(component, event, helper){
        
       
        var insertedRecord = event.getParams().response;
        console.log("insertedRecord---"+insertedRecord.id);
        
         component.find('CCtobEdit').forEach(form=>{
            form.submit(); 
    });
        
        
        var action = component.get("c.submitDecisionHistory");
        action.setParams({
            "prodId": insertedRecord.id
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            //console.log('results success or error---'+JSON.stringify(results));
            if (state === "SUCCESS") {
                //var results = response.getReturnValue();
               // console.log('results---'+JSON.stringify(results));
                 component.find('notifLib').showToast({
            "title": "Decision Saved!",
            "message": "Decision has been saved successfully.",
            "variant": "success"
        		});
                component.set("v.showSpinner",true);
                
            
                $A.get('e.force:refreshView').fire();
                              
            }
        });
        $A.enqueueAction(action);
        
           },
    
    saveAll : function(component, event, helper){
        
        component.find('CCtobEdit').forEach(form=>{form.submit();
                                                 
                                                });
                                                 
                                                 component.find('notifLib').showToast({
                                                 "title": "Adjustment Saved!",
                                                 "message": "Adjustment has been saved successfully.",
                                                 "variant": "success"
                                                });                                  
    },
    
})