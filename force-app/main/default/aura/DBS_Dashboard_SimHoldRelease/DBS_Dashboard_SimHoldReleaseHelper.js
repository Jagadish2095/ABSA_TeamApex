({                                   
    getToken: function(component, event) {
        var tokenAction = component.get("c.getToken");
        tokenAction.setCallback(this, function(response) {
            var state = response.getState();
			var errors = response.getError();
            
            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = response.getReturnValue()[0];
				var resultMessage = response.getReturnValue()[1];
                component.set("v.resultStatus", resultStatus);
                
                if (resultStatus === 'Success') {
                    console.log("Successfully re Authenicated");                    
                } else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
                    component.set("v.modalObj", {isOpen: true, header: 'Sim release get token auth timeout', body: resultMessage});
               		this.disAbleActionButtons(component, event, 'false');
                }else{
                     console.log("Failed re-Authenication, sim release helper");
                     component.set("v.modalObj", {isOpen: true, header: 'Sim release  get token auth exception', body: resultMessage});
                     this.disAbleActionButtons(component, event, 'false');
                }
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'Sim release get token auth error', body: errors[0].message});              
                }
                this.disAbleActionButtons(component, event, 'false');
            }
        });
        $A.enqueueAction(tokenAction);   
    },   
    getTokenAndPostAgain: function(component, event) {

        var tokenAction = component.get("c.getToken");
        tokenAction.setCallback(this, function(response) {
            var state = response.getState();
            var errors = response.getError(); 

            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = response.getReturnValue()[0];
				var resultMessage = response.getReturnValue()[1];
                component.set("v.resultStatus", resultStatus);
                
                if (resultStatus === 'Success') {
                    console.log("Successfully re sim release authenicated");
                    this.postAgain(component, event);           
                } else if (resultStatus === 'Unauthorized') {
                	console.log("Failed authentication: Unauthorized");
                    component.set("v.modalObj", {isOpen: true, header: 'Sim release unauth token repost', body: resultMessage}); 
                    this.disAbleActionButtons(component, event, 'false');
                }else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			component.set("v.modalObj", {isOpen: true, header: 'Sim release timeout token repost', body: resultMessage});
                    this.disAbleActionButtons(component, event, 'false');
                } else {
                    
                    console.log("Failed re-authenication");                   
        			component.set("v.modalObj", {isOpen: true, header: 'Sim release auth repost', body: resultMessage});
                    this.disAbleActionButtons(component, event, 'false');
                }
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'Sim release auth repost error', body: errors[0].message});              
                } 
                this.disAbleActionButtons(component, event, 'false');
            }
        });
        $A.enqueueAction(tokenAction); //Invoke apex method    
    },
    postAgain: function(component, event) {

        var sim = component.get("v.selectedSim");
        var sim_hold_number = sim.value.sim_hold_number;
        var user_number = sim.value.user_number;
        var accountNumber = component.get("v.data.robotData");
        accountNumber.Access_Account_Number__c;
        var accAccOrIdNum = component.get("v.accAccOrIdNum");
        
        var action = component.get("c.postSimHold");
        action.setParams({
            accessAccountNumber: accountNumber.Access_Account_Number__c,
            accountNumber: sim_hold_number,
            userNumber: user_number,
            keyValue: accAccOrIdNum
        });
        //Call back method
        action.setCallback(this, function(a) {
            var state = a.getState();
            var errors = a.getError();
            var response = a.getReturnValue(); 
            console.log('Returned response: ' + response);
            
            if (component.isValid() && state === "SUCCESS") {           
                var resultStatus = response[0];
                var resultMessage = response[1];
				var queueItemID = response[2];
                
                component.set("v.resultStatus", resultStatus);
                
                if (resultStatus === 'Success') {
                    console.log('Returned AbBot queue ID: ' + queueItemID);
                    
                    component.set("v.queueItemID", queueItemID);
                    this.createSimHoldRecordHelper(component, event);
                } else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			component.set("v.modalObj", {isOpen: true, header: 'Sim release re-post timeout', body: resultMessage}); 
                    this.disAbleActionButtons(component, event, 'false');
                }else {
                    console.log("Failed to Post queue item");                    
        			component.set("v.modalObj", {isOpen: true, header: 'Sim release re-post exception', body: resultMessage});                      
                    this.disAbleActionButtons(component, event, 'false');
                }
            }else{ 
                if(errors && Array.isArray(errors) && errors.length > 0){        			
                    component.set("v.modalObj", {isOpen: true, header: 'Sim release re-post error', body: errors[0].message});                      
                    this.disAbleActionButtons(component, event, 'false');
                }                  
            }
        });
        $A.enqueueAction(action);
    },
    releaseSimHoldHelper: function(component, event) {

        var sim = component.get("v.selectedSim");
        var sim_hold_number = sim.value.sim_hold_number;
        var user_number = sim.value.user_number;
        var accountNumber = component.get("v.data.robotData");
        accountNumber.Access_Account_Number__c;
        var accAccOrIdNum = component.get("v.accAccOrIdNum");
        var action = component.get("c.postSimHold");
        action.setParams({
            accessAccountNumber: accountNumber.Access_Account_Number__c,
            accountNumber: sim_hold_number,
            userNumber: user_number,
            keyValue: accAccOrIdNum
        });
        //Call back method
        action.setCallback(this, function(a) {
            var state = a.getState();
            var errors = a.getError();
            var response = a.getReturnValue();
			
            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = response[0];
                var resultMessage = response[1];
                var queueItemID = response[2];
                component.set("v.resultStatus", resultStatus);
                if (resultStatus === 'Success') {
                    console.log('Returned AbBot queue ID: ' + queueItemID);
  
                    component.set("v.queueItemID", queueItemID);
                    this.createSimHoldRecordHelper(component, event);
                } else if (resultStatus === 'Unauthorized') {                    
                    this.getTokenAndPostAgain(component, event);
                } else if (resultStatus === 'Timeout') {                    
                    component.set("v.modalObj", {isOpen: true, header: 'Sim release timeout', body: resultMessage});                                            
                	this.disAbleActionButtons(component, event, 'false');
                } else {          
                    component.set("v.modalObj", {isOpen: true, header: 'Sim release hold exception', body: resultMessage});            
                	this.disAbleActionButtons(component, event, 'false');
                }
            }else{ 
                 if(errors && Array.isArray(errors) && errors.length > 0){   
                     component.set("v.modalObj", {isOpen: true, header: 'Sim release error occurred', body: errors[0].message});
                     this.disAbleActionButtons(component, event, 'false');
                 }else{
                    let errors = "Please try angain later"
                    component.set("v.modalObj", {isOpen: true, header: 'Sim release error occurred', body: errors});
                    this.disAbleActionButtons(component, event, 'false');

                }
            } 
        });
        $A.enqueueAction(action);
    },      
    createSimHoldRecordHelper: function(component, event) {
        var queueItemID = component.get("v.queueItemID");
        if (!queueItemID) {
            return;
        }
        
        var simReleaseAction = component.get("v.simReleaseAction");
        simReleaseAction.Queue_Item_ID__c = queueItemID;

        var releasedSimObj = JSON.stringify(simReleaseAction);
        var action = component.get("c.processRobotDataAction");
        action.setParams({
            itemID: queueItemID,
            robotAction: releasedSimObj,
            actionType: 'upsert'
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var errors = a.getError();
            
            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = a.getReturnValue()[0];
                var resultMessage = a.getReturnValue()[1];
                
                if (resultStatus === 'Success') {
                	console.log('Created SimHold QueueItem Record Successfully: ' + queueItemID);
                	this.pollApex(component, event);
                }else{
                     component.set("v.modalObj", {isOpen: true, header: 'Save sim release record exception', body: resultMessage});                                    
                } 
            }else{
                 if(errors && Array.isArray(errors) && errors.length > 0){   
                     component.set("v.modalObj", {isOpen: true, header: 'Save sim release record error', body: errors[0].message});
                 }             
            }
        });
        $A.enqueueAction(action);
    },
    
    pollApex: function(component, event) {
        var queueItemID = component.get("v.queueItemID");
        if (!queueItemID) {
            return;
        }
        
        var waitTime = "5000";
        var maxRepeats = component.get("v.maxRepeats");
        var self = this;
        if (maxRepeats > 0) {
            window.setTimeout(
                $A.getCallback(function() {
                    console.log("Poll Apex #" + component.get("v.maxRepeats"));
                    self.getSimHoldStatusThenPostToInboundServiceHelper(component, event);
                    self.pollApex(component, event);
                }), waitTime
            );
            component.set("v.maxRepeats", component.get("v.maxRepeats") - 1);
        }
    },
    
    getSimHoldStatusThenPostToInboundServiceHelper: function(component, event) {
        var queueItemID = component.get('v.queueItemID');
        if (!queueItemID){
            return;
        }
        
        var accountNumber = component.get("v.data.robotData");
        var maxRepeats = component.get("v.maxRepeats");
        var resultStatus = component.get("v.resultStatus");

        var action = component.get("c.getActionRestResponse");
        action.setParams({
            itemID: queueItemID
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
			var response = a.getReturnValue();
            var errors = a.getError(); 
            
            if (component.isValid() && state === "SUCCESS") {

                console.log('Sim hold response: ' + JSON.stringify(a.getReturnValue()));
				var api_status = response.api_status; 

                //Extend polling
                if(api_status && !component.get("v.extendPolling")){
                    var maxCounts = $A.get("$Label.c.DBS_ActionMaxRepeats");
                    component.set("v.maxRepeats", maxCounts); 
                    component.set("v.extendPolling", true);                               
                }
                
                if(api_status == 'Success'){     
                    var status_code = response.status_code;
                    var business_exception = response.business_exception;
                    var response_body = response.response_body;
    
                    var simAction = component.get("v.simReleaseAction");
    
                    simAction.Access_Account_Number__c = accountNumber.Access_Account_Number__c;
                    simAction.Queue_Item_ID__c = queueItemID;
                    simAction.Robot_Item_Status__c = status_code;
                    simAction.Action_Type__c = 'Sim Hold Release';
                    simAction.Robot_Item_Exception_Reason__c = business_exception;
                    simAction.JSON__c = response_body;
                    component.set("v.simReleaseAction", simAction);
                    //update sim status on the tab
                    var selected_sim_hold = component.get("v.selectedSim");
                    var trans_id = selected_sim_hold.key;
    
                    var holds_data = component.get("v.data.simsData");

                    if (((status_code == '1' || status_code == '0')  && maxRepeats == 0) || maxRepeats == 0) {
                        holds_data[trans_id].value.sim_hold_status = 'Yes';
                        holds_data[trans_id].value.sim_hold_status_message = 'Timeout';
                        holds_data[trans_id].value.sim_hold_status_message_class = 'slds-text-color_error';
                        holds_data[trans_id].value.sim_hold_color = 'slds-text-color_error';
                        holds_data[trans_id].value.show_button_spinner = false;
                        console.log('Stopped because status_code: '+status_code+' and maxRepeats: '+maxRepeats);
                        this.controllerPostSimHoldToInbound(component, event);
                        this.disAbleActionButtons(component, event, 'false');
                        this.updateSimHoldData(component, event);
                    } 
                    if(maxRepeats<1){
                       return;
                    }                     
                    if (status_code == '4') {
    
                        holds_data[trans_id].value.sim_hold_status = 'No';
                        holds_data[trans_id].value.sim_hold_status_message = 'Successfully released';
                        holds_data[trans_id].value.sim_hold_status_message_class = 'slds-text-color_success';
                        holds_data[trans_id].value.sim_hold_color = ''; 
                        holds_data[trans_id].value.show_button_spinner = false;
                        console.log('Stopped because robot status: ' + status_code+' and maxRepeats: '+maxRepeats);
                       
                        component.set("v.data.simsData", holds_data);
                        this.controllerPostSimHoldToInbound(component, event);
                        this.disAbleActionButtons(component, event, 'false');
                        this.updateSimHoldData(component, event);
						component.set("v.maxRepeats", -1); 
                        return;
                    }
 
                    if (status_code == '2' || status_code == '5' || status_code == '7') {
                        //make call one more time, then stop
                        holds_data[trans_id].value.sim_hold_status = 'Yes';
                        holds_data[trans_id].value.sim_hold_status_message = business_exception;
                        holds_data[trans_id].value.sim_hold_status_message_class = 'slds-text-color_error';
                        holds_data[trans_id].value.sim_hold_color = 'slds-text-color_error';
                        holds_data[trans_id].value.show_button_spinner = false;
                        
                        console.log('Stopped because robot status: ' + status_code+' and maxRepeats: '+maxRepeats);
                        this.controllerPostSimHoldToInbound(component, event);
                        this.disAbleActionButtons(component, event, 'false'); 
                        this.updateSimHoldData(component, event);
                        component.set("v.maxRepeats", -1);
                    } 
                    
    
                    component.set("v.data.simsData", holds_data);                    
                }else if(api_status == 'Unauthorized'){                 	
                    this.getToken(component, event);
                    this.getTokenAndPostAgain(component, event);                    
                }else if(api_status == 'Timeout'){  
                    this.disAbleActionButtons(component, event, 'false');
                    component.set("v.maxRepeats", -1); 
					component.set("v.modalObj", {isOpen: true, header: 'Sim release action response timeout.', body: response.sf_message});
                }else{ 
					this.disAbleActionButtons(component, event, 'false');
					component.set("v.maxRepeats", -1);                     
               		component.set("v.modalObj", {isOpen: true, header: 'Sim release action response exception.', body:response.business_exception});
                }
            }else{
                this.disAbleActionButtons(component, event, 'false');
                component.set("v.maxRepeats", -1); 
                if(errors && Array.isArray(errors) && errors.length > 0){
                	component.set("v.modalObj", {isOpen: true, header: 'Sim hold release error', body: errors[0].message});
                }
            }          
        });
        $A.enqueueAction(action);
    },
    
    controllerPostSimHoldToInbound: function(component, event) {
        var queueItemID = component.get("v.queueItemID"); 
        if (!queueItemID) {
            return;
        }
        
        var simAction = component.get("v.simReleaseAction"); 
        simAction.Queue_Item_ID__c = queueItemID;

        var simhold = JSON.stringify(simAction);
        //saveRobotAction
        var action = component.get("c.processRobotDataAction");
        action.setParams({
            itemID: queueItemID,
            robotAction: simhold,
            actionType: 'upsert'
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var errors = a.getError();
            var response = a.getReturnValue();
            
            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = response[0];
                var resultMessage = response[1];
                if(resultStatus === 'Success'){
                    console.log("Sim hold record saved in Salesforce");
                }else{
					component.set("v.modalObj", {isOpen: true, header: 'Save simhold record exception', body: resultMessage});                                    
                }                
            }else{
				if(errors && Array.isArray(errors) && errors.length > 0){
                	component.set("v.modalObj", {isOpen: true, header: 'Save simhold record error', body: errors[0].message});
                }                
            }
        });
        $A.enqueueAction(action);
    },
    
    updateSimHoldData: function(component, event) {
        var selected_sim_hold = component.get("v.selectedSim");
        var trans_id = selected_sim_hold.key;
 
        var get_holds = component.get("v.data.simsData");
        var update_sim_release_table = component.getEvent("updateHold");
        update_sim_release_table.setParams({
            "updatedHoldsObj": get_holds,
            "key": trans_id
        }).fire();
    },     
  	disAbleActionButtons: function(component, event, booleanVal) {
            
           var data = component.get("v.data");
           
           var selected_sim = component.get("v.selectedSim");       
           var sel_row_id = selected_sim.key; 
                      
           var get_sims = component.get("v.data.simsData");
           //Simhold action button
           for (let key in get_sims) {
               get_sims[key].value.action_button_disabled = booleanVal;
               
               //apply css styles to action buttons
               if(booleanVal == 'true'){
                   get_sims[key].value.action_button_class  = (key === sel_row_id) ? 'slds-button_outline-brand' : 'slds-button_outline-gray';                    
               }else{
                   get_sims[key].value.action_button_class = ''; 
               }
           }
           
           get_sims[sel_row_id].value.show_button_spinner = booleanVal;

           if(booleanVal == 'true'){ 
                //Enable spinners
				data.showSpinner.notes =  '';
				data.showSpinner.simHolds = '';
				data.showSpinner.simHoldsMsg = 'Releasing sim hold...';  
           }else{
				data.showSpinner.notes =  'slds-hide';
				data.showSpinner.simHolds ='slds-hide';         
           }
           
           //Debit order action buttons
           var get_debits = data.debitsData;
            
           for (let key in get_debits) { 
               get_debits[key].value.action_button_disabled = booleanVal;    
               get_debits[key].value.action_button_class = (booleanVal == 'true') ? 'slds-button_outline-gray' : '';
           }          
                          
           //Disable iip action buttons
           var get_iips = data.iipsData;      
            
           for (let key in get_iips) {
               get_iips[key].value.release_action_button_disabled = booleanVal;
               get_iips[key].value.cancel_action_button_disabled = booleanVal; 
               get_iips[key].value.cancel_action_button_class = (booleanVal == 'true') ? 'slds-button_outline-gray' : '';
           } 
       
           data.debitsData = get_debits;
           data.simsData = get_sims;
           data.iipsData = get_iips;
           
           data.wrapUpBtnDisabled = booleanVal; 
            
           component.set("v.data", data); 
        },     

})