({
    navigateToSharePointHelper: function(component, event) {
        var MIPortalLink = $A.get("$Label.c.DBS_MIPortalLink");
        window.open(MIPortalLink, '_blank');        
        this.saveNotesHelper(component, event);
    },    
    getToken: function(component, event) {
        var tokenAction = component.get("c.getToken");
        //Call back method
        tokenAction.setCallback(this, function(response) {
            var state = response.getState();
			var errors = response.getError();
            
            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = response.getReturnValue()[0];
                var resultMessage = response.getReturnValue()[1];
				component.set("v.resultStatus", resultStatus);
                
                if (resultStatus === 'Success') {
                    console.log("Successfully re Authenicated");                    
                }else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up get token auth timeout', body: resultMessage});
                }else{     
                    console.log("Failed re-Authenication, get token wrap up helper");
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up  get token auth exception', body: resultMessage});
                }
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up get token auth error', body: errors[0].message});              
                }
            }
        }); 
        $A.enqueueAction(tokenAction);  
    },

    getTokenAndPostAgain: function(component, event) {
        var tokenAction = component.get("c.getToken");

        //Call back method
        tokenAction.setCallback(this, function(a) {
            var state = a.getState();
            var errors = a.getError(); 
			var response = a.getReturnValue();    
            
            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = response[0];
                var resultMessage = response[1];
                
				component.set("v.resultStatus", resultStatus);
                
                if (resultStatus === 'Success') {
                    console.log("Successfully re Authenicated");
                    this.postAgain(component, event);
                }else if (resultStatus === 'Unauthorized') {
                	console.log("Failed authentication: Unauthorized");
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up unauth token repost', body: resultMessage});                
                }else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			component.set("v.modalObj", {isOpen: true, header: 'Wrap up timeout token repost', body: resultMessage});
                } else {
                    console.log("Failed re-authenication");                   
        			component.set("v.modalObj", {isOpen: true, header: 'Wrap up auth repost', body: resultMessage});
                }
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up auth repost error', body: errors[0].message});              
                }                
            }
        });
        $A.enqueueAction(tokenAction);    
    },

    postAgain: function(component, event) {

        var robotData = component.get("v.data.robotData");
        console.log(JSON.stringify(robotData));
        var notesData = component.get("v.data.notesData");
        var accAccOrIdNum = component.get("v.accAccOrIdNum");
        var noteObj = '{"keyValue": "' + accAccOrIdNum + '","queueItemId":"' + robotData.Name + '", "notes":"' + notesData + '","accessAccountNumber":"' + robotData.Access_Account_Number__c + '"}';
        console.log(noteObj);

        var action = component.get("c.saveNotesPost");
        action.setParams({
            noteObj: noteObj
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var response = a.getReturnValue();            
			var errors = a.getError(); 
            
            if (component.isValid() && state === "SUCCESS"){                
                var resultStatus = response[0];
                var resultMessage = response[1];
                
                if (resultStatus === 'Success') {
                    var queueItemID = response[2];
                    console.log("Save notes item created successfully");
                    component.set("v.queueItemID", queueItemID);                    

                    this.createNoteActionRecordHelper(component, event);
                } else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			component.set("v.modalObj", {isOpen: true, header: 'Wrap up re-post timeout', body: resultMessage});               
                }else {
                    console.log("Failed to Post queue item");                    
        			component.set("v.modalObj", {isOpen: true, header: 'Wrap up re-post exception', body: resultMessage});                      
                }               
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){        			
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up re-post error', body: errors[0].message});                      
                }                  
            }
        });
        $A.enqueueAction(postAction); 
    },

    saveNotesHelper: function(component, event) {
  
 		var data = component.get("v.data");

        var robotData = component.get("v.robotData");;

        var notesData = component.get("v.notesData");
 
        //Removes all special chars and only leaves the ones specified
        var escapedNotesData = notesData.replace(/[^a-zA-Z0-9!@#$%^&*()-+={}:;?.,<>_|\s]/g, "").replace(/\s\s/g, " ");
                  
        //Finds any number of sequential spaces and removes them. replacing them with a single space instead
        var formattedNotes = escapedNotesData.replace(/\s+/g,' ').trim(); 
        
        var accAccOrIdNum = component.get("v.accAccOrIdNum");
        var noteObj = '{"keyValue": "' + accAccOrIdNum + '","queueItemId":"' + robotData.Name + '", "notes":"' + formattedNotes + '","accessAccountNumber":"' + robotData.Access_Account_Number__c + '"}';
        console.log(noteObj);
 
        var action = component.get("c.saveNotesPost");
        action.setParams({
            noteObj: noteObj 
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var response = a.getReturnValue();
            var errors = a.getError(); 
              
            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = response[0];
                var resultMessage = response[1];
                
                if (resultStatus === 'Success') {
                    var queueItemID = response[2];
                    console.log("Save notes item created successfully");
                    component.set("v.queueItemID", queueItemID);                    
                    this.createNoteActionRecordHelper(component, event);
                } else if (resultStatus === 'Unauthorized') {                    
                    component.set("v.modalObj", {isOpen: true, header: 'Save notes unauth timeout', body: resultMessage });                                                        
                } else if (resultStatus === 'Timeout') {
                    this.getToken(component, event); 
                    component.set("v.modalObj", {isOpen: true, header: 'Save notes timeout, try again', body: resultMessage });                    
                }else {                      
                      component.set("v.modalObj", {isOpen: true, header: 'Save notes exception.', body: resultMessage });                    
                }                
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'Save notes error', body: errors[0].message});
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    createNoteActionRecordHelper: function(component, event) {

        var robotData = component.get("v.data.robotData");
        console.log(JSON.stringify(robotData));
        
        var queueItemID = component.get("v.queueItemID");
        if (!queueItemID) {
            return;
        }
        
        var notes = component.get("v.saveNotesAction");
        notes.Queue_Item_ID__c = queueItemID;
        notes.Action_Type__c = 'Notes';

        var stringifiedNotes = JSON.stringify(notes);

        var action = component.get("c.processRobotDataAction");
        action.setParams({
            itemID: queueItemID,
            robotAction: stringifiedNotes,
            actionType: 'upsert'
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var errors = a.getError();
            if (component.isValid() && state === "SUCCESS") {
                console.log('Created Notes QueueItem Record Successfully: ' + queueItemID);
                //this.pollApex(component, event);   
				component.set("v.showSpinner", 'slds-hide'); //temp
                this.controllerResetDashboard(component, event); //temp
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'Create note action auth error', body: errors[0].message});              
                }                
            }
        });
        $A.enqueueAction(action);
    },
    
    pollApex: function(component, event) {
        var queueItemID = component.get("v.queueItemID");
        if (!queueItemID){ 
            return;
        }
        
        var waitTime = "5000";
        var maxRepeats = component.get("v.maxRepeats");
        var self = this;
        if (maxRepeats > 0) {
            window.setTimeout(
                $A.getCallback(function() {
                    console.log("Poll Apex #" + component.get("v.maxRepeats"));
                    self.getSavedNoteStatusFromAbBot(component, event);
                    self.pollApex(component, event);
                }), waitTime
            );
            component.set("v.maxRepeats", component.get("v.maxRepeats") - 1);
        }
    },
    
    getSavedNoteStatusFromAbBot: function(component, event) {
        var saveNotesAction = component.get("v.saveNotesAction"); 
        
        var queueItemID = component.get('v.queueItemID');
        if (!queueItemID) {
            return;
        }
        
        var accountNumber = component.get("v.data.robotData");
        var robotData = component.get("v.data.robotData");
        var maxRepeats = component.get("v.maxRepeats");

        var action = component.get("c.getActionRestResponse");
        action.setParams({
            itemID: queueItemID
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
			var response = a.getReturnValue();
            var errors = a.getError();   
            
            if (component.isValid() && state === "SUCCESS") {
				
                if(response.api_status === 'Success'){                                    
                    console.log('Notes response: ' + response);
    
                    
                    var api_status = response.status_code;
                    saveNotesAction.Queue_Item_ID__c = queueItemID;
                    saveNotesAction.Robot_Item_Status__c = response.status_code;
                    saveNotesAction.Robot_Item_Exception_Reason__c = response.business_exception;
                    saveNotesAction.JSON__c = response.response_body;
                    saveNotesAction.Access_Account_Number__c = robotData.Access_Account_Number__c;
    
                    component.set("v.saveNotesAction", saveNotesAction);
    
                    if (api_status == '4') {
                        console.log('Stopped polling because status: ' + api_status);
                        component.set("v.maxRepeats", 0);
                        this.controllerResetDashboard(component, event);
                    }
    
                    if (api_status == '2' || api_status == '5' || api_status == '7') {
                        component.set("v.maxRepeats", 0);
                        console.log('Stopped polling because robot status: ' + api_status);
                        this.controllerResetDashboard(component, event);
                    }
     
                    this.controllerSaveNote(component, event);
                    
                }else if(response.api_status === 'Unauthorized'){
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up unauth', body: response.sf_message});                
                }else if(response.api_status === 'Timeout'){
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up timeout', body: response.sf_message});                
                }else{
   					component.set("v.modalObj", {isOpen: true, header: 'Wrap up error.', body: response.business_exception});                                                    
                }                
            }else{
                if(response.business_exception){
                	component.set("v.modalObj", {isOpen: true, header: 'Wrap up exception', body: response.business_exception});
                }else{                    
                    component.set("v.modalObj", {isOpen: true, header: 'Wrap up error', body: errors[0].message});
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    controllerSaveNote: function(component, event) {
        var queueItemID = component.get("v.queueItemID");
        if (!queueItemID) {
            return;
        }
        
        var saveNotesAction = component.get("v.saveNotesAction");
        var noteObj = JSON.stringify(saveNotesAction);

        //saveRobotAction
        var action = component.get("c.processRobotDataAction");
        action.setParams({
            itemID: queueItemID,
            robotAction: noteObj,
            actionType: 'upsert'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError(); 
            if (component.isValid() && state === "SUCCESS") {
                console.log("re updated notes with status from abbot");
            }
        });
        $A.enqueueAction(action);
    },    
    controllerResetDashboard: function(component, event) {
        var updateNotesEvent = component.getEvent("addNotes");
        //var saveNotesAction = component.get("v.saveNotesAction.Robot_Item_Status__c");
        updateNotesEvent.setParams({
            "additionalNotes": null,
            "botStatus": 2
        }).fire();
    }
})