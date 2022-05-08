({
    myAction : function(component, event, helper) {
        
    },
    doInit : function(component, event, helper) {
        console.log('recordtype',component.get("v.recordType"));
        component.set("v.newCase",{});
        component.set("v.newCase.Origin",'');
        component.set('v.policyColumnHeaders', [
            {label: 'Policy Number', fieldName: 'policyNumber', type: 'text'},
            {label: 'Policy Status', fieldName: 'policyStatus', type: 'text'},
            {label: 'Product Description', fieldName: 'productDesc', type: 'text'},
            //{label: 'Cover Amount', fieldName: 'coverAmt', type: 'text'},
            //{label: 'Outstanding Amount', fieldName: 'outstandingAmt', type: 'text'},
            // {label: 'Premium', fieldName: 'premium', type: 'text'},
            {label: 'Inception Date', fieldName: 'inceptionDate', type: 'text'},
        ]);
            helper.getServiceGroup(component);
            helper.getRecordType(component);
            //Get Complaints Permission Sets to set navigation buttons
            // helper.getUserPermissionSets(component);  
            if(component.get("v.recordId") != null){
            	component.set("v.parentId",component.get("v.recordId"));  
            	console.log(component.get("v.parentId"));           
            }else{     
            	component.set("v.parentId",$A.get("$SObjectType.CurrentUser.Id"));  
            }
            if(component.get("v.recordType") == 'AIP Case'){
            
            	if( component.get("v.newCase.Product_Provider__c") == null || component.get("v.newCase.Product_Provider__c") == '' ) 
            		component.set("v.newCase.Product_Provider__c",'AIP');
            	component.set("v.showAIPCaseQueryFields", true);
            	//
            }
            },
            
            updateSelectedPolicy: function (component, event) {
            //var selectedRows = event.getParam('selectedRows');
            var lines;
            lines = component.find('policyDataTable').getSelectedRows();
            if(lines.length > 0){
        		component.set('v.policyNumber', lines[0].policyNumber);
        		component.set('v.productProvider', lines[0].productDesc);
        		component.set('v.coverAmount', lines[0].coverAmt);
        		component.set('v.outstandingAmount', lines[0].outstandingAmt);
        		component.set('v.policyInceptionDate', lines[0].inceptionDate);
        		component.set('v.policyPremium', lines[0].premium);
        		component.set('v.policyStatus', lines[0].policyStatus);
        		component.set('v.isPolicySelected', false);
    		}
    
    		//component.set('v.policyNumber', lines[0].policyNumber);
	},
 
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
    
    	if(eventIsIndivClient == true) {
        	component.set("v.newCase.Phone__c", eventAccountValue.Phone);
        	component.set("v.newCase.Mobile__c", eventAccountValue.PersonMobilePhone);
        	component.set("v.newCase.Email__c", eventAccountValue.PersonEmail);
    	}
    console.log("setAttribute: " + component.get("v.accountRecord").ID_Number__pc);
    console.log("setAttribute.Id: " + component.get("v.accountRecord").Id);
    console.log("setAttribute.Name: " + component.get("v.accountRecord").Name);
    console.log("setAttribute.FirstName: " + component.get("v.accountRecord").FirstName);
    console.log("setAttribute.LastName: " + component.get("v.accountRecord").LastName);
    
    //Smanga Start - 21 Sept 2020
    /*  var selectedCaseType     = component.get("v.caseTypeSelected");
      var clientFinderProdList = component.get("v.productList");
      var showTheReminder      = component.get("v.showTheReminder");
      var accountId            = component.get("v.accountRecord").Id;
      console.log("showTheReminder ==> "+ showTheReminder);
      console.log("clientFinderProdList ==> "+ clientFinderProdList);
      console.log("accountId ==> "+ accountId);
      console.log("selectedCaseType ==> "+ selectedCaseType);
      
      if(clientFinderProdList !== null && accountId !== undefined && (selectedCaseType ==='ATM' || selectedCaseType ==='Complaint') && showTheReminder){
          helper.showReminderAction(component, event);

      }*/
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
            //I will Resove and navigate to new case created
  saveAndNavigateToCase :function(component, event, helper) {
       //Show spinner
       helper.showSpinner(component);
       component.set("v.isIwillResolve", true);
                
       //Enqueue action to create case
       helper.createNewCase(component,helper,event);
       /*var a = component.get('c.createNewCase');
        $A.enqueueAction(a);*/
    },
        
   openModel: function(component, event, helper) {
       // for Display Model,set the "isOpen" attribute to "true"
       component.set("v.isOpen", true);
   },
            
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
      component.set("v.showPolicies", false);
      component.set("v.isPolicySelected", true);
   },
       
   //Method to call function to create new Case
   onCatChange: function(component, event, helper) {
       if(component.get("v.newCase.Category__c") == 'Claims'){
          //component.set("v.showCaseFields", true);
          //}else{
          component.set("v.showCaseFields", false);
          component.set("v.newCase.Contact_Number__c", '');
          component.set("v.newCase.Claim_Number__c", '');
          component.set("v.newCase.Adviser_First_Name__c", '');
          component.set("v.newCase.Adviser_Last_Name__c", '');
       }
       if(component.get("v.newCase.Category__c") == 'Query'){
           component.set("v.showAIPCaseQueryFields", true);
           component.set("v.showCaseCancelFields", false);
       }else if(component.get("v.newCase.Category__c") == 'Cancellation'){
           component.set("v.showCaseCancelFields", true);
       }else{
           component.set("v.showCaseCancelFields", false); 
           component.set("v.showAIPCaseQueryFields", false);
           component.set("v.newCase.STI_Alternative_Measures__c", '');
           component.set("v.newCase.STI_Retain_Client__c", '');
           component.set("v.newCase.DD_Case_Outcome__c", '');                         
       }                    
  },
      
   checkConfirm: function(component, event, helper) {
       if(event.getSource().get('v.checked') == true){
          component.set("v.newCase.STI_Retain_Client__c", true);
       }else{
          component.set("v.newCase.STI_Retain_Client__c", false);
       }
   },
   
   getPolicyDetails: function(component, event, helper) {  
      helper.getPolicyDetailsForCase(component);
   },
       
   cancelAndCloseTab : function(component, event, helper) {
       //Close focus tab and navigate home
       helper.closeFocusedTab(component);
       helper.navHome(component, event, helper);
   },
                                
  renderPage: function(component, event, helper) {
       helper.renderPage(component);
  },
                                    
  setPolicyDetails: function(component, event, helper) {
                                        
      component.set("v.newCase.Policy_Number__c", component.get("v.policyNumber"));
      component.set("v.newCase.Product_Provider__c", component.get("v.productProvider"));
      component.set("v.newCase.Cover_Amount__c", component.get("v.coverAmount"));
      component.set("v.newCase.Debtors__c", component.get("v.outstandingAmount"));
      component.set("v.newCase.Premium_Amount__c", component.get("v.policyPremium"));
      component.set("v.newCase.Policy_Status__c", component.get("v.policyStatus"));
      component.set("v.newCase.Effective_Date_of_Policy__c", component.get("v.policyInceptionDate"));
      component.find('Policy_Number__c').set("v.value",component.get("v.policyNumber") );
      component.find('Product_Provider__c').set("v.value",component.get("v.productProvider") );
      component.set("v.showPolicies", false);
  },
      
})