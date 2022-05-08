({
    doInit:function(component, event, helper)
    {
        var objectName;
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userid",userId);
        component.set("v.showRadioButtons", true);
        component.set("v.showNotesSection", false);
        $A.util.addClass(component.find("warningtoggle"), "slds-hide");
        var firstAction = component.get("c.getObjectName");
        firstAction.setParams({
            "recordId": component.get("v.recordId")
        });
        
        firstAction.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                objectName = response.getReturnValue();
                component.set("v.objectName", objectName);
                
                if(objectName === "Case")
                {
                    $A.util.removeClass(component.find("warningtoggle"), "slds-hide");
                    
                    component.set('v.showSpinner', true);
                    component.set('v.isCaseOpen', false);
                    component.set("v.showDetails", true);
                    component.set('v.showSpinner', false);
                    
                    console.log("Case Record");
                }
                else if(objectName === "Opportunity")
                {
                    component.set('v.showSpinner', true);
                     // added on 2021-07-08 for investment refer client
                    // by Pravin W.
                    // if this is the Investment Opportunity 
                    // show refer client where user can select the owner
                    // and can also add comment
                    
                    var actionGetOpportunity = component.get("c.getOpportunity");
                    actionGetOpportunity.setParams({
                        "recordId": component.get("v.recordId")
                    });
                     actionGetOpportunity.setCallback(this, function(response){
                         debugger;
                        var state = response.getState();
                         var currentOpp;
                        if(state === "SUCCESS")
                        {
                            currentOpp = response.getReturnValue();
                            component.set('v.currentOppDetails',currentOpp);
                            component.set("v.showDetails", true);
                    		component.set('v.showSpinner', false);
                            // if it is non investment opportunity
                            if( currentOpp.Opportunity_Record_Type_Name__c != 'Investment Opportunity' ){
                                component.set('v.showSpinner', true);
                                component.set('v.isOpen', false);
                                component.set("v.showDetails", true);
                                component.set('v.showSpinner', false);
                                console.log("Opportunity Record");
                            }
                        } 
                        });
                        $A.enqueueAction(actionGetOpportunity);
                    //// get the pick list value for filtering
                    var actionGetUserSkills = component.get("c.getPiklistValues");
                    actionGetUserSkills.setParams({
                        "objName": "User",
                        "fldName": "Skills_Products__c"
                    });
                    actionGetUserSkills.setCallback(this, function(response){
                         debugger;
                        var state = response.getState();
                         var languageOptionLst = [];
                        var skillsOptionLst = [];
                        if(state === "SUCCESS"){
                            var result = response.getReturnValue();
                            
                                for(const key in result){
                                    console.log(key +' => '+result[key]);
                                      skillsOptionLst.push({
                                        label: key,
                                        value: result[key]
                                    });
                                }
                            component.set('v.SkillList',skillsOptionLst);
                        }
                    });    
                     $A.enqueueAction(actionGetUserSkills);
                    
                    // Get user language
                       var actionGetUserLanguages = component.get("c.getPiklistValues");
                    actionGetUserLanguages.setParams({
                        "objName": "User",
                        "fldName": "LanguageLocaleKey"
                    });
                    actionGetUserLanguages.setCallback(this, function(response){
                         debugger;
                        var state = response.getState();
                         var languageOptionLst = [];
                        if(state === "SUCCESS"){
                            var result = response.getReturnValue();
                            for(const key in result){
                                    console.log(key +' => '+result[key]);
                                      languageOptionLst.push({
                                        label: key,
                                        value: result[key]
                                    });
                                }
                            component.set('v.LanguageList',languageOptionLst);
                        }
                    });    
                     $A.enqueueAction(actionGetUserLanguages);
                }
            }
        });
        $A.enqueueAction(firstAction);
        },
    handleLanguageChange: function(component, event, helper){
        var selectedValues = event.getParam("value");
        component.set("v.selectedLanguageList", selectedValues);
    },
     handleSkillChange: function(component, event, helper){
          var selectedValues = event.getParam("value");
        component.set("v.selectedSkillList", selectedValues);
    },
    getSelectedFilters: function(component, event, helper){
        debugger;
        if(component.get("v.objectName") == 'Opportunity' ){
            
            var Notes = component.get("v.clientNotes");
            
            if(Notes == undefined || Notes==''){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : 'error',
                    "message": "Please fill the Agent Notes!"
                });
                toastEvent.fire();
                return;
            }
        }
        // get the selected field values
        var lstSelectedFilterLanguage = [];
        var lstSelectedFilterSkill = [];
        lstSelectedFilterLanguage = component.get('v.selectedLanguageList');
        lstSelectedFilterSkill = component.get('v.selectedSkillList'); 
        console.log('selected language '+lstSelectedFilterLanguage);
        console.log('selected '+lstSelectedFilterSkill);
        // now query the users based on above selected filters
          // Get user language
        var actionGetAdvisers = component.get("c.getAdvisers");
        actionGetAdvisers.setParams({
            "lstLanguages": lstSelectedFilterLanguage,
            "lstSkills": lstSelectedFilterSkill
        });
        
        actionGetAdvisers.setCallback(this, function(response){
            debugger;
            var state = response.getState();
            var languageOptionLst = [];
            if(state === "SUCCESS"){
                component.set('v.isSearchPerformed',true);
                var users = response.getReturnValue();
                component.set('v.users',users);
            }
        });
         $A.enqueueAction(actionGetAdvisers);
        
    },
    //Added By Divya
     onRadioChange: function(component, event, helper){
        var selected = event.getSource().get("v.text");
        component.set("v.selectedId",selected);
        component.set("v.showButton",true);
    },
  onRadioOpportunity: function(component, event, helper){
         component.set("v.showSpinner", true);
        //Added By Divya
        var selected = component.get("v.selectedId");
        var cbs = document.getElementsByClassName("slds-radio");
        for (var i = 0; i < cbs.length; i++) {
            cbs[i].checked = false;
        }
        component.set("v.checkThis", true);
        component.set("v.selectedRadio", selected);
        
        console.log('Opportunity Radio check selected');
        let currentoppid = component.get("v.recordId");
        console.log("currentoppid: " + currentoppid);
        console.log("selected Advisor ID: " + selected);
        console.log("Comments " + component.get("v.clientNotes"));
       
        
         var actionTransferToVA = component.get("c.referOpportunityToVA");
        actionTransferToVA.setParams({
            "userId": selected,
            "oppId": currentoppid,
            "agentNotes": component.get("v.clientNotes")
        });
        
        actionTransferToVA.setCallback(this, function(response){
            debugger;
           
            var state = response.getState();
            var languageOptionLst = [];
            if(state === "SUCCESS"){
                 var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!!!",
                        "message": "Client has been Referred",
                        "type": "success"
                    });
                    toastEvent.fire();
                    window.location.reload();
            }else{
                console.log('Error: ',response);
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Advisor Selection Failed! Since record cannot be update becase of custom validation rules!",
                        "type": "error"
                    });
                    toastEvent.fire();
            
            }
        });
         $A.enqueueAction(actionTransferToVA);

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
    openModal: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        component.set('v.isOpen', true);
        component.set('v.showSpinner', false);
    },
    showNotes: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        component.set("v.showRadioButtons", false);
        component.set("v.showNotesSection", true);      
        component.set('v.showSpinner', false);
    },
    closeModal: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        component.set('v.isOpen', false);
        component.set('v.showSpinner', false);
    },
    submitVirtualAdvisor: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        
        var ownerId = component.get('v.referralCase.OwnerId');
        var agentNotes = component.get('v.referralCase.Comments');
        console.log('agentNotes :'+agentNotes);
        var referralTypeValue = component.get('v.value');
        
        if(ownerId === undefined || ownerId === '')
        {
            helper.showToast('error', 'Error!!!', 'Please Enter a Virtual Advisor');
            component.set('v.showSpinner', false);
        }
        else
        {
            var action = component.get('c.referCase');
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
    confirmClientReferral: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        component.set('v.isOpen', false);
        var allRequiredFieldsProvided = true;
        
        var consultantEmail = component.get('v.opportunityDetails.VA_AIC_Consultant_Email__c');
        var generatorEmail = component.get('v.opportunityDetails.Lead_Originator_Email__c');
        
        if(consultantEmail === undefined
           || consultantEmail === '')
        {
            allRequiredFieldsProvided = false;
            component.set('v.showSpinner', false);
            helper.showToast('error', 'Error!!!', 'Please Provide Email Address of AIC Consultant');
        }
        
        if(generatorEmail === undefined
           || generatorEmail === '')
        {
            allRequiredFieldsProvided = false;
            component.set('v.showSpinner', false);
            helper.showToast('error', 'Error!!!', 'Please Provide Email Address of Lead Generator');
        }
        
        
        if(allRequiredFieldsProvided === true)
        {
            var action = component.get('c.updateOpportunity');
            action.setParams({
                'opportunityId' : component.get('v.recordId'),
                'referralType' : component.get('v.value'),
                'consultantEmailAddress' : consultantEmail,
                'generatorEmailAddress' : generatorEmail,
                'clientNotes' : component.get('v.opportunityDetails.VA_Client_Referral_Notes__c'),
                'insuranceType' : component.get('v.opportunityDetails.Type_of_Insurance_Needed__c')
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
        }
        
    },
})