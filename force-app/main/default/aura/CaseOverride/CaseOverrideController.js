/**
* Lightning Component Controller for CaseOverride
*
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-07-20
*
**/

({
    //Method to get Client Record from setClientInfo Lightning Event
    setClientValue : function(component, event, helper){
        //Get selected Client
        var eventAccountValue= event.getParam("accountValue");
        var eventIsIndivClient = event.getParam("isIndivClient");
        
        if (eventAccountValue != null && eventAccountValue != undefined) {
            
            component.set("v.accountRecord", eventAccountValue);
            
        }
        
        if (eventIsIndivClient != null && eventIsIndivClient != undefined) {
            
            component.set("v.isIndvClient", eventIsIndivClient);
            
        }
        
        console.log("setAttribute.Id: " + component.get("v.accountRecord").Id);
        console.log("setAttribute.Name: " + component.get("v.accountRecord").Name);
        console.log("setAttribute.FirstName: " + component.get("v.accountRecord").FirstName);
        console.log("setAttribute.LastName: " + component.get("v.accountRecord").LastName);

      //Smanga Start - 21 Sept 2020
      var selectedCaseType     = component.get("v.caseTypeSelected");
      var clientFinderProdList = component.get("v.productList");
      var showTheReminder      = component.get("v.showTheReminder");
      var accountId            = component.get("v.accountRecord").Id;
      console.log("showTheReminder ==> "+ showTheReminder);
      console.log("clientFinderProdList ==> "+ clientFinderProdList);
      console.log("accountId ==> "+ accountId);
      console.log("selectedCaseType ==> "+ selectedCaseType);
      
      // Added by Poulami to remove the Product Validation for NBFS Service Group
      var NBFSFlag = component.get('v.isNBFSServiceGroup');  
      if(clientFinderProdList !== null && accountId !== undefined && (selectedCaseType ==='ATM' || selectedCaseType ==='Complaint') && showTheReminder && NBFSFlag === false){
      }
      //Smanga End- 21 Sept 2020
    },
    
    //Method to get Contact Record from setContactInfo Lightning Event
    setContactValue : function(component, event, helper){
        //Get selected Contact
        var contactRecordIdEvent = event.getParam("contactRecordId");
        var contactRecordEvent= event.getParam("contactRecord");
        
        component.set("v.contactId", contactRecordIdEvent);
        component.set("v.contactRecord", contactRecordEvent);
    },
    
    //Method to get Product Record from setProductInfo Lightning Event
    setProductValue : function(component, event, helper){
        //Get selected Contact
        var accNo = event.getParam("accountNumber");
        var accStatus = event.getParam("accountStatus");
        var accProduct = event.getParam("accountProduct");
        
        component.set("v.accountNumber", accNo);
        component.set("v.accountStatus", accStatus);
        component.set("v.accountProduct", accProduct);
        
    },
    
    //Method to get Participant Record from setParticipantInfo Lightning Event
    setParticipantValue : function(component, event, helper){
        //Get selected Client
        var participantRecordValue = event.getParam("participantRecord");
        
    },
    
    closeModelYes: function(component,event,helper){
        
        var isComplaint = component.get("v.isComplaint");
        if(isComplaint){
            component.set("v.caseTypeSelected" , 'ATM');
            component.set("v.isOpen" , false);
            component.set("v.popupMessage" , '');
            component.set("v.isATM", true);
            component.set("v.isComplaint", false);
            component.find("iAmountWithdrawn").set("v.value" , "");
            component.find("iAmountRecieved").set("v.value" , "");
        }
        else{
            
            component.set("v.isOpen" , false);
            component.set("v.popupMessage" , '');
            //component.set("v.isATM", false);
        }
    },
    closeModelNo: function(component,event,helper){
        var isATM = component.get("v.isATM");
        if(isATM){
            component.set("v.caseTypeSelected" , 'Complaint');
            component.set("v.isATM", false);
            component.set("v.isComplaint", true);
        }
        component.set("v.isOpen" , false);
        component.set("v.popupMessage" , '');
        
    },
    
    //Method to update paramters based on Service Group selected
    onServiceGroupSelectChange : function(component, event, helper) {
        console.log('v.caseTypeSelected ==> '+ component.get("v.caseTypeSelected"));

        helper.showSpinner(component);
        
        var selectedCaseType = component.get("v.caseTypeSelected") 
        console.log('selectedCaseType: '+ selectedCaseType);
        var recordTypeName;
        
        if(selectedCaseType == 'Life_Complaint') {
            component.set("v.isOpen" , true);
            component.set("v.serviceGroupFilter", 'Complaint');
            component.set("v.isComplaint", true);
            component.set("v.isNonConfidentialFraud", false);
            component.set("v.isATM", false);
            component.set("v.isServiceRequest", false);
            component.set("v.isCompliment", false);
            recordTypeName = 'Life Complaint';
            console.log('Life Complaint Selected');
        }
        else if(selectedCaseType == 'Complaint') {
            component.set("v.isOpen" , true);
            component.set("v.serviceGroupFilter", 'Complaint');
            component.set("v.isComplaint", true);
            component.set("v.isNonConfidentialFraud", false);
            component.set("v.isATM", false);
            component.set("v.isServiceRequest", false);
            component.set("v.isCompliment", false);
            recordTypeName = 'Complaint';
            console.log('ComplaintSelected');
            
        }else if (selectedCaseType == 'Non_Confidential_Fraud') {
            component.set("v.serviceGroupFilter", 'Non Confidential - Forensic');
            component.set("v.isComplaint", false);
            component.set("v.isNonConfidentialFraud", true);
            component.set("v.isATM", false);
            component.set("v.isServiceRequest", false);
            component.set("v.isCompliment", false);
            
        }else if (selectedCaseType == 'ATM') {
            component.set("v.isOpen" , true);
            component.set("v.serviceGroupFilter", 'ATM');
            component.set("v.isComplaint", false);
            component.set("v.isNonConfidentialFraud", false);
            component.set("v.isATM", true);
            component.set("v.isServiceRequest", false);    
            component.set("v.isCompliment", false);
            component.find("iAmountWithdrawn").set("v.value" , "");
            component.find("iAmountRecieved").set("v.value" , "");
            
        }else if(selectedCaseType == 'Service_Request'){
            component.set("v.serviceGroupFilter", 'Service Request');
            component.set("v.isComplaint", false);
            component.set("v.isNonConfidentialFraud", false);
            component.set("v.isATM", false);
            component.set("v.isServiceRequest", true);
            component.set("v.isCompliment", false);
            recordTypeName = 'Service Request';
            
        }else if(selectedCaseType == 'Compliment'){	
            component.set("v.serviceGroupFilter", 'Compliment');	
            component.set("v.isComplaint", false);	
            component.set("v.isNonConfidentialFraud", false);	
            component.set("v.isATM", false);	
            component.set("v.isServiceRequest", false);	
            component.set("v.isCompliment", true);	
            
        }else if(selectedCaseType == 'Short_term_Complaint'){
            //component.set("v.isOpen" , true);
            component.set("v.serviceGroupFilter", 'Short Term Complaint');
            component.set("v.isShortTermComplaint", true);
            component.set("v.isComplaint", false);
            component.set("v.isNonConfidentialFraud", false);
            component.set("v.isATM", false);
            component.set("v.isServiceRequest", false);
            component.set("v.isCompliment", false);
            recordTypeName = 'Short Term Complaint';
        }
        
        //Koketso - Query only service groups for the selected record type
        console.log('**recordTypeName**', recordTypeName);
        var serviceGroupLookupCondition = ' AND Active__c=true AND Assign_Record_Type__c = \''+recordTypeName+'\'';
        component.set('v.serviceGroupLookupCondition', serviceGroupLookupCondition);
        
        helper.hideSpinner(component);
    },
    
    //Init load of Component
    doInit : function(component, event, helper) {
        
        //Close all open Tabs
        //helper.closeAllTabs(component);
        
        //Get Case Record Types and deafult from Profile to set Record Type buttons
        helper.getCaseRecordTypes(component);
        
        //Get Complaints Permission Sets to set navigation buttons
        helper.getUserPermissionSets(component);  
        if(component.get("v.recordId") != null){
            component.set("v.parentId",component.get("v.recordId"));  
            console.log(component.get("v.parentId"));           
        }else{     
            component.set("v.parentId",$A.get("$SObjectType.CurrentUser.Id"));  
        }
    },
    
    isReceiptChanged : function(component, event, helper) {
        var isReceiptChecked = component.find('iReceiptSlipAvailable').get('v.value');
        component.set("v.isReceiptChecked",isReceiptChecked); 
    },
    
    handleUploadFinished: function(component, event, helper) {        
        component.set("v.contentDocumentId",event.getParam("files")[0].documentId); 
    },
    
    handleSuccess: function(component, event, helper) {
        var payload = event.getParams().response;
        var action = component.get("c.updateContentDocument");
        action.setParams({caseId : payload.id, contentDocumentId : component.get("v.contentDocumentId")});        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": payload.id,
                    "slideDevName": "details"
                });
                navEvt.fire();
            }            
        });
        $A.enqueueAction(action);
        
        
    },
    //Koketso - handle multiple files, and display selected file names
    handleFilesChange: function(component, event, helper) {
        
        var uploadedFileIds = [];
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles:',uploadedFiles);
        
        if(uploadedFiles.length > 0){
            
            var filenames = '';
            var uploadedFileNames = component.find('uploadedFileNames');
            
            for(var f = 0; f < uploadedFiles.length; f++){
                uploadedFileIds.push(uploadedFiles[f]['documentId']);
                filenames += uploadedFiles[f]['name']+"; ";
            }
            
            if(filenames != '') {
                var forensicFileText = component.find('forensicFileText');
                $A.util.removeClass(forensicFileText, 'slds-text-color_error');
                $A.util.addClass(forensicFileText, 'slds-text-color_success');
                var complaintFileText = component.find('complaintFileText');
                $A.util.removeClass(complaintFileText, 'slds-text-color_error');
                $A.util.addClass(complaintFileText, 'slds-text-color_success');                
                $A.util.removeClass(uploadedFileNames, 'slds-text-color_error');
                $A.util.addClass(uploadedFileNames, 'slds-text-color_success');
            }
            else {
                var forensicFileText = component.find('forensicFileText');
                $A.util.removeClass(forensicFileText, 'slds-text-color_success');
                $A.util.addClass(forensicFileText, 'slds-text-color_error'); 
                var complaintFileText = component.find('complaintFileText');
                $A.util.removeClass(complaintFileText, 'slds-text-color_success');
                $A.util.addClass(complaintFileText, 'slds-text-color_error');
                $A.util.removeClass(uploadedFileNames, 'slds-text-color_success');
                $A.util.addClass(uploadedFileNames, 'slds-text-color_error');
            }
            console.log('uploadedFileIds:',uploadedFileIds);
            component.set("v.fileStr", filenames);
            component.set("v.fileIds", uploadedFileIds);
        }
        
    },
    
    //Get the Service Group record based on Service Group Id
    getServiceGroup : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        //Get Case Type
        var caseRecordType = component.get("v.caseTypeSelected");
        
        var action = component.get("c.findServiceGroupRecord"); 
        
        var serviceGroupId;
        if(caseRecordType == 'Non_Confidential_Fraud') {
            serviceGroupId = component.find("serviceGroupLookupSearch").get("v.value");
        }else if (caseRecordType == 'Complaint') {
            serviceGroupId = component.find("serviceGroupLookupSearchComplaint").get("v.value");
        }else if (caseRecordType == 'Service_Request'){
            /* Commented out by Simangaliso Mathenjwa 25 june 2020
             * serviceGroupId = component.find("serviceGroupLookupSearchServiceReq").get("v.value");
             */
            // begin Added by Simangaliso Mathenjwa 25 june 2020
            var serviceGroupRec2 = component.get("v.serviceGroupRecord");
            var serviceGroupId = serviceGroupRec2.Id;
            // Start Added by Simangaliso Mathenjwa 25 june 2020
            if(serviceGroupId == null || serviceGroupId == ''){
                component.find('classify').set('v.value', false);
            }
        }else if (caseRecordType == 'Compliment'){	
            serviceGroupId = component.find("serviceGroupLookupSearchCompliment").get("v.value");	
        }
        
        action.setParams({
            "serviceGroupId" :serviceGroupId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.serviceGroupRecord", response.getReturnValue());
                
                var queueName;
                var serviceGroupName;
                var serviceGroupId;
                
                helper.hideSpinner(component);
                
            }else{
                
                // show error notification
                var toastEvent = helper.getToast("Error", "There was an error searching for the relevant Service Group", "error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Check the NBFS Service Group record based on Service Group Id
     	 checkNBFSServiceGroup : function(component, event, helper) {
       
        	helper.showSpinner(component);
       
        	//Get Case Type
            var caseRecordType = component.get("v.caseTypeSelected");
        	var action = component.get("c.getServiceGroupInfo");
        	var serviceGroupId;

        	if(caseRecordType == 'Non_Confidential_Fraud') {
            	serviceGroupId = component.find("serviceGroupLookupSearch").get("v.value");
        	}else if (caseRecordType == 'Service_Request' || caseRecordType == 'Complaint' || caseRecordType == 'Short_term_Complaint'){
           
            	var serviceGroupRec2 = component.get("v.serviceGroupRecord");
                var serviceGroupId = serviceGroupRec2.Id;
                if(caseRecordType == 'Complaint' && (serviceGroupId == undefined || serviceGroupId == null)){
                     if(component.find("iAlternativeContact") !== undefined)
            		 	component.find("iAlternativeContact").set("v.value", '');
                     if(component.find("iCapacity") !== undefined)
                     	component.find("iCapacity").set("v.value", '');
                     component.set("v.NBFSCategory", '');
                     component.set("v.MonResRequired", '');
                }
                
                if(caseRecordType == 'Service_Request' && serviceGroupId == null){
                    var isClassifyChecked = component.find('classify');
                    isClassifyChecked.set('v.value', false);
                    component.set("v.isClassify", false); 
                    component.set("v.productId", null);
                    component.set("v.serviceTypeId", null);
                }
           
        	}else if (caseRecordType == 'Compliment'){
            	serviceGroupId = component.find("serviceGroupLookupSearchCompliment").get("v.value");
       	  	}
       
        		action.setParams({
            		"serviceGroupId" :serviceGroupId
        		});
        		console.log("serviceGroupId",serviceGroupId);
        		// Add callback behavior for when response is received
        		action.setCallback(this, function(response) {
           
            		var state = response.getState();
            		if (component.isValid() && state === "SUCCESS") {
                		var NBFSResponse = response.getReturnValue();
                        console.log('NBFSResponse',NBFSResponse);
                        if(NBFSResponse[0] == "True"){
                            
                            var a = component.get('c.getCurrentUserDetails');
        					$A.enqueueAction(a);
                            component.set("v.isNBFSServiceGroup", true);
                        }
                		else
                    		component.set("v.isNBFSServiceGroup", false);
                		
                    helper.hideSpinner(component);
                	component.set("v.NBFSServiceGroup", NBFSResponse[1]);
                    component.set("v.region", NBFSResponse[2]);
                    var showFpocBtn = component.get("v.showFpocBtn");
                    var showIwillResolveBtn = component.get("v.showIwillResolveBtn");
            		var showRoutingBtn = component.get("v.showRoutingBtn");
                    var btnFPOC = component.find("ibtnFPOC");
                	var btnRoute = component.find("ibtnServiceGroupRouting");
                	var btnResolve = component.find("ibtnIwillResolve");
                    if(btnFPOC !== undefined)
                    	btnFPOC.set('v.disabled',false);
            		if(btnRoute !== undefined)
                     	btnResolve.set('v.disabled',false);
            		if(btnResolve !== undefined)
                   		btnRoute.set('v.disabled',false);
              		}else{
               
                	// show error notification
                    var toastEvent = helper.getToast("Error", "There was an error searching for the relevant Service Group", "error");
                	toastEvent.fire();
               
                	helper.hideSpinner(component);
            		}
  			});
       
        	// Send action off to be executed
        	$A.enqueueAction(action);
     	},
   
      	//Set NBFS Category values based on Roles and Profiles
    	getCurrentUserDetails : function(component, event, helper) {
      
        var action = component.get("c.getCurrentUserRole");
        var NBFSCategory;
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var rolePermissionSets = response.getReturnValue();
                console.log('rolePermissionSets',rolePermissionSets);
              	if(rolePermissionSets[0] == 'true')
                    component.set("v.NBFSQueueMember", true);
                
                else if(rolePermissionSets[1] == 'true'){ //added for short term insurance
                    NBFSCategory = 'Level 3'
                    component.set("v.NBFSCategory", NBFSCategory);
                    
                }else if(rolePermissionSets[3] == 'true'){ //added for short term insurance
                    NBFSCategory = 'Level 1'
                    component.set("v.NBFSCategory", NBFSCategory);
                }
                else{
                    NBFSCategory = 'Level 2'
                    component.set("v.NBFSCategory", NBFSCategory);
                }
                
                console.log('NBFSCategory',NBFSCategory);
                if(NBFSCategory !== undefined){
                    console.log('Entered');
                    var iCategory = component.find("iCategory");
                    iCategory.set('v.disabled',true);
                    var c = component.get('c.checkButtonDisplay');
                    $A.enqueueAction(c);
                }
            }else{
               
                	// show error notification
                    var toastEvent = helper.getToast("Error", "There was an error searching for the relevant Service Group", "error");
                	toastEvent.fire();
               
                	helper.hideSpinner(component);
                 }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    // Method to check buttons to be enabled for NBFS Case Record Type:
    	checkButtonDisplay : function(component, event, helper) {
            
        		var claimAmount = component.get("v.claimAmount");
            	console.log('buttonclaimAmount',claimAmount);
            	var showFpocBtn = component.get("v.showFpocBtn");
            	var showIwillResolveBtn = component.get("v.showIwillResolveBtn");
            	var showRoutingBtn = component.get("v.showRoutingBtn");
        		var NBFSServiceGroup = component.get("v.NBFSServiceGroup");

                //added for short term insurance
                if(NBFSServiceGroup !== 'Absa Short Term Insurance'){
                    var MonResRequired = component.find("iMonResReq").get("v.value");
                    console.log('MonResRequired',MonResRequired);
                }
            if(NBFSServiceGroup.includes('Complaints')){
                    NBFSServiceGroup =	NBFSServiceGroup.substring(0, NBFSServiceGroup.indexOf('Complaints'));
            		NBFSServiceGroup = NBFSServiceGroup.trim();
                }
            	console.log('NBFSServiceGroup',NBFSServiceGroup);
            	var NBFSSource = component.get("v.region");
            	if(component.get("v.NBFSCategory") === undefined)
        			var NBFSCategory = component.find("iCategory").get("v.value");
            	else
                    var NBFSCategory = component.get("v.NBFSCategory");
            	var btnFPOC = component.find("ibtnFPOC");
                var btnRoute = component.find("ibtnServiceGroupRouting");
                var btnResolve = component.find("ibtnIwillResolve");
            	var btnCancel = component.find("ibtnCancel");
 				var FpocBtn = true;
            	var IwillResolveBtn;
            	var RoutingBtn;
            
        		//if(NBFSServiceGroup === 'Wealth Advisory' || NBFSServiceGroup === 'Stockbroking' || NBFSServiceGroup === 'Portfolio Management')
            	if(NBFSServiceGroup === 'Wealth Advisory')
            {
                    if(NBFSCategory === 'Level 1' && claimAmount < 5001){
                        
                        IwillResolveBtn = false;
                        RoutingBtn = true;
                    }
                	else if((NBFSCategory === 'Level 1' && claimAmount > 5000) || NBFSCategory === 'Level 2' || NBFSCategory === 'Level 3'){
                        
                        IwillResolveBtn = true;
                        RoutingBtn = false;
                    }
            	}
            	else if(NBFSServiceGroup === 'Absa Estates Wills & Trusts' || NBFSServiceGroup === 'Absa Linked Investments' || NBFSServiceGroup === 'Absa Fund Managers' || NBFSServiceGroup === 'Absa Short Term Insurance'){
                    if(NBFSCategory === 'Level 1'){
                        	//FpocBtn = false;/ Removed as part of NBFS Phase2
                        	IwillResolveBtn = false;
                        	RoutingBtn = true;
                    	}
                		else if(NBFSCategory === 'Level 2' || NBFSCategory === 'Level 3'){
                            //FpocBtn = true;/ Removed as part of NBFS Phase2
                        	IwillResolveBtn = true;
                        	RoutingBtn = false;
                	}
            	}
            else if(NBFSServiceGroup === 'Absa Advisers' || NBFSServiceGroup === 'Stockbroking' || NBFSServiceGroup === 'Portfolio Management'){
                     if(NBFSCategory === 'Level 1' && MonResRequired === 'No'){
                        IwillResolveBtn = false;
                        RoutingBtn = true;
                    }
                	else if((NBFSCategory === 'Level 1' && MonResRequired === 'Yes') || NBFSCategory === 'Level 2' || NBFSCategory === 'Level 3'){
                        IwillResolveBtn = true;
                        RoutingBtn = false;
                    }
            	}
                else{
                    	//FpocBtn = false;/ Removed as part of NBFS Phase2
                        IwillResolveBtn = false;
                        RoutingBtn = false;
                    }
            	if(btnFPOC !== undefined)
                    btnFPOC.set('v.disabled',FpocBtn);
            	if(btnResolve !== undefined)
                    btnResolve.set('v.disabled',IwillResolveBtn);
            	if(btnRoute !== undefined)
                    btnRoute.set('v.disabled',RoutingBtn);
            	btnCancel.set('v.disabled',false);
            if(NBFSCategory === 'Level 3' && NBFSSource !== null){
                var sources = NBFSSource.split(';');
                	if (NBFSServiceGroup === 'Absa Estates Wills & Trusts' || NBFSServiceGroup === 'Stockbroking'){
                        sources.splice( sources.indexOf('FAIS'), 1 );
                        sources.splice( sources.indexOf('FSCA'), 1 );
                	}
        			if (NBFSServiceGroup === 'Absa Estates Wills & Trusts' || NBFSServiceGroup === 'Stockbroking' || NBFSServiceGroup === 'Wealth Advisory' || NBFSServiceGroup === 'Portfolio Management' || NBFSServiceGroup === 'Absa Fund Managers')
        				sources.splice( sources.indexOf('LTIO'), 1 );
                    if (NBFSServiceGroup === 'Absa Advisers' || NBFSServiceGroup === 'Stockbroking' || NBFSServiceGroup === 'Wealth Advisory' || NBFSServiceGroup === 'Portfolio Management' || NBFSServiceGroup === 'Absa Fund Managers' || NBFSServiceGroup === 'Absa Linked Investments')
        				sources.splice( sources.indexOf('Master of the Court'), 1 );
                    if (NBFSServiceGroup === 'Absa Advisers' || NBFSServiceGroup === 'Absa Estates Wills & Trusts' || NBFSServiceGroup === 'Wealth Advisory' || NBFSServiceGroup === 'Portfolio Management' || NBFSServiceGroup === 'Absa Fund Managers' || NBFSServiceGroup === 'Absa Linked Investments')
        				sources.splice( sources.indexOf('JSE'), 1 );
                // Added for Phase 2 NBFS changes
                	if (NBFSServiceGroup === 'Absa Advisers' || NBFSServiceGroup === 'Absa Estates Wills & Trusts' || NBFSServiceGroup === 'Wealth Advisory' || NBFSServiceGroup === 'Portfolio Management' || NBFSServiceGroup === 'Absa Fund Managers' || NBFSServiceGroup === 'Stockbroking')
        				sources.splice( sources.indexOf('PFA'), 1 );
            }
            	component.set("v.regionList", sources);
            	component.set("v.NBFSCategory", NBFSCategory);
            },
   
   //Get prepaid complaint Service Group By Vinod  And Amit
   assignPrepaidServiceGroup : function(component, event, helper) {
        var label = component.find("iDepositType");
        var atmServiceType = component.find("iType").get("v.value");
        console.log('atm service type: '+atmServiceType);
       //By Amit
       if(atmServiceType=='Deposit'){
         component.set("v.iscontextDeposit",true);
        $A.util.addClass(label, "customRequired");
        }
       if(atmServiceType!='Deposit'){
        component.set("v.iscontextDeposit",false);
       $A.util.removeClass(label,"customRequired");

       }
		if(atmServiceType == 'Prepaid') {
            var prepaidComplaintServiceId = $A.get("$Label.c.prepaidServiceGroupId");
            console.log('prepaidComplaintServiceId: '+prepaidComplaintServiceId);
        	component.set('v.prepaidComplaintServiceGroup', prepaidComplaintServiceId);
            var serviceGroupId = component.find("serviceGroupLookupSearchATM");
            serviceGroupId.set("v.value", component.get("v.prepaidComplaintServiceGroup"));
        } else {
            var serviceGroupId = component.find("serviceGroupLookupSearchATM");
            serviceGroupId.set("v.value","");
        }
    },
    /**check refund option to get Site detail By Vinod
   checkRefundOption : function(component, event, helper) {
        var atmRefundOption = component.find("iRefundOption").get("v.value");
       component.set('v.atmRefundOptionValue', atmRefundOption);
   },**/
    //Get the Site record based on Service Group Id
    getSite : function(component, event, helper) {
        
        helper.showSpinner(component);
        var atmServiceType = component.find("iType").get("v.value");
        var action = component.get("c.findSiteRecord");
        var siteId = component.find("siteLookupSearch").get("v.value");
        
        action.setParams({
            "siteId" : siteId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                component.set("v.siteRecord", response.getReturnValue());
                
                var serviceGroupId = component.find("serviceGroupLookupSearchATM");
                var siteSearchType = component.find("siteLookupSearch");
                var siteId = component.find("siteLookupSearch");
                var prepaidQueue = component.find("siteLookupSearch");
                var depositeQueue = component.find("siteLookupSearch");
                
               //Changed by Vinod
               
                if(atmServiceType != 'Prepaid') {
                	serviceGroupId.set("v.value", component.get("v.siteRecord.Service_Group__c"));
                }
                
              //  serviceGroupId.set("v.value", component.get("v.siteRecord.Service_Group__c")); 
                siteSearchType.set("v.value", component.get("v.siteRecord.Name"));
                siteId.set("v.value", component.get("v.siteRecord.Id"));
                
                //Get Case Type
                var caseRecordType = component.get("v.caseTypeSelected");
                var actionServiceGroup = component.get("c.findServiceGroupRecord");
                var serviceGroupId = component.find("serviceGroupLookupSearchATM").get("v.value");
                
                actionServiceGroup.setParams({
                    "serviceGroupId" :serviceGroupId
                });
                
                // Add callback behavior for when response is received
                actionServiceGroup.setCallback(this, function(response) {
                    
                    var state = response.getState();
                    
                    if (component.isValid() && state === "SUCCESS") {
                        
                        component.set("v.serviceGroupRecord", response.getReturnValue());
                        
                        var queueName;
                        var serviceGroupName;
                        var serviceGroupId;
                        
                        queueName = component.find("serviceGroupLookupSearchATM");
                        serviceGroupName = component.find("serviceGroupLookupSearchATM");
                        serviceGroupId = component.find("serviceGroupLookupSearchATM");
                        
                        queueName.set("v.value", component.get("v.serviceGroupRecord.Queue__c")); 
                        serviceGroupName.set("v.value", component.get("v.serviceGroupRecord.Name"));
                        serviceGroupId.set("v.value", component.get("v.serviceGroupRecord.Id"));
                        
                        helper.hideSpinner(component);
                        
                    }else{
                        
                        // show error notification
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "message": "There was an error searching for the relevant Service Group",
                            "type":"error"
                        });
                        
                        toastEvent.fire();
                        
                        helper.hideSpinner(component);
                    }
                });
                
                // Send action off to be executed
                $A.enqueueAction(actionServiceGroup);               
                
                helper.hideSpinner(component);
                
            }else{
                
                // show error notification
                var toastEvent = helper.getToast("Error", "There was an error searching for the relevant Site", "error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    }, 
    
    showEmailReminder:function(component, event, helper) {
        console.log("Inside Oncommit function ==>");
        var staffMember = component.get("v.staffMemberValue");
        if(component.get("v.showStaffTheReminder") && staffMember){
            helper.showStaffReminderAction(component, event);
        }
    },
    
    //Method to call function to create new Case
    createNewCase : function(component, event, helper) {
        
        console.log('Communacation method==> '+component.get("v.communicationMethod"));
        var comMethod =  component.get("v.communicationMethod");
        
        //Show spinner
        helper.showSpinner(component);
        
        console.log('in router---');
        //Get Case Type
        var caseRecordType = component.get("v.caseTypeSelected");
        console.log('***selected caseRecordType'+caseRecordType);
        //Case variables
        var subject = component.find("iSubject").get("v.value");
        var description = component.find("iDescription").get("v.value");
        var caseOrigin = component.find("iOrigin").get("v.value");
        var serviceGroupRecord = component.get("v.serviceGroupRecord");
        var accId =  component.get("v.accountId");
        var accRecord =  component.get("v.accountRecord");
        var contactRecordId =  component.get("v.contactRecord").Id;
        var selectedProductAccNo = component.get("v.accountNumber");
        var selectedProductStatus= component.get("v.accountStatus");
        var selectedProductName = component.get("v.accountProduct");
        var isCreateAndEmail = component.get('v.isCreateAndEmail');
        
        //Suppress auto response as we sending direct email.
        if(isCreateAndEmail == true) {
            component.set("v.newCase.Skip_Auto_Response__c", isCreateAndEmail);
        }
        
        //Koketso - get all uploaded files
        var uploadedFileIds =  component.get("v.fileIds");
        
        var claimAmount = component.get("v.claimAmount");
        
         //commented out by Nekhubvi M  06/10/2020
        /*
        if(claimAmount != null && claimAmount.includes('.')) {
            console.log('Claim amount inside ---->' + claimAmount);
            claimAmount.replace('.' , ',');
        } */
        
        //Added out by Nekhubvi M  06/10/2020
  
        if(claimAmount){
        	var claimAmount = claimAmount.includes('.') ? claimAmount.replace('.' , ',') : claimAmount;
        }
        
        var amountRecieved;
        
        
        component.set("v.newCase.Subject", subject);
        component.set("v.newCase.Description", description);
        component.set("v.newCase.Origin", caseOrigin);
        component.set("v.newCase.AccountId", accId);
        component.set("v.newCase.ContactId", contactRecordId);
        
        //** RN - Validation section **
        //No Client selected
        if(!accRecord.Name && !accRecord.LastName){
            var toast = helper.getToast("Validation Warning", "Please search for an existing Client or create a new Client record", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //No Subject  
        if(!subject){
            var toast = helper.getToast("Validation Warning", "Please provide a Subject for this Case", "warning"); 
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        // Start -Validate Create case & send email box and Alternate email address - Simangaliso 
        var altEmailAdd      = component.get("v.alternateEmailAddress");
        var isCreateAndEmail =  component.get("v.isCreateAndEmail");
        
        if(!altEmailAdd  && isCreateAndEmail){
            var toast = helper.getToast("Validation Warning", "Please provide Alternate email address", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        // End -Validate Create case & send email box and Alternate email address - Simangaliso 
        
        //Comm Method validation for Complant
        if(!comMethod  && (caseRecordType == 'Complaint' || caseRecordType == 'Short_term_Complaint')){
            var toast = helper.getToast("Validation Warning", "Communication method required", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Service Group Validatio
        if (caseRecordType == 'ATM') {
            var serviceGroupATM = component.find("serviceGroupLookupSearchATM").get("v.value");
            var siteId = component.find("siteLookupSearch").get("v.value");
            
			//Chnage by AG 
           var compval= component.find("iDepositType").get("v.value");
            if(!compval){
                if(component.get('v.iscontextDeposit')){
                var toast = helper.getToast("Validation Warning", "Deposit Type required", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }}
          
            if(!claimAmount){
                var toast = helper.getToast("Validation Warning", "Claim amount required", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            if(!comMethod ){
                var toast = helper.getToast("Validation Warning", "Communication method required", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            var phoneNo = component.find("iPhone").get("v.value");
            var mobileNo = component.find("iMobile").get("v.value");
            var emailAddress = component.find("iEmail").get("v.value");
            var postalAddress = component.find("iPostalAddress").get("v.value");
            var idvLevel = component.find("iIdvLevelRequired").get("v.value");
            var idvComplete = component.find("iIdvCompleted").get("v.value");
            
            if((comMethod =='Email' && !emailAddress) || (comMethod =='Phone' && !phoneNo) || (comMethod =='Post' && !postalAddress) || (comMethod =='SMS' && !mobileNo)){
                var toast = helper.getToast("Validation Warning", "Kindly specify the Communication Method", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            if(!siteId){
                var toast = helper.getToast("Validation Warning", "Please search and select a Site for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!serviceGroupATM){
                var toast = helper.getToast("Validation Warning", "Please search and select a Service Group for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            
        } else {
            if(!serviceGroupRecord.Id){
                var toast = helper.getToast("Validation Warning", "Please search and select a Service Group for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        
        
        //Complaints, ATM and Non-Confidential Fraud specific fields
        if(caseRecordType == 'Non_Confidential_Fraud' || caseRecordType == 'Complaint' || caseRecordType =='Life_Complaint' || caseRecordType == 'ATM'|| caseRecordType == 'Short_term_Complaint' && (caseRecordType != 'Service_Request' && caseRecordType != 'Compliment')) {
            var customerExpectation = component.find("iCustomerExpectation").get("v.value");
            claimAmount = claimAmount != null ? claimAmount : 0;
            var incidentDate = component.find("iIncidentDate").get("v.value");
            var fastTrack = component.find("iFastTrack").get("v.value");
            var communicationMethod = component.find("iCommunicationMethod").get("v.value");
            var phoneNo = component.find("iPhone").get("v.value");
            var mobileNo = component.find("iMobile").get("v.value");
            var emailAddress = component.find("iEmail").get("v.value");
            var postalAddress = component.find("iPostalAddress").get("v.value");
            var idvLevel = component.find("iIdvLevelRequired").get("v.value");
            var idvComplete = component.find("iIdvCompleted").get("v.value");
            var incidentTime ;
            var amountWithDrawn ;
            var absaATM ;
            var atmNumber ;
            var nonAbsaAtm ;
            var sequenceNumber ;
            
            console.log('Claim Ammount **************** ' + claimAmount);
            console.log('type---',type);
            console.log('accountNumber---',accountNumber);
            
            console.log('in js controller routng new case');
            if(caseRecordType == 'ATM' ){
                //var refundOption= component.get("v.atmRefundOptionValue");
            	//var site= component.find("iRefundSite").get("v.value");
                incidentTime = component.find("iIncidentTime").get("v.value");
                if(component.get('v.iscontextDeposit').value==false){
                amountWithDrawn = component.find("iAmountWithdrawn").get("v.value").includes('.') ? component.find("iAmountWithdrawn").get("v.value").replace('.' , ',') : component.find("iAmountWithdrawn").get("v.value");
                    amountRecieved = component.find("iAmountRecieved").get("v.value") != null && component.find("iAmountRecieved").get("v.value").includes('.') ? component.find("iAmountRecieved").get("v.value").replace('.' , ',') : component.find("iAmountRecieved").get("v.value");
                 }
                else{
                 amountWithDrawn='0';
                 amountRecieved='0';
                 }

                
                absaATM =component.find("iAbsaAtm").get("v.value");
                //amountRecieved = component.find("iAmountRecieved").get("v.value") != null ? component.find("iAmountRecieved").get("v.value") : 0;
                
                /*
                if(amountRecieved != null && amountRecieved.includes('.') ) {
                    amountRecieved.replace('.' , ',');
                    alert('amountRecieved Inside' + amountRecieved);
                }*/
                
                nonAbsaAtm =component.find("iNonAbsaAtmText").get("v.value");
                sequenceNumber =component.find("iSequenceNumber").get("v.value");
                
                
                if(!incidentDate ){
                    var toast = helper.getToast("Validation Warning", "Please fill Incident Date required for case ", "warning");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null; 
                }
                
                //added as new req in prod 7/nov/2019
                if(!incidentTime ){
                    var toast = helper.getToast("Validation Warning", "Please fill Incident Time required for case ", "warning");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null; 
                }
                /*if(!amountWithDrawn){
                    var toast = helper.getToast("Validation Warning", "rawn required for case ", "warning");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null; 
                } */
                
                
                if(!amountWithDrawn){
                    if(!component.get('v.iscontextDeposit')){
                    var toast = helper.getToast("Validation Warning", "Amount Withdrawn required for case ", "warning");
                    helper.hideSpinner(component);
                    toast.fire();
                    }
                    return null; 
                }
                
                
                
                component.set("v.newCase.IncidentTime__c", incidentTime);
                component.set("v.newCase.Amount_Withdrawn__c", amountWithDrawn);
                component.set("v.newCase.AbsaATM__c", absaATM);
                component.set("v.newCase.ATMNumber__c", atmNumber);
                component.set("v.newCase.Amount_Received__c", amountRecieved);
                component.set("v.newCase.NonAbsaATMText__c", nonAbsaAtm);
                component.set("v.newCase.SequenceNumber__c", sequenceNumber);
                //component.set("v.newCase.Site__c", site); 
                //component.set("v.newCase.Refund_Option__c", refundOption);
            }
            component.set("v.newCase.Expectation_of_the_Customer__c", customerExpectation);
            component.set("v.newCase.Claim_Amount__c", claimAmount);
            component.set("v.newCase.Incident_Date__c", incidentDate);
            component.set("v.newCase.Fast_Track__c", fastTrack);
            component.set("v.newCase.Communication_Method__c", communicationMethod);
            component.set("v.newCase.Phone__c", phoneNo);
            component.set("v.newCase.Mobile__c", mobileNo);
            component.set("v.newCase.Email__c", emailAddress);
            component.set("v.newCase.Postal_Address__c", postalAddress);
            component.set("v.newCase.ID_V_Level_Required__c", idvLevel);
            component.set("v.newCase.ID_V_Completed__c", idvComplete);
    
        }
        
        //Complaint specific fields
        if(caseRecordType == 'Complaint') {
            var responsibleSite = component.find("iResponsibleSiteComplaint").get("v.value");
            
            component.set("v.newCase.Responsible_Site__c", responsibleSite);
            // Poulami Added for NBFS Service Group
            var NBFSFlag = component.get('v.isNBFSServiceGroup');
            if(NBFSFlag == true){
                var servicegroupname = component.get('v.NBFSServiceGroup');
                var caseCategory = component.find("iCategory").get("v.value");
                console.log('caseCategory',caseCategory);
                var claimAmount = component.get('v.claimAmount');
            var monetaryRequired = component.get('v.MonResRequired');
                if(caseCategory === 'Level 3')
                    var caseSource = component.find("levelsource").get("v.value");
                else
                    var caseSource = component.find("iSource").get("v.value");
                console.log('caseSource',caseSource);
                var AlternativeContact = component.find("iAlternativeContact").get("v.value");
                var Capacity = component.find("iCapacity").get("v.value");
                
                component.set("v.newCase.NBFS_Category__c", caseCategory);
                component.set("v.newCase.Source__c", caseSource);
                component.set("v.newCase.Monetary_Resolution_Required__c", monetaryRequired);

                component.set("v.newCase.Alternative_Contact__c", AlternativeContact);
                component.set("v.newCase.Capacity__c", Capacity);
                
                if(!caseCategory){
                    var toast = helper.getToast("Validation Warning", "Please select a Category for your Case", "warning");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null;
                }
                if(!caseSource || caseSource === '--None--'){
                    var toast = helper.getToast("Validation Warning", "Please select a Source for your Case", "warning");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null;
                }
                 if(!monetaryRequired || monetaryRequired === '--None--'){
                var toast = helper.getToast("Validation Warning", "Please enter the Monetary Resolution Required for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
                if(!AlternativeContact){
                    var toast = helper.getToast("Validation Warning", "Please enter the Alternative Contact for your Case", "warning");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null;
                }
                if(!Capacity){
                    var toast = helper.getToast("Validation Warning", "Please enter the Capacity for the contact for your Case", "warning");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null;
                }
            }
        }
        
        //Short term insurance changes
        if(caseRecordType == 'Short_term_Complaint'){
            var altFirstName = component.find("sfirstName").get("v.value");
            var altLastName = component.find("slastName").get("v.value");
            var altPhone = component.find("salternativePhone").get("v.value");
            var altEmail = component.find("salternativeEmail").get("v.value");
            var relatedBusArea = component.find("relatedBusinessArea").get("v.value");
            var relatedProdArea = component.find("relatedProductArea").get("v.value");
            var compCausedBy = component.find("complaintCausedBy").get("v.value");
            var compClaimNumber = component.find("claimNumber").get("v.value");
            var compPolicyNumber = component.find("policyNumber").get("v.value");
            
            var caseCategory = component.find("iCategory").get("v.value");
            var caseSource = component.find("iSource").get("v.value");
            var Capacity = component.find("iCapacity").get("v.value");
            
            component.set("v.newCase.First_Name__c", altFirstName);
            component.set("v.newCase.Last_Name__c", altLastName);
            component.set("v.newCase.Alternative_Phone__c", altPhone);
            component.set("v.newCase.Alternative_Email__c", altEmail);
            component.set("v.newCase.Related_Business_Area__c", relatedBusArea);
            component.set("v.newCase.Related_Product_Area__c", relatedProdArea);
            component.set("v.newCase.NBFS_Category__c", caseCategory);
            component.set("v.newCase.Capacity__c", Capacity);
            component.set("v.newCase.Source__c", caseSource);
            component.set("v.newCase.Complaint_Caused_By__c", compCausedBy);
            component.set("v.newCase.Claim_Number__c", compClaimNumber);
            component.set("v.newCase.Policy_Number__c", compPolicyNumber);
            
            //Start of validation for short term complaint fields
            if(!relatedBusArea){
                var toast = helper.getToast("Validation Warning", "Please select Related Business Area for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!relatedProdArea){
                var toast = helper.getToast("Validation Warning", "Please select Related Product Area for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!compCausedBy){
                var toast = helper.getToast("Validation Warning", "Please select Complaint Caused By for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null; 
            }
            
            if(!compClaimNumber && !compPolicyNumber){
                var toast = helper.getToast("Validation Warning", "Please provide either Claim Number or Policy Number for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!caseCategory){
                var toast = helper.getToast("Validation Warning", "Please select a Category for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!caseSource){
                var toast = helper.getToast("Validation Warning", "Please select a Source for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!altFirstName){
                var toast = helper.getToast("Validation Warning", "Please enter the Contact First Name for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!altLastName){
                var toast = helper.getToast("Validation Warning", "Please enter the Contact Last Name for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!altPhone && !altEmail){
                var toast = helper.getToast("Validation Warning", "Please enter the Contact Phone number or Email address for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            if(!Capacity){
                var toast = helper.getToast("Validation Warning", "Please enter the Capacity for the contact for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
        }
        
        //Non-Confidential Fraud specific fields
        if(caseRecordType == 'Non_Confidential_Fraud') {
            
            var originatedBy = component.find("iOriginatedBy").get("v.value");
            var policeCaseNo = component.find("iPoliceCaseNumber").get("v.value");
            var from1481 = component.find("iForm1481").get("v.value");
            var form1094 = component.find("iForm1094").get("v.value");
            var entity = component.find("iEntity").get("v.value");
            var reportDate = component.find("iReportedDate").get("v.value");
            var lossAmount = component.find("iLossAmount").get("v.value");
            var responsibleSite = component.find("iResponsibleSiteFraud").get("v.value");
            
            component.set("v.newCase.Originated_By__c", originatedBy);
            component.set("v.newCase.Police_Case_Number__c", policeCaseNo);
            component.set("v.newCase.Declaration_Form_1481_Attached__c", from1481);
            component.set("v.newCase.Fraud_Declaration_Form_1094_Attached__c", form1094);
            component.set("v.newCase.Entity__c", entity);
            component.set("v.newCase.Reported_Date__c", reportDate);
            component.set("v.newCase.Loss_Amount__c", lossAmount);
            component.set("v.newCase.Responsible_Site__c", responsibleSite);
            
        } 
        
        //ATM specific fields
        var siteRecord;
        
        if(caseRecordType == 'ATM') {
            
            var internationalCard = component.find("iInternationalATMUsed").get("v.value");
            var depositType = component.find("iDepositType").get("v.value");
            //var isPrepaid = component.find("iPrepaid").get("v.value"); by Vinod.
            var receiptSlipAvailable = component.find("iReceiptSlipAvailable").get("v.value");
            var countryValue = component.find("iCountry").get("v.value");
            
            var accountNumber =  component.find("iAccountNumber").get("v.value");
            var type = component.find("iType").get("v.value");
            //serviceTypeRecord = component.get("v.serviceTypeRecord");
            var siteId = component.find("siteLookupSearch").get("v.value");
            siteRecord = component.get("v.siteRecord");
            console.log('receiptSlipAvailable----',receiptSlipAvailable);
            
            component.set("v.newCase.International_ATM_Used__c", internationalCard);
            component.set("v.newCase.Deposit_Type__c", depositType);
            //component.set("v.newCase.Prepaid__c", isPrepaid); by Vinod.
            component.set("v.newCase.Receipt_Slip_Available__c", receiptSlipAvailable);
            component.set("v.newCase.Country__c", countryValue);
            component.set("v.newCase.Responsible_Site__c", siteId);
            component.set("v.newCase.Account_Number__c", accountNumber);
            component.set("v.newCase.ATM_Service_Type__c", type);
            var AtmServiceType =component.find("iType").get("v.value");
            if(!AtmServiceType){
                var toast = helper.getToast("Validation Warning", "Please select a ATM Service Type for your Case", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
                
            }            
            
            
        }
        
        //Service Request specific fields
        if(caseRecordType == 'Service_Request') {
            var responsibleSite = component.find("iResponsibleSiteServiceReq").get("v.value");           
            component.set("v.newCase.Responsible_Site__c", responsibleSite);
            component.set("v.newCase.Type__c", component.get("v.serviceTypeObj.Type__c"));
            component.set("v.newCase.Subtype__c", component.get("v.serviceTypeObj.Subtype__c"));
            component.set("v.newCase.Product__c", component.get("v.serviceTypeObj.Product__c"));
        }
        
        //Compliment specific fields - Smanga
        if(caseRecordType == 'Compliment'){
            component.set("v.newCase.Staff_Member_Compliment_Applies_To__c", component.find("staffMemberSF").get("v.value"));
            component.set("v.newCase.Staff_Member_Non_Salesforce_User__c", component.find("staffMember").get("v.value"));
        }
        
        //Routing?
        var routingCase = component.get("v.isRouting");
        if(routingCase == true) {
            component.set("v.newCase.Case_Ownership__c", "Route");
        }     
        
        //I will Resolve?
        var iWillResolveCase = component.get("v.isIwillResolve");
        if(iWillResolveCase == true) {
            component.set("v.newCase.Status", "In Progress");
            component.set("v.newCase.Case_Ownership__c", "I will Resolve");
        }            
        
        //FPOC ?
        var fpocCase = component.get("v.isFPOC");
        if(fpocCase == true) {
            component.set("v.newCase.Case_Ownership__c", "FPOC");
        }  
        
        //koketso - Close case on creation 
        var isCloseCase = component.get("v.isCloseCase");
        if(isCloseCase == true) {
            component.set("v.newCase.Status", "Resolved");
            component.set("v.newCase.Case_Ownership__c", "Close");
        } 
        
        console.log('createCase');
        var action = component.get("c.createCase");
        
        var newCaseRecord = component.get("v.newCase");
        //Disable button after click - Simangaliso Mathenjwa
        helper.disableButton(component, event, true);
        action.setParams({
            "caseRecord" : newCaseRecord,
            "serviceGroupRecord" : serviceGroupRecord,
            "clientRecord" : accRecord,
            "caseRecordType" : caseRecordType,
            "isRoutingRequired" : routingCase,
            "productAccNo" : selectedProductAccNo,
            "productStatus" : selectedProductStatus,
            "productName" : selectedProductName
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var message = '';
            
            if (component.isValid() && state === "SUCCESS") {
                
                var caseRecId = response.getReturnValue();
                var contentDocId =  component.get("v.contentDocumentId");
                
                if(contentDocId) {
                    var action = component.get("c.updateContentDocument");
                    action.setParams({caseId : caseRecId, contentDocumentId : component.get("v.contentDocumentId")});        
                    // Add callback behavior for when response is received
                    action.setCallback(this, function(response) {
                        var state = response.getState();            
                        if (state === "SUCCESS") {
                            console.log(response.getReturnValue());
                        }            
                    });
                    $A.enqueueAction(action);
                }
                
                //Properly chain async actions.
                helper.doUpdateContentDocuments(component, caseRecId, uploadedFileIds);
                
            }else if(state === "ERROR"){
                
                //Disable button after click - Simangaliso Mathenjwa
                //Added condition for NBFS Service Group -- Poulami
                if(component.get('v.isNBFSServiceGroup') === true){
                    var c = component.get('c.checkButtonDisplay');
                    $A.enqueueAction(c);
                }
                 else
                	helper.disableButton(component, event, false);
                
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                var toast = helper.getToast("Error", message, "error");
                
                toast.fire();
                
                helper.hideSpinner(component);
            } else {
                
                //Disable button after click - Simangaliso Mathenjwa
                //Added condition for NBFS Service Group - Poulami
                if(component.get('v.isNBFSServiceGroup') === true){
                    var c = component.get('c.checkButtonDisplay');
                    $A.enqueueAction(c);
                }
                 else
                	helper.disableButton(component, event, false);
                var errors = response.getError();
                
                var toast = helper.getToast("Error", message, "error");
                
                toast.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action); 
        
    },
    
    //Cancel button 
    cancelAndCloseTab : function(component, event, helper) {
        //Close focus tab and navigate home
        helper.closeFocusedTab(component);
        helper.navHome(component, event, helper);
    },
    
    //Save FPOC nad navigate to closure screen
    saveAsFPOC : function(component, event, helper) {
        //Smanga Start - 7 October 2020
       console.log("<== inside saveAsFPOC ==> ");
       var selectedCaseType     = component.get("v.caseTypeSelected");
       var clientFinderProdList = component.get("v.productList");
       var accountId            = component.get("v.accountRecord").Id;
       var accProduct           = component.get("v.accountProduct");
     
       console.log("clientFinderProdList ==> "+ clientFinderProdList);
       console.log("accProduct ==> "+ accProduct);
       console.log("accountId ==> "+ accountId);
       console.log("selectedCaseType ==> "+ selectedCaseType);
       // Added by Poulami to remove the Product Validation for NBFS Service Group	
       var NBFSFlag = component.get('v.isNBFSServiceGroup');  	
       if(clientFinderProdList !== null && accountId !== undefined && (selectedCaseType ==='ATM' || selectedCaseType ==='Complaint' || selectedCaseType === 'Short_term_Complaint') && accProduct === "" && NBFSFlag === false){
        console.log("<===inside if statement* ===>");
           helper.showReminderAction(component, event);
           return null;
          }
       //Smanga End- 7 October 2020
        
        component.set("v.isFPOC", true);
        //Enqueue action to create case
        var a = component.get('c.createNewCase');
        $A.enqueueAction(a);
        helper.hideSpinner(component);
    },
    
    //I will Resove and navigate to new case created
    saveAndNavigateToCase : function(component, event, helper) {
       
        //Smanga End- 22 Sept 2020
       console.log("<== inside saveAndNavigateToCase ==> ");
       var selectedCaseType     = component.get("v.caseTypeSelected");
       var clientFinderProdList = component.get("v.productList");
       var accountId            = component.get("v.accountRecord").Id;
       var accProduct           = component.get("v.accountProduct");
     
       console.log("clientFinderProdList ==> "+ clientFinderProdList);
       console.log("accProduct ==> "+ accProduct);
       console.log("accountId ==> "+ accountId);
       console.log("selectedCaseType ==> "+ selectedCaseType);
       // Added by Poulami to remove the Product Validation for NBFS Service Group
      var NBFSFlag = component.get('v.isNBFSServiceGroup');  	
       if(clientFinderProdList !== null && accountId !== undefined && (selectedCaseType ==='ATM' || selectedCaseType ==='Complaint' || selectedCaseType === 'Short_term_Complaint') && accProduct === "" && NBFSFlag === false){
           console.log("<===inside if statement* ===>");
           helper.showReminderAction(component, event);
           return null;
          }
       //Smanga End- 22 Sept 2020
        
  		//Show spinner
        helper.showSpinner(component);
        component.set("v.isIwillResolve", true);
        
        //Enqueue action to create case
        var a = component.get('c.createNewCase');
        $A.enqueueAction(a);
    },
    
    //Route case based on Service Group selected
    serviceGroupRouting : function(component, event, helper) {
        
        //Smanga End- 22 Sept 2020
        console.log("<== inside serviceGroupRouting ==> ");
        var selectedCaseType     = component.get("v.caseTypeSelected");
        var clientFinderProdList = component.get("v.productList");
        var accountId            = component.get("v.accountRecord").Id;
        var accProduct           = component.get("v.accountProduct");

        console.log("clientFinderProdList ==> "+ clientFinderProdList);
        console.log("accProduct ==> "+ accProduct);
        console.log("accountRecord ==> "+ accountId);
        console.log("selectedCaseType ==> "+ selectedCaseType);
         var NBFSFlag = component.get('v.isNBFSServiceGroup');
        if(clientFinderProdList !== null && accountId !== undefined && (selectedCaseType ==='ATM' || selectedCaseType ==='Complaint' || selectedCaseType === 'Short_term_Complaint') && accProduct === "" && NBFSFlag === false){
            helper.showReminderAction(component, event);
            return null;
        }
        //Smanga End- 22 Sept 2020

        //Show spinner
        helper.showSpinner(component);
        
        component.set("v.isRouting", true);
        //Enqueue action to create case
        var a = component.get('c.createNewCase');
        $A.enqueueAction(a);
    },
    
    onCaseClassify : function(component, event, helper) {
        var isClassifyChecked = component.find('classify');
        /* commented out by Simangaliso Mathenjwa 25 june 2020
        var serviceGroupId = component.find("serviceGroupLookupSearchServiceReq").get("v.value");
        */
        
        // begin Added by Simangaliso Mathenjwa 25 june 2020
        var serviceGroupRec2 = component.get("v.serviceGroupRecord");
        var serviceGroupId = serviceGroupRec2.Id;
        // Start Added by Simangaliso Mathenjwa 25 june 2020
        
        if(isClassifyChecked.get('v.value') == true && (serviceGroupId == null || serviceGroupId == '')){
            isClassifyChecked.set('v.value', false);
            var toast = helper.getToast("Validation Warning", "Please search for a Service Group before you can classify", "warning");
            toast.fire();
        }else{
            var action = component.get("c.findProductsByServiceGroup");
            action.setParams({
                serviceGroupId : serviceGroupId
            });        
            action.setCallback(this, function(response) {
                var state = response.getState();            
                if (state === "SUCCESS") {
                    var productOptions = response.getReturnValue();
                    console.log("productOptions:", productOptions);
                    
                    if(productOptions.length > 0){
                        component.set("v.productOptions", productOptions);
                    }
                }            
            });
            $A.enqueueAction(action);
        }
        component.set("v.isClassify", isClassifyChecked.get('v.value')); 
    },
    
    //Koketso - get all Service Types linked to a selected product by Product ID
    getServiceTypesByProduct : function(component, event, helper) {
        /* Commented Out by Simangaliso Mathenjwa 25 June 2020
        var serviceGroupId = component.find("serviceGroupLookupSearchServiceReq").get("v.value");
        */
        
        // begin Added by Simangaliso Mathenjwa 25 june 2020
        var serviceGroupRec2 = component.get("v.serviceGroupRecord");
        var serviceGroupId = serviceGroupRec2.Id;
        // Start Added by Simangaliso Mathenjwa 25 june 2020
        
        var productId = component.get("v.productId");
        
        component.set("v.serviceTypeOptions", []);
        component.set("v.serviceTypeId", null);
        
        var action = component.get("c.findServiceTypesByProductAndServiceGroup");
        
        action.setParams({
            "productId": productId,
            "serviceGroupId": serviceGroupId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var serviceTypeOptions = response.getReturnValue();
                console.log("serviceTypeOptions:", serviceTypeOptions);
                
                if(serviceTypeOptions.length > 0){
                    component.set("v.serviceTypeOptions", serviceTypeOptions);
                }
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    reloadServiceTypes : function(component, event, helper) {
        helper.showSpinner(component);
        
        var action = component.get("c.findServiceTypeRecord");
        
        var serviceId = component.get("v.serviceTypeId");
        
        action.setParams({
            "recId": serviceId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                component.set("v.serviceTypeObj", response.getReturnValue());
                
                helper.hideSpinner(component);
                
            }else if(state === "ERROR"){
                
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
                
                // refresh record detail
                //$A.get("e.force:refreshView").fire();
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Koketso - close case if already classified on creation
    closeCase : function(component, event, helper) {

        var productId = component.get("v.productId");
        var serviceTypeId = component.get("v.serviceTypeId");

        console.log(':::::productId:::::', productId);
		console.log(':::::serviceTypeId:::::', serviceTypeId);
        
        if(productId == null || serviceTypeId == null){
            var toast = helper.getToast("Validation Warning", "Please classify by entering product and service type before closing a case", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        component.set("v.isCloseCase", true);
        
        var action = component.get('c.createNewCase');
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    checkIfNotNumber : function(component, event, helper) {
        
        var claimAmount = component.get("v.claimAmount");
        claimAmount = claimAmount.includes(',') ? claimAmount.replace(',' , '.') : claimAmount;
        console.log('Claim Ammount ' + claimAmount);
        if(isNaN(claimAmount)){
            component.set("v.claimAmount","");
        }
        if(component.get('v.isNBFSServiceGroup') === true){
                var check = component.get('c.checkButtonDisplay');
                $A.enqueueAction(check);
            }
    },
    checkIfNotNumberAmountReceived : function(component, event, helper) {
        
        var amountReceived = component.get("v.amountReceived");
        amountReceived = amountReceived.includes(',') ? amountReceived.replace(',' , '.') : amountReceived;
        console.log('Claim Ammount ' + amountReceived);
        if(isNaN(amountReceived)){
            component.set("v.amountReceived","");
        }
    },
    checkIfNotNumberAmountWithdrawn : function(component, event, helper) {
        
        var amountWithdrawn = component.get("v.amountWithdrawn");
        amountWithdrawn = amountWithdrawn.includes(',') ? amountWithdrawn.replace(',' , '.') : amountWithdrawn;
        console.log('Claim Ammount ' + amountWithdrawn);
        if(isNaN(amountWithdrawn)){
            component.set("v.amountWithdrawn","");
        }
    }
        
})