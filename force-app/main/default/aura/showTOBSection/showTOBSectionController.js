({
	doInit : function(component, event, helper) {
        helper.setTobFields(component, event);
        
        helper.setshowTobFields(component, event);
        var LimitP = component.get("v.prodrec.limitType");
        console.log("limit type---"+LimitP);
        if(LimitP == 'REDUCING LIMIT'){
            component.set("v.selectedValues",'Reducing - Once Off And Recurring');
        }else if(LimitP == 'VARIABLE LIMIT'){
            component.set("v.selectedValues",'Variable');
        }else{
                    component.set("v.selectedValues",LimitP);       
     	}
       
        
        
        
        
    },
    
    
    setLimitTypeChanged :function(component, event, helper){
        var target = event.getSource();
        console.log("target--"+target);
        var selectCmp = target.get("v.value");
        var LimitP = component.get("v.prodrec.limitType");
          if(LimitP == 'REDUCING LIMIT' && selectCmp!=4  ){
            component.set("v.selectedValues",'Reducing - Once Off And Recurring');
          }  
        else{
        if(selectCmp == 4){
            component.set("v.selectedValues",'Variable');
        }else  if(selectCmp == 3){
            component.set("v.selectedValues",'Reducing - Once Off Only');
        }else if(selectCmp == 2){
            component.set("v.selectedValues",'Fixed');
        } else if(selectCmp == 1){
            component.set("v.selectedValues",'Indefinite');
        }else{
             component.set("v.selectedValues",selectCmp);
        }
          }       
        // component.set("v.selectedValues",selectCmp);
        console.log("changed---"+selectCmp);
        console.log("changed lablel---"+component.find("limitValue").get("v.label"));
        
        
       /* component.find("adjustedValue").forEach(Adjustval =>{var applicantValue = Adjustval.get("v.value");
                                                   // applicantgross = applicantgross+ parseFloat(applicantValue);
                                                    console.log("applicantValue---",applicantValue);
                                                                 
                                                           // Adjustval.set("v.value","0");
                                                            }
                                                    
        
        
        );*/
        
        
       /*var rowIndex = target.get("v.class");
        console.log("Row No : " + rowIndex);
        
        component.set("v.iterationIndex",rowIndex);*/
        
        /*var prodId = component.find("productRecordId").get("v.value");
        console.log('product Id--'+prodId);*/
    },
    
    saveAll : function(component, event, helper){
        event.preventDefault();
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
         else if(approverId==null || approverId!=userId){
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();     
        }
        else{
        component.set("v.showSpinner",true);
        
        component.find('tobEdit').forEach(form=>{
            form.submit();
                                                 
                                                });
            
        
                                                 
        //helper.saveFinalTOB(); 

       var action = component.get("c.saveTOB");
        action.setParams({
            "appProdId": component.get("v.prodrec.appProdId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("show field wrapper state---"+state);
            if (state === "SUCCESS") {
                //var results = response.getReturnValue();
               // console.log('results fieldWrapList---'+JSON.stringify(results));
               // component.set("v.showfieldWrapList",results);
               // 
                component.find('notifLib').showToast({
                                                 "title": "Adjustment Saved!",
                                                 "message": "Adjustment has been saved successfully.",
                                                 "variant": "success"
                                                });
                
                 component.set("v.showSpinner",false);
                
                 $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action); 
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
    checkValidation : function(component, event, helper){
      var target = event.getSource();
        var fieldName = target.get("v.fieldName");
        var fieldVal = target.get("v.value");
        if(fieldName) {
            if(fieldName == "Adjusted_Number__c") {  
             var recordval = component.get("v.appTOB");   
                if(recordval["Requested_Number__c"].value < fieldVal){
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
            console.log('tobgul'+JSON.stringify(recordval));
            if(recordval["Tob_Description__c"].value=='Overdraft Limit'){
              component.set("v.appTOB", recordval);
              console.log('tob'+JSON.stringify(component.get("v.appTOB")));  
            }
            
            
        }
    },
    handleSuccess : function(component, event, helper){
        
        var insertedRecord = event.getParams().response;
        console.log("insertedRecord---"+insertedRecord.id);
        
         component.find('tobEdit').forEach(form=>{
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
})