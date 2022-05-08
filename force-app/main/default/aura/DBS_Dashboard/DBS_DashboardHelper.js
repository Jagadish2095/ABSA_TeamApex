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
                    console.log("Successfully re authenticated");                    
                } else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			this.newSearchModal(component, 'Authentication Timeout', resultMessage);
                }else {
                    console.log("Failed re-Authenication");
        			this.newSearchModal(component, 'Failed authentication', resultMessage);                    
                } 
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    this.newSearchModal(component, 'Authentication token error', errors[0].message);
                }                  
            }
        });
        $A.enqueueAction(tokenAction); //Invoke apex method    
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
                    console.log("Successfully re Authenicated");
                    this.postAgain(component, event);
                } else if (resultStatus === 'Unauthorized') {
                    console.log("Failed authentication: Unauthorized");
        			this.newSearchModal(component, 'Unauthorized request', resultMessage);
                } else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			this.newSearchModal(component, 'Authentication Timeout', resultMessage);
                } else {
                    console.log("Failed re-authenication");                   
        			this.newSearchModal(component, 'Failed re-authentication', resultMessage); 
                }
            }else{                
                if(errors && Array.isArray(errors) && errors.length > 0){
                    this.newSearchModal(component, 'Authentication token error', errors[0].message);
                }              
            }
        });
        $A.enqueueAction(tokenAction);   
    },
    postAgain: function(component, event) {

        var inputVariable = component.find('accAccOrIdNum').getElement().value;
        
        var inputString = inputVariable.toString();
        if(inputString){
            inputString.trim();
        }else{
            inputString = component.get("v.accAccOrIdNum");
        }  
        
        var selectedRadio = component.get("v.value");
        
        var accessAccount = (selectedRadio == 'access account') ? (inputString) : ('');
        
        var postAction = component.get("c.postQueueItem");
        postAction.setParams({
                accessAccount: accessAccount,
                keyValue: inputString
        });  
        //Call back method
        postAction.setCallback(this, function(response) {
            var state = response.getState();
			var errors = response.getError();
            
            if (component.isValid() && state === "SUCCESS") {
                var resultStatus = response.getReturnValue()[0];
				var resultMessage = response.getReturnValue()[1];
                
                component.set("v.resultStatus", resultStatus); 
                if (resultStatus === 'Success') {

                    var queueItemId = response.getReturnValue()[2];
                    component.set("v.itemID", "Item created with row id: " + queueItemId); //queue item to be created for the web service  
                    component.set("v.queueItemID", queueItemId);
                    this.createQueueItemRecordHelper(component, event);

                } else if (resultStatus === 'Timeout') {
                    console.log("Failed authentication: Timeout");
        			this.newSearchModal(component, 'Authentication Timeout', resultMessage);
                }else {
                    console.log("Failed to Post queue item");                    
        			this.newSearchModal(component, 'Repeat post warning', resultMessage);        
                }
            }else{
                if(errors && Array.isArray(errors) && errors.length > 0){
                    this.newSearchModal(component, 'Authentication token error', errors[0].message);
                }                  
            }
        });
        $A.enqueueAction(postAction); 
    },
    postItemToQueue: function(component, event) {
        
        var data = component.get("v.data");
        
        var inputVariable = component.find('accAccOrIdNum').getElement().value;
        
        var inputString = inputVariable.toString();
        if(inputString){
            inputString.trim();
        }   

        var inputLength = inputString.length;
		
        var selectedRadio = component.get("v.value");
        
		component.set("v.accAccOrIdNum", inputString);
        
        var accessAccount = (selectedRadio == 'access account') ? (inputString) : ('');
        
		var accAccOrIdNum = component.get("v.accAccOrIdNum");
        if(!accAccOrIdNum || accAccOrIdNum == null || accAccOrIdNum == ''){ 
            component.set("v.resultStatus", "Enter access account/ID");
            component.set("v.invalidACCText", "slds-show");
            return;            
        }
        
        //Validate if input value is numeric
        if (isNaN(inputVariable) || (selectedRadio == 'ID number' && inputLength != 13) ) {
            component.set("v.resultStatus", "Enter valid " + selectedRadio);
            component.set("v.invalidACCText", "slds-show");
            return;
        }
        
        //Validate inputs        

        if ((inputLength > 5) && (inputLength < 17) && (accAccOrIdNum)) { 
            var maxCounts = $A.get("$Label.c.DBS_MaxRepeats")
            component.set("v.maxRepeats", maxCounts);

            component.set("v.searchCardVisible", "slds-hide");
            component.set("v.informationCardVisible", 'slds-show');

            //Show spinner
            var turnOnSpinners = {
                profileInfo: '',
                profileMsg: 'Profile loading...',
                transactions: '',
                transactionsMsg: 'Transactions loading...',
                debitOrders: '',
                debitOrdersMsg: 'Debit orders loading...',
                iipHolds: '',
                iipHoldsMsg: 'IIP holds loading...',
                callHistory: '',
                callHistoryMsg: 'Call history loading...',
                simHolds: '',
                simHoldsMsg: 'Sim holds loading...',
                notes: '',
                notesMsg: 'Loading...'
            };  
            
            component.set("v.data.showSpinner", turnOnSpinners);
      

            component.set("v.invalidACCText", "slds-hide");
            component.set("v.resultStatus", "");

            var action = component.get("c.postQueueItem");
            action.setParams({
                accessAccount: accessAccount,
                keyValue: inputString
            });
            //Call back method
            action.setCallback(this, function(response) {
                var state = response.getState();
				var errors = response.getError();
                
                if (component.isValid() && state === "SUCCESS") {
                    var fullResult = response.getReturnValue();
                    var resultStatus = response.getReturnValue()[0];
					var resultMessage = response.getReturnValue()[1];
                    
                    if (resultStatus === 'Success') {

                        var queueItemId = response.getReturnValue()[2];
                        if(!queueItemId){      
							this.newSearchModal(component, 'Warning', 'Did not create queue item id');                            
                        }
                        
                        console.log('PostQueueItem; Queue item created :' + queueItemId);

                        component.set("v.itemID", "Item created with row id: " + queueItemId); //queue item to be created for the web service  
                        component.set("v.queueItemID", queueItemId);
                        if (queueItemId) {
                            this.createQueueItemRecordHelper(component, event);
                        }
                    } else if (resultStatus === 'Failure') {
        				this.newSearchModal(component, 'Profile retrieval error', resultMessage);                       	
                    } else if (resultStatus === 'Unauthorized') {
                        this.getTokenAndPostAgain(component, event);
                        console.log('Unauthorized api response');
                    }  else if (resultStatus === 'Timeout') {
                    	console.log("Failed: Timeout");
                 	    component.set("v.resultStatus", resultStatus);
        				this.newSearchModal(component, 'Authentication Timeout', resultMessage);
               		 }else {
                         console.log("Post queue item else error");
                         this.newSearchModal(component, 'Queue item creation : warning', resultMessage);  
                    }

                    //Do more polling
                    // Now we will start service which should have 2 minute timeout.
                    var maxRepeats = component.get("v.maxRepeats");
                    if (maxRepeats > 0) {
                        this.pollApex(component, event);
                        component.set("v.maxRepeats", component.get("v.maxRepeats") - 1);
                    }
                }else if(state=="ERROR"){  
                    if (errors) {
                        this.newSearchModal(component, 'Queue item creation : exception', errors[0].message);
                    } 
                }
            });
            $A.enqueueAction(action); //Invoke apex method        

        } else {
            if (inputLength > 0) {
                component.set("v.resultStatus", "Invalid access account/ID");
            } else {
                component.set("v.resultStatus", "Enter access account/ID");
            }
            component.set("v.invalidACCText", "");
        }
    },    
    pollApex: function(component, event) {
        //var waitTime = component.get("v.waitTime");//need to check with MK
        var waitTime = "5000";  // need to check with MK
        var maxRepeats = component.get("v.maxRepeats");
        
        //var waitTimeVal = waitTime[maxRepeats];// need to check with MK
        var self = this;
        if (maxRepeats > 0) {
            window.setTimeout(
                $A.getCallback(function() {
                    console.log("Poll Apex #" + component.get("v.maxRepeats"));
                    console.log("Time #" + JSON.stringify(waitTime));
                    self.getDataAndThenPostToInboundServiceHelper(component, event);
                    self.pollApex(component, event);
                }), waitTime//waitTimeVal // need to check with MK
            );
            component.set("v.maxRepeats", component.get("v.maxRepeats") - 1);
        }
    },
    getDataAndThenPostToInboundServiceHelper: function(component, event) {
		var valQueueItemID = component.get('v.queueItemID');
        var maxRepeats = component.get("v.maxRepeats");
        
        console.log("valQueueItemID ==> " + valQueueItemID);
        if (maxRepeats < 1 || !valQueueItemID) {
            return;
        }         
	 
        var action = component.get("c.getRestResponse");
        action.setParams({
            itemID: valQueueItemID
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
			var errors = a.getError();
            var response = a.getReturnValue();
                       
            if (component.isValid() && state === "SUCCESS") {
                
                component.set("v.resultStatus", response.api_status);
                 
                if (response.api_status === 'Success') {

                        //Set the components fed by profile data
                        var profileDataDictStr = response.profile_data;
                        var debitOrderDataDictStr = response.debit_orders;
                        var recentTransactionDataDictStr = response.recent_transactions;
                        var callHistoryDataDictStr = response.call_history;
                        var simHoldDataDictStr = response.sim_holds;
                        component.set('v.profileDataMessage', profileDataDictStr); //Set the attribute value 
                        component.set('v.debitsDataMessage', debitOrderDataDictStr); //Set the attribute value 
                        component.set('v.transactionsMessage', recentTransactionDataDictStr);
                        component.set('v.callsDataMessage', callHistoryDataDictStr);
                        component.set('v.holdsDataMessage', simHoldDataDictStr);

                        if (profileDataDictStr) {
                            console.log('Profile data not empty in SQLDB');
                            console.log(profileDataDictStr);

                            this.controllerPostToInbound(component, event);
                            this.getDataFromObjectHelper(component, event);
                        } else {
                            console.log('Profile data empty from SQLDB (Postman possibly used)');
                            //This is added here for testing with postman
                            this.controllerPostToInbound(component, event);
                            this.getDataFromObjectHelper(component, event);
                        }

                } else if (response.api_status === 'Unauthorized') {                    
                    this.getToken(component, event);
                } else if (response.api_status === 'Timeout') {                     
                    this.newSearchModal(component,'Inbound service: '+ response.api_status+', timeout', response.sf_message);
                } else {
                    this.newSearchModal(component,'Inbound service status: '+ response.api_status, response.sf_message); 
                }
            }else{
                if(errors && errors.length > 0){
                    this.newSearchModal(component, 'Inbound service error', errors[0].message);
                }                 
            }
        });
        $A.enqueueAction(action);
    },
    controllerPostToInbound: function(component, event) {

        var profileDataMessage = component.get('v.profileDataMessage');
        var debitsDataMessage = component.get('v.debitsDataMessage');       
        var transactionsMessage = component.get('v.transactionsMessage');
        var callsDataMessage = component.get('v.callsDataMessage');
        var holdsDataMessage = component.get('v.holdsDataMessage');

        var fullDictionary = component.get('v.profileDataMessage');
        var postToInbound = component.get("v.postToInbound");

        var queueItemID =  component.get("v.queueItemID");
        var maxRepeats = component.get("v.maxRepeats");
        if (maxRepeats < 1 || !queueItemID) {
            return;
        } 

        if (debitsDataMessage && postToInbound.profile && !postToInbound.debit_orders) {
            fullDictionary = debitsDataMessage;
            component.set("v.postToInbound.debit_orders", true);
            transactionsMessage = null;
        }

        if (transactionsMessage && postToInbound.debit_orders && !postToInbound.transactions) {
            fullDictionary = transactionsMessage;
            component.set("v.postToInbound.transactions", true);
            console.log('transaction message changed. ' + fullDictionary);
            debitsDataMessage = null;
            callsDataMessage = null;
        }

        if (callsDataMessage && postToInbound.transactions && !postToInbound.call_history) {
            fullDictionary = callsDataMessage;
            component.set("v.postToInbound.call_history", true);
            console.log('call history message changed. ' + fullDictionary);
            callsDataMessage = null;
            transactionsMessage = null;
            holdsDataMessage = null;
            debitsDataMessage = null;
            console.log('call_history: '+JSON.stringify(fullDictionary));
        }

        if (holdsDataMessage && postToInbound.call_history && !postToInbound.sim_holds) {
            fullDictionary = holdsDataMessage;
            component.set("v.postToInbound.sim_holds", true);
            console.log('sim holds message changed. ' + fullDictionary);
            holdsDataMessage = null;
            callsDataMessage = null;
            transactionsMessage = null;            
        }
        
        if(transactionsMessage){
		//Check number of transactions.
		//If less than 6, dont get in.
		 var set_transactions = [];
            var transactions_data = transactionsMessage; 


            if (postToInbound.sim_holds) { 
                fullDictionary = transactionsMessage;
                component.set("v.postToInbound.addTransactions", true);
                                
                console.log('additional trans message changed. ' + fullDictionary);
                holdsDataMessage = null;
                callsDataMessage = null;
                transactionsMessage = null;
               
            }
        } 
        
        var action = component.get("c.postToInboundService");
        action.setParams({
            message: fullDictionary
        });
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            var errors = response.getError();
            
            if (component.isValid() && state === "SUCCESS"){
                
                if(profileDataMessage){
                	component.set("v.postToInbound.profile", true);
                } 
                //if(component.get("v.postToInbound.call_history")){
                //    alert();
                //}
                var resultStatus = response.getReturnValue()[0];
                var resultMessage = response.getReturnValue()[1];
                
                if (resultStatus === 'Success') {
                    console.log('Posted');
                } else {
                    //this.newSearchModal(component, 'Save robot data to Salesforce : Error', resultMessage);// 13 Jan 2020 commented by Rakesh and need to check with MK
                    this.newSearchModal(component, 'Unable to retrieve account:', 'Complications occurred while retrieving this account.Please use IMSP to retrieve this account for now');//added by Rakesh on 13 Jan 2020
                }
            }else{
                if(errors){ 
                	this.newSearchModal(component, 'Save robot data to Salesforce : Exception', errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    createQueueItemRecordHelper: function(component, event) {
        //Show spinner
        component.set("v.data.showSpinner.profileInfo", '');

        var queueItemID = component.get("v.queueItemID");
        if (!queueItemID) {
            return;
        }         
        var action = component.get("c.createQueueItemRecord");
        action.setParams({
            itemID: queueItemID
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log("SUCCESSFULLY CREATED QUEUE ITEM RECORD");
            }
        });
        $A.enqueueAction(action);
    },
    getDataFromObjectHelper: function(component, event) {
        var data = component.get("v.data"); 
        var queueItemID = component.get("v.queueItemID");   
        //1490310
        //var queueItemID = '1449962';  
        //component.set("v.searchCardVisible", "slds-hide");
        //component.set("v.informationCardVisible", 'slds-show');    
                 
        //prevent component error during quick tab refresh 
        if (!queueItemID) {
            return;
        } 
        var action = component.get("c.getDataFromObject");
        action.setParams({
            itemID: queueItemID
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
			var errors = response.getError();
            
            if (component.isValid() && state === "SUCCESS") {
                var obj = response.getReturnValue()[0];

                //If object is not null, populate profile data
                if (obj) {
                    //load entire object
					data.robotData = obj;
					//data.robotData.Access_Account_Number__c = '4047939793';
                    component.set("v.data", data);
					
                    
                    //Set profile Data
                    if (obj.Profile_JSON__c) {
                        var profile_data = JSON.parse(obj.Profile_JSON__c);
                         
                        //Increase polling if surname not null
                        if(profile_data.cust_surname && !component.get("v.extendPolling")){
            			   var maxCounts = $A.get("$Label.c.DBS_MaxRepeats")                      
                           component.set("v.maxRepeats", maxCounts); 
                           component.set("v.extendPolling", true);                            
                        }
                        
                        profile_data.Access_Account_Number__c = obj.Access_Account_Number__c;

                        //Set Email format: {0=a@absa.co.za, 1=g@absa.co.za}
                        var emailSplit = profile_data.e_statement_emails.split(',');
                        var emailSplitCount = emailSplit.length;

                        if (emailSplitCount == 2) {
                            var mail1 = profile_data.e_statement_emails.split(',')[0]; //{0=a@absa.co.za                           
                            if (mail1.split('=')[1].length > 1) {
                                var primaryEmail = mail1.split('=')[1]; //a@absa.co.za                                
                                profile_data.e_statement_emails_primary = primaryEmail;
                            }
                            var mail2 = profile_data.e_statement_emails.split(',')[1]; //1=g@absa.co.za}                           
                            var mail2_2 = mail2.split('=')[1]; //g@absa.co.za}
						    if(mail2_2){
								mail2_2 = mail2_2.substring(0, mail2_2.length - 1); //g@absa.co.za     
							}							
                            if (mail2_2.length > 1) {
                                var SecondaryEmail = mail2_2;
                                profile_data.e_statement_emails_secondary = SecondaryEmail;
                            }
                        }

                        //Internet banking service color schemes
                        //AOL Status         
                        //profile_data.service_status = 'Unpaid suspended';
                        if (profile_data.service_status == 'ACTIVE') {
                            profile_data.aol_status_class = 'slds-text-color_success';
                        } else {
                            profile_data.aol_status_class = 'slds-text-color_error';
                        }
                        profile_data.service_status = (profile_data.service_status) ? utilities.capitalizeFirstLetter(profile_data.service_status) : '';

                        //AOL Password          
                        if (profile_data.password_status == 'ACTIVE') {
                            profile_data.aol_password_class = 'slds-text-color_success';
                        } else {
                            profile_data.aol_password_class = 'slds-text-color_error';
                        }
                        profile_data.password_status = (profile_data.password_status) ? utilities.capitalizeFirstLetter(profile_data.password_status) : '';

                        //AOL pin         
                        if (profile_data.pin_status == 'ACTIVE') {
                            profile_data.aol_pin_status_class = 'slds-text-color_success';
                        } else {
                            profile_data.aol_pin_status_class = 'slds-text-color_error';
                        }

                        //Registered Channels Icons
                        var tick_icon = '✔';
                        var cross_icon = '✖';
                        //AOL        
                        if ((profile_data.registered_aol_banking == 'NO') || (profile_data.registered_aol_banking == 'N') || (profile_data.registered_aol_banking == 'Unavailable')){
                            profile_data.registered_aol_banking_icon = 'error-icon';
                            profile_data.registered_aol_banking_sign = cross_icon;
                        }
                        if ((profile_data.registered_aol_banking == 'YES') || (profile_data.registered_aol_banking == 'Y')) {
                            profile_data.registered_aol_banking_icon = 'success-icon';
                            profile_data.registered_aol_banking_sign = tick_icon;
                        }

                        //Notify Me
                        if ((profile_data.registered_notify_me == 'NO') || (profile_data.registered_notify_me == 'N') || (profile_data.registered_notify_me == 'Unavailable')) {
                            profile_data.registered_notify_me_icon = 'error-icon';
                            profile_data.registered_notify_me_sign = cross_icon;
                        }
                        if ((profile_data.registered_notify_me == 'YES') || (profile_data.registered_notify_me == 'Y')) {
                            profile_data.registered_notify_me_icon = 'success-icon';
                            profile_data.registered_notify_me_sign = tick_icon;
                        }

                        //Mobile App
                        if ((profile_data.registered_mobile_banking == 'NO') || (profile_data.registered_mobile_banking == 'N') || (profile_data.registered_mobile_banking == 'Unavailable')) {
                            profile_data.registered_mobile_banking_icon = 'error-icon';
                            profile_data.registered_mobile_banking_sign = cross_icon;
                        }
                        if ((profile_data.registered_mobile_banking == 'YES') || (profile_data.registered_mobile_banking == 'Y')) {
                            profile_data.registered_mobile_banking_icon = 'success-icon';
                            profile_data.registered_mobile_banking_sign = tick_icon;
                        }

                        //Absa rewards loyalty
                        if ((profile_data.registered_rewards == 'NO') || (profile_data.registered_rewards == 'N') || (profile_data.registered_rewards == 'Unavailable')){
                            profile_data.registered_rewards_icon = 'error-icon';
                            profile_data.registered_rewards_sign = cross_icon;
                        }
                        if ((profile_data.registered_rewards == 'YES') || (profile_data.registered_rewards == 'Y')){
                            profile_data.registered_rewards_icon = 'success-icon';
                            profile_data.registered_rewards_sign = tick_icon;
                        }

                        // Telephone banking
                        if ((profile_data.registered_telephone_banking == 'NO') || (profile_data.registered_telephone_banking == 'N') || (profile_data.registered_telephone_banking == 'Unavailable')) {
                            profile_data.registered_telephone_banking_icon = 'error-icon';
                            profile_data.registered_telephone_banking_sign = cross_icon;
                        }
                        
                        if ((profile_data.registered_telephone_banking == 'YES') || (profile_data.registered_telephone_banking == 'Y')) {
                            profile_data.registered_telephone_banking_icon = 'success-icon';
                            profile_data.registered_telephone_banking_sign = tick_icon;
                        }
                        //registered_ussd
                       
                        if ((profile_data.registered_ussd == 'YES') || (profile_data.registered_ussd == 'Y')) {
                            profile_data.registered_ussd_icon = 'success-icon';
                            profile_data.registered_ussd_sign = tick_icon;
                        }
                        if ((profile_data.registered_ussd == 'NO') || (profile_data.registered_ussd == 'N') || (profile_data.registered_ussd == 'Unavailable')) {
                            profile_data.registered_ussd_icon = 'error-icon';
                            profile_data.registered_ussd_sign = cross_icon;
                        }                        
                        if (profile_data.estatement_registration == 'Unavailable') {
                            profile_data.estatement_registration = 'Unavailable';
                        } else {
                            profile_data.estatement_registration = (profile_data.estatement_registration) ? utilities.formattedDateEstatementRegistration(profile_data.estatement_registration) : '';
                        }
                        //Formatting                         
                        profile_data.cust_name = (profile_data.cust_name) ? utilities.capitalizeFirstLetter(profile_data.cust_name) : '';
                        profile_data.cust_title = (profile_data.cust_title) ? utilities.capitalizeFirstLetter(profile_data.cust_title) : '';
                        profile_data.cust_surname = (profile_data.cust_surname) ? utilities.capitalizeFirstLetter(profile_data.cust_surname) : '';
                        profile_data.poa_first_names = (profile_data.poa_first_names) ? utilities.capitalizeFirstLetter(profile_data.poa_first_names) : '';
                        profile_data.poa_surname = (profile_data.poa_surname) ? utilities.capitalizeFirstLetter(profile_data.poa_surname) : '';
                        profile_data.cust_dob = (profile_data.cust_dob) ? utilities.calculateAgeHelper(profile_data.cust_dob) : '';
                        profile_data.pin_status = (profile_data.pin_status) ? utilities.capitalizeFirstLetter(profile_data.pin_status) : '';
                        profile_data.rvn_email = (profile_data.rvn_email) ? (profile_data.rvn_email.toLowerCase()) : '';
                        profile_data.e_statement_emails_primary = (profile_data.e_statement_emails_primary) ? profile_data.e_statement_emails_primary.toLowerCase() : '';
                        profile_data.e_statement_emails_secondary = (profile_data.e_statement_emails_secondary) ? profile_data.e_statement_emails_secondary.toLowerCase() : '';
						//last login converted data -- rakesh
                        //component.set("v.loginBtn", true);internet_user_loged_in_date
                        //profile_data.internet_user_loged_in_date = (profile_data.internet_user_loged_in_date) ? utilities.formattedDateEstatementRegistration(profile_data.internet_user_loged_in_date) : '';
                        profile_data.i_user_logged_in_date = (profile_data.internet_user_loged_in_date) ? utilities.formattedDateEstatementRegistration(profile_data.internet_user_loged_in_date) : '';
                        profile_data.i_user_loged_in_time = (profile_data.internet_user_loged_in_time) ? utilities.formattedTime(profile_data.internet_user_loged_in_time) : '';
                        profile_data.i_user_name = (profile_data.internet_user_name) ? utilities.capitalizeFirstLetter(profile_data.internet_user_name) : '';
                        //component.set("v.loginBtn", true);
                        if(profile_data.i_user_name != null){
                            
                          
                        }
                        //last login -- mk
                        if(profile_data.i_user_logged_in_date){
                           profile_data.view_login_button_disabled = 'false'; 
                        }else{
                           profile_data.view_login_button_disabled = 'true'; 
                        }
                        
                        //Apply CSS
                        var css_class = 'greyout-cls';
                        profile_data.cust_name_cls = (profile_data.cust_name) ? '' : css_class;
                        profile_data.cust_id_cls = (profile_data.cust_id) ? '' : css_class;
                        profile_data.access_account_number_cls = (profile_data.Access_Account_Number__c) ? '' : css_class;
                        profile_data.cust_client_code_cls = (profile_data.cust_client_code) ? '' : css_class;
                        profile_data.cust_dob_cls = (profile_data.cust_dob) ? '' : css_class;
                        profile_data.cell_number_cls = (profile_data.cell_number) ? '' : css_class;
                        profile_data.rvn_email_cls = (profile_data.rvn_email) ? '' : css_class;
                        profile_data.estatement_registration_cls = (profile_data.estatement_registration) ? '' : css_class;
                        profile_data.e_statement_emails_primary_cls = (profile_data.e_statement_emails_primary) ? '' : css_class;
                        profile_data.e_statement_emails_secondary_cls = (profile_data.e_statement_emails_secondary) ? '' : css_class;
                        profile_data.cust_poa_cls = (profile_data.cust_poa) ? '' : css_class;
                        profile_data.poa_first_names_poa_surname_cls = (profile_data.poa_first_names || profile_data.poa_surname) ? '' : css_class;
                        profile_data.poa_id_cls = (profile_data.poa_id) ? '' : css_class;

                        profile_data.service_status_cls = (profile_data.service_status) ? '' : css_class;
                        profile_data.password_status_cls = (profile_data.password_status) ? '' : css_class;
                        profile_data.pin_status_cls = (profile_data.pin_status) ? '' : css_class;
                        profile_data.combi_card_number_cls = (profile_data.combi_card_number) ? '' : css_class;
                        profile_data.last_success_cls = (profile_data.i_user_logged_in_date) ? '' : css_class;//
                        
                        var channels_css = ' greyout-cls slds-p-left_large';
                        profile_data.registered_aol_banking_cls = (profile_data.registered_aol_banking) ? '' : channels_css;
                        profile_data.registered_notify_me_cls = (profile_data.registered_notify_me) ? '' : channels_css;
                        profile_data.registered_mobile_banking_cls = (profile_data.registered_mobile_banking) ? '' : channels_css;
                        profile_data.registered_rewards_cls = (profile_data.registered_rewards) ? '' : channels_css;
                        profile_data.registered_telephone_banking_cls = (profile_data.registered_telephone_banking) ? '' : channels_css;
 						profile_data.registered_ussd_cls = (profile_data.registered_ussd) ? '' : channels_css;
                        
                        profile_data.payment_to_benif_limit_cls = (profile_data.payment_to_benif_limit) ? '' : css_class;
                        profile_data.inter_acc_fund_transfer_limit_cls = (profile_data.inter_acc_fund_transfer_limit) ? '' : css_class;
                        profile_data.future_dated_pay_limit_cls = (profile_data.future_dated_pay_limit) ? '' : css_class;
                        profile_data.stop_order_limit_cls = (profile_data.stop_order_limit) ? '' : css_class;

                        profile_data.cash_with_draw_limit_cls = (profile_data.cash_with_draw_limit) ? '' : css_class;
                        profile_data.pos_purchase_limit_cls = (profile_data.pos_purchase_limit) ? '' : css_class;
                        profile_data.total_card_limit_cls = (profile_data.total_card_limit) ? '' : css_class;
						
					
						data.profileData = profile_data;
						data.showSpinner.profileInfo = 'slds-hide';
                        component.set("v.data", data);
                       
                    }

                    if (obj.Recent_Transactions_JSON__c) {
                    	var dataRows = [];
                        var transactions_list = JSON.parse(obj.Recent_Transactions_JSON__c);

                        for (let key in transactions_list) {
                            
                            component.set("v.loadTransText", '');
                            
                            let row = transactions_list[key];
                            
                            //CashSend
                            if (row.iip_business_ref_number != 'No data') {
                                let ref_num = row.iip_business_ref_number;
                                if (!isNaN(ref_num) && ref_num.length == 10) {
                                    row.payment_status = utilities.capitalizeOnlyFirstLetter(row.payment_status); 
                                    row.description = '003 <b>' + row.payment_status + '</b>: CashSend withdrawal <br/> number: <b>' + row.iip_business_ref_number + '</b>';                                	
                                }                                
                            }
                            
                            //remove the first 3 nums off description from mainfraim
                            let descr = row.description;
                            if (descr != 'No data' && descr) {
                                descr = row.description.substring(4, row.description.length);
                                descr = utilities.capitalizeOnlyFirstLetter(descr); 
                            }
                            row.description = descr;  
                            
                            if (row.description) {
                                let description = row.description;
                                if (description.includes('Unsuccesful')) {
                                    component.set("v.transactions_tab_red_star", "*");
                                }
                            }  
                            
                            dataRows.push({
                                "index": key,
                                "relationship": "parent",
                                "row_class": "",
                                "icon_class": "circle_icon_plus",
                                "trans_date": (row.date) ? utilities.formattedDate(row.date) : '',
                                "trans_time": (row.time) ? utilities.formattedTime(row.time) : '', 
                                "trans_amount": row.requested_amount,
                                "trans_channel": (row.payment_channel) ? utilities.capitalizeOnlyFirstLetter(row.payment_channel) : '',
                                "trans_reference": row.reference_number,
                                "trans_description": (row.description) ? utilities.capitalizeFirstLetter(row.description) : '' 
                            });
         
                            let childRows = [];
                            dataRows.push({
                                "index": key + 'A',
                                "parent_index": key,
                                "relationship": "child",
                                "row_class": "hide ",
                                "label": "To account",
                                "value": row.account_no 
                            }, {
                                "index": key + 'B',
                                "parent_index": key,
                                "relationship": "child",
                                "row_class": "hide ",
                                "label": "Bank name",
                                "value": (row.institution) ? utilities.capitalizeOnlyFirstLetter(row.institution) : '' 
                            }, {
                                "index": key + 'C',
                                "parent_index": key,
                                "relationship": "child",
                                "row_class": "hide ",
                                "label": "Reference no.",
                                "value": row.reference_no
                            },{
                                "index": key + 'D',
                                "parent_index": key,
                                "relationship": "child",
                                "row_class": "hide ",
                                "label": "EFT no.",
                                "value": row.eft_no
                            });
                            dataRows = dataRows.concat(childRows);
                        }
                        
                        //polling changes
                        let clickedTransactions = component.get("v.clickedTransactions");
                        
                        var arrayLength = clickedTransactions.length;
                        
                        for (var i = 0; i < arrayLength; i++) {
                            let new_index = dataRows.findIndex(x => x.index === clickedTransactions[i]);
                            if(dataRows[new_index].relationship == 'parent'){
                                dataRows[new_index].icon_class = 'circle_icon_minus';
                                dataRows[new_index].row_class = ' bground ';
                            }else{
                                 dataRows[new_index].row_class = ' bground ';
                                let last_index = clickedTransactions[i];
                                if(last_index.includes('D')){
            						dataRows[new_index].row_class = ' last_expandable_row_class ';
                                }
                            } 
       
                        }
                         
                        component.set("v.transactionsList", dataRows);
                        console.log(JSON.stringify(dataRows));
                        component.set("v.data.showSpinner.transactions", 'slds-hide'); 
					}

                    //Set Debit Orders Data                                           
                    if (obj.Debit_Orders_JSON__c) {
                        var set_debits = [];
                        var debits_data = JSON.parse(obj.Debit_Orders_JSON__c);

                        for (var key in debits_data) {
                            var index = key;
                            var debits_record = debits_data[index];
                            debits_record.action_date = utilities.convertToValidDate(debits_record.action_date);
                            debits_record.action_button_class = 'slds-button_outline-gray';
                            
                            var debit_order_status = debits_record.status;
                            
                            //if(debit_order_status.includes('R') || debit_order_status.includes('F')){
                            //Rakesh added on 30th Jan		                            
                            if(debit_order_status.includes('R') || debit_order_status.includes('F') || debit_order_status.includes('D')){	
                                
                                debits_record.debit_order_transaction_status_class = 'darkgrey-color-cls';  
                                
                                if(debit_order_status.includes('R')){    
                                    debits_record.debit_order_transaction_status = 'Reversed'; 
                                    debits_record.debit_order_transaction_class = 'greyout-color-cls';
                                }
                                if(debit_order_status.includes('F')){
                                   debits_record.debit_order_transaction_status = 'Future dated';  
                                   debits_record.debit_order_transaction_class = ''; 
                                }
                                //Rakesh added on 30th Jan		
                                if(debit_order_status == 'D'){		
                                   debits_record.debit_order_transaction_status = 'Debit unsuccessful';  		
                                   debits_record.debit_order_transaction_class = 'greyout-color-cls'; 		
                                } 
                            }                            

                            console.log('Index: ' + index + ' Debits - item: ' + debits_record);
							debits_record.action_button_disabled = true; 
                            set_debits.push({
                                value: debits_record,
                                key: key
                            });
                        }
                        component.set("v.data.debitsData", set_debits);
                        //Remove spinner
                        component.set("v.data.showSpinner.debitOrders", 'slds-hide');                        
                    }

                    //Set call history                                          
                    if (obj.Call_History_JSON__c) {
                        var set_calls = [];
                        var calls_data = JSON.parse(obj.Call_History_JSON__c);

                        for (var key in calls_data) {
                            var index = key;
                            var calls_record = calls_data[index];
                            calls_record.record_time = (calls_record.record_time) ? utilities.formattedTime(calls_record.record_time) : '';
                            calls_record.record_date = (calls_record.record_date) ? utilities.convertToValidDateCallHistory(calls_record.record_date) : '';                            
                            
                            console.log('Index: ' + index + ' Calls - item: ' + calls_record);
                            set_calls.push({
                                value: calls_record,
                                key: key
                            });
                        }
                        component.set("v.data.callsData", set_calls);
                        //Remove spinner
                        component.set("v.data.showSpinner.callHistory", 'slds-hide');
                    }

                    //Set IIP Hold                                      
                    if (obj.IIP_JSON__c) {                
                        var ipps_data = JSON.parse(obj.IIP_JSON__c);
                        var set_iips = [];
                        for (var key in ipps_data) {
                            var index = key;
                        	var ipp_record = ipps_data[index]; 
                              
                            ipp_record.release_action_button_disabled = true;
                            ipp_record.cancel_action_button_disabled = true; 
                            
                            ipp_record.release_action_button_class = 'slds-button_outline-gray'; 
                            ipp_record.cancel_action_button_class = 'slds-button_outline-gray';                               
                            
                            if(ipp_record.created_date)
                            	ipp_record.formatted_created_date = utilities.formattedDate(ipp_record.created_date);
                            
                            if(ipp_record.created_time)
                            	ipp_record.formatted_created_time = utilities.formattedTime(ipp_record.created_time);

                            var status_notes = ipp_record.status_notes;
                            if(status_notes){
                                
                                if(status_notes.includes('R'))
                                    ipp_record.formatted_status_notes = 'Released'; 
                                
                                if(status_notes.includes('O')){ 
                                    ipp_record.formatted_status_notes = 'In progress';  
                                	component.set("v.iip_holds_tab_red_star", "*"); 
                                }                                
                                
                                if(status_notes.includes('C'))
                                    ipp_record.formatted_status_notes = 'Cancelled';
                            
                            }
                                
                            if(ipp_record.amount)
                                ipp_record.formatted_amount = 'R'+ipp_record.amount;                                

                            
                            set_iips.push({
                                value: ipp_record,
                                key: key
                            });                             
                        }                  
                        component.set("v.data.iipsData", set_iips); 
                        
						component.set("v.data.showSpinner.iipHolds",'slds-hide');
                        
                    } 
                    
                    //Set Sim Hold                                           
                    if (obj.Sim_Holds_JSON__c) {
                        var set_holds = [];
                        var holds_data = JSON.parse(obj.Sim_Holds_JSON__c);

                        for (var key in holds_data) {
                            var index = key;
                            var holds_record = holds_data[index];
                            if (holds_record.user_number && holds_record.user_number != 'Unavailable') { 
                                holds_record.user_number = '00' + holds_record.user_number;
                            }                                

                            if (holds_record.sim_hold_status == 'N') {
                                holds_record.sim_hold_color = '';
                                holds_record.sim_hold_status = 'No';
                                holds_record.action_button_disabled = false; 
                            }
                            if (holds_record.sim_hold_status == 'Y') {
                                holds_record.sim_hold_color = 'slds-text-color_error';
                                holds_record.sim_hold_status = 'Yes';                                
                                holds_record.action_button_disabled = true;                                  
                                holds_record.action_button_class = 'slds-button_outline-gray';
                                 
                                //holds_record.show_button_spinner = true;
                                component.set("v.sim_holds_tab_red_star", "*");
                                
                            }
                            console.log('Index: ' + index + ' Calls - item: ' + holds_record);

                            set_holds.push({
                                value: holds_record,
                                key: key
                            });
                        }

						data.simsData = set_holds;
						data.showSpinner.simHolds = 'slds-hide';
                        data.showSpinner.notes = 'slds-hide';
                        component.set("v.data", data);
						
						component.set("v.data.showSpinner.simHolds",'slds-hide');
                        component.set("v.data.showSpinner.notes",'slds-hide');
                        //this.enableActionButtons(component, event);   
                     
                    }
                    
                    
                    //Stop polling
                    if (obj.Robot_Item_Status__c == 4) {
                        console.log('stopping because of status code: ' + obj.Robot_Item_Status__c);
                        component.set("v.maxRepeats", 0);
                        
                        this.enableActionButtons(component, event); 
                        return; 
                    }

                    if (component.get("v.maxRepeats") == 0) {
                        console.log('Stopping because of timeout');

                        var reset = true;
                        //If there's a populated tab... do not reset dashboard/show timeout error
                        if (obj.Profile_JSON__c || obj.Recent_Transactions_JSON__c || obj.Debit_Orders_JSON__c || obj.Call_History_JSON__c || obj.Sim_Holds_JSON__c) {
                            reset = false;
                        }
                        //Stop spinners
                        if (!obj.Profile_JSON__c) {
                            component.set("v.data.showSpinner.profileInfo", 'slds-hide');
                        }
                        if (!obj.Recent_Transactions_JSON__c) {
                            component.set("v.data.showSpinner.transactions", 'slds-hide');
                            component.set("v.loadTransText", 'slds-hide');
                        }
                        if (!obj.Debit_Orders_JSON__c) {
                            component.set("v.data.showSpinner.debitOrders", 'slds-hide');
                        }
                        if (!obj.Call_History_JSON__c) {
                            component.set("v.data.showSpinner.callHistory", 'slds-hide');
                        }
                        if (!obj.Sim_Holds_JSON__c) {
                            component.set("v.data.showSpinner.simHolds", 'slds-hide');
                        }
                        if(!obj.IIP_JSON__c){
                            component.set("v.data.showSpinner.iipHolds",'slds-hide');
                        }
	 
                        if (reset) {
                            component.set("v.data.showSpinner.profileInfo", 'slds-hide');
                            component.set("v.modalObj", {isOpen: true, header: 'An error occurred', body:'Time out'});              
                       	
                            //Show timeout error                         
                            this.resetDashboard(component, event);
                        
                        }
                        component.set("v.data.showSpinner.notes", 'slds-hide');
                        return;
                    }
                    if (obj.Robot_Item_Status__c == 2 || obj.Robot_Item_Status__c == 5 || obj.Robot_Item_Status__c == 7) {
                        //Stop polling
                        component.set("v.maxRepeats", -1);

                        //Remove spinner
                        component.set("v.data.showSpinner.profileInfo", 'slds-hide');

                        //Show timeout error 
                        //Rakesh added on 16 Jan 2020(user friendly messages)
              			if(obj.Robot_Item_Status__c == 5){
                           component.set("v.modalObj", {isOpen: true, header: 'Business exception', body: obj.Robot_Item_Exception_Reason__c}); 
                        }
                        else if(obj.Robot_Item_Status__c == 7){
                           component.set("v.modalObj", {isOpen: true, header: 'Technical exception', body: obj.Robot_Item_Exception_Reason__c}); 
                        }
                        else{                  
                        component.set("v.modalObj", {isOpen: true, header: 'An error occurred', body: obj.Robot_Item_Exception_Reason__c});
                        }
                        this.resetDashboard(component, event);
    
                        component.set("v.data.showSpinner.notes", 'slds-hide');
                        return; 
                    }  
                }else{
                    if(errors && Array.isArray(errors) && errors.length > 0){ 
                   		component.set("v.modalObj", {isOpen: true, header: 'Populate dashboard error', body: errors[0].message});                       
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
 	resetDashboard: function(component, event) { 

        component.set("v.options", [{'label': 'ID number', 'value': 'ID number'},{'label': 'Access account', 'value': 'access account'}]);
        component.set("v.value", "access account");

        component.set("v.invalidACCText", 'slds-hide');
        component.set("v.searchCardVisible", "slds-show");
        component.set("v.informationCardVisible", 'slds-hide');

        component.set("v.resultStatus", ""); 

        component.set("v.queueItemID", "");

        component.set("v.profileDataMessage", "");

        component.set("v.transactionsList", "");
        component.set("v.transactionsMessage", "");
		component.set("v.loadTransText", 'slds-hide');

        component.set("v.debitsDataMessage", "");

        component.set("v.callsDataMessage", "");

        component.set("v.formattedNotes", "");
        component.set("v.additionalNotes", "");
        
		component.set("v.IIPHoldAction", "");
        component.set("v.iipsData","");
        component.set("v.holdsDataMessage", "");

        component.set("v.maxRepeats", -1);              
        
        component.set("v.postToInbound", {
            profile: false,
            debit_orders: false,
            transactions: false,
            call_history: false,
            sim_holds: false
        });        
        component.set("v.transactions_tab_red_star", "");
        component.set("v.sim_holds_tab_red_star", "");      
		component.set("v.iip_holds_tab_red_star", "");//25112019_Rakesh added
        //Set default tab to profile
        var profileTab = 'profile';
        var currentTab = component.get("v.currentTab");

        if (profileTab != currentTab) {
            var deActivateTab = currentTab;
            component.set("v.currentTab", profileTab);
            this.activateTab(component, profileTab);
            this.deActivateTab(component, deActivateTab);
        }

        component.set("v.additionalNotes", "");
         
        var logInObj = component.get("v.data");

         
        component.set("v.data", null);
        
        var data = {
          robotData: {
            'sObjectType': 'Robot_Data_Retrieval__c',
            'Name': '',
            'Recent_Transactions_JSON__c': '',
            'Profile_JSON__c': '',
            'ID_Number__c': '',
            'Debit_Orders_JSON__c': '',
            'Call_History_JSON__c': '',
            'Access_Account_Number__c': '',
            'Robot_Item_Tag__c': '',
            'Robot_Item_Exception_Reason__c': '',
            'Sim_Holds_JSON__c': '',
            'IIP_JSON__c':'',
            'Robot_Item_Status__c': 0
          },
          showSpinner: {
            profileInfo: 'slds-hide',
            profileMsg: 'Profile loading...',
            transactions: 'slds-hide',
            transactionsMsg: 'Transactions loading...',
            debitOrders: 'slds-hide',
            debitOrdersMsg: 'Debit orders loading...',
            iipHolds: 'slds-hide',
            iipHoldsMsg: 'IIP holds loading...',
            callHistory: 'slds-hide',
            callHistoryMsg: 'Call history loading...',
            simHolds: 'slds-hide',
            simHoldsMsg: 'Sim holds loading...',
            notes: 'slds-hide',
            notesMsg: 'Loading...'
          },
          loggedInUser: logInObj.loggedInUser,
          profileData: {
            'cust_name_cls': 'greyout-cls',
            'cust_id_cls': 'greyout-cls',
            'access_account_number_cls': 'greyout-cls',
            'cust_client_code_cls': 'greyout-cls',
            'cust_dob_cls': 'greyout-cls',
            'cell_number_cls': 'greyout-cls',
            'rvn_email_cls': 'greyout-cls',
            'estatement_registration_cls': 'greyout-cls',
            'e_statement_emails_primary_cls': 'greyout-cls',
            'e_statement_emails_secondary_cls': 'greyout-cls',
            'cust_poa_cls': 'greyout-cls',
            'poa_first_names_poa_surname_cls': 'greyout-cls',
            'poa_id_cls': 'greyout-cls',
            'service_status_cls': ' greyout-cls',
            'password_status_cls': ' greyout-cls',
            'pin_status_cls': ' greyout-cls',
            'last_success_cls': ' greyout-cls',
            'combi_card_number_cls': ' greyout-cls',
            'registered_aol_banking_cls': 'greyout-cls slds-p-left_large',
            'registered_notify_me_cls': ' greyout-cls slds-p-left_large',
            'registered_mobile_banking_cls': ' greyout-cls slds-p-left_large',
            'registered_rewards_cls': ' greyout-cls slds-p-left_large',
            'registered_telephone_banking_cls': ' greyout-cls slds-p-left_large',
            'registered_ussd_cls': ' greyout-cls slds-p-left_large',
            'payment_to_benif_limit_cls': 'greyout-cls',
            'inter_acc_fund_transfer_limit_cls': 'greyout-cls',
            'future_dated_pay_limit_cls': 'greyout-cls',
            'stop_order_limit_cls': 'greyout-cls',
            'cash_with_draw_limit_cls': 'greyout-cls',
            'pos_purchase_limit_cls': 'greyout-cls',
            'total_card_limit_cls': 'greyout-cls',
            'view_login_button_disabled': 'true'
          },
          debitsData: {},
          iipsData: {},
          callsData: {},
          simsData: {},
          notesData: [],
          wrapUpBtnDisabled: true
        }; 
        component.set("v.data", data);
    },   
    enableWrapUpButton: function(component, event) {       
        var notesData = component.get("v.data.notesData");
        var additionalNotes = component.get("v.additionalNotes");
        console.log(JSON.stringify('notes -- ' + notesData));

        var noteSize = 0;
        for (var key in notesData) {
            noteSize++;
            break;
        }
        var isDisabled = true;

        var extraNotesTrim = "";
        if (additionalNotes) {
            extraNotesTrim = additionalNotes.trim();
        }

        var extraNotesLen = extraNotesTrim.length;
        if (noteSize > 0 || extraNotesLen > 0) {
            isDisabled = false;
        }
        component.set("v.data.wrapUpBtnDisabled", isDisabled);

    },
    navigationHelper: function(component, event) {
        var clickedTab = event.currentTarget.id;
        var currentTab = component.get("v.currentTab");

        if (clickedTab != currentTab) {
            var deActivateTab = currentTab;

            component.set("v.currentTab", clickedTab);			
            
            this.activateTab(component, clickedTab);
            this.deActivateTab(component, deActivateTab);
            
            //set notes textbox cursor 
            (clickedTab === 'notes') ? component.set("v.anchorCursor", true) : component.set("v.anchorCursor", false);         
        }
    }, 
    activateTab: function(component, clickedTab) {
        var tabId = component.find(clickedTab);
        var tab_div = component.find(clickedTab + "Div");
        $A.util.addClass(tabId, 'slds-active');
        $A.util.addClass(tab_div, 'slds-show');
        $A.util.removeClass(tab_div, 'slds-hide');
    },
    deActivateTab: function(component, previousTab) {
        var tabId = component.find(previousTab);
        var tab_div = component.find(previousTab + "Div");
        $A.util.removeClass(tabId, 'slds-active');
        $A.util.removeClass(tab_div, 'slds-show');
        $A.util.addClass(tab_div, 'slds-hide');
    },
    navigateToSharePointHelper: function(component, event) {
        var MIPortalLink = $A.get("$Label.c.DBS_MIPortalLink");
        window.open(MIPortalLink, '_blank');        
        this.saveNotesHelper(component, event);
    },
    saveNotesHelper: function(component, event) {

        var robotData = component.get("v.data.robotData");
        console.log(JSON.stringify(robotData));
        var notesData = component.get("v.formattedNotes");

        //Removes all special chars and only leaves the ones specified  
        var escapedNotesData = notesData.replace(/[^a-zA-Z0-9!@#$%^&*()-+={}:;?.,<>_|\s]/g, "").replace(/\s\s/g, " ");
          
        //Finds any number of sequential spaces and removes them. replacing them with a single space instead
        var formattedNotes = escapedNotesData.replace(/\s+/g,' ').trim();
        
        console.log('Robot data: ' + JSON.stringify(robotData));
        console.log('notesData data: ' + JSON.stringify(formattedNotes));

        var noteObj = '{"keyValue": "' + robotData.ID_Number__c + '","queueItemId":"' + robotData.Name + '", "notes":"' + formattedNotes + '","accessAccountNumber":"' + robotData.Access_Account_Number__c + '"}';
        console.log('Notes object request: ' + noteObj);

        var action = component.get("c.saveNotesPost");
        action.setParams({
            noteObj: noteObj
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            var response = a.getReturnValue();
			var errors = a.getError(); 
            if (component.isValid() && state === "SUCCESS") {
                var queueItemID = response[2];
                console.log("Save notes item created successfully: " + queueItemID);
                component.set("v.queueItemID", queueItemID);

                this.createNoteActionRecordHelper(component, event);
            } else if (resultStatus === 'Unauthorized') {
                this.getToken(component, event); 
                component.set("v.modalObj", {isOpen: true, header: 'Save notes, request unauthorized', resultMessage });                                
            } else if (resultStatus === 'Timeout') {
                component.set("v.modalObj", {isOpen: true, header: 'Save notes timeout', body: resultMessage });                    
            }else {                      
                component.set("v.modalObj", {isOpen: true, header: 'Save notes exception.', body: resultMessage });                    
            }  
        });
        $A.enqueueAction(action);
    },
    createNoteActionRecordHelper: function(component, event) {

        var robotData = component.get("v.data.robotData");
        console.log(JSON.stringify(robotData));
        var queueItemID = component.get("v.queueItemID");
        var notes = component.get("v.data.notesData");
        notes.Queue_Item_ID__c = queueItemID;
        notes.Action_Type__c = 'Notes';

        var stringifiedNotes = JSON.stringify(notes);
        console.log("queueItemID: " + queueItemID + " stringifiedNotes: " + stringifiedNotes);
        var action = component.get("c.processRobotDataAction");
        action.setParams({
            itemID: queueItemID,
            robotAction: stringifiedNotes,
            actionType: 'upsert'
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('Created Notes QueueItem Record Successfully: ' + queueItemID);
                
                document.getElementById("accAccOrIdNum").value = "";
            	component.set("v.accAccOrIdNum", null);
                this.resetDashboard(component, event);
            }
        });
        $A.enqueueAction(action);
    }, 
    newSearchModal:function(component, headerMsg, bodyMsg) {
        component.set("v.modalObj", {isOpen: true, header: headerMsg, body: bodyMsg});
        component.set("v.searchCardVisible", "");
        component.set("v.informationCardVisible", "slds-hide"); 
        component.set("v.maxRepeats", -1);
        this.resetDashboard(component, event);   
        return; 
    }, 
    anchorCursorHelper: function(component, event, helper) {
        document.getElementById("accAccOrIdNum").focus(); 
    },
    enableActionButtons:function(component, event){
        component.set("v.data.showSpinner.notes", 'slds-hide');
        component.set("v.loadTransText", 'slds-hide');
        
        var debits_data = component.get("v.data.debitsData");
        //Enable debit order action buttons                                          
        if (debits_data) {
            for (var key in debits_data) {
                debits_data[key].value.action_button_disabled = false; 
            } 
            component.set("v.data.debitsData", debits_data);                     
        }
        
        //Enable IIP
        var iipsData = component.get("v.data.iipsData");
        if (iipsData) {
            for (var key in iipsData) {
                iipsData[key].value.release_action_button_disabled = false; 
                iipsData[key].value.cancel_action_button_disabled = false; 
                                
                iipsData[key].value.release_action_button_class = ''; 
                iipsData[key].value.cancel_action_button_class = '';                  
            } 
            component.set("v.data.iipsData", iipsData);                     
        } 
        
        //Enable simhold button                                                               
        var holds_data = component.get("v.data.simsData");
        if (holds_data) {
            for (var key in holds_data) {          
                holds_data[key].value.action_button_disabled = false;    
            }
            component.set("v.data.simsData", holds_data);
        }                                 
    }
})