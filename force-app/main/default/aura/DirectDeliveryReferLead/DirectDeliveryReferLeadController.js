({
    doInit:function(component, event, helper)
    {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userid",userId);
        $A.util.addClass(component.find("toggle1"), "slds-hide");
        $A.util.addClass(component.find("toggle2"), "slds-hide");
        //console.log('value of opportunityid ' + component.get("v.recordId") );
        var objType;
        
        var action0 = component.get("c.getObjectName");
        action0.setParams({
            "recordId": component.get("v.recordId")
        });
        action0.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                objType = response.getReturnValue();
                console.log('value of objType ' + objType );
                component.set("v.objectType", objType);
                if(objType === 'Case'){
                    console.log('Now in case logic ');
                    var action2 = component.get("c.getReferralCampaigns");
                    var recId = component.get("v.recordId");
                    action2.setParams({
                        'recordId' : recId
                    });
                    action2.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var result = response.getReturnValue();
                            var options = [];
                            for(var key in result){
                                options.push({label: result[key], value: key});
                            }
                            component.set("v.options", options);
                            console.log('List of options ' + options);
                            
                        }
                    });
                    $A.enqueueAction(action2);
                    var action1 = component.get("c.getUserName");
                    action1.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var result = response.getReturnValue();
                            component.set("v.currentUserName", result);
                        }
                    });
                    $A.enqueueAction(action1);
                    
                    var action3 = component.get("c.getCaseDetails");
                    var recId1 = component.get("v.recordId");
                    action3.setParams({
                        'caseId' : recId1
                    });
                    action3.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var result = response.getReturnValue();
                            console.log('result@@@'+result.Account.ID_Number__pc);
                            component.set("v.accountIdnumber", result.Account.ID_Number__pc);
                        }
                    });
                    $A.enqueueAction(action3);
                }
                
                if(objType === 'Opportunity'){
                    var action = component.get("c.getOpportunityDetails");
                    action.setParams({
                        "opportunityId": component.get("v.recordId")
                    });
                    
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        
                        if (state === "SUCCESS") {
                            var opportunity = response.getReturnValue();
                            console.log('value of opportunity ' + opportunity);
                            if(opportunity != null)
                            {
                                component.set("v.opportunityDetails", opportunity.Opp);
                                component.set("v.accountIdnumber", opportunity.Opp.ID_Number__c);
                                component.set("v.oppRecordtype", opportunity.Opp.Opportunity_Record_Type_Name__c);
                                component.set("v.showDetails", true);
                                console.log('Opportunity Record type '+opportunity.Opp.Opportunity_Record_Type_Name__c);
                                // Date 2021-06-16
                                // added AHP Opportunity rec type in below if condtion to show the refer lead functionality
                                // for AHP Product
                                if(component.get("v.oppRecordtype") == 'Direct Delivery Sales Opportunity' || component.get("v.oppRecordtype") == 'DD STI Opportunity' || component.get("v.oppRecordtype") == 'DD AHP Opportunity'){
                                    component.set("v.isDirectSales",true);
                                    component.set("v.accountAVAFNumber", opportunity.Opp.AVAF_Account_Number__c);
                                    // code added for the AHP
                                    component.set("v.referralLead.FirstName",opportunity.Opp.Person_Account_First_Name__c);
                                    component.set("v.referralLead.LastName",opportunity.Opp.Person_Account_Last_Name__c);
                                    
                                    var action2 = component.get("c.getReferralCampaigns");
                                    var recId = component.get("v.recordId");
                                    action2.setParams({
                                        'recordId' : recId
                                    });
                                    action2.setCallback(this, function(response){
                                        var state = response.getState();
                                        if (state === "SUCCESS") {
                                            var result = response.getReturnValue();
                                            var options = [];
                                            for(var key in result){
                                                options.push({label: result[key], value: key});
                                            }
                                            component.set("v.options", options);
                                            
                                        }
                                    });
                                    $A.enqueueAction(action2);
                                }
                                else {
                                    component.set("v.others",true);
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
                    $A.enqueueAction(action);
                    $A.enqueueAction(action1);
                }
                
                // code for Leads
                // added on 20121/06/28 by Pravin W.
                 if(objType === 'Lead'){
                     debugger;
                 	var actionGetLead = component.get("c.getLeadDetails");
                    actionGetLead.setParams({
                        "leadId": component.get("v.recordId")
                    });
                     
                     actionGetLead.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS"){
                            var leadRec = response.getReturnValue();
                            console.log('value of retrieved lead ' + leadRec);
                            if(leadRec != null){
                                if( leadRec.RecordType.DeveloperName = 'AIP_Lead' ){
                                    
                                    // populate the default values in the component
                                    //component.set("v.opportunityDetails", opportunity.Opp);
                                    component.set("v.accountIdnumber", leadRec.ID_Number__c);
                                    component.set("v.showDetails", true);
                                    component.set("v.accountAVAFNumber", leadRec.DD_AVAF_Account_Number__c);
                                    // code added for the AHP
                                    component.set("v.isAIPLead",true);
                                    component.set("v.referralLead.FirstName",leadRec.FirstName);
                                    component.set("v.referralLead.LastName",leadRec.LastName);
                                    // get the referal campaign details
                                    var actionGetCampaigns = component.get("c.getReferralCampaigns");
                                    var recId = component.get("v.recordId");
                                    actionGetCampaigns.setParams({
                                        'recordId' : recId
                                    });
                                    
                                    actionGetCampaigns.setCallback(this, function(response){
                                        var state = response.getState();
                                        if (state === "SUCCESS") {
                                            var result = response.getReturnValue();
                                            var options = [];
                                            for(var key in result){
                                                options.push({label: result[key], value: key});
                                            }
                                            component.set("v.options", options);
                                        }
                                    });
                                    $A.enqueueAction(actionGetCampaigns);
                                }else{
                                    component.set("v.others",true);
                                }
                            }
                        }
                       component.set("v.showSpinner", false);
                     });
                     
                     //
                     var actionGetUserName = component.get("c.getUserName");
                    actionGetUserName.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var result = response.getReturnValue();
                            component.set("v.currentUserName", result);
                        }
                    });
                    $A.enqueueAction(actionGetUserName);
                    $A.enqueueAction(actionGetLead);
                     //
                 } 
            }
            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action0);
        console.log('value of objType after  ' + objType );
    },
    onSelect : function(component,event,helper){
        component.set("v.isButtonActive",false);
        component.set("v.showComponent",true);
        var selected = event.getSource().get("v.value");
        console.log(selected + ' <<<<<<selected value <<<<<<<<<<<');
        component.set("v.selCampaignVal",selected);
        
        component.set("v.referralLead.ID_Number__c",'');
        //component.set("v.referralLead.DD_Agent_Who_Referred_Lead__c",'');
        component.set("v.referralLead.OwnerId",'');
        component.set("v.referralLead.DD_AVAF_Account_Number__c",'');
        component.set("v.referralLead.DD_Convenient_Time_To_Call__c",'');
        component.set("v.referralLead.ID_Number__c",component.get("v.accountIdnumber"));
        component.set("v.referralLead.DD_AVAF_Account_Number__c",component.get("v.accountAVAFNumber"));
        component.set("v.referralLead.Financial_Product__c",'');
    },
    
    handleClick1 : function(component,event,helper){
        console.log('in handle');
        var canProceed = true;
        var inputCmp1 = component.find("clientid");
        var inputCmp2 = component.find("prodInterest");
        var inputCmp4 = component.find("accNumber");
        var inputCmp5 = component.find("Convenienttime");
        var inputCmp6 = component.find("ownersid");
        var inputCmp7 = component.find("reflead");
        var inputCmp8 = component.find("accNumber");
        var inputClientFirstNameCmp = component.find("clientfname");
        var inputClientLastNameCmp = component.find("clientlname");
        
        var value1 = inputCmp1.get("v.value");
        var value2 = inputCmp2.get("v.value");
        var value4 = inputCmp4.get("v.value");
        var value5 = inputCmp5.get("v.value");
        var value6 = inputCmp6.get("v.value");
		var value7 = inputCmp7.get("v.value");
        var value8 = inputCmp8.get("v.value");
        var inputClientFirstName = inputClientFirstNameCmp.get("v.value");
        var inputClientLastName = inputClientLastNameCmp.get("v.value");
        var selectedCampaign = component.get("v.selCampaignVal");
        debugger;
        
        if(inputClientFirstNameCmp && (inputClientFirstName == undefined || inputClientFirstName == '') && component.get("v.oppRecordtype") == 'DD AHP Opportunity'){
            // validation for AHP Opportunities
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Client First Name"
            });
            toastEvent.fire();
        }
        else if(inputClientLastNameCmp && (inputClientLastName == undefined || inputClientLastName == '') && component.get("v.oppRecordtype") == 'DD AHP Opportunity'){
            // validation for AHP Opportunities
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Client Last Name"
            });
            toastEvent.fire();
        }else if (value1 == undefined || value1 == '') {
            
            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the Client Identity Number."
            });
            toastEvent.fire();
        }
        
        
        /*  else if((value4 == undefined || value4 == '') && component.get("v.selCampaignVal") == 'DD - HOT Referral - Advice - STI' ){

            canProceed = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Info!",
                "type" : 'error',
                "message": "Please fill the AVAF Account Number."
            });
            toastEvent.fire();
        }*/
             else if((component.get("v.selCampaignVal") == 'DD - Referral - Advice - STI' || component.get("v.selCampaignVal") == 'DD - HOT Referral - Advice – STI') && component.get("v.isAIPLead") && (value7 == undefined || value7 == '')){
                
                canProceed = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please fill the Agent who is referring the lead."
                });
                toastEvent.fire();
            }
                 
        		else if(component.get("v.isAIPLead") && (value6 == undefined || value6 == '') && (component.get("v.selCampaignVal") == 'DD - Referral - Advice - STI' || component.get("v.selCampaignVal") == 'DD - HOT Referral - Advice – STI')){
                
                canProceed = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please fill the Agent that is receiving the Lead."
                });
                toastEvent.fire();
            }
            else if((component.get("v.isDirectSales") || component.get("v.isAIPLead") ) && (value5 == undefined || value5 == '') && component.get("v.selCampaignVal") == 'DD - Referral - Advice - STI'){
                
                canProceed = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please fill the Convenient Time to Call the client."
                });
                toastEvent.fire();
            }
                else if((value2 == undefined || value2 == '') && component.get("v.selCampaignVal") == 'Face to Face Advisors'){
                    
                    canProceed = false;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info!",
                        "type" : 'error',
                        "message": "Please fill the Potential product of interest"
                    });
                    toastEvent.fire();
                }
        
        else if(component.get("v.isAIPLead") && (value8 == undefined || value8 == '') && (component.get("v.selCampaignVal") == 'DD - HOT Referral - Advice – STI')){
                
                canProceed = false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please fill the Agent that is receiving the Lead."
                });
                toastEvent.fire();
            }
        
        if(canProceed === true)
        {
            helper.createLead(component,event);
        }
    },
    
    
    getFinancialProductdd : function(component, event, helper) {
        alert('hi');
    }
})