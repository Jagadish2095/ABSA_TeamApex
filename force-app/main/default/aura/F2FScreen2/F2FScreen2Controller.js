({
	doInit : function(component, event, helper) {
        var evt = $A.get("e.c:F2FFinishevent");
        evt.setParam("check", true); 
        evt.fire();
		let currentcaseid=component.get("v.recordId");
//        let selectetRecId=component.get("v.selectedRadio");//selected record ko store krke fetch karna hoga
        console.log("currentcaseid: "+currentcaseid);
        //console.log("selectetRecId: "+selectetRecId);
        // call the apex class method 
        var action = component.get("c.currentUsersiteRec");
        // set param to method  
        action.setParams({
            
            'caseid':currentcaseid,
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              console.log('--json--'+JSON.stringify(storeResponse));
                component.set("v.selectedRecordInfo", storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                             
            }
             else
            {
                console.log('---Else to helper---');
                helper.getUserEmail(component,event,currentcaseid);               
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
	},
    onButtonPressed : function(component, event, helper) {
		
        component.set("v.validateCase",false);
        var caseId=component.get("v.recordId");
        console.log("caseId to be passed: "+caseId);
        /*
        var action = component.get("c.finishButton");
        
        action.setParams({"CaseId":caseId});
        
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log(" result.getReturnValue(): "+result.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        */
        ////
        let emailID;
        let useradvisor;
        let descr=component.find("descr").get("v.value");
          if(component.get("v.selectedRecordInfo.userEmail__c") != null){
        emailID=component.get("v.selectedRecordInfo.userEmail__c");
        useradvisor = component.get("v.selectedRecordInfo.User__r.Name");
        }
        else if(component.get("v.usrEmail.Email") != null){
        emailID = component.get("v.usrEmail.Email");
        useradvisor = component.get("v.usrEmail.Name");
        }
            
        let currentcaseid=component.get("v.recordId");//mod by HP       
        //let useradvisor = component.get("v.selectedRecordInfo.User__r.Name");
       // alert(emailID)
        if(descr ==null && descr !=''){
            var toastEvent = $A.get("e.force:showToast");
            if(toastEvent){
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please Enter Description"
                });
                toastEvent.fire();
                
            }else{
                alert('Please Enter Description')
            }
            
        }else{
            
            var action = component.get("c.sendEmailf2f");
            action.setParams({"emailId" :emailID,"content" :descr,"caseid":currentcaseid,"advisor":useradvisor});
            action.setCallback(this, function(response){
                component.set("v.isLoading", false);
                var state = response.getState();
                if (state === "SUCCESS"){
                    var result = response.getReturnValue();
                    //alert("Thanks for email. You may close now.");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Case is completed! Please finish the process!",
                        type: 'success'
                    });
                    toastEvent.fire();
                    console.log(result);
                    var evt = $A.get("e.c:F2FFinishevent");
                    evt.setParam("check", false);
                    evt.fire();
                }
                else
                {
                    var errors = response.getError();
                    if (errors) {
                        for(let error of errors){
                            let errorMessage = error.message;
                            let errorKey = errorMessage.match(/(\b[A-Z][A-Z]+([_]*[A-Z]+)*)/g).pop();
                            errorMessage = errorMessage.split(errorKey+", ").pop().split(": [").shift();
                            
                            var toastEvent = $A.get('e.force:showToast');
                            toastEvent.setParams({
                                title: 'Error!',
                                message: errorMessage,
                                type: 'error'
                            });
                            toastEvent.fire();  
                        }
                    }
                }
            });
            $A.enqueueAction(action);
            component.set("v.isLoading", true);
        }
        ////
       /* var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Hi Case is completed! Please Finish the Process.",
            type: 'success'
        });
        toastEvent.fire();*/
        
       /* var evt = $A.get("e.c:F2FFinishevent");
        evt.setParam("check", false);
        evt.fire();*/
	}
})