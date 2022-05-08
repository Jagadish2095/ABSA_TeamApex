({
    doInit:function(component, event, helper)
    {
        console.log('opppp',component.get("v.OpportunityFromFlow"));
        component.set("v.memberDetails",{});
        helper.getPickListValuesForRelationshipType(component, event);
        helper.getPickListValuesForIdType(component, event);
        helper.getOpportunityPartyDetails(component, event);
    },

    onOutcomeChange : function(component,event,helper){
        component.set("v.isQuoteDone",true);
    },
    onPicklistSelectedRelationshipTypeChange : function(component, event, helper)
    {
        var selectedValue = event.getSource().get("v.value");
        component.set("v.showOptionToAddMember", false);
        component.set("v.showNewPanel", false);
        
        if(selectedValue === component.get("v.memberTypeMainMember"))
        {
            helper.getOpportunityDetails(component,event);
            helper.getPickListValuesForCoverAmount(component, component.get("v.memberTypeMainMember"));
            component.set("v.showPolicyCoverOptions", true);
            component.set("v.showNewMemberButton", false);
        }
        else if(selectedValue === component.get("v.memberTypeSpouse"))
        {
            component.set("v.existingPolicyCoverOptions", []);
            helper.getSpouseDetails(component, event);
        }
        else if(selectedValue === component.get("v.memberTypeChild")
           || selectedValue === component.get("v.memberTypeParent"))
        {
            component.set("v.showOptionToAddMember", true);
            component.set("v.showNewMemberButton", false);
        }
        else
        {
            component.set("v.showPolicyCoverOptions", false);
            component.set("v.showNewMemberButton", false);
        }
        
        component.set("v.selectedRelationshipType", selectedValue);
        component.set("v.selectedOptionOnAddMember",'');
        component.set("v.selectedMemberResponse",'');
        component.set("v.selectedPolicyCoverAmount",'');
        component.set("v.selectedRecordId",'');
        component.set("v.showExistingMemberOptions", false);
    },
    onPicklistSelectedAddMemberChange : function(component, event, helper)
    {
        var selectedValue = event.getSource().get("v.value");
        component.set("v.selectedOptionOnAddMember", selectedValue);
        
        if(selectedValue != '')
        {
            if(selectedValue == 'Yes')
            {
                helper.generateMemberPicklistOptions(component,event);
                component.set("v.showNewMemberButton", false);
            }
            else if(selectedValue == 'No')
            {
                component.set("v.showExistingMemberOptions", false);
                component.set("v.showPolicyCoverOptions", false);
                component.set("v.showNewMemberButton", true);
                helper.getPickListValuesForCoverAmount(component, component.get("v.selectedRelationshipType"));
                component.set("v.selectedMemberResponse",'');
                component.set("v.selectedPolicyCoverAmount",'');
            }
        }
        else
        {
            component.set("v.showExistingMemberOptions", false);
            component.set("v.showNewMemberButton", false);
            component.set("v.selectedMemberResponse",'');
            component.set("v.selectedPolicyCoverAmount",'');
        }
        component.set("v.selectedRecordId",'');
    },
    onPicklistExistingMemberOptionsChange :function(component,event,helper)
    {
        var selectedValue = event.getSource().get("v.value");
        component.set("v.memberDetails",{});
        component.set("v.selectedRecordId",'');
        
        let memberObject = component.get("v.memberDetails");
        var existingOppDetailMap = component.get("v.OpportunityPartyDetailsMap");
        
        if(selectedValue !=''
           && existingOppDetailMap != null
           && Object.keys(existingOppDetailMap).includes(selectedValue))
        {
            memberObject.Name = existingOppDetailMap[selectedValue].First_Name__c +''+ existingOppDetailMap[selectedValue].Last_Name__c;
            memberObject.First_Name__c = existingOppDetailMap[selectedValue].First_Name__c;
            memberObject.Last_Name__c = existingOppDetailMap[selectedValue].Last_Name__c;
            memberObject.ID_Type__c = existingOppDetailMap[selectedValue].ID_Type__c;
            memberObject.RSA_ID_Number__c = existingOppDetailMap[selectedValue].RSA_ID_Number__c;
            memberObject.Date_of_Birth__c = existingOppDetailMap[selectedValue].Date_of_Birth__c;
            memberObject.Age__c = existingOppDetailMap[selectedValue].Age__c;
            memberObject.DD_Cross_Sell_Product_Member_Type__c = component.get("v.productNameHealthAssistance");
            memberObject.Relationship__c = existingOppDetailMap[selectedValue].Relationship__c;
            memberObject.Gender__c = existingOppDetailMap[selectedValue].Gender__c;
            memberObject.Id = existingOppDetailMap[selectedValue].Id;
            memberObject.Opportunity__c = component.get("v.OpportunityFromFlow");
            
            component.set("v.memberDetails", memberObject);
            component.set("v.showPolicyCoverOptions", true);
            component.set("v.selectedPolicyCoverAmount", '');
            component.set("v.selectedRecordId", selectedValue);
            helper.getPickListValuesForCoverAmount(component, component.get("v.selectedRelationshipType"));
        }
    },
    onPicklistExistingPolicyCoverOptionsChange :function(component, event, helper)
    {
        var selectedValue = event.getSource().get("v.value");
        
        helper.calculatePremium(component, selectedValue);
        
        component.set("v.selectedPolicyCoverAmount",'');
        component.set("v.selectedOptionOnAddMember",'');
        component.set("v.selectedMemberResponse",'');
        component.set("v.selectedRelationshipType",'');
        component.set("v.showExistingMemberOptions", false);
        component.set("v.showOptionToAddMember", false);
        component.set("v.showPolicyCoverOptions", false);
    },
    onPicklistExistingPolicyCoverOptionsChangeForNewMember :function(component, event, helper)
    {
        var selectedValue = event.getSource().get("v.value");
        component.set("v.selectedPolicyCoverAmount", selectedValue);
        component.set("v.showExistingMemberOptions", false);
        component.set("v.showPolicyCoverOptions", false);
    },
   	displayNewMember: function(component, event)
    {
        component.set("v.memberDetails",{});
        let member = component.get("v.memberDetails");
        component.set("v.memberDetails", member);
        component.set("v.showNewPanel", true);
    },
    cancelMember: function(component, event)
    {
        component.set("v.showNewPanel", false);
    },
    onPicklistGenderChange: function(component, event, helper)
    {
       component.set("v.memberDetails.Gender__c", event.getSource().get("v.value"));         
    },
    onPicklistselectedIdTypeChange : function(component, event, helper)
    {
        component.set("v.memberDetails.ID_Type__c", event.getSource().get("v.value"));
    },
    addMember: function(component, event, helper)
    {
       var allValid = false;
       var formId = "memberForm";
       allValid = helper.validationCheck(component, allValid, formId);
        
       if(allValid === true)
       {
           let memberObject = component.get("v.memberDetails");
           memberObject.Opportunity__c = component.get("v.OpportunityFromFlow");
           component.set("v.memberDetails", memberObject);
           
           var allBeneficiaryMap = component.get("v.allBeneficiariesMap");
           let objectMap = $A.util.isEmpty(allBeneficiaryMap) ? {} : allBeneficiaryMap;
           
           helper.calculatePremium(component, component.get("v.selectedPolicyCoverAmount"));
           
           component.set("v.allBeneficiariesMap", objectMap);
           component.set("v.showNewPanel", false);
           component.set("v.selectedOptionOnAddMember", '');
           component.set("v.showNewMemberButton", false);
           component.set("v.selectedRelationshipType",'');
           component.set("v.showOptionToAddMember", false); 
           component.set("v.selectedGenderValue",'');
           component.set("v.memberDetails",{});

       }
    },
    removeDeletedRow: function(component, event, helper)
    {
        component.set("v.showSpinner", true);
        var index = event.getParam("indexVar");
        var allRowsList = component.get("v.allBeneficiaries");
        allRowsList.splice(index, 1);
        
        //Param from Cross Sell Products Child Component
        component.set("v.memberDetails", event.getParam("raiderDetails"));
        var member = component.get("v.memberDetails");
        
        var deleteList = component.get("v.OpportunityPartyDetailsListDelete");
        
        if(member != undefined)
        {
            deleteList.push(member);
            component.set("v.OpportunityPartyDetailsListDelete", deleteList);

            var oppPartyData = component.get("v.allBeneficiaries");
            var oppPartyDeleteData = component.get("v.OpportunityPartyDetailsListDelete");
            
            if(oppPartyDeleteData.length > 0)
            {
                var action = component.get("c.deleteOppPartyData");
                action.setParams({
                    "oppPartyListdelete": oppPartyDeleteData,
                    "oppPartyId": member.Id,
                    "roadCover": false,
                    "healthAssis": true
                });
                
                action.setCallback(this, function(a) {
                    
                    var state = a.getState();
                    if(state === "SUCCESS")
                    {
                        console.log('Success');
                    }
                    else
                    {
                        console.log('Error '+JSON.stringify(a.getError()));
                    }
                    
                    component.set("v.showSpinner",false);
                });
                $A.enqueueAction(action);
            }
        }

        component.set("v.selectedRelationshipType",'');
        
        component.set("v.showOptionToAddMember", false);
        component.set("v.selectedOptionOnAddMember",'');
        
        component.set("v.showExistingMemberOptions",false);
        component.set("v.selectedMemberResponse",'');
        
        component.set("v.showNewMemberButton", false); 
        component.set("v.allBeneficiaries", allRowsList);
    },
    editRow : function(component, event, helper)
    {
        var index = event.getParam("indexVar");
        component.set("v.indexVar", index);
        component.set("v.showUpdatePanelModal", true);
        
        //Param from Cross Sell Products Child Component
        component.set("v.memberDetails", event.getParam("raiderDetails"));
        
        var member = component.get("v.memberDetails");
        let memberType;
        
        if(member.Relationship__c === component.get("v.memberTypeMainMember")
          || member.Relationship__c === component.get("v.memberTypeSpouse"))
        {
            memberType = component.get("v.memberTypeMainMember");
        }
        else
        {
            memberType = component.get("v.memberTypeChild");
        }
        
        helper.getPickListValuesForCoverAmount(component, memberType);
    },
    updateMember : function(component, event, helper)
    {
        component.set("v.showSpinner", true);
        var allValid = false;
        var formId = "updateForm";
        var member = component.get("v.memberDetails");
        
        if(member.Relationship__c != component.get("v.memberTypeMainMember"))
        {
            allValid = helper.validationCheck(component, allValid, formId);
        }
        else
        {
            allValid = true;
        }
        
        if(allValid)
        {
            var index = component.get("v.indexVar");
            var allRowsList = component.get("v.allBeneficiaries");
            
            allRowsList.splice(index, 1);
            component.set("v.allBeneficiaries", allRowsList);
            
            helper.calculatePremium(component, component.get("v.selectedPolicyCoverAmount"));
            
            component.set("v.showUpdatePanelModal", false);
            component.set("v.memberDetails",{});
            
        }
        component.set("v.showSpinner", false);
    },         
    closeConfirmation: function(component, event, helper) 
    {
        component.set("v.showUpdatePanelModal", false);
    },
    handleChangePrev : function(component,event,helper)
    {
        var actionClicked = event.getSource().getLocalId();
		var navigate = component.getEvent("navigateFlowEvent");
		navigate.setParam("action", actionClicked);
		navigate.fire();
    },
    
    handleChangeNext :function(component, event, helper)
    {
		var LabelName = event.getSource().get("v.label");
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        //component.find('Quote_Outcome__c').get("v.value");
        console.log('Outcome'+JSON.stringify(component.get("v.opportunityDetails")));
        console.log('quoteOutcome',quoteOutcome);
 		if(quoteOutcome == '' || quoteOutcome == null){
           var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please select Quote Outcome.",
                            "type":"error"
                        });
                 toastEvent.fire();
                return null;
        }
        else{	
        if(LabelName == 'Quote')
        {
            if(quoteOutcome == 'Client Interested'){
            var allPartyIdsAdded = true;
            var oppPartyData = component.get("v.allBeneficiaries");
            
            var mainMemberSumAssured = 0;
            var otherMemberSumAssured = 0;
            
            if(oppPartyData != undefined
               && oppPartyData.length > 0)
            {
                for(var i = 0; i < oppPartyData.length; i++)
                {
                    if(oppPartyData[i].Relationship__c === component.get("v.memberTypeMainMember"))
                    {
                        component.set("v.mainMemberAdded", true);
                        mainMemberSumAssured = oppPartyData[i].SumAssured;
                    }
                    else if(oppPartyData[i].SumAssured > otherMemberSumAssured)
                    {
                        otherMemberSumAssured = oppPartyData[i].SumAssured;
                    }
                    
                    if(oppPartyData[i].RSA_ID_Number__c === undefined
                      || oppPartyData[i].RSA_ID_Number__c === '')
                    {
                        allPartyIdsAdded = false;
                    }
                }
            }
            
            if(mainMemberSumAssured >= otherMemberSumAssured)
            {
                if(allPartyIdsAdded === true)
                {
                    if(component.get("v.mainMemberAdded") === true)
                    {
                        helper.saveOppPartyData(component,event,helper); 
                    }
                    else
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Main Member is required in order to create Quote",
                            "type":"error"
                        });
                        toastEvent.fire();
                    }
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "ID Number is required in order to create Quote, One or More Members must be Updated",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "One or More Member Sum Assured Exceed the Main Member Sum Assured",
                    "type":"error"
                });
                toastEvent.fire();
            }
            }else{
                 helper.saveOppPartyData(component,event,helper); 
            }
        }
        else
        {
            var actionClicked = event.getSource().getLocalId();
            var navigate = component.getEvent("navigateFlowEvent");
            navigate.setParam("action", actionClicked);
            navigate.setParam("outcome", component.get("v.quoteStatus"));
            navigate.fire();
        }
        }
    },         
    
    handleChangeNext1 :function(component, event, helper)
    {
		var LabelName = event.getSource().get("v.label");
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        console.log('**'+JSON.stringify(component.get("v.opportunityDetails.Quote_Outcome__c")));
        if(quoteOutcome == '' || quoteOutcome == null){
            var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "please select Quote Outcome.",
                            "type":"error"
                        });
                 toastEvent.fire();
                return null;
        }
        else{
        	if(LabelName == 'Quote')
        	{
            	var allPartyIdsAdded = true;
            	var oppPartyData = component.get("v.allBeneficiaries");
            
            var mainMemberSumAssured = 0;
            var otherMemberSumAssured = 0;
            var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
 			if(quoteOutcome == 'Client Interested'){
            if(oppPartyData != undefined && oppPartyData.length > 0)
            {
                for(var i = 0; i < oppPartyData.length; i++)
                {
                    if(oppPartyData[i].Relationship__c === component.get("v.memberTypeMainMember"))
                    {
                        component.set("v.mainMemberAdded", true);
                        mainMemberSumAssured = oppPartyData[i].SumAssured;
                    }
                    else if(oppPartyData[i].SumAssured > otherMemberSumAssured)
                    {
                        otherMemberSumAssured = oppPartyData[i].SumAssured;
                    }
                    
                    if(oppPartyData[i].RSA_ID_Number__c === undefined
                      || oppPartyData[i].RSA_ID_Number__c === '')
                    {
                        allPartyIdsAdded = false;
                    }
                }
            }
            
            if(mainMemberSumAssured >= otherMemberSumAssured)
            {
                if(allPartyIdsAdded === true)
                {
                    if(component.get("v.mainMemberAdded") === true)
                    {
                        helper.saveOppPartyData(component,event,helper); 
                    }
                    else
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Main Member is required in order to create Quote",
                            "type":"error"
                        });
                        toastEvent.fire();
                    }
                }
            }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "ID Number is required in order to create Quote, One or More Members must be Updated",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "One or More Member Sum Assured Exceed the Main Member Sum Assured",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
        }
        else
        {
            var actionClicked = event.getSource().getLocalId();
            var navigate = component.getEvent("navigateFlowEvent");
            navigate.setParam("action", actionClicked);
            navigate.setParam("outcome", component.get("v.quoteStatus"));
            navigate.fire();
        }
      }
    },                     
})