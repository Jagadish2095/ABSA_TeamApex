({
    doInit : function(component, event, helper) {
    /* added for investment opportunity	
    by PRavin W. on 09/07/2021*/
        var objectName;
         console.log("v.showBranchdetailsLst");
        console.log("v.selectedUser");
        if(component.get("v.selectedUser") != null)
        {
            component.set("v.usrDialog", true);
        }
        var firstAction = component.get("c.getObjectName");
        firstAction.setParams({
            "recordId": component.get("v.CurrentCaseRecordId")
        });
        
        firstAction.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                objectName = response.getReturnValue();
                console.log('in search result object name '+objectName);
                component.set("v.objectName", objectName);
            }
        });   
         $A.enqueueAction(firstAction);
        
    },
    onRadioChange: function(component, event, helper){
//Added By Divya
        var selected = event.getSource().get("v.text");
        component.set("v.selectedId",selected);
         component.set("v.showButton",true);
    },
    onRadioOpportunity: function(component, event){
         if(component.get("v.objectName") == 'Opportunity' ){
            
            var Notes = component.get("v.caseComments");
            
            if(Notes == undefined || Notes==''){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please fill the Agent Notes!"
                });
                toastEvent.fire();
                return;
            }
        }
        component.set("v.isLoading", true);
        //var selected = event.getSource().get("v.text");
        var selected = component.get("v.selectedId");
        var cbs = document.getElementsByClassName("slds-radio");
        for (var i = 0; i < cbs.length; i++) {
            cbs[i].checked = false;
        }
        component.set("v.checkThis", true);
        component.set("v.selectedRadio", selected);
        component.set("v.dsblBtn",false);

        var evt = $A.get("e.c:F2FSearchEvent"); 
        evt.setParam("check", false); 
        evt.fire();
        console.log('Opportunity Radio check selected');
        let currentoppid = component.get("v.CurrentCaseRecordId");
        console.log("currentoppid: " + currentoppid);
        console.log("selected Advisor ID: " + selected);
        console.log("Comments " + component.get("v.caseComments"));
        
         // call the apex class method 
        var action = component.get("c.referOpportunityToF2F");
        // set param to method  
        action.setParams({
            'userId': selected,
            'oppId':currentoppid,
            'agentNotes': component.get("v.caseComments") 
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var storeResponse = response.getReturnValue();
                console.log("storeResponse " + storeResponse);
                if(storeResponse === 'Success')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!!!",
                        "message": "Client has been Referred",
                        "type": "success"
                    });
                    toastEvent.fire();
                    window.location.reload();
                }
                 component.set("v.isLoading", false);
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Advisor Selection Failed! Since record cannot be update becase of custom validation rules!",
                        "type": "error"
                    });
                    toastEvent.fire();
                   component.set("v.isLoading", false);
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    
    onRadio: function(component, event, helper) {      
        var selected = event.getSource().get("v.text");
        var cbs = document.getElementsByClassName("slds-radio");
        for (var i = 0; i < cbs.length; i++) {
            cbs[i].checked = false;
        }
        component.set("v.checkThis", true);
        component.set("v.selectedRadio", selected);
        component.set("v.dsblBtn",false)
        // alert('hello'+component.get("v.selectedRadio"));
        console.log("current record id: "+component.get("v.recordId"));
        
        //      Store selected advisor id         //
         var evt = $A.get("e.c:F2FSearchEvent");
        evt.setParam("check", false); 
        evt.fire();
        let currentcaseid=component.get("v.CurrentCaseRecordId");
        console.log("currentcaseid: "+currentcaseid);
        console.log("selected Advisor ID: "+selected);
        // call the apex class method 
        var action = component.get("c.addAdvisorIdtoCase");
        // set param to method  
        action.setParams({
            'userId': selected,
            'caseid':currentcaseid,
            'agentNotes': component.get("v.caseComments")
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            component.set("v.isLoading", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log("added sucessfully");
                 if(storeResponse === 'Success')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!!!",
                        "message": "Client has been Referred",
                        "type": "success"
                    });
                    toastEvent.fire();
                    
                    window.location.reload();
                }
            }
            else
            {
                var errors = response.getError();
                    console.log("errors : "+JSON.stringify(errors));
                if (errors) {
                    for(let error of errors){
                        if(error.message){
                            helper.showError(error.message);
                        }
                        if(error.fieldErrors && error.fieldErrors.message){
                            helper.showError(error.fieldErrors.message);
                        }
                        if(error.pageErrors && error.pageErrors.length>0){
                            for(let pageError of error.pageErrors){
                                helper.showError(pageError.message);
                            }
                        }
                    }
                }
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        component.set("v.isLoading", true);
        //callbackend//
    },    
    acordian : function(component, event, helper) {
        var open = event.getSource().get("v.title");
        
        if(open == "View"){
            component.set('v.close', true);
            component.set('v.open', false);
        }
        else if(open == "close"){
            component.set('v.open', true);
            component.set('v.close', false);
        }
    },
    /* next : function(component, event, helper) {
        let currentcaseid=component.get("v.CurrentCaseRecordId");
        let selectetRecId=component.get("v.selectedRadio");
        console.log("currentcaseid: "+currentcaseid);
        console.log("selectetRecId: "+selectetRecId);
        // call the apex class method 
        var action = component.get("c.currentUsersiteRec");
        // set param to method  
        action.setParams({
            'userId': selectetRecId,
            'caseid':currentcaseid,
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // alert(JSON.stringify(storeResponse))
                component.set("v.selectedRecordInfo", storeResponse);
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
               
               
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        component.set("v.ShowResultOnNextScree",true)
        component.set("v.open",false)
        
    },*/
    finish : function(component, event, helper) {
        let descr=component.find("descr").get("v.value");
        let emailID=component.get("v.selectedRecordInfo.userEmail__c");
        let currentcaseid=component.get("v.CurrentCaseRecordId");//mod by HP
        console.log("current recod id: "+currentcaseid);
        let useradvisor = component.get("v.selectedRecordInfo.User__r.Name");
        
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
                var state = response.getState();
                if (state === "SUCCESS"){
                    var result = response.getReturnValue();
                    //alert("Thanks for email. You may close now.");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Email sent succesfully!",
                        type: 'success'
                    });
                    toastEvent.fire();
                    console.log(result)
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "For Completing Case BranchName,Email are Mandatory",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);  
        }
        
    },
    
})