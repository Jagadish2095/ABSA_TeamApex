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
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold get token auth timeout', body: resultMessage});
                }else{
                     console.log("Failed re-Authenication, sim release helper");
                     component.set("v.modalObj", {isOpen: true, header: 'IIP hold  get token auth exception', body: resultMessage});
                }
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold get token auth error', body: errors[0].message});              
                }
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
                    console.log("Successfully re IIP hold authenicated");
                    this.postAgain(component, event);           
                } else if (resultStatus === 'Unauthorized') {
                	console.log("Failed authentication: Unauthorized");
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold unauth token repost', body: resultMessage});                
                }else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			component.set("v.modalObj", {isOpen: true, header: 'IIP hold timeout token repost', body: resultMessage});
                } else {
                    console.log("Failed re-authenication");                   
        			component.set("v.modalObj", {isOpen: true, header: 'IIP hold auth repost', body: resultMessage});
                }
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold auth repost error', body: errors[0].message});              
                }                
            }
        });
        $A.enqueueAction(tokenAction); //Invoke apex method    
    },
    postAgain: function(component, event) {

        var iip = component.get("v.selectedIIPHold");
        var created_date = iip.value.created_date;
        var created_time = iip.value.created_time;
        
        var source_account = iip.value.source_account;
        var target_account = iip.value.target_account;
        
        var amount = iip.value.amount;
        var status_notes = iip.value.status_notes;        
        
        var robotData = component.get("v.data.robotData");
        robotData.Access_Account_Number__c;
        var accAccOrIdNum = component.get("v.accAccOrIdNum");
        if(!accAccOrIdNum)
            accAccOrIdNum = robotData.Access_Account_Number__c;
        
        var iip_hold_action = component.get("v.IIPHoldAction"); 
        var ippObj = '{"keyValue": "' + accAccOrIdNum + '","queueItemId":"' + robotData.Name + '", "iip_hold_action":"' + iip_hold_action + '","created_date":"' + created_date + '","created_time":"' + created_time + '","source_account":"' + source_account + '","target_account":"' + target_account + '", "status_notes":"' + status_notes + '","accessAccountNumber":"' + robotData.Access_Account_Number__c + '"}';
       
        var action = component.get("c.postIIPHold");       
        action.setParams({
            ippObj
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
                    this.createIIPHoldRecordHelper(component, event);
                } else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			component.set("v.modalObj", {isOpen: true, header: 'IIP hold re-post timeout', body: resultMessage});               
                }else {
                    console.log("Failed to Post queue item");                    
        			component.set("v.modalObj", {isOpen: true, header: 'IIP hold re-post exception', body: resultMessage});                      
                }
            }else{ 
                if(errors && Array.isArray(errors) && errors.length > 0){        			
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold re-post error', body: errors[0].message});                      
                }                  
            }
        });
        $A.enqueueAction(action);
    },    
	iipHoldHelper : function(component, event) {
        var actionTaken = component.get("v.actionTaken");
        
        var iip = component.get("v.selectedIIPHold");
        
        var created_date = iip.value.created_date;
        var created_time = iip.value.created_time;
        
        var source_account = iip.value.source_account;
        var target_account = iip.value.target_account;
                
        var amount = iip.value.amount;
   
        var status_notes = iip.value.status_notes;        
        var user_number = iip.value.user_number;  
        var robotData = component.get("v.data.robotData");
        robotData.Access_Account_Number__c;
        
        var accAccOrIdNum = component.get("v.accAccOrIdNum");
        
        if(!accAccOrIdNum)
              accAccOrIdNum = robotData.Access_Account_Number__c;
                  
        var ippObj = '{"amount": "' + amount + '","keyValue": "' + accAccOrIdNum + '","user_number":"' + user_number + '", "queueItemId":"' + robotData.Name + '", "iip_hold_action":"' + actionTaken + '","created_date":"' + created_date + '","created_time":"' + created_time + '","source_account":"' + source_account + '","target_account":"' + target_account + '", "status_notes":"' + status_notes + '","accessAccountNumber":"' + robotData.Access_Account_Number__c + '"}';
       
        var action = component.get("c.postIIPHold");
        action.setParams({
            ippObj: ippObj 
        });      
        action.setCallback(this, function(a) {
            var state = a.getState(); 
            var response = a.getReturnValue(); 
            var errors = a.getError();
            
            if (component.isValid() && state === "SUCCESS") {
      			var resultStatus = response[0]; 
                var resultMessage = response[1];
                var queueItemID = response[2];
 
                component.set("v.resultStatus", resultStatus);
                
                if (resultStatus === 'Success') {
                    console.log('Returned AbBot queue ID: ' + queueItemID);
                    component.set("v.queueItemID", queueItemID);
                    this.createIIPHoldRecordHelper(component, event);
                } else if (resultStatus === 'Unauthorized') {                    
                    this.getTokenAndPostAgain(component, event);
                }else if (resultStatus === 'Timeout') {
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold timeout', body: resultMessage });                    
                }else {                      
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold exception.', body: resultMessage });  
                     this.enableActionButtons(component, event); 
                    component.set("v.maxRepeats", -1);
                }
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold error', body: errors[0].message});
                }
            }
        });
        $A.enqueueAction(action);        
	},
    createIIPHoldRecordHelper: function(component, event) {
        var queueItemID = component.get("v.queueItemID");
     	if (!queueItemID) {
            return;
        }
     
        var iipHoldAction = component.get("v.iipHoldAction");
        iipHoldAction.Queue_Item_ID__c = queueItemID;
        
        var iip = JSON.stringify(iipHoldAction);
        var action = component.get("c.processRobotDataAction");
        action.setParams({
           	itemID: queueItemID,
            robotAction: iip,
            actionType: 'upsert'
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var errors = a.getError();
            
            if (component.isValid() && state === "SUCCESS") {
                console.log('Created IIP Hold QueueItem Record Created Successfully: ' + queueItemID);
                this.pollApex(component, event);
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    component.set("v.modalObj", {isOpen: true, header: 'Create IIP Hold record error', body: errors[0].message});              
                }                
            }
        });
        $A.enqueueAction(action);
    },    
 	pollApex: function(component, event) {
        var queueItemID = component.get('v.queueItemID');
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
                    self.getIIPThenPostToInboundServiceHelper(component, event);
                    self.pollApex(component, event);
                }), waitTime
            );
            component.set("v.maxRepeats", component.get("v.maxRepeats") - 1);
        }
    },           
    getIIPThenPostToInboundServiceHelper: function(component, event) {
        var queueItemID = component.get('v.queueItemID');
        if (!queueItemID){
            return;
        }
     
        var accountNumber = component.get("v.data.robotData");
        var maxRepeats = component.get("v.maxRepeats");
        var resultStatus = component.get("v.resultStatus"); 
		var actionTaken = component.get("v.actionTaken");        
        var iipAction = component.get("v.iipHoldAction");   
        
        var action = component.get("c.getActionRestResponse");
        action.setParams({
            itemID: queueItemID
        });        
        action.setCallback(this, function(a) {
            var state = a.getState();
            var response = a.getReturnValue();
            var errors = a.getError();
            
            if (component.isValid() && state === "SUCCESS") {                
               		component.set("v.resultStatus", resultStatus);
                    var api_status = response.api_status;                
                    console.log('api_status: ' + api_status+' Robot Status code: '+response.status_code);
                
                    //Extend polling
                    if(api_status && !component.get("v.extendPolling")){
                        var maxCounts = $A.get("$Label.c.DBS_ActionMaxRepeats");
                        component.set("v.maxRepeats", maxCounts); 
                        component.set("v.extendPolling", true);  
                         console.log('reset maxRepeats ');
                    }                
                    
                    if(api_status == 'Success'){                       
                        var status_code = response.status_code;
                        var business_exception = response.business_exception;
                        var response_body = response.response_body; 
                                         
                        iipAction.Access_Account_Number__c = accountNumber.Access_Account_Number__c;
                        iipAction.Queue_Item_ID__c = queueItemID;
                        iipAction.Robot_Item_Status__c = status_code;
                        iipAction.Action_Type__c = 'IIP Hold Release';//IIP Hold Release
                        iipAction.Robot_Item_Exception_Reason__c = business_exception;
                        iipAction.JSON__c = response_body;
                        component.set("v.iipHoldAction", iipAction);
                        
                        var selected_iip = component.get("v.selectedIIPHold");
                        var iip_id = selected_iip.key;
                        
                        var iip_data = component.get("v.data.iipsData");


                        
                        if ((status_code == '1' || status_code == '0') && maxRepeats == 0) {
                        //continue polling
                        if (maxRepeats == 0) {                        
                            iip_data[iip_id].value.iip_hold_status_message = 'Timeout';
                            iip_data[iip_id].value.iip_hold_status_message_class = 'slds-text-color_error';
                            iip_data[iip_id].value.iip_hold_color = 'slds-text-color_error';
                            iip_data[iip_id].value.show_release_button_spinner = false;
                            iip_data[iip_id].value.show_cancel_button_spinner = false; 
                           
                            iip_data[iip_id].value.cancel_action_button_disabled = false;  
                            iip_data[iip_id].value.release_action_button_disabled = false;  
                            
                            iip_data[iip_id].value.release_action_button_class = ''; 
                            iip_data[iip_id].value.cancel_action_button_class = '';                              
                                                       
                            this.controllerPostIIPHoldToInbound(component, event);
                            this.disAbleActionButtons(component, event, 'false');
						    this.updateIIPHoldData(component, event); 
                        }
                    }                    
                    if(maxRepeats<1){
                       return;
                    }     
                    if (status_code == '4') {  
                        
                        if(actionTaken == 'release'){
                            iip_data[iip_id].value.iip_hold_status_message ='Released successfully';
                        }
                        
                        if(actionTaken == 'cancel'){
                            iip_data[iip_id].value.iip_hold_status_message ='Cancelled successfully';
                        }

                        iip_data[iip_id].value.iip_hold_status_message_class = 'reversed-do-success-text';//green
                        iip_data[iip_id].value.iip_hold_color = 'reversed-do-success-text'; 
                        iip_data[iip_id].value.show_release_button_spinner = false;
                        iip_data[iip_id].value.show_cancel_button_spinner = false; 
                
                        iip_data[iip_id].value.release_action_button_class = ''; 
                        iip_data[iip_id].value.cancel_action_button_class = ''; 
                        
                        iip_data[iip_id].value.cancel_action_button_disabled = false;  
                        iip_data[iip_id].value.release_action_button_disabled = false;                          
						iip_data[iip_id].value.formatted_status_notes = 'Released';
                        iip_data[iip_id].value.status_notes ='R';
                 
                        console.log('Stopped because robot status: '+status_code); 
                         
                        this.disAbleActionButtons(component, event, 'false');
                        component.set("v.data.iipsData", iip_data);
                        this.controllerPostIIPHoldToInbound(component, event);
                        component.set("v.maxRepeats", -1);                        
                        this.updateIIPHoldData(component, event);

                        return; 
                    }
    
                    if (status_code == '2' || status_code == '5' || status_code == '7') {
                        //make call one more time, then stop                    
                        iip_data[iip_id].value.iip_hold_status_message = business_exception;
                        iip_data[iip_id].value.iip_hold_status_message_class = 'slds-text-color_error';
                        iip_data[iip_id].value.iip_hold_color = 'slds-text-color_error';                        
                        iip_data[iip_id].value.show_release_button_spinner = false;
                        iip_data[iip_id].value.show_cancel_button_spinner = false;  
                       
                        iip_data[iip_id].value.release_action_button_class = ''; 
                        iip_data[iip_id].value.cancel_action_button_class = ''; 
                        
                        iip_data[iip_id].value.cancel_action_button_disabled = false;  
                        iip_data[iip_id].value.release_action_button_disabled = false;   
                        
                        this.disAbleActionButtons(component, event, 'false');
                        this.updateIIPHoldData(component, event); 
                        this.controllerPostIIPHoldToInbound(component, event);
                        component.set("v.maxRepeats", -1);
                        console.log('Stopped because robot status: '+status_code);  
                    }                           
                 
                    component.set("v.data.iipsData", iip_data);
                }else if(api_status == 'Unauthorized'){                  
                    this.getToken(component, event);
                    //this.getDebitOrderStatusThenPostToInboundServiceHelper(component, event);                    
                }else if(api_status === 'Timeout'){
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold action timeout.', body: response.sf_message});                
                    this.disAbleActionButtons(component, event, 'false');
                    component.set("v.maxRepeats", -1);                      
                }else{
   					component.set("v.modalObj", {isOpen: true, header: 'IIP hold action error.', body: response.business_exception});    
                     this.disAbleActionButtons(component, event, 'false');
                     component.set("v.maxRepeats", -1);                    
                }  
            }else{    
                this.disAbleActionButtons(component, event, 'false');
                component.set("v.maxRepeats", -1);                  
                if(response.business_exception){
                	component.set("v.modalObj", {isOpen: true, header: 'IIP hold exception', body: response.business_exception});
                }else{                      
                    component.set("v.modalObj", {isOpen: true, header: 'IIP hold error', body: errors[0].message});
                }
                 
            }
        });
        $A.enqueueAction(action);
    },   
    controllerPostIIPHoldToInbound: function(component, event) {
        var queueItemID = component.get("v.queueItemID"); 
        if (!queueItemID) {
            return;
        }
        
        var iipHoldAction = component.get("v.iipHoldAction"); 
        iipHoldAction.Queue_Item_ID__c = queueItemID;

        var iiphold = JSON.stringify(iipHoldAction);
        //saveRobotAction
        var action = component.get("c.processRobotDataAction");
        action.setParams({
            itemID: queueItemID,
            robotAction: iiphold,
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
                    console.log("IIP hold record saved in Salesforce");
                }else{
                    this.disAbleActionButtons(component, event, 'false');
					component.set("v.modalObj", {isOpen: true, header: 'Save iip hold record exception', body: resultMessage});                                    
                }                
            }else{
                this.disAbleActionButtons(component, event, 'false');
				if(errors && Array.isArray(errors) && errors.length > 0){
                	component.set("v.modalObj", {isOpen: true, header: 'Save iip hold record error', body: errors[0].message});
                }                
            }
        });
        $A.enqueueAction(action);
    }, 
    updateIIPHoldData: function(component, event) {
        var selected_iip_hold = component.get("v.selectedIIPHold");
        var trans_id = selected_iip_hold.key;

        var get_iips = component.get("v.data.iipsData");
        var update_iips_table = component.getEvent("updateIIPs");
        update_iips_table.setParams({
            "updatedIIPsObj": get_iips,
            "key": trans_id
        }).fire();
    },    

    //********************************************************************************//
    //********************************************************************************//
    //********************************************************************************//
     disAbleActionButtons: function(component, event, booleanVal) {
         var data = component.get("v.data");
         var selectedAction = component.get("v.actionTaken");     
		 var selected_iip = component.get("v.selectedIIPHold");
         var sel_row_id = selected_iip.key;  
		 
         var get_iips = component.get('v.data.iipsData'); 

         /***************IIP HOLDS******************/         
         for (let key in get_iips) {
            get_iips[key].value.release_action_button_disabled = booleanVal;
            get_iips[key].value.cancel_action_button_disabled = booleanVal;             
             
             get_iips[key].value.release_action_button_class = (booleanVal == 'true') ? 'slds-button_outline-gray' : '';
             get_iips[key].value.cancel_action_button_class = (booleanVal == 'true') ? 'slds-button_outline-gray' : '';
         } 
         
         if(booleanVal == 'true'){ 
            //Enable spinners
            data.showSpinner.notes =  '';
            data.showSpinner.iipHolds ='';
             
            get_iips[sel_row_id].value.show_release_button_spinner = (selectedAction === 'release') ? 'true' : 'false';
            get_iips[sel_row_id].value.show_cancel_button_spinner = (selectedAction === 'cancel') ? 'true' : 'false';            
 
             if(selectedAction === 'release'){
                data.showSpinner.iipHoldsMsg = 'Releasing IIP hold...';     
                get_iips[sel_row_id].value.release_action_button_class = 'slds-button_outline-brand'; 
             }
            
             if(selectedAction === 'cancel'){
                data.showSpinner.iipHoldsMsg = 'Cancelling IIP...'; 
                get_iips[sel_row_id].value.cancel_action_button_class = 'slds-button_outline-brand';  
             }
                           
         }else{
				data.showSpinner.notes =  'slds-hide';
				data.showSpinner.iipHolds ='slds-hide';     
                get_iips[sel_row_id].value.show_release_button_spinner = 'false';
                get_iips[sel_row_id].value.show_cancel_button_spinner = 'false';            
              
         }
             
         /***************DEBIT ORDERS******************/         
         var get_debits = data.debitsData;         
         for (let key in get_debits) {
             get_debits[key].value.action_button_disabled = booleanVal; 
             get_debits[key].value.action_button_class = (booleanVal == 'true') ? 'slds-button_outline-gray' : '';
         }         
         
        /***************SIM HOLDS*********************/ 
         var get_sims = data.simsData;         
         for (let key in get_sims) {
             get_sims[key].value.action_button_disabled = booleanVal;      
             get_sims[key].value.action_button_class = (booleanVal == 'true') ? 'slds-button_outline-gray' : '';
         }          

         data.iipsData = get_iips;
         data.debitsData = get_debits;
         data.simsData = get_sims;
         data.wrapUpBtnDisabled = booleanVal; 
          
         component.set("v.data", data); 
     },    
})