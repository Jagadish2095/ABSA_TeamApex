/**
 * @description       
 * @author             Tracy de Bruin : CloudSmiths
 * @lastmodified  2021-05-30
 * @last modified by  : Monde Masiza
 * 1.0   2021-05-26   Monde Masiza  
**/
({
    setClientValue : function(component, event, helper){
        //Get selected Client
        var leadRecordType = component.get("v.defaultRecordType");
        var eventClient= event.getParam("accountValue");
        var eventClientIndivIdentifier = event.getParam("isIndivClient");
        console.log('eventClientIndivIdentifier ==>'+ JSON.stringify(eventClient));

        if (eventClient != null && eventClient != undefined) {
            component.set("v.clientRecord", eventClient);
        }
        
        if (eventClientIndivIdentifier != null && eventClientIndivIdentifier != undefined) {
            component.set("v.isIndvClient", eventClientIndivIdentifier);
        }
        
        console.log("setAttribute.Id: " + component.get("v.clientRecord").Id);
        console.log("setAttribute.Salutation: " + component.get("v.clientRecord").Salutation);
        console.log("setAttribute.Name: " + component.get("v.clientRecord").Name);
        console.log("setAttribute.FirstName: " + component.get("v.clientRecord").FirstName);
        console.log("setAttribute.LastName: " + component.get("v.clientRecord").LastName);
        console.log("setAttribute.ID_Number__pc: " + component.get("v.clientRecord").ID_Number__pc);
        console.log("setAttribute.Source__c: " + component.get("v.clientRecord").Source__c);
        console.log("setAttribute.PersonMobilePhone: " + component.get("v.clientRecord").PersonMobilePhone);
        console.log("setAttribute.Communicationmethod: " + component.get("v.clientRecord").Communication_Method__c);
        
        //Determine if Client is Individual or Business and populate Lead fields accordingly
        console.log('eventClientIndivIdentifier ==> '+ eventClientIndivIdentifier);
        if(eventClientIndivIdentifier == true) {
            var clientSalutationDefault = eventClient.Salutation;
            var clientSalutationStructured = eventClient.Salutation;
            
            if(clientSalutationStructured != null) {
                //Check if Salutation ends with a fullstop, if not then add a fullstop
                if (clientSalutationDefault.endsWith('.')) {
                    clientSalutationStructured =  helper.camelize(clientSalutationDefault);
                } else {
                    clientSalutationStructured = helper.camelize(clientSalutationDefault) + '.';
                }
            }
            console.log('indide ifff');
            //Simangaliso Mathenjwa - toggle
            var toggleFirstDiv= component.find("firstDiv");
            $A.util.removeClass(toggleFirstDiv, 'slds-hide');
            $A.util.addClass(toggleFirstDiv, 'slds-show');
 
            //Set Lead values/fields based on selected Client
            component.set("v.showLeadInformation", true);
            
            component.set("v.leadRecord.Name", eventClient.Name);
            component.find("iSalutation").set("v.value", clientSalutationStructured);
            component.set("v.leadRecord.FirstName", eventClient.FirstName);
            component.set("v.leadRecord.LastName", eventClient.LastName);
            component.set("v.leadRecord.Email", eventClient.PersonEmail);
            component.set("v.leadRecord.Phone", eventClient.Phone);
            component.set("v.leadRecord.ID_Number__c", eventClient.ID_Number__pc);
            component.set("v.leadRecord.Company", '');
             //added by short term insurance.
             if(leadRecordType == 'Personal_Lines' || leadRecordType == 'Idirect'){
                component.set("v.leadRecord.Phone", eventClient.PersonHomePhone);//Home_Phone__c
                component.set("v.leadRecord.Home_Phone__c", eventClient.PersonHomePhone);
                component.set("v.leadRecord.ID_Type__c", eventClient.ID_Type__pc);
            //added short team fields - Monde
            component.set("v.leadRecord.Initials__c", eventClient.Initials__pc);
            component.set("v.leadRecord.Gender__c", eventClient.Gender__pc);
            component.set("v.leadRecord.Salutation", eventClient.Salutation);
			component.set("v.leadRecord.ID_Type__c", eventClient.ID_Type__c);     
            component.set("v.leadRecord.Physical_address_line_1__c", eventClient.BillingStreet);
            component.set("v.leadRecord.Physical_address_Postal_code__c", eventClient.BillingPostalCode);
            component.set("v.leadRecord.Physical_address_Suburb__c", eventClient.BillingState);
            component.set("v.leadRecord.Physical_address_City__c", eventClient.BillingCity);
            component.set("v.leadRecord.Physical_address_Country__c", eventClient.BillingCountry);
            component.set("v.leadRecord.Physical_address_Line_2__c", eventClient.Physical_address_line_2_c__c);
            component.set("v.leadRecord.Date_of_Birth__c", eventClient.PersonBirthdate); //Work_Phone__c
            component.set("v.leadRecord.Work_Phone__c", eventClient.Work_Phone__c); 


            }else{
                component.set("v.leadRecord.Phone", eventClient.Phone);
            }
            component.set("v.leadRecord.Company_Registration_Number__c", '');
            //added for STI
            component.set("v.leadRecord.Parent_Account__c", eventClient.Id);
            //component.set("v.leadRecord.Entity_Type__c", '');
            component.set("v.leadRecord.CIF__c", eventClient.CIF__c);
            //added for Direct delivery
            component.set("v.leadRecord.DD_Gender__c", eventClient.Gender__pc);
            component.set("v.leadRecord.DD_Initials__c", eventClient.Initials__pc);
            component.set("v.leadRecord.DD_Date_of_Birth__c", eventClient.PersonBirthdate);
            component.set("v.leadRecord.ID_Type__c", eventClient.ID_Type__pc);
            component.set("v.leadRecord.Marital_status__c", eventClient.Marital_Status__pc);
            component.set("v.leadRecord.DD_Source_of_Funds__c", eventClient.DD_Source_of_Funds__pc);
            component.set("v.leadRecord.DD_Source_of_Income__c", eventClient.Income_Source__pc);
            component.set("v.leadRecord.Salutation", eventClient.Salutation);
            if(component.get("v.clientRecord").Source__c == 'SF') {
                component.set("v.leadRecord.MobilePhone", eventClient.PersonMobilePhone);
            }

            console.log('eventClient.Communication_Method__c 2==> ' + component.get("v.clientRecord").Communication_Method__c);
            if(component.get("v.defaultRecordType") == 'Retail_Sales_Lead' || component.get("v.defaultRecordType") == 'Retail_Service_Lead'){

                if(eventClient.Communication_Method__c=='Email' || eventClient.Communication_Method__c=='In-App' || eventClient.Communication_Method__c=='Mobile' ||eventClient.Communication_Method__c=='Phone' || eventClient.Communication_Method__c=='Whatsapp' || eventClient.Communication_Method__c=='SMS' ){
                    component.set("v.leadRecord.Preferred_Communication_Channel_RBB__c", eventClient.Communication_Method__c);
                }
            }else{
                component.set("v.leadRecord.Preferred_Communication_Channel__c", eventClient.Communication_Method__c);
            }
            
        }
        else {
            
            console.log('eventClient.Name ==> ' + eventClient.Name);
            
            //Only populate CompanyName for Business 
            component.set("v.leadRecord.Name", '');
            component.find("iSalutation").set("v.value", null);
            component.set("v.leadRecord.FirstName", '');
            component.set("v.leadRecord.LastName", '');
            component.set("v.leadRecord.Email", '');
            component.set("v.leadRecord.Phone", '');
            component.set("v.leadRecord.ID_Number__c", '');
            component.set("v.leadRecord.Company", eventClient.Name);
            component.set("v.leadRecord.Company_Registration_Number__c", eventClient.Company_Registration_Number__c);
            //component.set("v.leadRecord.Entity_Type__c", eventClient.Client_Type__c);
             //added for STI
            component.set("v.leadRecord.Parent_Account__c", eventClient.Id);
            component.set("v.leadRecord.CIF__c", eventClient.CIF__c);
            
            if(eventClient.Source__c == 'SF') {
                component.set("v.leadRecord.MobilePhone", null);
            }
            
            if(eventClient.Name){
                
                //Simangaliso Mathenjwa - toggle
                var toggleFirstDiv= component.find("firstDiv");
                $A.util.removeClass(toggleFirstDiv, 'slds-hide');
                $A.util.addClass(toggleFirstDiv, 'slds-show');
            }
        }
    },
    
    clearServiceGroup : function(component, event, helper){
        
        var childCmp = component.find("serviceGrouplookup");
        
        if(Array.isArray(childCmp)){
                
            for(var i = 0; i < childCmp.length; i++){
                childCmp[i].clearSelectionMethod(component, event, helper);
            }
         } else if(!Array.isArray(childCmp)){
                childCmp.clearSelectionMethod(component, event, helper);
        }
        
        var serviceGroupLookupCondition = '';
        var recordType = component.get("v.defaultRecordType");//added by short term insurance.
        
        var leadSource =  component.get("v.leadRecord.LeadSource");
        console.log('**leadSource**', leadSource);
        
        if(recordType != 'Idirect' && recordType != 'Personal_Lines'){//added by short term insurance to exclude Idirect & PL from this logic.
            if(leadSource == 'IB Walk-in'){
                serviceGroupLookupCondition = ' AND  Name LIKE \'IB -%\' AND Active__c=true AND Assign_Record_Type__c IN (\'Retail Sales Lead\')';
            }else{
                serviceGroupLookupCondition = ' AND (NOT Name  LIKE \'IB -%\') AND Active__c=true AND Assign_Record_Type__c IN (\'Retail Sales Lead\')';
            }
        }
    
            //logic added by short term insurance
            if(recordType == 'Idirect'){
                serviceGroupLookupCondition = ' AND (NOT Name  LIKE \'IB -%\') AND Active__c=true AND Assign_Record_Type__c IN (\'Idirect Lead\')';
            }else if(recordType == 'Personal_Lines'){
                serviceGroupLookupCondition = ' AND (NOT Name  LIKE \'IB -%\') AND Active__c=true AND Assign_Record_Type__c IN (\'Personal Lines\',\'Retail Sales Lead\')';
            }
        
        component.set('v.serviceGroupLookupCondition', serviceGroupLookupCondition);
    },
    
     //Method to get Contact Record from setContactInfo Lightning Event
    setContactValue : function(component, event, helper){
        //Get selected Contact
        var contactRecordEvent= event.getParam("contactRecord");

        component.set("v.contactRecord", contactRecordEvent);
    },

    
    getFinancialProduct : function(component, event, helper) {
        helper.showSpinner(component);
        var rectype =component.get("v.defaultRecordType"); //added for direct delivery
        //Get Case Type
        var productInterest ;
        var action = component.get("c.findFinancialProduct"); 
        if(rectype =='Direct_Delivery_Sales_Lead'){
            productInterest =  component.find("ddFinancialProduct").get("v.value"); 
        }else if(rectype =='STI_Lead'){
            productInterest =  component.find("iFinancialProductSTI").get("v.value"); 
        }else{
         productInterest =  component.find("iFinancialProduct1").get("v.value"); 
        }
        if(productInterest == '' || productInterest == undefined || productInterest == null){
            if(rectype =='STI_Lead'){
              helper.hideSpinner(component);
            }else{
            component.set("v.showInvestmentField",false);	
                }
        }
        else{
        action.setParams({
            "financialProductId" : productInterest
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {
				var retVal = response.getReturnValue();
                
                console.log('response.getReturnValue'+JSON.stringify(response.getReturnValue()))
                component.set("v.financialProductRecord", response.getReturnValue());
                if(retVal.Name == 'Invest – Stockbroking – Portfolio Managed Options'){	
                    component.set("v.showInvestmentField",true);	
                }else{	
                    component.set("v.showInvestmentField",false);	
                }
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
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
        }
    },
    
    getPreferredSite : function(component, event, helper) {
        helper.showSpinner(component);
        var rectype =component.get("v.defaultRecordType");//added for VA STI
        //Get Case Type
        var action = component.get("c.findSite"); 
         var preferredSite;
        if(rectype =='STI_Lead'){
        
        	preferredSite =  component.find("iPreferredSiteSTI").get("v.value"); 
        }else{
            preferredSite =  component.find("iPreferredSite").get("v.value"); 
        }
        
        if(preferredSite == '' || preferredSite == undefined || preferredSite == null){
            
            helper.hideSpinner(component);
            
        }else{
        action.setParams({
            "siteId" : preferredSite
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {

                component.set("v.siteRecord", response.getReturnValue());
                
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
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
        }
    },
    
    //koketso - get logged in user record types  
    doInit : function(component, event, helper) {
        
        helper.getUserPermissionSets(component);
        helper.getUserServiceGroup(component);
        var serviceGroupLookupCondition;
        
        //var serviceGroupLookupCondition = ' AND (NOT Name  LIKE \'IB -%\') AND Active__c=true AND Assign_Record_Type__c IN (\'Retail Sales Lead\')';
        //component.set('v.serviceGroupLookupCondition', serviceGroupLookupCondition);
        
        //Set CaseType default selection
        var action = component.get("c.getLoggedInUserLeadRecordTypes");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
             if (component.isValid() && state === "SUCCESS") {
                
                var recordTypes = response.getReturnValue();
                console.log('****Lead recordTypes****'+recordTypes);
                if(recordTypes != null) {
                    recordTypes.forEach(function(item) {
                        //Set default record type
                        
                        //Changed by Eduardo Salia and Vitthal Jivrag for VA STI
                        if(component.get("v.defaultRecordType") === 'STI_Lead'
                           && item.value === 'STI_Lead')
                        {
                            component.set("v.defaultRecordTypeId", item.recordTypeId);
                            
                            var toggleFirstDiv= component.find("firstDiv");
                            $A.util.addClass(toggleFirstDiv, 'slds-hide');
                        }
                        else if(item.isDefault == true
                                && component.get("v.defaultRecordType") != 'STI_Lead')
                        {
                            
                            component.set("v.defaultRecordType", item.value);
                            component.set("v.defaultRecordTypeId", item.recordTypeId);
                            if(item.value == 'Retail_Sales_Lead' || item.value == 'Retail_Service_Lead') {
                                //Simangaliso Mathenjwa - toggle
                                var toggleFirstDiv= component.find("firstDiv");
       							$A.util.addClass(toggleFirstDiv, 'slds-hide');
                                
                                component.set("v.isRetailLead", true); 
                                serviceGroupLookupCondition = ' AND (NOT Name  LIKE \'IB -%\') AND Active__c=true AND Assign_Record_Type__c IN (\'Retail Sales Lead\')';
                                component.set('v.serviceGroupLookupCondition', serviceGroupLookupCondition);
                                // create a Default RowItem [Product Interest Instance] on first time Load
                                // by call this helper function  
                                helper.createProductInterestData(component, event);
                                
                            } 
                           else if(item.value == 'Direct_Delivery_Sales_Lead'){ //added this else if for firect delivery
                                var toggleFirstDiv= component.find("firstDiv");
                                $A.util.addClass(toggleFirstDiv, 'slds-hide');

                            }else if(item.value == 'Idirect' || item.value == 'Personal_Lines'){
                                toggleFirstDiv= component.find("firstDiv");
                                $A.util.addClass(toggleFirstDiv, 'slds-hide');
                                component.set("v.isShortTermInsurance", true); 
                                component.set("v.isRetailLead",true);
                                
                                //set the condition based on lead record types that are related to short term insurance.
                                if(item.value == 'Idirect'){
                                    serviceGroupLookupCondition  = ' AND (NOT Name  LIKE \'IB -%\') AND Active__c=true AND Assign_Record_Type__c IN (\'Idirect Lead\')';
                                    component.set('v.serviceGroupLookupCondition', serviceGroupLookupCondition);
                                }else if(item.value == 'Personal_Lines'){
                                    serviceGroupLookupCondition = ' AND (NOT Name  LIKE \'IB -%\') AND Active__c=true AND Assign_Record_Type__c IN (\'Personal Lines\', \'Retail Sales Lead\')';
                                    component.set('v.serviceGroupLookupCondition', serviceGroupLookupCondition);
                                }

                            }
                            else{
                                //Simangaliso Mathenjwa - toggle
                                var toggleFirstDiv= component.find("firstDiv");
       							$A.util.removeClass(toggleFirstDiv, 'slds-hide');
                            }
                        }
                    }); 
                }
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    createNewLead : function(component, event, helper) {
        //Show spinner
        helper.showSpinner(component);
		var defaultRecordType = component.get("v.defaultRecordType");
        var leadRecord = component.get("v.leadRecord");
        leadRecord.Salutation = component.find("iSalutation").get("v.value");
        var productInterest = component.get("v.financialProductRecord");
        var preferredSiteRecord = component.get("v.siteRecord");
        var leadSource = leadRecord.LeadSource;
        var LeadType = leadRecord.LeadType;
        var useAssignmentRule = component.find("iAssignmentRule");
        var useAssignmentRuleValue =  useAssignmentRule.get("v.value");
        var preferredCommunicationChannel = leadRecord.Preferred_Communication_Channel__c;
        if(defaultRecordType == 'STI_Lead'){
            var productInterestVal = component.find("iFinancialProductSTI").get("v.value");
        var preferredSiteRecordVal = component.find("iPreferredSiteSTI").get("v.value");
        var leadSource = leadRecord.Lead_Source__c;
        var leadSubSource = leadRecord.STI_Sub_Source__c;
        var LeadType = leadRecord.Lead_Type__c;
            var aicConsultant = leadRecord.AIC_Relationship_Consultant_Name__c;
        var referredBranch = leadRecord.Referring_Banker_s_Branch__c;
        var leadName = leadRecord.Lead_Name__c;
        var leadPhone =leadRecord.Lead_Phone__c;
        var leadEmail = leadRecord.Lead_Email__c;
        var parentAccount = leadRecord.Parent_Account__c;
        var contactlookup = component.get("v.selectedLookUpRecord");
        } else{
            var leadSource = leadRecord.LeadSource;
        var LeadType = leadRecord.LeadType;
        }
                    
        var clientRecord = component.get("v.clientRecord");
        
        //Validation - No Client selected
        if(!clientRecord.Name && !clientRecord.LastName){
            var toast = helper.getToast("Validation Warning", "Please search for an existing Client or create a new Client record", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        if(defaultRecordType == 'STI_Lead'){
            if(component.get("v.isIndvClient") == false){
            
             //Validation for contact lookup
        if($A.util.isUndefinedOrNull(contactlookup) || $A.util.isEmpty(contactlookup)){
       		var toast = helper.getToast("Validation Error", "Please provide Contact Name for the lead", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
             //Validation - No parentAccount selected
        if(parentAccount == null || parentAccount == '' || parentAccount == undefined){
            var toast = helper.getToast("Validation Error", "Please provide parent Account for the lead", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        }
            
              //Validation - No product selected
        if(productInterestVal == null || productInterestVal == '' || productInterestVal == undefined){
            var toast = helper.getToast("Validation Error", "Please provide product interest for the lead", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
              //Validation - No AICRelationshipConsultant selected
        if(aicConsultant == null || aicConsultant == '' || !aicConsultant){
            var toast = helper.getToast("Validation Error", "Please provide AIC Relationship Consultant Name", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
             //Validation - No Salutation selected
         if(leadRecord.Salutation =='' || leadRecord.Salutation == null){
       		var toast = helper.getToast("Validation Error", "Please provide Salutation", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
    		}
             //Validation - No preferredSite selected
        	if(preferredSiteRecordVal == null || preferredSiteRecordVal == '' || preferredSiteRecordVal == undefined){
        	var toast = helper.getToast("Validation Error", "Please provide preferredSiteRecord for the lead", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
            
                  //Validation - No preferredCommunicationChannel selected
        if(preferredCommunicationChannel == null || preferredCommunicationChannel == '' || !preferredCommunicationChannel){
            var toast = helper.getToast("Validation Error", "Please provide Preferred Communication Channel", "error");
             helper.hideSpinner(component);
             toast.fire();
        	 return null;
        }
            //Validation - if no LeadName
    if(leadName =='' || leadName == null){
            var toast = helper.getToast("Validation Error", "Please provide CAF STI Lead Source Name", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
       
    }
      //Validation - if no LeadType
    if(LeadType =='' || LeadType == null){
            var toast = helper.getToast("Validation Error", "Please provide Lead Type", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
       
    }
                //Validation - if no LeadSource
    if(leadSource =='' || leadSource == null){
            var toast = helper.getToast("Validation Error", "Please provide Lead Source", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
       
    }
            
                            //Validation - if no LeadSubSource
    if(leadSubSource =='' || leadSubSource == null){
            var toast = helper.getToast("Validation Error", "Please provide Lead Sub Source", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
       
    }
      
                //Validation - if no LeadPhone
    if(leadPhone =='' || leadPhone == null){
        var toast = helper.getToast("Validation Error", "Please provide CAF STI Lead Source Phone", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
       
    }
                //Validation - if no LeadEmail
    if(leadEmail =='' || leadEmail == null){
        var toast = helper.getToast("Validation Error", "Please provide CAF STI Lead Source Email", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
       
    }
               //Validation - No ReferredBankerBranch selected
        if(referredBranch == null || referredBranch == '' || !referredBranch){
            var toast = helper.getToast("Validation Error", "Please provide Referring Banker's Branch", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        
        }
        }else{
        //Validation - No Client selected
        if(!leadSource){
            var toast = helper.getToast("Validation Warning", "Please provide a Lead Source", "error");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        var showInvestmentField = component.get("v.showInvestmentField");	
        if(showInvestmentField){	
            var investmentFieldValue = component.find("investedAmt").get("v.value");	
            //alert(showInvestmentField +' == '+investmentFieldValue);	
            if(investmentFieldValue == '' || investmentFieldValue == null || investmentFieldValue == undefined){	
                var toast = helper.getToast("Validation Warning", "Please provide an Invested Amount", "error");	
                helper.hideSpinner(component);	
                toast.fire();	
                return null;	
            }	
        }
        }
        //Calling the Apex Function to create Contact
        var createLeadAction = component.get("c.createLead");
        
        //Setting the Apex Parameter
        createLeadAction.setParams({
            "newLeadRecord" : leadRecord,
            "relatedClient" : clientRecord,
            "financialProductRecord" : productInterest,
            "preferredSiteRecord" : preferredSiteRecord,
            "useLeadAssignmentRule" : useAssignmentRuleValue
        });
        
        //Setting the Callback
        createLeadAction.setCallback(this, function(response) {
            
            var stateCase = response.getState();
            
            if (stateCase === "SUCCESS") {
                //Set Contact 
                var leadRecordId = response.getReturnValue();
                
                // show success notification
                var toastEvent = helper.getToast("Success!", "Lead successfully created in Salesforce", "Success");
                toastEvent.fire();
                
                helper.hideSpinner(component);
                
                //Navigate to Lead 
                helper.closeFocusedTabAndOpenNewTab(component,leadRecordId);
                
            }else if(stateCase === "ERROR"){
                
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
                
                if (message.includes('DUPLICATES_DETECTED')) {
                    message = 'Duplicate Contact detected, please use a diffrent Email Address or search for an existing Contact'
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            } 
        }); 
        
        //adds the server-side action to the queue        
        $A.enqueueAction(createLeadAction);
    },
    //function to create new AIC short term insurance lead - Monde Masiza
    createAICShortTermInsuranceLead : function(component, event, helper) {
        
        helper.showSpinner(component); 
        var clientRecord = component.get("v.clientRecord");
        var leadRecord = component.get("v.leadRecord");
        var leadSource = leadRecord.LeadSource;
        var defaultRecordType = component.get("v.defaultRecordType");
        debugger;
        console.log('defaultRecordType : '+ defaultRecordType);

        leadRecord.Salutation = component.find("iSalutation").get("v.value");
        leadRecord.ID_Type__c = component.find("iIdType").get("v.value");
        //leadRecord.Hot_Deal__c = component.find("iHotDeal").get("v.value");
        leadRecord.Nationality__c = component.find("iNationality").get("v.value");

        /*if(defaultRecordType != null && defaultRecordType != 'Personal_Lines' && defaultRecordType != 'Idirect'){
            productRecords = component.get("v.productInterestList");
            productInterest =  productRecords[0].Financial_Product__c; 
        }*/
       
       var serviceGroupRecord = component.get("v.serviceGroupRecord");
       var selectedServiceGroupId = serviceGroupRecord.Id;
       console.log("selectedServiceGroupId:" + selectedServiceGroupId);
       
        var assignLead = component.get("v.isAssignAICSTIlLead");
        var routeLead = component.get("v.isRouteAICSTIlLead");
        var assignLeadToUser = component.get("v.isAssignToUserAICSTIlLead");
        var serviceGroupRecord = component.get("v.serviceGroupRecord");
        var serviceGroupId2 = serviceGroupRecord.Id;
        var selectedUserRecord = component.get("v.selectedUserRecord");
        var selectedUserId = selectedUserRecord.Id;
        var preferredCommunicationChannel = leadRecord.Preferred_Communication_Channel_RBB__c;
        var email = leadRecord.Email;
        var phone = leadRecord.Phone;
        var mobilePhone = leadRecord.MobilePhone;
        var idNumber = leadRecord.ID_Number__c;
        var idType = leadRecord.ID_Type__c;
        var salutation = leadRecord.Salutation;
        var nationality = leadRecord.Nationality__c;
        var clientId = clientRecord.ID_Number__pc;
        var clientCIF = clientRecord.CIF__c;
        var firstName = leadRecord.FirstName;
        var initials = leadRecord.Initials__c;
        var gender = leadRecord.Gender__c;
        var clientType = leadRecord.Client_Type__c;
        var maritalStatus = leadRecord.Marital_status__c;
        var correspondenceLanguage = leadRecord.Correspondence_Language__c;
        var maritalContractType = leadRecord.Marital_Contract_Type__c;
        var occupationalStatus = leadRecord.Occupational_Status__c;
        var countryOfBirth = leadRecord.Country_of_Birth__c;
        var Occupation = leadRecord.Occupation__c;
        var sourceOfFunds = leadRecord.Source_of_Funds__c;
        var physicalAddressLine1 = leadRecord.Physical_address_line_1__c;
        var physicalAddressPostalCode = leadRecord.Physical_address_Postal_code__c;
        var physicalAddressSuburb = leadRecord.Physical_address_Suburb__c;
        var physicalAddressCity = leadRecord.Physical_address_City__c;
        var physicalAddressCountry = leadRecord.Physical_address_Country__c;
        var postalAddressLine1 = leadRecord.Postal_Address_Line_1__c;
        var postalAddressPostalCode = leadRecord.Postal_Address_Postal_code__c;
        var postalAddressSuburb = leadRecord.Postal_Address_Suburb__c;
        var postalAddressCity  = leadRecord.Postal_Address_City__c;
        var postalAddressCountry = leadRecord.Postal_Address_Country__c;
        var countryPassportIssued = leadRecord.Country_Passport_Issued__c;
        

        //added by Mbuyiseni Mbhokane - for Short term insurance stream
        var physicalAddressPostalCode = leadRecord.Physical_address_Postal_code__c;
        var postalAddressPostalCode = leadRecord.Postal_Address_Postal_code__c;
        
         var physicalCodeIds = component.find("PhysicalCodeLookUp").get("v.value");
         var postalCodeIds = component.find("postalCodeLookUp").get("v.value");

        //set the value that should be saved to the record
        component.set("v.leadRecord.Postal_Code__c", component.get("v.postalCodeId"));
        component.set("v.leadRecord.Physical_Code__c", component.get("v.physicalCodeId"));
        
        //Validation for short term insurance - Monde added this
       //Validation - No First name provided 

       if(selectedServiceGroupId == null || selectedServiceGroupId == ''){
        var toast = helper.getToast("Validation Warning", "Please select branch", "warning");
        helper.hideSpinner(component);
        toast.fire();
        return null;
    }

        if(firstName == null || firstName == ''){
            var toast = helper.getToast("Validation Warning", "Please provide firstName ", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No Initials provided 
        if(initials == null || initials == ''){
            var toast = helper.getToast("Validation Warning", "Please provide initials ", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        //Validation - No Client selected
        if(!clientRecord.Name && !clientRecord.LastName){
            var toast = helper.getToast("Validation Warning", "Please search for an existing client or create a new client record", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        console.log('**leadID**', idNumber);
        console.log('**clientID**', clientId);
        console.log('**clientCIF**', clientCIF);
        
        //Validation - Do not change existing client ID
        if(clientCIF != null && (idNumber != clientId) && clientId != null){
            var toast = helper.getToast("Validation Warning", "ID Number change is not allowed, client already exists", "warning");
            component.set("v.leadRecord.ID_Number__c", clientId);
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No ID Type Selected
        if(idType == null || idType == ''){
            var toast = helper.getToast("Validation Warning", "Please select ID Type", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No ID selected
        if(idNumber == null || idNumber == ''){
            var toast = helper.getToast("Validation Warning", "Please provide an ID/Passport number for your lead", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }

        if(idNumber.length != 13 && idType == 'SA ID Number'){
            var toast = helper.getToast("Validation Warning", "Invalid length for a South African ID number", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }

        //Validation - No Numeric ID number
        if(/\D/.test(idNumber) && idType == 'SA ID Number'){
            var toast = helper.getToast("Validation Warning", "South African ID Number must be only numeric", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - Passport and nationality
        var idNumValidation = parseInt(idNumber.substr(6,1));
       
        
        if(idNumValidation > 4  && idType == 'SA ID Number' ){
            if(salutation == 'Mrs.' || salutation == 'Ms.'){
                var toast = helper.getToast("Validation Warning", "The salutation cant be Mrs./Ms. for this ID number", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        if(idNumValidation <= 4  && idType == 'SA ID Number' ){
            if(salutation == 'Mr.'){
                var toast = helper.getToast("Validation Warning", "The salutation cant be Mr. for this ID number", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        //Validation - No Salutation selected
        if(salutation =='' || salutation == null){
            var toast = helper.getToast("Validation Error", "Please provide Salutation", "error");
         helper.hideSpinner(component);
         toast.fire();
         return null;
         }

        //Validation - Passpoot validation
        var regexPassport = /[^a-zA-Z0-9 ]/;
 
        if(!regexPassport.test(idNumber) == false && idType == 'Passport'){
            var toast = helper.getToast("Validation Warning", "Invalid passport number. No Special Characters Allowed", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        if(idType == 'Passport' &&  countryPassportIssued == null || countryPassportIssued == ''){
            var toast = helper.getToast("Validation Warning", "Country Passport Issued is required when Id type is a passport", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No Nationality selected
        if(nationality == null || nationality == ''){
            var toast = helper.getToast("Validation Warning", "Please select Nationality", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
       //Validation - No Gender selected - Monde
        if(gender == null || gender == ''){
            var toast = helper.getToast("Validation Warning", "Please select Gender", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No Client Type selected - Monde
        if(clientType == null || clientType == ''){
            var toast = helper.getToast("Validation Warning", "Please select Client Type", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - Passport and nationality
        if(idType == 'Passport' && nationality == 'South Africa'){
            var toast = helper.getToast("Validation Warning", "Please choose a different nationality for a passport", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
         }
        
        //Validation - Passport and nationality
        if(idType == 'SA ID Number' && nationality != 'South Africa'){
            var toast = helper.getToast("Validation Warning", "Please choose a South African Nationality for a SA ID Number", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
         }

        //Validation - No Communication Channel Selected
        console.log('email ==> '+ email);
        console.log('phone ==> '+ phone);
        console.log('mobilePhone ==> '+ mobilePhone);
        console.log('preferredCommunicationChannel  ==> '+ preferredCommunicationChannel);
        if(preferredCommunicationChannel == null || preferredCommunicationChannel == '' || !preferredCommunicationChannel){
            var toast = helper.getToast("Validation Warning", "Please provide Preferred Communication Channel", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        } else{
            if (!email && preferredCommunicationChannel.includes('Email') ){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide email address", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
                
            }else if (!phone && preferredCommunicationChannel.includes('Phone')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide phone number", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
                
            }else if (!mobilePhone && preferredCommunicationChannel.includes('Mobile')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }else if (!mobilePhone && preferredCommunicationChannel.includes('SMS')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            
            }else if (!mobilePhone && preferredCommunicationChannel.includes('Whatsapp')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            
            }else if (!email && preferredCommunicationChannel.includes('In-App')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide email address", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
        }

        //Validation - No Marital Status selected 
        if(maritalStatus == null || maritalStatus == ''){
            var toast = helper.getToast("Validation Warning", "Please select Marital Status", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }else if(maritalStatus == 'Married' && (maritalContractType == null || maritalContractType == '')){
            var toast = helper.getToast("Validation Warning", "Please select Marital Contract Type", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }else{
            
        }
        
         //Validation - No Occupational Status selected 
        if(occupationalStatus == null || occupationalStatus == ''){
            var toast = helper.getToast("Validation Warning", "Please select Occupational Status", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No Correspondence Language selected 
        if(correspondenceLanguage == null || correspondenceLanguage == ''){
            var toast = helper.getToast("Validation Warning", "Please select Correspondence Language", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No Country Of Birth selected 
        if(countryOfBirth == null || countryOfBirth == ''){
            var toast = helper.getToast("Validation Warning", "Please select Country of Birth", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        debugger;
        //Validation - No Occupation selected 
        if(Occupation == null || Occupation == ''){
            var toast = helper.getToast("Validation Warning", "Please select Occupation", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No physicalAddressLine1 provided 
        if(physicalAddressLine1  == null || physicalAddressLine1  == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Physical Address Line 1", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No physicalAddressSuburb provided 
        if(physicalAddressSuburb == null || physicalAddressSuburb == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Physical Address Suburb", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No physicalAddressCity provided 
        if(physicalAddressCity  == null || physicalAddressCity  == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Physical Address City", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No physicalAddressCountry provided 
        if(physicalAddressCountry  == null || physicalAddressCountry  == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Physical Address Country", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No postalAddressLine1 provided 
        if(postalAddressLine1 == null || postalAddressLine1 == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Postal Address Line 1", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }

        //Validation - No physicalAddressSuburb provided 
        if(physicalAddressSuburb  == null || physicalAddressSuburb  == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Physical Address Suburb", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No postalAddressSuburb provided 
        if(postalAddressSuburb  == null || postalAddressSuburb  == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Postal Address Suburb", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No postalAddressCity provided 
        if(postalAddressCity == null || postalAddressCity == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Postal Address City", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
         //Validation - No postalAddressCountry provided 
        if(postalAddressCountry == null || postalAddressCountry == ''){
            var toast = helper.getToast("Validation Warning", "Please provide Postal Address Country", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No source Of funds selected 
        if(sourceOfFunds == null || sourceOfFunds == ''){
            var toast = helper.getToast("Validation Warning", "Please select Source of Funds", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - Incorrect phone number length
        if(phone){
            if(phone.length != 10){
                var toast = helper.getToast("Preferred Communication Channel", "Phone number length must be 10", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        //Validation - Incorrect phone characters
        if(phone){
            if(/\D/.test(phone)){
                var toast = helper.getToast("Preferred Communication Channel", "Phone number must be only numeric", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        //Validation - Incorrect mobile number length
        if(mobilePhone){
            if(mobilePhone.length != 10 ){
                var toast = helper.getToast("Preferred Communication Channel", "Mobile number length must be 10", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        //Validation - Incorrect phone characters
        if(mobilePhone){
           if(/\D/.test(mobilePhone)){
                var toast = helper.getToast("Preferred Communication Channel", "Mobile number must be only numeric", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            } 
        }

        //Validation - No Lead Source selected
        if(!leadSource){
            var toast = helper.getToast("Validation Warning", "Please provide a lead source", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }

        //Validate the physical address postal code 
        if (physicalAddressPostalCode && (defaultRecordType == 'Personal_Lines' || defaultRecordType == 'Idirect')) {
           if (/\D/.test(physicalAddressPostalCode)) {
               var toast = helper.getToast("Validation Warning", "Physical address Postal code must be only numeric", "warning");
               helper.hideSpinner(component);
               toast.fire();
               return null;
           }
       }

       //Validate the physical address postal code 
       if (postalAddressPostalCode && (defaultRecordType == 'Personal_Lines' || defaultRecordType == 'Idirect')) {
           if (/\D/.test(physicalAddressPostalCode)) {
               var toast = helper.getToast("Validation Warning", "Postal address Postal code must be only numeric", "warning");
               helper.hideSpinner(component);
               toast.fire();
               return null;
           }
       }

       if(assignLeadToUser == true && (selectedUserId == null || selectedUserId == '')){
           var toast = helper.getToast("Validation Warning", "Please provide a colleague to assign your lead to", "warning");
           helper.hideSpinner(component);
           toast.fire();
           return null;
       }
        console.log('**assign**', assignLead);
        console.log('**route**', routeLead);
        console.log('**assignToUser**', assignLeadToUser);
        console.log('**assignToUser**', assignLeadToUser);

        if(assignLeadToUser == true && (selectedUserId != null || selectedUserId != '')){
            leadRecord.OwnerId = selectedUserId;
        }
        //Calling the Apex function to create a Lead
        var action = component.get("c.createLeadForShortTermInsurance");
       console.log('serviceGroupRecord1' +  selectedServiceGroupId);
       console.log('selectedServiceGroupId:' + JSON.stringify(selectedServiceGroupId));
        //Setting the Apex Parameter
        action.setParams({
            "newLeadRecord" : leadRecord,
            "acc" : clientRecord,
            "selectedServiceGroupId" : selectedServiceGroupId,
            "route" : routeLead
        });
        
        //Setting the Callback
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log('******ReturnVal***', response.getReturnValue());
                
                
                    // show success notification
                    var toastEvent = helper.getToast("Success!", "Lead successfully created in Salesforce", "Success");
                    helper.hideSpinner(component);
                    toastEvent.fire();
                    
                    //Set LeadId 
                    var leadRecordId = response.getReturnValue();
                    
                    //Navigate to Lead 
                    if(assignLead == true) {
                        helper.closeFocusedTabAndOpenNewTab(component, leadRecordId);
                    } else if (routeLead == true || assignLeadToUser == true) {
                        helper.closeFocusedTab(component);
                        helper.navHome(component, event, helper);
                    } 
                
                
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
                
                if (message.includes('DUPLICATES_DETECTED')) {
                    message = '	New lead cannot be created at this stage. This customer already has an Open/Active Lead. Please search for the customer’s lead and lease with the BM if you are not the owner of the open lead.'
                }
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            } 
        }); 
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
       },
    //function to create and navigate to new Short Term Insurance Lead - Monde Masiza
    saveAndNavigateToAICSTIlLead : function(component, event, helper) {
        
    //Show spinner
    helper.showSpinner(component);
    component.set("v.isAssignAICSTIlLead", true); 
    component.set("v.isRouteAICSTIlLead", false);
    component.set("v.isAssignToUserAICSTIlLead", false);
    
    //Enqueue action to create Lead
    $A.enqueueAction(component.get('c.createAICShortTermInsuranceLead'));
    helper.hideSpinner(component);
},
    //function to create and route new Short Term Insurance Lead - Monde Masiza
    routeAICSTIlLead : function(component, event, helper) {
        
        //Show spinner
        helper.showSpinner(component);
        component.set("v.isAssignAICSTIlLead", false);
    
        //Monde 
        var physicalCodeIds = component.find("PhysicalCodeLookUp").get("v.value");
        var postalCodeIds = physicalCodeIds.Id
        component.set("v.postalCodeLookUp",physicalCodeIds);
        
        console.log('isAssignAICSTIlLead : '+ component.get("v.isAssignAICSTIlLead"));
        component.set("v.isRouteAICSTIlLead", true);
        console.log('isRouteAICSTIlLead : '+ component.get("v.isRouteAICSTIlLead"));
        component.set("v.isAssignToUserAICSTIlLead", false);
        console.log('isAssignToUserAICSTIlLead : '+ component.get("v.isAssignToUserAICSTIlLead"));
        
        //Enqueue action to create Lead
        $A.enqueueAction(component.get('c.createAICShortTermInsuranceLead '));
        console.log('Calling the Method : '+ component.get('c.createAICShortTermInsuranceLead '));
        helper.hideSpinner(component);
    },

 //function to create and assign new Short Term Insurance Lead to User - Monde Masiza
 assignAICSTIlLeadToUser : function(component, event, helper) {
        
    //Show spinner
    helper.showSpinner(component);
    component.set("v.isAssignAICSTIlLead", false);
    component.set("v.isRouteAICSTIlLead", false);  
    component.set("v.isAssignToUserAICSTIlLead", true);
    
    //Enqueue action to create Lead
    $A.enqueueAction(component.get('c.createAICShortTermInsuranceLead'));
    helper.hideSpinner(component);
},

    cancelAndCloseTab : function(component, event, helper) {
        //Close focus tab and navigate home
        helper.closeFocusedTab(component);
        helper.navHome(component, event, helper);
    },
    
    getAssignmentRules : function(component, event, helper) {
        console.log('getAssignmentRules');
        var leadRecordss = component.find("iAssignmentRule");
        console.log('Value : ' + leadRecordss.get("v.value")); 
        
    },
    
    //function to create a new Retail Lead 
    createRetailLead : function(component, event, helper) {
        
        helper.showSpinner(component);
		var clientRecord = component.get("v.clientRecord");
        var leadRecord = component.get("v.leadRecord");
        var leadSource = leadRecord.LeadSource;
        var defaultRecordType = component.get("v.defaultRecordType");
		
        leadRecord.Salutation = component.find("iSalutation").get("v.value");
        leadRecord.ID_Type__c = component.find("iIdType").get("v.value");
        leadRecord.Hot_Deal__c = component.find("iHotDeal").get("v.value");
        leadRecord.Nationality__c = component.find("iNationality").get("v.value");

        
       

        var productRecords = component.get("v.productInterestList");
        var productInterest =  productRecords[0].Financial_Product__c; 
        
        
        var assignLead = component.get("v.isAssignRetailLead");
        var routeLead = component.get("v.isRouteRetailLead");
        var assignLeadToUser = component.get("v.isAssignToUserRetailLead");

        var serviceGroupRecord = component.get("v.serviceGroupRecord");
        
        // Added by Simangaliso Mathenjwa 8 June 2020
        var serviceGroupId2 = serviceGroupRecord.Id;
        // Added by Simangaliso Mathenjwa 8 June 2020
		var selectedUserRecord = component.get("v.selectedUserRecord");
        var	selectedUserId = selectedUserRecord.Id;

        var preferredCommunicationChannel = leadRecord.Preferred_Communication_Channel_RBB__c;
        
        var email = leadRecord.Email;
        var phone = leadRecord.Phone;
        var mobilePhone = leadRecord.MobilePhone;
        var idNumber = leadRecord.ID_Number__c;
        var idType = leadRecord.ID_Type__c;
        var salutation = leadRecord.Salutation;
        var nationality = leadRecord.Nationality__c;
        var clientId = clientRecord.ID_Number__pc;
        var clientCIF = clientRecord.CIF__c;

    

        //Validation - No Client selected
        if(!clientRecord.Name && !clientRecord.LastName){
            var toast = helper.getToast("Validation Warning", "Please search for an existing client or create a new client record", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        console.log('**leadID**', idNumber);
        console.log('**clientID**', clientId);
        console.log('**clientCIF**', clientCIF);
        
        //Validation - Do not change existing client ID
        if(clientCIF != null && (idNumber != clientId) && clientId != null){
            var toast = helper.getToast("Validation Warning", "ID Number change is not allowed, client already exists", "warning");
            component.set("v.leadRecord.ID_Number__c", clientId);
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No ID Type Selected
        if(idType == null || idType == ''){
            var toast = helper.getToast("Validation Warning", "Please select ID Type", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
		//Validation - No ID selected
        if(idNumber == null || idNumber == ''){
            var toast = helper.getToast("Validation Warning", "Please provide an ID/Passport number for your lead", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }

		if(idNumber.length != 13 && idType == 'SA ID Number'){
            var toast = helper.getToast("Validation Warning", "Invalid length for a South African ID number", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }

		//Validation - No Numeric ID number
        if(/\D/.test(idNumber) && idType == 'SA ID Number'){
            var toast = helper.getToast("Validation Warning", "South African ID Number must be only numeric", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - Passport and nationality
        var idNumValidation = parseInt(idNumber.substr(6,1));
       
        
        if(idNumValidation > 4  && idType == 'SA ID Number' ){
            if(salutation == 'Mrs.' || salutation == 'Ms.'){
                var toast = helper.getToast("Validation Warning", "The salutation cant be Mrs./Ms. for this ID number", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        if(idNumValidation <= 4  && idType == 'SA ID Number' ){
            if(salutation == 'Mr.'){
                var toast = helper.getToast("Validation Warning", "The salutation cant be Mr. for this ID number", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        //Validation - Passpoot validation
        var regexPassport = /[^a-zA-Z0-9 ]/;
        
        
        if(!regexPassport.test(idNumber) == false && idType == 'Passport'){
            var toast = helper.getToast("Validation Warning", "Invalid passport number. No Special Characters Allowed", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No Nationality selected
        if(nationality == null || nationality == ''){
            var toast = helper.getToast("Validation Warning", "Please select Nationality", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - Passport and nationality
        if(idType == 'Passport' && nationality == 'South Africa'){
            var toast = helper.getToast("Validation Warning", "Please choose a different nationality for a passport", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
	     }
        
        //Validation - Passport and nationality
        if(idType == 'SA ID Number' && nationality != 'South Africa'){
            var toast = helper.getToast("Validation Warning", "Please choose a South African Nationality for a SA ID Number", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
	     }
        //Validation - No Communication Channel Selected
        console.log('email ==> '+ email);
        console.log('phone ==> '+ phone);
        console.log('mobilePhone ==> '+ mobilePhone);
        console.log('preferredCommunicationChannel  ==> '+ preferredCommunicationChannel);
        if(preferredCommunicationChannel == null || preferredCommunicationChannel == '' || !preferredCommunicationChannel){
            var toast = helper.getToast("Validation Warning", "Please provide Preferred Communication Channel", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        } else{
            if (!email && preferredCommunicationChannel.includes('Email') ){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide email address", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
                
            }else if (!phone && preferredCommunicationChannel.includes('Phone')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide phone number", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
                
            }else if (!mobilePhone && preferredCommunicationChannel.includes('Mobile')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }else if (!mobilePhone && preferredCommunicationChannel.includes('SMS')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            
            }else if (!mobilePhone && preferredCommunicationChannel.includes('Whatsapp')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            
            }else if (!email && preferredCommunicationChannel.includes('In-App')){
                var toast = helper.getToast("Preferred Communication Channel", "Please provide email address", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
        }
        
        
		//Validation - Incorrect phone number length
        if(phone){
            if(phone.length != 10){
                var toast = helper.getToast("Preferred Communication Channel", "Phone number length must be 10", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
        	}
        }
		
        //Validation - Incorrect phone characters
        if(phone){
            if(/\D/.test(phone)){
                var toast = helper.getToast("Preferred Communication Channel", "Phone number must be only numeric", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        
        //Validation - Incorrect mobile number length
        if(mobilePhone){
            if(mobilePhone.length != 10 ){
                var toast = helper.getToast("Preferred Communication Channel", "Mobile number length must be 10", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
        	}
        }
        
        //Validation - Incorrect phone characters
        if(mobilePhone){
           if(/\D/.test(mobilePhone)){
                var toast = helper.getToast("Preferred Communication Channel", "Mobile number must be only numeric", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
        	} 
        }
        //Validation - No product selected
        if(productInterest == null || productInterest == ''){
            var toast = helper.getToast("Validation Warning", "Please provide first product interest for your lead", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        //Validation - No Lead Source selected
        if(!leadSource){
            var toast = helper.getToast("Validation Warning", "Please provide a lead source", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        console.log('**assign**', assignLead);
        console.log('**route**', routeLead);
        console.log('**assignToUser**', assignLeadToUser);
    
        //Validation - No Service Group selected
        if(routeLead == true && (serviceGroupId2 == null || serviceGroupId2 == '')){
            var toast = helper.getToast("Validation Warning", "Please provide branch for your lead", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        if(assignLeadToUser == true && (selectedUserId == null || selectedUserId == '')){
            var toast = helper.getToast("Validation Warning", "Please provide a colleague to assign your lead to", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
            
		if(assignLeadToUser == true && (serviceGroupId2 == null || serviceGroupId2 == '')){
            var toast = helper.getToast("Validation Warning", "Please provide a branch for your colleague", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        if(assignLeadToUser == true && (serviceGroupId2 != null || serviceGroupId2 != '')){
            
            var selectedUserServiceGroupIds = component.get("v.selectedUserServiceGroupIds"); 
            
            console.log("***selectedServiceGroupId****", serviceGroupId2);
            console.log("***selectedUserServiceGroupIds****", selectedUserServiceGroupIds);
            
            if(!selectedUserServiceGroupIds.includes(serviceGroupId2)){
                var toast = helper.getToast("Validation Error", "The selected colleague does not belong to the selected branch", "Error");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        
        if(assignLeadToUser == true && (selectedUserId != null || selectedUserId != '')){
            leadRecord.OwnerId = selectedUserId;
        }
        //Calling the Apex Function to create a Lead
        var action = component.get("c.createNewRetailLead");
        
        //Setting the Apex Parameter
        action.setParams({
            "leadRecord" : leadRecord,
            "accountRecord" : clientRecord,
            "productInterestList" : productRecords,
            "serviceGroupRecord" : serviceGroupRecord,
            "routeLead" : routeLead
        });
        
        //Setting the Callback
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log('******ReturnVal***', response.getReturnValue());
                
                if(response.getReturnValue() != 'No Service Group Found'){
                    // show success notification
                    var toastEvent = helper.getToast("Success!", "Lead successfully created in Salesforce", "Success");
                    helper.hideSpinner(component);
                    toastEvent.fire();
                    
                    //Set LeadId 
                    var leadRecordId = response.getReturnValue();
                    
                    //Navigate to Lead 
                    if(assignLead == true) {
                        helper.closeFocusedTabAndOpenNewTab(component, leadRecordId);
                    } else if (routeLead == true || assignLeadToUser == true) {
                        helper.closeFocusedTab(component);
                        helper.navHome(component, event, helper);
                    } 
                }else{
                    var toast = helper.getToast("Branch Not Found", "You are currently not assigned to a branch, please provide branch for your lead", "Error");
                    helper.hideSpinner(component);
                    toast.fire();
                    return null;
                }
                
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
                
                if (message.includes('DUPLICATES_DETECTED')) {
                    message = '	New lead cannot be created at this stage. This customer already has an Open/Active Lead. Please search for the customer’s lead and lease with the BM if you are not the owner of the open lead.'
                }
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            } 
        }); 
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    
    //function to create and navigate to new Retail Lead 
    saveAndNavigateToRetailLead : function(component, event, helper) {
        
        //Show spinner
        helper.showSpinner(component);
		component.set("v.isAssignRetailLead", true); 
        component.set("v.isRouteRetailLead", false);
        component.set("v.isAssignToUserRetailLead", false);
        
        //Enqueue action to create Lead
        $A.enqueueAction(component.get('c.createRetailLead'));
        helper.hideSpinner(component);
    },

    //function to create and route new Retail Lead 
    routeRetailLead : function(component, event, helper) {
        
        //Show spinner
        helper.showSpinner(component);
        component.set("v.isAssignRetailLead", false);
        component.set("v.isRouteRetailLead", true);  
        component.set("v.isAssignToUserRetailLead", false);
        
        //Enqueue action to create Lead
        $A.enqueueAction(component.get('c.createRetailLead'));
        helper.hideSpinner(component);
        
    },
    
    
    //function to create and assign new Retail Lead to User
    assignRetailLeadToUser : function(component, event, helper) {
        
        //Show spinner
        helper.showSpinner(component);
        component.set("v.isAssignRetailLead", false);
		component.set("v.isRouteRetailLead", false);  
        component.set("v.isAssignToUserRetailLead", true);
		var defaultRecordType = component.get("v.defaultRecordType");
        //Enqueue action to create Lead
        if(defaultRecordType == 'Direct_Delivery_Sales_Lead')
            $A.enqueueAction(component.get('c.saveDDLead'));
        else
        	$A.enqueueAction(component.get('c.createRetailLead'));
        helper.hideSpinner(component);
    },
      
    //Get the Service Group record based on colleague selected
    getSelectedUserServiceGroup : function(component, event, helper) {
        
        var selectedUserId = component.get("v.selectedUserId");
        var currentUserGroups = component.get('v.userPublicGroupNames');
        
        console.log('***selectedUserId***', selectedUserId);
        console.log('***currentUserGroups***', currentUserGroups);
        
        helper.showSpinner(component);
                
        if(selectedUserId != ''){
            
            var action = component.get("c.getSelectedUserServiceGroupIds"); 
            
            action.setParams({
                "userId": selectedUserId,
                "groupNames": currentUserGroups
            });
            
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if (component.isValid() && state === "SUCCESS") {
                    component.set("v.selectedUserServiceGroupIds", response.getReturnValue());
                    
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
        }
    },
    
    //function to add new object Row in ProductInterest List 
    addNewRow: function(component, event, helper) {
        
        //Call the "createProductInterestData" helper method for add new Object Row to List  
        helper.createProductInterestData(component, event);
    },
 
    //function to remove deleted row item 
    removeDeletedRow: function(component, event, helper) {
        
        //Get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        var allRowsList = component.get("v.productInterestList");
        allRowsList.splice(index, 1);
        
        //Set the productInterestList after remove selected row element  
        component.set("v.productInterestList", allRowsList);
    },
    
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   }, 
    
   //Ading the logic for direct delivery lead creation 

   getFinancialProductdd :function(component, event, helper) {
       var leadRec = component.get("v.leadRecord");
    	component.set("v.financialProductRecord", '');
    	component.set("v.showExtenderCoverFields",false);
    	component.set("v.showCardLifeFields",false);
   		var productInterest =  component.find("ddFinancialProduct").get("v.value"); 
    	console.log('productInterest '+JSON.stringify(productInterest));
    	if($A.util.isEmpty(productInterest)==false){
        	var action = component.get("c.findFinancialProduct"); 
        	action.setParams({
            	"financialProductId" : productInterest
        	});

        	action.setCallback(this, function(response) {
     
            	var state = response.getState();
             
                if (component.isValid() && state === "SUCCESS") {
                    var retVal = response.getReturnValue();
                    var prdslecName = retVal.Name;
                    console.log('prdslecName '+prdslecName);
                    if(prdslecName == 'Extended Cover'){
                        component.set("v.showExtenderCoverFields",true);
                        component.set("v.showCardLifeFields",false);
                        component.set("v.showSourcefields",false);
                        component.set("v.showSTISourcefields",false);
                        component.set("v.showColleague",true);
                        helper.fetchPickListVal(component, 'DD_Source__c', 'DDInboundSource');
                        
                    }else if(prdslecName =='Card Life'){
                        component.set("v.showExtenderCoverFields",false);
                        component.set("v.showCardLifeFields",true);
                        component.set("v.showSourcefields",true);
                        component.set("v.showSTISourcefields",false);
                        component.set("v.showColleague",true);
                        helper.fetchPickListVal(component, 'DD_Source__c', 'DDInboundSource');
                        
                    }else if(prdslecName =='AVAF Credit Life'){
                        component.set("v.showSourcefields",false);
                        component.set("v.showExtenderCoverFields",true);
                        component.set("v.showCardLifeFields",false);
                        component.set("v.showSTISourcefields",false);
                        component.set("v.showColleague",true);
                        helper.fetchPickListVal(component, 'DD_Source__c', 'DDInboundSource');
                        
                    }else if(prdslecName =='STI'){
                        component.set("v.showSTISourcefields",true);
                        component.set("v.showSourcefields",false);
                        component.set("v.showExtenderCoverFields",false);
                        component.set("v.showCardLifeFields",false);
                        component.set("v.showColleague",false);
                        helper.fetchPickListVal(component, 'DD_Source__c', 'DDSTISource');
                        
                    }else{
                        component.set("v.showSTISourcefields",false);
                        component.set("v.showExtenderCoverFields",false);
                        component.set("v.showCardLifeFields",false);
                        component.set("v.showSourcefields",true);
                        component.set("v.showColleague",true);
                        helper.fetchPickListVal(component, 'DD_Source__c', 'DDInboundSource');
                    }
                    
                    console.log('response.getReturnValue'+JSON.stringify(response.getReturnValue()))
                    component.set("v.financialProductRecord", response.getReturnValue());
                    component.set("v.bDisabledSourceFld", false);
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
                }
           });
            // Send action off to be executed
            $A.enqueueAction(action);
    }
       	else{
           	component.set("v.bDisabledDependentFld" , true);
            component.set("v.bDisabledSourceFld" , true);
            component.set("v.showBSSAFieldBool" , false);
            component.set("v.sourceOptions", ['--- None ---']);
            component.set("v.subsourceOptions", ['--- None ---']);
       	}
},

   routeDDLead : function(component, event, helper) {
    helper.showSpinner(component);
    component.set("v.isRouteRetailLead", true);  
    $A.enqueueAction(component.get('c.saveDDLead'));
    helper.hideSpinner(component);

	},
	showBSSAField : function(component, event, helper) {
        
    var depnedentFieldMap = component.get("v.depnedentFieldMap");
    //var selctedPick =component.find("STISource").get("v.value");//SS&E(BSSA)
    var selctedPick =component.get("v.leadRecord.DD_Source__c");;
    console.log('selctedPick',selctedPick);
    if(selctedPick =='SS&E' || selctedPick =='Inbound CLI' || selctedPick =='Absa Life'){
        component.set("v.showBSSAFieldBool",true);
        helper.fetchSiteCodePickListVal(component, 'DD_Source__c', selctedPick);
    }else{
        component.set("v.showBSSAFieldBool",false);
    	}
        if(selctedPick !== '--- None ---' && selctedPick != '' && selctedPick != undefined){
            var ListOfDependentFields = depnedentFieldMap[selctedPick];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.subsourceOptions", ['--- None ---']);
            }  
        }
        else {
            component.set("v.subsourceOptions", ['--- None ---']);
            component.set("v.siteCodeOptions", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
            
	},
	handleSelectedLookUpRecord: function(component, event, helper) {
        
         console.log("Inside handleSelectedLookUpRecord");
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.leadRecord.Parent_Contact_Id__c", component.get("v.selectedLookUpRecord.Id"));
        component.set("v.leadRecord.ContactName__c", component.get("v.selectedLookUpRecord.Id"));
        component.set("v.leadRecord.Salutation", component.get("v.selectedLookUpRecord.Salutation"));
        component.set("v.leadRecord.FirstName", component.get("v.selectedLookUpRecord.FirstName"));
        component.set("v.leadRecord.LastName", component.get("v.selectedLookUpRecord.LastName"));
        component.set("v.leadRecord.DD_Initials__c", component.get("v.selectedLookUpRecord.Initials__c"));
        component.set("v.leadRecord.Phone", component.get("v.selectedLookUpRecord.Phone"));
        component.set("v.leadRecord.MobilePhone", component.get("v.selectedLookUpRecord.MobilePhone"));
        component.set("v.leadRecord.DD_Date_of_Birth__c", component.get("v.selectedLookUpRecord.Birthdate"));
        component.set("v.leadRecord.Email", component.get("v.selectedLookUpRecord.Email"));
        component.set("v.leadRecord.ID_Number__c", component.get("v.selectedLookUpRecord.ID_Number__c"));
        component.set("v.leadRecord.ID_Type__c", component.get("v.selectedLookUpRecord.ID_Type__c"));
        component.set("v.leadRecord.Alternate_Phone1__c", component.get("v.selectedLookUpRecord.Alternate_Phone1__c"));
        component.set("v.leadRecord.Alternate_Phone2__c", component.get("v.selectedLookUpRecord.Alternate_Phone2__c"));
        component.set("v.leadRecord.Alternate_Phone3__c", component.get("v.selectedLookUpRecord.Alternate_Phone3__c"));
        
       
   },
   //copy the physical address to postal address - Short term insurce 
   copyAddress: function(component, event, helper) {

    var leadRecord = component.get("v.leadRecord");
    
    component.set("v.leadRecord.Postal_Address_Line_1__c",leadRecord.Physical_address_line_1__c);
    component.set("v.leadRecord.Postal_Address_Line_2__c",leadRecord.Physical_address_Line_2__c);
    component.set("v.leadRecord.Postal_Address_Suburb__c",leadRecord.Physical_address_Suburb__c);
    component.set("v.leadRecord.Postal_Address_City__c",leadRecord.Physical_address_City__c);
   
    component.find("postalCodeLookUp").set("v.value", component.find("PhysicalCodeLookUp").get("v.value"));
    component.set("v.leadRecord.Postal_Address_Country__c",leadRecord.Physical_address_Country__c);
    component.set("v.postalCodeId",component.find("postalCodeLookUp").get("v.value"));
},
 //added to handle the postal code changes - Short term insurce 
 handlePostalChange: function(component, event, helper) {
        
    console.log('lookupValue : '+ component.find("postalCodeLookUp").get("v.value"));
    var postalCode = component.find("postalCodeLookUp").get("v.value");

    component.set("v.postalCodeId",postalCode);
    var action = component.get("c.findPostalCodeRecord"); 
    
        action.setParams({
            "postalCodeId" :postalCode
        });
    
      action.setCallback(this, function(response) { 
        var state = response.getState(); 
     
        if (state === "SUCCESS") { 
            
            var leadAddress = response.getReturnValue();
            //console.log('###leadRecord : '+ JSON.stringify(leadRecord));
            
            component.set("v.leadRecord.Postal_Address_Suburb__c",leadAddress.Suburb__c);
            component.set("v.leadRecord.Postal_Address_City__c",leadAddress.Area__c);
            
    
        } 
        
    }); 
    
    $A.enqueueAction(action); 
},
   //added to handle the postal code changes - Short Term insurance 
   handlePhysicalChange: function(component, event, helper) {
        
    component.set("v.physicalCodeId", component.find("PhysicalCodeLookUp").get("v.value"));

    var action = component.get("c.findPostalCodeRecord"); 
        action.setParams({
            "postalCodeId" :component.get("v.physicalCodeId")
        });
    
      action.setCallback(this, function(response) { 
        var state = response.getState(); 
     
        if (state === "SUCCESS") { 
           
            var leadAddress = response.getReturnValue();
            
            
            component.set("v.leadRecord.Physical_address_Suburb__c",leadAddress.Suburb__c);
            component.set("v.leadRecord.Physical_address_City__c",leadAddress.Area__c);
            
    
        } 
        
    }); 
    
    $A.enqueueAction(action); 
},
    
   saveDDLead : function(component, event, helper) {
   // console.log('clientRecord '+JSON.stringify(component.get("v.clientRecord")));
       console.log('DD leadRecord>>>> '+JSON.stringify(component.get("v.leadRecord")));
       helper.showSpinner(component);
       var selectedUserId;
       component.set("v.butonDisable",true);
       var leadRecord = component.get("v.leadRecord");
       var clientRecord = component.get("v.clientRecord");
       // = component.find("ddInitial").get("v.value");
       var productInterest = component.get("v.financialProductRecord");
       console.log('****'+JSON.stringify(productInterest));
       var routeLead = component.get("v.isRouteRetailLead");
       var AssignLead = component.get("v.isAssignToUserRetailLead");
       console.log('irrref'+JSON.stringify(component.find("iReferrer")));
       if(component.find("iReferrer")!=undefined){ //added newly by pranav for hide the collegue functionality for sti product
         selectedUserId = component.find("iReferrer").get("v.value");  
       }
        
       var serviceGroupRecord = component.get("v.serviceGroupRecord");
       var serviceGroupId2 = serviceGroupRecord.Id;

       //leadRecord.ID_Type__c = component.find("iIdType").get("v.value");
        var phone = leadRecord.Phone;
        var leadSource = leadRecord.DD_Source__c;
        var leadSubSource = leadRecord.DD_Lead_Sub_Source__c;
        var mobilePhone = leadRecord.MobilePhone;
        var preferredCommunicationChannel = leadRecord.Preferred_Communication_Channel__c;
        var clientId = clientRecord.ID_Number__pc;
        var clientCIF = clientRecord.CIF__c;
        var gender=leadRecord.DD_Gender__c;
        var dob = leadRecord.DD_Date_of_Birth__c;
        var idNumber = leadRecord.ID_Number__c;
        var idType = leadRecord.ID_Type__c;
        var initials =leadRecord.DD_Initials__c;
        var email = leadRecord.Email;
        var AVAFaccnum = leadRecord.DD_AVAF_Account_Number__c;
        var branchemployeeNumber = leadRecord.Branch_Employee_Number__c;
        var vehcleDesc =leadRecord.DD_Vehicle_Description__c;
        var outstndingCap =leadRecord.Outstanding_Capital__c;
        var marketval = leadRecord.DD_Market_Value__c;
        var sourceIncome = leadRecord.DD_Source_of_Income__c;
        var sourceFund = leadRecord.DD_Source_of_Funds__c;
        var absaCredCardNum =leadRecord.DD_Absa_Credit_card_Number__c;
        var creditLimit = leadRecord.DD_Absa_Credit_Card_Limit__c	;
        var firstName = leadRecord.FirstName;
        var salutation = component.find("iSalutation").get("v.value");
        var maritalStatus = leadRecord.Marital_status__c;
        var maritalcontract = leadRecord.DD_Marital_Contract_Type__c;
        var selectedProductname = component.get("v.financialProductRecord").Name;
        var validCheck = component.get("v.showBSSAFieldBool");

        var siteCode = leadRecord.BSSA_Site_Code__c;
        console.log('DD Salutation>>>>' + component.find("iSalutation").get("v.value"));
        leadRecord.Salutation = component.find("iSalutation").get("v.value");


       //Validation - No Client selected
       if(!clientRecord.Name && !clientRecord.LastName){
        var toast = helper.getToast("Validation Warning", "Please search for an existing client or create a new client record", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
       
       //Validation - No Marital Status selected
       if(selectedProductname != 'Extended Cover' && selectedProductname != 'STI' && (maritalStatus == '' || maritalStatus == null)){
        var toast = helper.getToast("Validation Warning", "Please provide Marital Status.", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
       
       //Validation - No Marital Contract selected
       if(maritalStatus == 'Married' && (maritalcontract == null || maritalcontract == '')){
        var toast = helper.getToast("Validation Warning", "Please provide Marital Contract Type.", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

     //Validation - Do not change existing client ID
     if(clientCIF != null && (idNumber != clientId) && clientId != null){
        var toast = helper.getToast("Validation Warning", "ID Number change is not allowed, client already exists", "warning");
        component.set("v.leadRecord.ID_Number__c", clientId);
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    //Validation - if no firstName
    if(firstName =='' || firstName == null){
        var toast = helper.getToast("Validation Warning", "Please provide First Name", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
       
       //Validation - if no salutation
    if(salutation =='' || salutation == null){
        var toast = helper.getToast("Validation Warning", "Please provide Salutation.", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
       //Validation - if no branch employee number
    if(selectedProductname != 'AVAF Credit Life' && selectedProductname != 'Extended Cover' && selectedProductname != 'STI' && (branchemployeeNumber =='' || branchemployeeNumber == null) && leadSource != 'STI'){
        var toast = helper.getToast("Validation Warning", "Please provide Branch Employee Number.", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
       
       //Validation - if no initials
    if(initials =='' || initials == null){
        var toast = helper.getToast("Validation Warning", "Please provide Initials", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    //Validation - if no dob
    if(dob =='' || dob == null){
        var toast = helper.getToast("Validation Warning", "Please provide Date of Birth", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    //Validation - if no gender
    if(gender =='' || gender == null){
        var toast = helper.getToast("Validation Warning", "Please provide gender", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
    //Validation - No ID Type Selected
    if(idType == null || idType == ''){
        var toast = helper.getToast("Validation Warning", "Please select ID Type", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    //Validation - No sourceIncome Selected
    if(selectedProductname !='Extended Cover' && selectedProductname !='AVAF Credit Life' && selectedProductname != 'STI' && (sourceIncome == null || sourceIncome == '')){
        var toast = helper.getToast("Validation Warning", "Please select Source Of Income", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    //Validation - No SourceFund Selected
    if(selectedProductname !='Extended Cover' && selectedProductname !='AVAF Credit Life' && selectedProductname != 'STI' && (!sourceFund || sourceFund == null || sourceFund == '')){
        var toast = helper.getToast("Validation Warning", "Please select Source of Fund", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
   if(AssignLead == true && (selectedUserId == null || selectedUserId == '')){
            var toast = helper.getToast("Validation Warning", "Please provide a colleague to assign your lead to", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
   }
    
    //Validation - No ID selected
    if(idNumber == null || idNumber == ''){
        var toast = helper.getToast("Validation Warning", "Please provide an ID/Passport number for your lead", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    if(idNumber.length != 13 && idType == 'SA ID Number'){
        var toast = helper.getToast("Validation Warning", "Invalid length for a South African ID number", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    //Validation - No Numeric ID number
    if(/\D/.test(idNumber) && idType == 'SA ID Number'){
        var toast = helper.getToast("Validation Warning", "South African ID Number must be only numeric", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    if(selectedProductname =='Road Cover' && (preferredCommunicationChannel == null || preferredCommunicationChannel == '' || !preferredCommunicationChannel)){
        var toast = helper.getToast("Validation Warning", "Please provide Preferred Communication Channel", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
     } else if(preferredCommunicationChannel != null && preferredCommunicationChannel != ''){
        if (!email && preferredCommunicationChannel.includes('Email') ){
            var toast = helper.getToast("Preferred Communication Channel", "Please provide email address", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
            
        }else if (!phone && preferredCommunicationChannel.includes('Phone')){
            var toast = helper.getToast("Preferred Communication Channel", "Please provide phone number", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
            
        }else if (!mobilePhone && preferredCommunicationChannel.includes('Mobile')){
            var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }else if (!mobilePhone && preferredCommunicationChannel.includes('SMS')){
            var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        
        }else if (!mobilePhone && preferredCommunicationChannel.includes('Whatsapp')){
            var toast = helper.getToast("Preferred Communication Channel", "Please provide mobile phone", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        
        }else if (!email && preferredCommunicationChannel.includes('In-App')){
            var toast = helper.getToast("Preferred Communication Channel", "Please provide email address", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }
        
    }
   // console.log('productInterest '+productInterest);
   // console.log('productInterest '+JSON.stringify(productInterest));

    if(!productInterest || productInterest.Id == null || productInterest.Id == ''){
        var toast = helper.getToast("Validation Warning", "Please provide first product interest for your lead", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
    
    //Validation - No Lead Source selected
    if(selectedProductname !='Extended Cover' && selectedProductname !='AVAF Credit Life' && !leadSource){
        var toast = helper.getToast("Validation Warning", "Please provide a lead source", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }//createNewDirectDeliveryLead

    //Validation - No Lead Sub Source selected
    if(selectedProductname !='Extended Cover' && selectedProductname !='AVAF Credit Life' && !leadSubSource && leadSource != 'STI'){
        var toast = helper.getToast("Validation Warning", "Please provide a lead Sub source", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
           
       //Validation - No Branch Employee Number selected
    if(selectedProductname =='STI' && (branchemployeeNumber =='' || branchemployeeNumber == null) && (leadSource == 'Branch' || leadSource == 'Life Adviser')){
        var toast = helper.getToast("Validation Warning", "Please provide Branch Employee Number", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
       
       //Validation - No Branch Employee Number selected
       if(selectedProductname =='STI' && (leadSource == 'Branch' || leadSource == 'Life Adviser') && (serviceGroupId2 == null || serviceGroupId2 == '')){
        var toast = helper.getToast("Validation Warning", "Please provide Branch for your Lead.", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
    //createNewDirectDeliveryLead
    //validations based on the product selected
    if(selectedProductname =='Extended Cover' || selectedProductname =='AVAF Credit Life' ){

        //Validation - No AVAF Number
    if(AVAFaccnum == null || AVAFaccnum == ''){
        var toast = helper.getToast("Validation Warning", "Please provide a AVAF Account Number", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

     //Validation - No vehicle Description
     if(vehcleDesc == null || vehcleDesc == ''){
        var toast = helper.getToast("Validation Warning", "Please provide a  Vehicle Description", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    //Validation - No Outstanding Capital
    if(outstndingCap == null || outstndingCap == ''){
        var toast = helper.getToast("Validation Warning", "Please provide a  Outstanding Capital", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }

    //Validation - No Market Value
    if(marketval == null || marketval == ''){
        var toast = helper.getToast("Validation Warning", "Please provide a  Market Value", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }
    //Validation - No Market Value
    if( marketval != '' && marketval > 1500000){
        var toast = helper.getToast("Validation Warning", "Please provide a  Market Value less than 1,500,000", "warning");
        helper.hideSpinner(component);
        component.set("v.butonDisable",false);
        toast.fire();
        return null;
    }


    }else if(selectedProductname =='Card Life'){

        //Validation - No Absa Credit card Number
        if(absaCredCardNum == null || absaCredCardNum == ''){
            var toast = helper.getToast("Validation Warning", "Please provide a  Absa Credit card Number", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }

        //validation -no credit Limit 
        if(creditLimit == null || creditLimit == ''){
            var toast = helper.getToast("Validation Warning", "Please provide a  credit card Limit", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }
    }
		//validCheck
       if(selectedProductname !='Extended Cover' && selectedProductname !='AVAF Credit Life' && selectedProductname !='STI' && leadSource != 'STI'){
        if(validCheck == true && (siteCode == null || siteCode == '')){
            var toast = helper.getToast("Validation Warning", "Please provide BBSA site code for  lead", "warning");
            helper.hideSpinner(component);
            component.set("v.butonDisable",false);
            toast.fire();
            return null;
        }
    	if(validCheck == false && (serviceGroupId2 == null || serviceGroupId2 == '')){
        	var toast = helper.getToast("Validation Warning", "Please provide branch for your lead", "warning");
        	helper.hideSpinner(component);
        	component.set("v.butonDisable",false);
        	toast.fire();
        	return null;
    		}
       }
    if(serviceGroupId2!=null){
        leadRecord.Service_Group_Search__c=serviceGroupId2;
        component.set("v.leadRecord",leadRecord);
    }
    var action =component.get("c.duplicateCheck");
    action.setParams({
        "idnumber" : idNumber,
        "financialProductRecord" : productInterest

    });
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {

            var isExistingLead = response.getReturnValue();
            if(isExistingLead == true){
                //throw duplicate error message
               var message= 'There is an open lead already existing with the same Id number'
                var toastEvent = helper.getToast("Duplicate Error!!!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
                component.set("v.butonDisable",false);


            }else if(isExistingLead == false){
                //creation of lead process
                var action = component.get("c.createNewDirectDeliveryLead");
                var isRoute = component.get("v.isRouteRetailLead");
                if(isRoute == true){
                    action.setParams({
                        "leadRecord" : leadRecord,
                       "relatedClient" : clientRecord,
                        "financialProductRecord" : productInterest,
                       "campaignName" : null,
                        "isReferral" : false,
                        "userOrQueue" :null
                    });
                }else if(AssignLead == true){
                    action.setParams({
                        "leadRecord" : leadRecord,
                        "relatedClient" : clientRecord,
                         "financialProductRecord" : productInterest,
                        "campaignName" : null,
                         "isReferral" : false,
                         "userOrQueue" :selectedUserId
                    });
                }else{
                    action.setParams({
                        "leadRecord" : leadRecord,
                        "relatedClient" : clientRecord,
                         "financialProductRecord" : productInterest,
                         "campaignName" : null,
                         "isReferral" : false,
                         "userOrQueue" :$A.get("$SObjectType.CurrentUser.Id")
                    });
                }
                
            
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var leadRecordId = response.getReturnValue().Id;
                        console.log('res '+JSON.stringify(response.getReturnValue()));
                        //var toastEvent = helper.getToast("Success!", "Lead successfully created in Salesforce", "Success");
                           // toastEvent.fire();
                            helper.hideSpinner(component);
                            component.set("v.butonDisable",false);
                            //Navigate to Lead 
                            helper.closeFocusedTabAndOpenNewTab(component,leadRecordId);
                         
                    }else if(state === "ERROR"){
                            
                        var message = '';
                        var errors = response.getError();
                        console.log('errors== '+JSON.stringify(errors));
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
                        
                        if (message.includes('DUPLICATES_DETECTED')) {
                            message = 'Duplicate Contact detected, please use a diffrent Email Address or search for an existing Contact'
                        }
                        
                        // show Error message
                        var toastEvent = helper.getToast("Error!!!", message, "Error");
                        toastEvent.fire();
                        
                        helper.hideSpinner(component);
                        component.set("v.butonDisable",false);
                    } 
            
                });
                $A.enqueueAction(action);




            }//creation of lead process ends
           
        }else if(state === "ERROR"){
            helper.hideSpinner(component);
                component.set("v.butonDisable",false);

        }

    });
     $A.enqueueAction(action);
    

    //--dup check ends

   }//method end
})