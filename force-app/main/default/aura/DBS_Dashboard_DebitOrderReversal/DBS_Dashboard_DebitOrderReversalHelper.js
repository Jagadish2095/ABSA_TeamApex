({
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
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order get token auth timeout', body: resultMessage});
                   }else{     
                       console.log("Failed re-Authenication, get token wrap up helper");
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order  get token auth exception', body: resultMessage});
                   }
               }else{
                   if(errors && Array.isArray(errors) && errors.length > 0){
                       component.set("v.modalObj", {isOpen: true, header: 'Wrap up get token auth error', body: errors[0].message});              
                   }
               }
           });
           $A.enqueueAction(tokenAction); //Invoke apex method    
       },
    
    getTokenAndPostAgain: function(component, event) {
           //var jitterbitToken = component.get("v.jitterbitToken");
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
                       this.postAgain(component, event);
                   }else if (resultStatus === 'Unauthorized') {
                       console.log("Failed authentication: Unauthorized");
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order unauth token repost', body: resultMessage});                
                   }else if (resultStatus === 'Timeout') {
                       console.log("Failed authentication: Timeout");
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order timeout token repost', body: resultMessage});
                   } else {
                       console.log("Failed re-authenication");                   
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order auth repost', body: resultMessage});
                   }
               }else{
                   if(errors && Array.isArray(errors) && errors.length > 0){
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order auth repost error', body: errors[0].message});              
                   }                
               }
           });
           $A.enqueueAction(tokenAction);    
       },
    
      postAgain: function(component, event) {
           var debitOrder = component.get("v.selectedDebit");
           var debit_user_seq = debitOrder.value.external_user_seq; 
           var debit_action_date =  debitOrder.value.action_date;
           debit_action_date = (debit_action_date) ? utilities.formattedDateDebitOrder(debit_action_date) : ''; 
           var debit_reason_for_reversal = component.get("v.value");
           var accountNumber = component.get("v.data.robotData");
           var accAccOrIdNum = component.get("v.accAccOrIdNum");   
           accountNumber.Access_Account_Number__c;  
           var debitObj = '{"keyValue": "' + accAccOrIdNum + '","debitUserSeq": "' + debit_user_seq + '" ,"debitAmount": "' + debitOrder.value.amount + '", "debitActionDate": "' + debit_action_date + '", "debitType": "' + debitOrder.value.type + '", "debitReasonForReversal": "' + debit_reason_for_reversal + '","accessAccountNumber": "' + accountNumber.Access_Account_Number__c + '"}';
           var action = component.get("c.postReverseDebitOrder");
           action.setParams({            
                debitObj: debitObj            
           });     
           //Call back method
           action.setCallback(this, function(a) {
               var state = a.getState();    
               var response = a.getReturnValue();   
               var errors = a.getError();
               
               if (component.isValid() && state === "SUCCESS") {
           
                    var resultStatus = response[0];
                    var resultMessage = response[1];
                    var queueItemID = response[2];
                   
                    if (resultStatus === 'Success') {
                       console.log('Returned AbBot queue ID: ' + queueItemID);
                     
                       component.set("v.queueItemID", queueItemID);
                       this.createDebitOrderRecordHelper(component, event);
                   } else if (resultStatus === 'Timeout') {
                       console.log("Failed authentication: Timeout");
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order re-post timeout', body: resultMessage});               
                   }else {
                       console.log("Failed to Post queue item");                    
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order re-post exception', body: resultMessage});                      
                   }  
               }else{ 
                   if(errors && Array.isArray(errors) && errors.length > 0){        			
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order re-post error', body: errors[0].message});                      
                   }                  
               }
           });
           $A.enqueueAction(action);
       },        
         
    debitOrderReversalHelper: function(component, event) {
        var debitOrder = component.get("v.selectedDebit");
        var debit_user_seq = debitOrder.value.external_user_seq;
        var debit_action_date =  debitOrder.value.action_date;
        debit_action_date = (debit_action_date) ? utilities.formattedDateDebitOrder(debit_action_date) : '';
        var debit_reason_for_reversal = component.get("v.value");
        var accountNumber = component.get("v.data.robotData");
        var accAccOrIdNum = component.get("v.accAccOrIdNum");   
        accountNumber.Access_Account_Number__c;  
        var debitObj = '{"keyValue": "' + accAccOrIdNum + '","debitUserSeq": "' + debit_user_seq + '" ,"debitAmount": "' + debitOrder.value.amount + '", "debitActionDate": "' + debit_action_date + '", "debitType": "' + debitOrder.value.type + '", "debitReasonForReversal": "' + debit_reason_for_reversal + '","accessAccountNumber": "' + accountNumber.Access_Account_Number__c + '"}';
        var action = component.get("c.postReverseDebitOrder");
        action.setParams({            
            debitObj: debitObj          
        });      
           //Call back method
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
                       this.createDebitOrderRecordHelper(component, event);
                   } else if (resultStatus === 'Unauthorized') {                    
                       this.getTokenAndPostAgain(component, event);
                   }else if (resultStatus === 'Timeout') {
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order reversal timeout', body: resultMessage });                    
                   }else {                      
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order reversal exception.', body: resultMessage });                    
                   }
               }else{
                   if(errors && Array.isArray(errors) && errors.length > 0){
                       
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order reversal error', body: errors[0].message});
                       
                       this.disAbleActionButtons(component, event,'false');   
                       
                   }else{                       
                           let errors = 'Please try again later';
                           component.set("v.modalObj", {isOpen: true, header: 'Debit order reversal error', body: errors});
                                
                           this.disAbleActionButtons(component, event,'false');                        
                       }
                   
               }
           });
           $A.enqueueAction(action);
       },       

       createDebitOrderRecordHelper: function(component, event) {
           var queueItemID = component.get("v.queueItemID");
            if (!queueItemID) {
               return;
           }
        
           var debitReverseAction = component.get("v.debitReverseAction");
           debitReverseAction.Queue_Item_ID__c = queueItemID;
           
           var reversedDebitObj = JSON.stringify(debitReverseAction);
           var action = component.get("c.processRobotDataAction");
           action.setParams({
                  itemID: queueItemID,
               robotAction: reversedDebitObj,
               actionType: 'upsert'
           });
           action.setCallback(this, function(a) {
               var state = a.getState();
               var errors = a.getError();
               
               if (component.isValid() && state === "SUCCESS") {
                   console.log('Created DebitOrder QueueItem Record Successfully: ' + queueItemID);
                   this.pollApex(component, event);
               }else{
                   if(errors && Array.isArray(errors) && errors.length > 0){
                       component.set("v.modalObj", {isOpen: true, header: 'Create debit order record error', body: errors[0].message});
                       this.disAbleActionButtons(component, event, 'false');
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
                       self.getDebitOrderStatusThenPostToInboundServiceHelper(component, event);
                       self.pollApex(component, event);
                   }), waitTime
               );
               component.set("v.maxRepeats", component.get("v.maxRepeats") - 1);
           }
       },           
       getDebitOrderStatusThenPostToInboundServiceHelper: function(component, event) {
           var queueItemID = component.get('v.queueItemID');
           if (!queueItemID){
               return;
           }
        
           var accountNumber = component.get("v.data.robotData");
           var maxRepeats = component.get("v.maxRepeats");
           var resultStatus = component.get("v.resultStatus");
		   var data = component.get("v.data");
   
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
                           var debitAction = component.get("v.debitReverseAction");                    
                           debitAction.Access_Account_Number__c = accountNumber.Access_Account_Number__c;
                           debitAction.Queue_Item_ID__c = queueItemID;
                           debitAction.Robot_Item_Status__c = status_code;
                           debitAction.Action_Type__c = 'Debit Order Reversal';//Debit Order Reversal
                           debitAction.Robot_Item_Exception_Reason__c = business_exception;
                           debitAction.JSON__c = response_body;
                           component.set("v.debitReverseAction", debitAction);
                           
                           var selected_debit_order = component.get("v.selectedDebit");
                           var sel_row_id = selected_debit_order.key;
                           
                           var debit_data = component.get("v.data.debitsData");
                      
                           if ((status_code == '1' || status_code == '0') && maxRepeats == 0) {
                           //continue polling
                           if (maxRepeats == 0) {                       
                               debit_data[sel_row_id].value.debit_order_transaction_status = 'Timeout';
                               debit_data[sel_row_id].value.debit_order_transaction_status_class = 'slds-text-color_error';
                               debit_data[sel_row_id].value.debit_order_transaction_class = 'slds-text-color_error';
                               
                               this.controllerPostDebitOrderToInbound(component, event);
                               this.disAbleActionButtons(component, event,'false');
                               this.updateDebitOrderData(component, event); 
                           }
                       }                    
                       if(maxRepeats<1){
                          return;
                       }     
                       if (status_code == '4') { 

                           debit_data[sel_row_id].value.debit_order_transaction_status = 'Successfully reversed';                    
                           debit_data[sel_row_id].value.debit_order_transaction_status_class = 'success-color-cls';
                           debit_data[sel_row_id].value.debit_order_transaction_class = 'greyout-color-cls';
                           
                           console.log('Stopped because robot status: '+status_code); 
                           
                           this.disAbleActionButtons(component, event, 'false');

                           data.debitsData = debit_data;
						   component.set("v.data", data);
						   this.controllerPostDebitOrderToInbound(component, event);
                           component.set("v.maxRepeats", -1);                        
                           this.updateDebitOrderData(component, event);
   
                           return; 
                       }
       
                       if (status_code == '2' || status_code == '5' || status_code == '7') {
                           //make call one more time, then stop                    
                           debit_data[sel_row_id].value.debit_order_transaction_status = business_exception;
                           debit_data[sel_row_id].value.debit_order_transaction_class = 'slds-text-color_error';
                           debit_data[sel_row_id].value.debit_order_transaction_status_class = 'slds-text-color_error';
                                           
                           this.disAbleActionButtons(component, event, 'false'); 
                           this.updateDebitOrderData(component, event); 
                           this.controllerPostDebitOrderToInbound(component, event);
                           component.set("v.maxRepeats", -1);
                           console.log('Stopped because robot status: '+status_code); 
                       }                           
					   data.debitsData = debit_data;
                       component.set("v.data", data);
                   }else if(api_status == 'Unauthorized'){                  
                       this.getToken(component, event);
                       this.getDebitOrderStatusThenPostToInboundServiceHelper(component, event);                    
                   }else if(api_status === 'Timeout'){
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order reversal timeout.', body: response.sf_message});                
                   }else{
                       	  this.disAbleActionButtons(component, event, 'false');
                          component.set("v.modalObj", {isOpen: true, header: 'Debit order reversal error.', body: response.business_exception});                                                    
                   }  
               }else{
                   this.disAbleActionButtons(component, event, 'false');
                   if(response.business_exception){
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order exception', body: response.business_exception});
                   }else{                      
                       component.set("v.modalObj", {isOpen: true, header: 'Debit order error', body: errors[0].message});
                   }
                   
               }
           }); 
           $A.enqueueAction(action);
       },       
       controllerPostDebitOrderToInbound: function(component, event) {
           var queueItemID = component.get("v.queueItemID");
           if (!queueItemID) {
               return;
           }
           
           var debitAction = component.get("v.debitReverseAction");
           debitAction.Queue_Item_ID__c = queueItemID;
           
           var debitorder = JSON.stringify(debitAction);
           //saveRobotAction
           var action = component.get("c.processRobotDataAction");
           action.setParams({
               itemID : queueItemID, 
               robotAction: debitorder,
               actionType : 'upsert'
           });
           action.setCallback(this, function(response) {
               var state = response.getState();
               var errors = response.getError(); 
               if (component.isValid() && state === "SUCCESS") {
                   console.log("Debit Order record saved in Salesforce");
               }else{
                   component.set("v.modalObj", {isOpen: true, header: 'Debit order post DO error', body: errors[0].message});                               
               }
           }); 
           $A.enqueueAction(action);
       },       
      updateDebitOrderData: function(component, event) {   
           var selected_debit_order = component.get("v.selectedDebit");
           var sel_row_id = selected_debit_order.key;        
           
           var get_debits = component.get("v.data.debitsData");
           var update_debit_order_table = component.getEvent("updateDO");
           update_debit_order_table.setParams({
               "updatedDebitsObj": get_debits,
               "key": sel_row_id 
           }).fire();     
       },
    
    //********************************************************************************//
    //********************************************************************************//
    //********************************************************************************//
       disAbleActionButtons: function(component, event, booleanVal) {
           
           var data = component.get("v.data");
           
           var selected_debit_order = component.get("v.selectedDebit");       
           var sel_row_id = selected_debit_order.key; 
                      
           //Enable/disable debit order buttons
           var get_debits = data.debitsData;
           
           for (let key in get_debits) {
               get_debits[key].value.action_button_disabled = booleanVal;
               
               //apply css styles to action buttons
               if(booleanVal == 'true'){
                   get_debits[key].value.action_button_class  = (key === sel_row_id) ? 'slds-button_outline-brand' : 'slds-button_outline-gray';                    
               }else{
                   get_debits[key].value.action_button_class = ''; 
               }
           }
           
           get_debits[sel_row_id].value.show_button_spinner = booleanVal;

           if(booleanVal == 'true'){ 
                //Enable spinners
				data.showSpinner.notes =  '';
				data.showSpinner.debitOrders ='';
				data.showSpinner.debitOrdersMsg = 'Reversing debit order...';  
           }else{
				data.showSpinner.notes =  'slds-hide';
				data.showSpinner.debitOrders ='slds-hide';         
           }
           
           //Enable/disable sim hold action buttons
           var get_sims = data.simsData;
            
           for (let key in get_sims) { 
               get_sims[key].value.action_button_disabled = booleanVal;  
               get_sims[key].value.action_button_class = (booleanVal == 'true') ? 'slds-button_outline-gray' : '';
           }          
                          
           //Disable iip action buttons
           var get_iips = data.iipsData;      
           
           for (let key in get_iips) {
               get_iips[key].value.release_action_button_disabled = booleanVal;
               get_iips[key].value.cancel_action_button_disabled = booleanVal; 
               get_iips[key].value.cancel_action_button_class = (booleanVal == 'true') ? 'slds-button_outline-gray' : '';
           }             
           
           data.simsData = get_sims;
           data.iipsData = get_iips;
           data.debitsData = get_debits;
           data.wrapUpBtnDisabled = booleanVal; 
            
           component.set("v.data", data); 
        },
    formattedDate: function(inputDate) {
        var returnValue = '';
        if (inputDate) {
            let dateValue = new Date(inputDate);
            returnValue = this.getDate(dateValue);
        }
        return returnValue;
    },
    
    getDate: function(dateValue) {
        if (typeof dateValue === "undefined") {
            return 'Invalid Date';
        }
        var monthNames = [
            "01", "02", "03", "04",
            "05", "06", "07", "08", "09",
            "10", "11", "12"
        ];
        var day = dateValue.getDate();        
        if (day !=null && day !=''){            
            var inputString = day.toString();
            var inputLength = inputString.length;
            if(inputLength < 2){                
                inputString = '0'+ inputString;
            }
            day = inputString;            
        }
        var monthIndex = dateValue.getMonth();
        var year = dateValue.getFullYear();
        var finalDate = year + monthNames[monthIndex] + day; 
        return finalDate;        
    }
   })