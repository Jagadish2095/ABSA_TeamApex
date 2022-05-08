({
    doInit:function(component, event, helper)
    {
        component.set("v.showSpinner", true);
        helper.getSTIRecordType(component);
        var objectName;
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userid",userId);
        
        var opportunityType = component.get("v.opportunityType");
       
        if(opportunityType === 'Direct Delivery')
        {
            component.set("v.isVirtualAdvisorOpportunity", false);
        }
        else
        {
           component.set("v.isVirtualAdvisorOpportunity", true);
        }
        /*Commented by Divya on 22-9-2021
         * if(opportunityType === 'Investment Opportunity')
        {
           component.set("v.investOpportunity", true); 
        }*/
        console.log("Is Virtual Advisor", component.get("v.isVirtualAdvisorOpportunity"));
        
        var firstAction = component.get("c.getObjectName");
        firstAction.setParams({
            "recordId": component.get("v.recordId")
        });
        
        firstAction.setCallback(this, function(response){
            var state = response.getState();
            console.log('state ' + state);
            
            if(state === "SUCCESS")
            {
                objectName = response.getReturnValue();
                component.set("v.objectName", objectName);
                console.log('objectName ' + objectName);
                
                if(objectName === "Lead" || objectName === "Opportunity")
                {
                    var action = component.get("c.getOpportunityDetails");
                    action.setParams({
                        "opportunityId": component.get("v.recordId")
                    });
                    
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        
                        if (state === "SUCCESS") {
                            var OpportunitywithAccount = response.getReturnValue();
                            if(OpportunitywithAccount != null)
                            {
                                if(OpportunitywithAccount.isIndClient === true){
                                    component.set("v.isIndvClient",true);
                                    component.set("v.referralLeadVASTI.Salutation", OpportunitywithAccount.Opp.Account.Salutation);
                                    component.set("v.referralLeadVASTI.FirstName", OpportunitywithAccount.Opp.Account.FirstName);
                                    component.set("v.referralLeadVASTI.LastName", OpportunitywithAccount.Opp.Account.LastName);
                                    component.set("v.referralLeadVASTI.Nationality__c", OpportunitywithAccount.Opp.Account.Nationality__pc);
                                    component.set("v.referralLeadVASTI.Email", OpportunitywithAccount.Opp.Account.PersonEmail);
                                    component.set("v.referralLeadVASTI.Phone", OpportunitywithAccount.Opp.Account.Phone);
                                    component.set("v.referralLeadVASTI.MobilePhone", OpportunitywithAccount.Opp.Account.PersonMobilePhone);
                                    component.set("v.referralLeadVASTI.ID_Number__c", OpportunitywithAccount.Opp.Account.ID_Number__pc);
                                    component.set("v.referralLeadVASTI.CIF__c", OpportunitywithAccount.Opp.Account.CIF__c);
                                    component.set("v.referralLeadVASTI.ID_Type__c", OpportunitywithAccount.Opp.Account.ID_Type__pc);
                                    component.set("v.referralLeadVASTI.Alternate_Phone1__c", OpportunitywithAccount.Opp.Account.Alternate_Phone1__pc);
                                    component.set("v.referralLeadVASTI.Alternate_Phone2__c", OpportunitywithAccount.Opp.Account.Alternate_Phone2__pc);
                                    component.set("v.referralLeadVASTI.Alternate_Phone3__c", OpportunitywithAccount.Opp.Account.Alternate_Phone3__pc);
                                    component.set("v.referralLeadVASTI.DD_Initials__c", OpportunitywithAccount.Opp.Account.Initials__pc);
                                    component.set("v.referralLeadVASTI.DD_Date_of_Birth__c", OpportunitywithAccount.Opp.Account.PersonBirthdate);
                                    component.set("v.referralLeadVASTI.Parent_Account__c", OpportunitywithAccount.Opp.Account.Id);
                                }else{
                                    component.set("v.isIndvClient",false);
                                    component.set("v.referralLeadVASTI.Parent_Account__c", OpportunitywithAccount.Opp.Account.Id);
                                    component.set("v.referralLeadVASTI.Company", OpportunitywithAccount.Opp.Account.Name);
                                    component.set("v.referralLeadVASTI.Company_Registration_Number__c", OpportunitywithAccount.Opp.Account.Company_Registration_Number__c);
                                    component.set("v.referralLeadVASTI.CIF__c", OpportunitywithAccount.Opp.Account.CIF__c);
                                }
                                
                                component.set("v.opportunityDetails", OpportunitywithAccount.Opp);
                                component.set("v.accountIdnumber", OpportunitywithAccount.Opp.ID_Number__c);
                                component.set("v.accountAVAFNumber", OpportunitywithAccount.Opp.AVAF_Account_Number__c);
                                component.set("v.showDetails", true);
                                component.set("v.opportunityType", OpportunitywithAccount.Opp.Opportunity_Record_Type_Name__c);
                                //Added By Divya
                                //Commented by Divya on 22-9-2021
                                //component.set("v.isReferedcompleted",OpportunitywithAccount.Opp.Is_Referred_Sys__c); 
                                //console.log('@@'+opportunityType);
                               // if(component.get("v.opportunityType") == 'Direct Delivery Sales Opportunity'){
                                  //  component.set("v.isVirtualAdvisorOpportunity", false);
                                //}else{
                                   // component.set("v.isVirtualAdvisorOpportunity", true);
                             //   }
                                
                                if(objectName === "Opportunity")
                                {
                                    component.set('v.showSpinner', true);
                                    component.set('v.isOpen', false);
                                    component.set("v.showDetails", true);
                                    component.set('v.showSpinner', false);
                                    
                                    console.log("Opportunity Record");
                                }
                            }
                        }
                        
                        component.set("v.showSpinner", false);
                    });
                    
                    var action1 = component.get("c.getUserName");
                    action1.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var result = response.getReturnValue();
                            component.set("v.currentUserName", result);
                        }
                    });
                    
                    $A.enqueueAction(action1);
                    $A.enqueueAction(action);
                }
                else if(objectName === "Case")
                {
                   component.set('v.showSpinner', true);
                    component.set('v.isCaseOpen', false);
                    component.set("v.showDetails", true);
                    component.set('v.showSpinner', false);                    
                    console.log("Case Record");
                    var action = component.get('c.getCaseDetails'); 
                    action.setParams({
                        "caseId" : component.get("v.recordId") 
                    });
                    action.setCallback(this, function(a){
                	var state = a.getState(); // get the response state
                    if(state == 'SUCCESS') {
                        component.set('v.referralCase', a.getReturnValue());                        
                        component.set('v.referralLead.ID_Number__c', a.getReturnValue().Customer_ID__c);
                        component.set('v.referralLead.DD_Agent_Who_Referred_Lead__c',a.getReturnValue().OwnerId);
                        component.set('v.caseOwner',a.getReturnValue().Owner.Name);
						component.set('v.referralLead.LastName',a.getReturnValue().Last_Name__c);
                        console.log('-->' + component.get('v.referralLead.Lastname'));
                        console.log('Success while calling apex'+JSON.stringify(a.getReturnValue()));
                    }
                    else{
                        console.log('Error while calling apex');
                    }
                });
               
                $A.enqueueAction(action);
                }
            }
        });
        $A.enqueueAction(firstAction);
    },
    
    // Added for VA STI
    getFinancialProduct : function(component, event, helper) {
        component.set("v.showSpinner", true);
        
        //Get Case Type
        var action = component.get("c.findFinancialProduct"); 
        
        var productInterest =  component.find("iFinancialProduct").get("v.value"); 
        
        if(productInterest == '' || productInterest == undefined || productInterest == null){	
            component.set("v.showSpinner", false);
        } else{
            
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
                    
                    component.set("v.showSpinner", false);
                    
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
                    helper.showToast("error", "Error", message);                                       
                    component.set("v.showSpinner", false);
                }
            });
            
            // Send action off to be executed
            $A.enqueueAction(action);
        }
    }, 
    hide : function(component,event,helper){
        
        if(component.get("v.value") == 'Hot'){
            component.set("v.selectedcampaign",'Hot Transfer');
        }
        else if(component.get("v.value") == 'Cold'){
            component.set("v.selectedcampaign",'Cold Transfer');
        }
            else if(component.get("v.value") == 'VASTI'){
                component.set("v.selectedcampaign",'VASTI Transfer');
            }
        component.set("v.referralLead.ID_Number__c",'');
        //component.set("v.referralLead.DD_Agent_Who_Referred_Lead__c",'');
        component.set("v.referralLead.OwnerId",'');
        component.set("v.referralLead.DD_AVAF_Account_Number__c",'');
        component.set("v.referralLead.DD_Convenient_Time_To_Call__c",'');
        component.set("v.referralLead.ID_Number__c",component.get("v.accountIdnumber"));
        component.set("v.referralLead.DD_AVAF_Account_Number__c",component.get("v.accountAVAFNumber"));
        component.find("referralIdopp1").get("v.body")[0].set("v.values", component.get("v.customvalue"));
        component.find("referralIdopp2").get("v.body")[0].set("v.values", component.get("v.customvalue"));
        component.set("v.referralLead.DD_Agent_Who_Referred_Lead__c",component.get("v.userid"));
    },
    handleClick2 : function(component,event,helper){
        
        var canProceed = true;
        var inputCmp1 = component.find("refnum2");
        var inputCmp2 = component.find("referralIdopp2");
        var inputCmp3 = component.find("recId2");
        var inputCmp4 = component.find("recDate2");
        var value1 = inputCmp1.get("v.value");
        var value2 = inputCmp2.get("v.value");
        var value3 = inputCmp3.get("v.value");
        var value4 = inputCmp4.get("v.value");
        console.log('@@@value'+value1);
        if (value1 == undefined || value1 == '') {
            
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Client Identity Number."
            });
            toastEvent.fire();
        } 
        /*else if(value2 == undefined || value2 == ''){
            
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Agent who is referring the lead."
            });
            toastEvent.fire();
        }
            else if(value3 == undefined || value3 == ''){
                
                canProceed = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please fill the Agent that is receiving the lead."
                });
                toastEvent.fire();
            } */
        else if(value4 == undefined || value4 == ''){
            
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Convenient Time to Call the client."
            });
            toastEvent.fire();
        }
        
        if(canProceed === true)
        {
            helper.createLead(component);
        }
    },
    handleClick1 : function(component,event,helper){
        
        var canProceed = true;
        var inputCmp1 = component.find("refnum1");
        var inputCmp2 = component.find("referralIdopp1");
        var inputCmp3 = component.find("recId1");
        var inputCmp4 = component.find("recDate1");
        var value1 = inputCmp1.get("v.value");
        var value2 = inputCmp2.get("v.value");
        var value3 = inputCmp3.get("v.value");
        var value4 = inputCmp4.get("v.value");
        console.log('@@@value'+value1);
        if (value1 == undefined || value1 == '') {
            
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Client Identity Number."
            });
            toastEvent.fire();
        } 
        
        /*else if(value2 == undefined || value2 == ''){
            
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Agent who is referring the lead."
            });
            toastEvent.fire();
        }
            else if(value3 == undefined || value3 == ''){
                
                canProceed = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please fill the Agent that is receiving the lead."
                });
                toastEvent.fire();
            }*/
        else if(value4 == undefined || value4 == ''){
            
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the AVAF Account Number."
            });
            toastEvent.fire();
        }
        
        if(canProceed === true)
        {
            helper.createLead(component);
        }
    },
    //Added for STI
    createNewLead : function(component, event, helper) {
        console.log("Inside createNewLead method of controller");
        //Show spinner
        component.set("v.showSpinner", true);
        var IndClient = component.get("v.isIndvClient");
        var leadRecord = component.get("v.referralLeadVASTI");
        leadRecord.Salutation = component.find("iSalutation").get("v.value");
        var productInterest = component.get("v.financialProductRecord");
        var productInterestVal = component.find("iFinancialProduct").get("v.value");
        var preferredSiteRecordVal = component.find("iPreferredSite").get("v.value");
        var preferredSiteRecord = component.get("v.siteRecord");
        var aicConsultant = leadRecord.AIC_Relationship_Consultant_Name__c;
        var leadSource = leadRecord.Lead_Source__c;
        var leadSubSource = leadRecord.STI_Sub_Source__c;
        var LeadType = leadRecord.Lead_Type__c;
        var preferredCommunicationChannel = leadRecord.Preferred_Communication_Channel__c;
        var referredBranch = leadRecord.Referring_Banker_s_Branch__c;
        var leadName = leadRecord.Lead_Name__c;
        var leadPhone =leadRecord.Lead_Phone__c;
        var leadEmail = leadRecord.Lead_Email__c;
        var phone = leadRecord.Phone;
        var parentAccount = leadRecord.Parent_Account__c;
        var oppRecordId = component.get("v.recordId");     
        var contactlookup = component.get("v.selectedLookUpRecord");
        
        if(IndClient == false){
            
             //Validation for contact lookup
        if($A.util.isUndefinedOrNull(contactlookup) || $A.util.isEmpty(contactlookup)){
            helper.showToast("Validation Error", "Please provide Contact Name for the lead", "error");
            component.set("v.showSpinner", false);          
			return null;
        }
             //Validation - No parentAccount selected
        if(parentAccount == null || parentAccount == '' || parentAccount == undefined){
            helper.showToast("Validation Error", "Please provide parent Account for the lead", "error");
            component.set("v.showSpinner", false);          
			return null;
        }
        }
       

       
         //Validation - if no LeadName
    if(leadName =='' || leadName == null){
        helper.showToast("Validation Error", "Please provide CAF STI Lead Source Name", "error");
        component.set("v.showSpinner", false);
       return null;
    }
                //Validation - if no LeadPhone
    if(leadPhone =='' || leadPhone == null){
        helper.showToast("Validation Error", "Please provide CAF STI Lead Source Phone", "error");
        component.set("v.showSpinner", false);
       return null;
    }
                     //Validation - if no Phone
    if(phone =='' || phone == null){
        helper.showToast("Validation Error", "Please provide Phone Number", "error");
        component.set("v.showSpinner", false);
       	return null;
    }
                //Validation - if no LeadEmail
    if(leadEmail =='' || leadEmail == null){
        helper.showToast("Validation Error", "Please provide CAF STI Lead Source Email", "error");
        component.set("v.showSpinner", false);
       return null;
    }
         //Validation - No product selected
        if(productInterestVal == null || productInterestVal == '' || productInterestVal == undefined){
            helper.showToast("Validation Error", "Please provide product interest for the lead", "error");
            component.set("v.showSpinner", false);          
			return null;
        }
       //Validation - No preferredSite selected
        if(preferredSiteRecordVal == null || preferredSiteRecordVal == '' || preferredSiteRecordVal == undefined){
            helper.showToast("Validation Error", "Please provide preferredSiteRecord for the lead", "error");
            component.set("v.showSpinner", false);          
			return null;
        }
        //Validation - No preferredCommunicationChannel selected
        if(preferredCommunicationChannel == null || preferredCommunicationChannel == '' || !preferredCommunicationChannel){
            helper.showToast("Validation Error", "Please provide Preferred Communication Channel", "error");
            component.set("v.showSpinner", false);
        return null;
        }
          //Validation - No ReferredBankerBranch selected
        if(referredBranch == null || referredBranch == '' || !referredBranch){
            helper.showToast("Validation Error", "Please provide Referring Banker's Branch", "error");
            component.set("v.showSpinner", false);
        return null;
        }
          //Validation - No AICRelationshipConsultant selected
        if(aicConsultant == null || aicConsultant == '' || !aicConsultant){
            helper.showToast("Validation Error", "Please provide AIC Relationship Consultant Name", "error");
            component.set("v.showSpinner", false);
        return null;
        }
                 //Validation - No LeadSource selected
        if(leadSource == null || leadSource == '' || !leadSource){
            helper.showToast("Validation Error", "Please provide LeadSource", "error");
            component.set("v.showSpinner", false);
        return null;
        }
                 //Validation - No LeadSubSource selected
        if(leadSubSource == null || leadSubSource == '' || !leadSubSource){
            helper.showToast("Validation Error", "Please provide Lead Sub Source", "error");
            component.set("v.showSpinner", false);
        return null;
        }
                //Validation - No LeadType selected
        if(LeadType == null || LeadType == '' || !LeadType){
            helper.showToast("Validation Error", "Please provide LeadType", "error");
            component.set("v.showSpinner", false);
        return null;
        }
        //Validation - No Salutation selected
         if(leadRecord.Salutation =='' || leadRecord.Salutation == null){
       	helper.showToast("Validation Error", "Please provide Salutation.", "error");
        component.set("v.showSpinner", false);
        return null;
    }
        var action = component.get("c.createReferredLeadVASTI");
        
        action.setParams({
            "salesLead":leadRecord,
            "opportunityId": oppRecordId,
            "campaignName": component.get("v.selectedcampaign"),
            "financialProductRecord" : productInterest,
            "preferredSiteRecord" : preferredSiteRecord,
            "useLeadAssignmentRule" : true
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log("Inside success"+response.getReturnValue());
                var lead = response.getReturnValue();
                console.log('lead created'+response.getReturnValue());
                if(!$A.util.isUndefinedOrNull(lead))
                {
                    console.log('Inside new lead success');
                    helper.showToast("success", "Success", "Lead Creation was Successful!!");
                    //window.location.reload();
                    
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": lead.Id,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    
                }
                else
                {
                    helper.showToast("error", "Error", "Lead Creation Failed");
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
                
                // show Error message                
                helper.showToast("error", "Error", message);                              
                //helper.hideSpinner(component);
            }
            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    }, 
    
    getPreferredSite : function(component, event, helper) {
        component.set("v.showSpinner", true);
        
        //Get Case Type
        var action = component.get("c.findSite"); 
        
        var preferredSite =  component.find("iPreferredSite").get("v.value"); 
        
        if(preferredSite == '' || preferredSite == undefined || preferredSite == null){	
            component.set("v.showSpinner", false);
        } else{
        
        action.setParams({
            "siteId" : preferredSite
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                component.set("v.siteRecord", response.getReturnValue());
                
                component.set("v.showSpinner", false);
                
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
                helper.showToast("error", "Error", message);
                
                
                component.set("v.showSpinner", false);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        }
    }, 
    
    handleSelectedLookUpRecord: function(component, event, helper) {
        
        console.log("Inside handleSelectedLookUpRecord");
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.referralLeadVASTI.Parent_Contact_Id__c", component.get("v.selectedLookUpRecord.Id"));
         component.set("v.referralLeadVASTI.ContactName__c", component.get("v.selectedLookUpRecord.Id"));
        console.log('selectedcontactid'+component.get("v.referralLeadVASTI.Parent_Contact_Id__c"));
        component.set("v.referralLeadVASTI.Salutation", component.get("v.selectedLookUpRecord.Salutation"));
        component.set("v.referralLeadVASTI.FirstName", component.get("v.selectedLookUpRecord.FirstName"));
        component.set("v.referralLeadVASTI.LastName", component.get("v.selectedLookUpRecord.LastName"));
        component.set("v.referralLeadVASTI.DD_Initials__c", component.get("v.selectedLookUpRecord.Initials__c"));
        component.set("v.referralLeadVASTI.Phone", component.get("v.selectedLookUpRecord.Phone"));
        component.set("v.referralLeadVASTI.MobilePhone", component.get("v.selectedLookUpRecord.MobilePhone"));
        component.set("v.referralLeadVASTI.DD_Date_of_Birth__c", component.get("v.selectedLookUpRecord.Birthdate"));
        component.set("v.referralLeadVASTI.Email", component.get("v.selectedLookUpRecord.Email"));
        component.set("v.referralLeadVASTI.ID_Number__c", component.get("v.selectedLookUpRecord.ID_Number__c"));
        component.set("v.referralLeadVASTI.ID_Type__c", component.get("v.selectedLookUpRecord.ID_Type__c"));
        component.set("v.referralLeadVASTI.Alternate_Phone1__c", component.get("v.selectedLookUpRecord.Alternate_Phone1__c"));
        component.set("v.referralLeadVASTI.Alternate_Phone2__c", component.get("v.selectedLookUpRecord.Alternate_Phone2__c"));
        component.set("v.referralLeadVASTI.Alternate_Phone3__c", component.get("v.selectedLookUpRecord.Alternate_Phone3__c"));
        
        
        
    },
    openModal: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        component.set('v.isOpen', true);
        component.set('v.showSpinner', false);
    },
    openCaseModal: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        
        if(component.get("v.value") === 'F2F')
        {
            component.set('v.isFaceToFaceCase', true);
            component.set('v.isVirtualAdvisorCase', false);
        }
        else if(component.get("v.value") === 'VA')
        {
            component.set('v.isFaceToFaceCase', false);
            component.set('v.isVirtualAdvisorCase', true);
        }
        
        component.set('v.showSpinner', false);
    },
    closeModal: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        component.set('v.isOpen', false);
        component.set('v.showSpinner', false);
    },
    confirmClientReferral: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        component.set('v.isOpen', false);
        
        var action = component.get('c.updateOpportunity');
        action.setParams({
            'opportunityId' : component.get('v.recordId'),
            'referralType' : component.get('v.value')
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var returnValue = response.getReturnValue();
                
                if(returnValue === true)
                {
                    helper.showToast('success', 'Success!!!', 'Client has been Referred');
                    window.location.reload();
                }
                else
                {
                    helper.showToast('error', 'Error!!!', 'Client Referral Failed');
                }
                component.set('v.showSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    submitVirtualAdvisor: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        
        var ownerId = component.get('v.referralCase.OwnerId');
        var agentNotes = component.get('v.referralCase.Comments');
        var referralTypeValue = component.get('v.value');
        
        if(ownerId === undefined || ownerId === '')
        {
            helper.showToast('error', 'Error!!!', 'Please Enter a Virtual Advisor');
            component.set('v.showSpinner', false);
        }
        else
        {
            var action = component.get('c.triggerUpdateOnReferLead');
            action.setParams({
                'caseId' : component.get('v.recordId'),
                'ownerId' : ownerId,
                'comments' : agentNotes,
                'referralType' : referralTypeValue
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                
                if(state === 'SUCCESS')
                {
                    var returnValue = response.getReturnValue();
                    if(returnValue === true)
                    {
                        helper.showToast('success', 'Success!!!', 'Client has been Referred');
                        window.location.reload();
                    }
                    else
                    {
                        helper.showToast('error', 'Error!!!', 'Referral to Virtual Advisor Failed');
                    }
                    component.set('v.showSpinner', false);
                }
                else
                {
                    helper.showToast('error', 'Error!!!', 'Referral to Virtual Advisor Failed');
                    component.set('v.showSpinner', false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    createSTILead : function(component,event,helper)
    {
        var canProceed = true;
        //var inputCmp1 = component.find("refnum1");
        //var inputCmp2 = component.find("referralId1");
        //var inputCmp3 = component.find("recId1");
        //var inputCmp4 = component.find("productInterest");
        //var value1 = inputCmp1.get("v.value");
        //var value2 = inputCmp2.get("v.value");
        //var value3 = inputCmp3.get("v.value");
        //var value4 = inputCmp4.get("v.value"); 
        var reflead = component.get("v.referralLead");
        var objName = component.get("v.objectName");
        //alert(reflead.Financial_Product__c);
		reflead.OwnerId = component.get("v.selectOwnerId");
        if(objName == 'Case'){
            var checkId = component.find("teamCheck").get("v.value");
            if((reflead.OwnerId != undefined && reflead.OwnerId != '') &&(checkId != undefined && checkId == true) ||
              ((reflead.OwnerId == undefined || reflead.OwnerId =='') && (checkId == undefined || checkId == false))){
                
               canProceed = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please enter either Agent or Team!"
                });
                toastEvent.fire();
            }
        }
        if (reflead.ID_Number__c == undefined || reflead.ID_Number__c == '')
        {
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Client Identity Number."
            });
            toastEvent.fire();
        }
        else if(reflead.Financial_Product__c == undefined || reflead.Financial_Product__c == '')
        {
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Product Interest"
            });
            toastEvent.fire();
        }
      /*  else if(reflead.DD_Agent_Who_Referred_Lead__c == undefined || reflead.DD_Agent_Who_Referred_Lead__c == '')
        {
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Referring Lead"
            });
            toastEvent.fire();
        }
        else if(reflead.OwnerId == undefined || reflead.OwnerId == '')
        {
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Receiving Lead"
            });
            toastEvent.fire();
        }*/
        
        if(canProceed === true)
        {
            var checkId = component.find("teamCheck").get("v.value");
            var action = component.get("c.createVAReferredLead");            
                action.setParams({
                    "Recinfo": component.get("v.referralLead"),
                    "caseInfo": component.get("v.referralCase"),
                    "isTeamAssign" : checkId,
                    "objName" : component.get("v.objectName")
                    //"selLeadOwner": selAdvId
                });
               action.setCallback(this, function(response){ 
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Inside success'+response.getReturnValue());
                    var result = response.getReturnValue();
                    
                    if(result == "Success"){
                        $A.get('e.force:refreshView').fire();
                        $A.get("e.force:closeQuickAction").fire();
                        helper.showToast("success", "Success", "Lead Creation was Successful!!");
                       component.set("v.showSpinner", false);
                        //window.location.reload();
                        
                    }
                    else{
                       canProceed = false;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "ERROR!",
                            "type" : 'error',
                            "message": "Cannot Save Lead :" + result
                        });
                        toastEvent.fire(); 
                        component.set("v.showSpinner", false);            
                    }                       
                    
                }
                else if (state === "ERROR") {
                    console.log('Inside error');
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });            
            $A.enqueueAction(action);
        }
    }
    
    
})