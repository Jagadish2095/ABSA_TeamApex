({
    getPickListValuesForRelationshipType : function(component,event)
    {
        var options = [];
        options.push({
            class: "optionClass",
            label: "--- None ---",
            value: ""
        });
        options.push({
            class: "optionClass",
            label: "Main Member",
            value: "Main Member"
        });
        options.push({
            class: "optionClass",
            label: "Spouse",
            value: "Spouse"
        });
        options.push({
            class: "optionClass",
            label: "Child",
            value: "Child"
        });
        options.push({
            class: "optionClass",
            label: "Parent / Parent In Law",
            value: "Parent"
        });
        
        component.set("v.relationshipTypeOptions", options);
    },
    generateMemberPicklistOptions :function(component,event)
    {
        var opts = [];
        var opportunityParties = component.get("v.OpportunityPartyDetailsList");
        
        if(opportunityParties != undefined
           && opportunityParties.length > 0)
        {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i = 0; i < opportunityParties.length; i++)
            {
                if(opportunityParties[i].Relationship__c
                   && opportunityParties[i].Relationship__c !='Main Member'
                   && opportunityParties[i].Age__c < 66)
                {
                    let partyName = opportunityParties[i].First_Name__c + ' ' + opportunityParties[i].Last_Name__c;
                    
                    opts.push({
                        class: "optionClass",
                        label: partyName,
                        value: opportunityParties[i].Id
                    });
                }
            }
            component.set("v.existingMemberOptions", opts);
            component.set("v.showExistingMemberOptions", true);
        }
    },
    saveOppPartyData : function(component,event,helper)
    {
        component.set("v.showSpinner",true);
        var oppPartyData =component.get("v.allBeneficiaries");
         // Added by Poulami to update quote status
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        var quoteOutcomeReason = component.find('Quote_Outcome_Reason__c').get("v.value");
        var quoteStatus ;
        if (quoteOutcome == 'Client Interested')
            quoteStatus = 'Accepted';
        else if (quoteOutcome == 'Client Not Interested')
            quoteStatus = 'Rejected';
        else if(quoteOutcome == 'Client Not Insurable' || quoteOutcome == 'Duplicate Quote') 
            quoteStatus = 'Denied';
        else
            quoteStatus = 'Draft';
        component.set('v.quoteStatus', quoteStatus);
        var newlst = [];
        var partylst = [];
        for(var j = 0; j < oppPartyData.length; j++)
        {
            if(oppPartyData[j].hasOwnProperty('Premium')
               && oppPartyData[j].hasOwnProperty('SumAssured'))
            {
                partylst.push({
                    Name: oppPartyData[j].First_Name__c,
                    premium: oppPartyData[j].Premium,
                    SumInsured: oppPartyData[j].SumAssured
                });
                delete oppPartyData[j].Premium;
                delete oppPartyData[j].SumAssured;
            }
        }
        
       /* if(partylst.length > 0)
        {*/
            var action = component.get("c.insertOppPartyData");
            action.setParams({
                "oppPartyList": oppPartyData
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                
                if(state === "SUCCESS")
                {
                    var oppParties = response.getReturnValue();
                    var action = component.get('c.createDDQuote');
                    
                    for(var i = 0; i < oppParties.length; i++){
                        for(var j = 0; j < partylst.length; j++){
                            if(oppParties[i].First_Name__c == partylst[j].Name)
                            {
                                newlst.push({
                                    Name: 'Health Assistance',
                                    premium: partylst[j].premium,
                                    SumInsured: partylst[j].SumInsured,
                                    OppPartyId : oppParties[i].Id
                                });
                            }
                        }
                    }
                    
                    action.setParams({
                        oppId: component.get('v.OpportunityFromFlow'),
                        totalPremium: '',
                        product: 'Health Assistance',
                        lineItems: JSON.stringify(newlst),
                        partyType: 'Health Assistance',
                        oppData : component.get("v.opportunityDetails"),//added newly
                        quoteStatus :quoteStatus
                    });
                    action.setCallback(this, function(a){
                        
                        var actionState = a.getState();
                        
                        if(actionState === 'SUCCESS')
                        {
                            component.set("v.showSpinner",false);
                            var toastEvent = $A.get('e.force:showToast');
                            toastEvent.setParams({
                                title: 'Success!',
                                message: 'Quote Created',
                                type: 'success'
                            });
                            
                            toastEvent.fire();
                            var editQuote=component.get("v.showQuoteEdit");
                            if(editQuote ==true){
                                //showQuoteEditEvent
                                component.set("v.updateQuoteScreenClose",false);
                                
                            }
                            else{
                            var actionClicked = event.getSource().getLocalId();
                            var navigate = component.getEvent("navigateFlowEvent");
                            navigate.setParam("action", actionClicked);
                            navigate.setParam("outcome", quoteStatus);
                            navigate.fire();
                            }
                        }else{
                            console.log('error '+ a.getError());
                            console.log('error '+ JSON.stringify(a.getError()));
                            component.set("v.showSpinner",false);
                            var toastEvent = $A.get('e.force:showToast');
                            toastEvent.setParams({
                                title: 'Error!',
                                message: 'Error creating new quote. Please try again!',
                                type: 'error',
                                mode: 'sticky'
                            });
                            
                            toastEvent.fire();
                        }
                        
                        $A.get('e.force:refreshView').fire();
                    });
                    
                    $A.enqueueAction(action);
                }else{
                    component.set("v.showSpinner",false);
                    
                }});
            
            $A.enqueueAction(action);
        //}//party list lenght check end
    },
    getOpportunityPartyDetails :function(component,event)
    {
        
        component.set("v.showSpinner",true);
        var oppId = component.get("v.OpportunityFromFlow");
        var oppData = component.get("v.opportunityDetails");//added by praanv
		var quoteStatus;//added by pranav
        var action = component.get("c.getPartyData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                var oppPartyDetailsMap = {};
                var allBeneficiariesData = component.get("v.allBeneficiaries");
                var allOportunityParytData = component.get("v.OpportunityPartyDetailsList");
                var existingData = response.getReturnValue();
                console.log('existingData'+existingData);
                if(existingData != undefined
                   && existingData.length > 0)
                {console.log('existingData1'+existingData);
                    for(var i = 0; i < existingData.length; i++)
                    {
                        if(existingData[i].DD_Cross_Sell_Product_Member_Type__c != undefined
                           && existingData[i].DD_Cross_Sell_Product_Member_Type__c.includes(component.get("v.productNameHealthAssistance")))
                        {
                            allBeneficiariesData.push(existingData[i]);  
                        }
                        
                        allOportunityParytData.push(existingData[i]);
                        oppPartyDetailsMap[existingData[i].Id] = existingData[i];
                    }
                    
                    
                    var action2 = component.get("c.getQuoteLineItemsDataByProduct");
                    action2.setParams({
                        "oppId" : oppId,
                        "productName":'Health Assistance'
                    });
                    action2.setCallback(this, function(res) {
                        var state1 = res.getState();
                        
                        if (state1 === 'SUCCESS') {
                            var quoteData =res.getReturnValue();
                            var premiumData=[];
                            
                            if(quoteData !=undefined && quoteData.length > 0){
                            if(allBeneficiariesData != undefined
                               && allBeneficiariesData.length > 0
                               && quoteData !=undefined
                               && quoteData.length > 0)
                            {
                                for(var j =0; j< allBeneficiariesData.length;j++){
                                    for(var k=0; k< quoteData.length; k++){

                                        oppData.Quote_Outcome__c=quoteData[k].Quote.Quote_Outcome__c;//addedd by pranv 19022021
									    oppData.Quote_Outcome_Reason__c=quoteData[k].Quote.Quote_Outcome_Reason__c;//addedd by pranv 19022021
									    quoteStatus=quoteData[k].Quote.Status;//addedd by pranv 19022021

                                        if(allBeneficiariesData[j].Id == quoteData[k].OpportunityPartyId__c){
                                            allBeneficiariesData[j].Premium=quoteData[k].Premium__c;
                                            allBeneficiariesData[j].SumAssured=quoteData[k].Policy_Cover__c;
                                        }
                                    }
                                    premiumData.push(allBeneficiariesData[j]);
                                }
                                component.set("v.quoteStatus",quoteStatus);//aded by prnav 19022021
							 component.set("v.opportunityDetails" ,oppData);//aded by prnav 19022021
                                
                                component.set("v.allBeneficiaries", premiumData);
                                component.set("v.isQuoteDone", false);
                                component.set("v.showSpinner", false);
                            }
                        }//new  quotelength is added for quote come fiunctinalit
                        else{

                            var action = component.get('c.getQuoteData1');
								action.setParams({
									"oppId": oppId,
									"productName" : 'Health Assistance'
								});
								action.setCallback(this, function (a) {
									var state = a.getState();
									if (state === "SUCCESS") {
										var quoteResp = a.getReturnValue();
										if (quoteResp != null && quoteResp.length > 0) {
                                            console.log('oppData '+JSON.stringify(oppData));
											oppData.Quote_Outcome__c = quoteResp[0].Quote_Outcome__c;
											oppData.Quote_Outcome_Reason__c = quoteResp[0].Quote_Outcome_Reason__c;
											quoteStatus = quoteResp[0].Status;
                                            component.set("v.quoteStatus",quoteStatus);//aded by prnav 19022021
                                            component.set("v.opportunityDetails" ,oppData);
                                            //component.set("v.spinner", false);
                                        }else{
                                            component.set("v.spinner", false);
                                        }

									}
									else {
										component.set("v.spinner", false);
									}
								});
								$A.enqueueAction(action);


                        }
                        }
                    });
                    $A.enqueueAction(action2);
                    
                    if(allBeneficiariesData != undefined
                       && allBeneficiariesData.length > 0)
                    {
                        component.set("v.allBeneficiaries", allBeneficiariesData);
                        component.set("v.showTableDetails", true);
                    }
                    else
                    {
                        component.set("v.allBeneficiaries", []);
                        component.set("v.showTableDetails", false);
                    }
                    
                    component.set("v.OpportunityPartyDetailsMap", oppPartyDetailsMap);
                    component.set("v.OpportunityPartyDetailsList", allOportunityParytData);
                }//new  quotelength is added for quote come fiunctinalit
                else{
					console.log('oppData@');
                    var action = component.get('c.getQuoteData');
                        action.setParams({
                            "oppId": oppId,
                            //"productName" : 'Card Life'
                        });
                        action.setCallback(this, function (a) {
                            var state = a.getState();
                            if (state === "SUCCESS") {
                                var quoteResp = a.getReturnValue();
                                if (quoteResp != null && quoteResp.length > 0) {
                                    console.log('oppData '+JSON.stringify(oppData));
                                    oppData.Quote_Outcome__c = quoteResp[0].Quote_Outcome__c;
                                    oppData.Quote_Outcome_Reason__c = quoteResp[0].Quote_Outcome_Reason__c;
                                    quoteStatus = quoteResp[0].Status;
                                    component.set("v.quoteStatus",quoteStatus);//aded by prnav 19022021
                                    component.set("v.opportunityDetails" ,oppData);
                                    //component.set("v.spinner", false);
                                }

                            }
                            else {
                                component.set("v.spinner", false);
                            }
                        });
                        $A.enqueueAction(action);


                }
                component.set("v.mainMemberAdded", false);
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    getSpouseDetails : function(component, event)
    {
        component.set("v.showSpinner",true);
        component.set("v.memberDetails", {});
        var allOportunityParytData = component.get("v.OpportunityPartyDetailsList");
        
        let hasSpouse = false;
        
        if(allOportunityParytData != undefined
           && allOportunityParytData.length > 0)
        {
            for(var i = 0; i < allOportunityParytData.length; i++)
            {
                if(allOportunityParytData[i].Relationship__c === component.get("v.memberTypeSpouse"))
                {
                    hasSpouse = true;
                    
                    let memberObject = component.get("v.memberDetails");
                    memberObject.Name = allOportunityParytData[i].First_Name__c +''+ allOportunityParytData[i].Last_Name__c;
                    memberObject.First_Name__c = allOportunityParytData[i].First_Name__c;
                    memberObject.Last_Name__c = allOportunityParytData[i].Last_Name__c;
                    memberObject.ID_Type__c = allOportunityParytData[i].ID_Type__c;
                    memberObject.RSA_ID_Number__c = allOportunityParytData[i].RSA_ID_Number__c;
                    memberObject.Date_of_Birth__c = allOportunityParytData[i].Date_of_Birth__c;
                    memberObject.Age__c = allOportunityParytData[i].Age__c;
                    memberObject.DD_Cross_Sell_Product_Member_Type__c = component.get("v.productNameHealthAssistance");
                    memberObject.Relationship__c = allOportunityParytData[i].Relationship__c;
                    memberObject.Gender__c = allOportunityParytData[i].Gender__c;
                    memberObject.Opportunity__c = component.get("v.OpportunityFromFlow");
                    memberObject.Id = allOportunityParytData[i].Id;
                    
                    component.set("v.memberDetails", memberObject);
                }
            }
        }
        
        console.log("hasSpouse " + hasSpouse);
        
        component.set("v.showSpinner", false);
        if(hasSpouse === true)
        {
            component.set("v.showPolicyCoverOptions", true);
        }
        else
        {
            component.set("v.memberDetails", {});
            component.set("v.selectedOptionOnAddMember", '');
            component.set("v.showOptionToAddMember", false); 
            component.set("v.showPolicyCoverOptions", false);
            component.set("v.showExistingMemberOptions", false);
            component.set("v.showNewMemberButton", true);
            component.set("v.selectedMemberResponse",'');
            component.set("v.selectedPolicyCoverAmount",'');
        }
        
        this.getPickListValuesForCoverAmount(component, component.get("v.memberTypeSpouse"));
    },
    getOpportunityDetails : function(component, event)
    {
        var oppId = component.get("v.OpportunityFromFlow");
        var action = component.get("c.fetchOpportunityRecord");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS")
            {
                var oppRecord = a.getReturnValue();
                component.set("v.opportunityDetails", oppRecord[0]); /////chnagd t0 {0}
                component.set("v.memberDetails", {});
                
                let member = component.get("v.memberDetails");
                member.First_Name__c = oppRecord[0].Person_Account_First_Name__c;
                member.Last_Name__c = oppRecord[0].Person_Account_Last_Name__c;
                member.ID_Type__c = oppRecord[0].Person_Id_Type__c;
                member.Relationship__c = component.get("v.memberTypeMainMember");
                member.Age__c = oppRecord[0].Person_Account_Age__c;
                member.RSA_ID_Number__c = oppRecord[0].ID_Number__c;
                member.Date_of_Birth__c = oppRecord[0].Person_BirthDate__c;
                member.DD_Cross_Sell_Product_Member_Type__c = component.get("v.productNameHealthAssistance");
                member.Gender__c = oppRecord[0].Person_Account_Gender__c;
                member.Opportunity__c= oppId;
                
                component.set("v.showSpinner", false);
                
                component.set("v.memberDetails", member);
                //component.set("v.allBeneficiaries", currentData);
                component.set("v.selectedOptionOnAddMember", '');
                component.set("v.showOptionToAddMember", false); 
                component.set("v.selectRelationshipType",'');
                component.set("v.showPolicyCoverOptions", true);
            }
        });
        $A.enqueueAction(action);
    },
    getPickListValuesForIdType : function(component,event)
    {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "--- None ---",
            value: ""
        });
        opts.push({
            class: "optionClass",
            label: "SA Identity Document",
            value: "SA Identity Document"
        });
        /*
        opts.push({
            class: "optionClass",
            label: "Passport",
            value: "Passport"
        });
        opts.push({
            class: "optionClass",
            label: "Temporary ID ",
            value: "Temporary ID "
        });*/
        component.set("v.IdTypeOptions",opts);
        
    },
    validationCheck :function(component, allValid, formId)
    {
        var firstName = component.get("v.memberDetails.First_Name__c");
        if(!(/\S/.test(firstName)))
        {
            firstName = firstName.replace(/\s+/g, '');
            component.set("v.memberDetails.First_Name__c", firstName);
        }
        
        var lastName = component.get("v.memberDetails.Last_Name__c");
        if(!(/\S/.test(lastName)))
        {
            lastName = lastName.replace(/\s+/g, '');
            component.set("v.memberDetails.Last_Name__c", lastName);
        }
        
        allValid = component.find(formId).reduce(function (validSoFar, inputCmp){
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        //Check if date is in past
        var now = new Date();
        var selectedDate = new Date(component.get("v.memberDetails.Date_of_Birth__c"));
        if(selectedDate > now)
        {
            allValid = false; 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Date of Birth cannot be in the future",
                "type":"error"
            });
            toastEvent.fire();
        }
        
        var idNumber = component.get("v.memberDetails.RSA_ID_Number__c");
        if(idNumber === undefined
           || isNaN(idNumber)
           || idNumber.length != 13)
        {
            allValid = false; 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "ID Number is invalid, must be 13 digits",
                "type":"error"
            });
            toastEvent.fire();
        }
        
        var coverAmount = component.get("v.selectedPolicyCoverAmount");
        if(coverAmount === undefined
           || coverAmount === '')
        {
            allValid = false; 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please select Cover Amount",
                "type":"error"
            });
            toastEvent.fire();
        }
        
        return allValid;
    },
    getPickListValuesForCoverAmount : function(component, memberType)
    {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "--- None ---",
            value: ""
        });
        opts.push({
            class: "optionClass",
            label: "R400",
            value: component.get("v.valueEquals400")
        });
        opts.push({
            class: "optionClass",
            label: "R600",
            value: component.get("v.valueEquals600")
        });
        opts.push({
            class: "optionClass",
            label: "R800",
            value: component.get("v.valueEquals800")
        });
        opts.push({
            class: "optionClass",
            label: "R1 000",
            value: component.get("v.valueEquals1000")
        });
        
        if(memberType === component.get("v.memberTypeMainMember")
           || memberType === component.get("v.memberTypeSpouse"))
        {
            opts.push({
                class: "optionClass",
                label: "R1 500",
                value: component.get("v.valueEquals1500")
            });
            opts.push({
                class: "optionClass",
                label: "R2 000",
                value: component.get("v.valueEquals2000")
            });
        }
        
        component.set("v.existingPolicyCoverOptions", opts);
    },
    calculatePremium : function(component, selectedValue)
    {
        let opportunityParty = component.get("v.memberDetails");
        var currentData = component.get("v.allBeneficiaries");
        var currentRecordId = component.get("v.selectedRecordId");
        var memberType = component.get("v.selectedRelationshipType");
        var existingOppDetailMap = component.get("v.OpportunityPartyDetailsMap");
        let policyFound = false;
        
        console.log("DOB " + opportunityParty.Date_of_Birth__c);
        console.log("opportunityParty " + opportunityParty);
        var action = component.get("c.calculateOpportunityPartyAge");
        action.setParams({
            "dateOfBirth": opportunityParty.Date_of_Birth__c
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log("State " + state);
            
            if(state === "SUCCESS")
            {
                var ageAsNumber = a.getReturnValue();
                console.log("Age " + ageAsNumber);
                console.log("Member " + memberType);
                console.log("Selected Value " + selectedValue);
                
                if((memberType === component.get("v.memberTypeMainMember")
                    || opportunityParty.Relationship__c === component.get("v.memberTypeMainMember"))
                   && ageAsNumber != undefined
                   && ageAsNumber > 17
                   && ageAsNumber < 66)
                {
                    if(selectedValue === component.get("v.valueEquals400"))
                    {
                        opportunityParty.SumAssured = 400.00;
                        opportunityParty.Premium = 65.00;
                    }
                    else if(selectedValue === component.get("v.valueEquals600"))
                    {
                        opportunityParty.SumAssured = 600.00;
                        opportunityParty.Premium = 85.00;
                    }
					else if(selectedValue === component.get("v.valueEquals800"))
					{
						opportunityParty.SumAssured = 800.00;
						opportunityParty.Premium = 100.00;
					}
					else if(selectedValue === component.get("v.valueEquals1000"))
					{
                        opportunityParty.SumAssured = 1000.00;
                        opportunityParty.Premium = 125.00;
					}
					else if(selectedValue === component.get("v.valueEquals1500"))
					{
                        opportunityParty.SumAssured = 1500.00;
                        opportunityParty.Premium = 190.00;
					}
					else if(selectedValue === component.get("v.valueEquals2000"))
                    {
                        opportunityParty.SumAssured = 2000.00;
                        opportunityParty.Premium = 250.00;
                    }
                    
                    opportunityParty.Relationship__c = component.get("v.memberTypeMainMember");
                    opportunityParty.DD_Cross_Sell_Product_Member_Type__c = component.get("v.productNameHealthAssistance");
                    component.set("v.mainMemberAdded", true);
                    policyFound = true;
                }
                else if((memberType === component.get("v.memberTypeSpouse")
                        || opportunityParty.Relationship__c === component.get("v.memberTypeSpouse"))
                    && ageAsNumber != undefined
                    && ageAsNumber > 17
                    && ageAsNumber < 66)
                {
                    if(selectedValue === component.get("v.valueEquals400"))
                    {
                        opportunityParty.SumAssured = 400.00;
                        opportunityParty.Premium = 50.00;
                    }
                    else if(selectedValue === component.get("v.valueEquals600"))
                    {
                        opportunityParty.SumAssured = 600.00;
                        opportunityParty.Premium = 70.00;
                    }
					else if(selectedValue === component.get("v.valueEquals800"))
                    {
                        opportunityParty.SumAssured = 800.00;
                        opportunityParty.Premium = 90.00;
                    }
					else if(selectedValue === component.get("v.valueEquals1000"))
					{
						opportunityParty.SumAssured = 1000.00;
						opportunityParty.Premium = 110.00;
					}
					else if(selectedValue === component.get("v.valueEquals1500"))
					{
                        opportunityParty.SumAssured = 1500.00;
                        opportunityParty.Premium = 160.00;
                    }
					else if(selectedValue === component.get("v.valueEquals2000"))
					{
                        opportunityParty.SumAssured = 2000.00;
                        opportunityParty.Premium = 215.00;
                    }
                    
                    opportunityParty.Relationship__c = component.get("v.memberTypeSpouse");
                    opportunityParty.DD_Cross_Sell_Product_Member_Type__c = component.get("v.productNameHealthAssistance");
                    policyFound = true;
                }
				else if((memberType === component.get("v.memberTypeChild")
                        || opportunityParty.Relationship__c === component.get("v.memberTypeChild"))
                        && ageAsNumber != undefined
                        && ageAsNumber < 25)
                {
                    if(selectedValue === component.get("v.valueEquals400"))
                    {
                        opportunityParty.SumAssured = 400.00;
                        opportunityParty.Premium = 20.00;
                    }
                    else if(selectedValue === component.get("v.valueEquals600"))
                    {
                        opportunityParty.SumAssured = 600.00;
                        opportunityParty.Premium = 25.00;
                    }
					else if(selectedValue === component.get("v.valueEquals800"))
                    {
                        opportunityParty.SumAssured = 800.00;
                        opportunityParty.Premium = 30.00;
                    }
					else if(selectedValue === component.get("v.valueEquals1000"))
                    {
                        opportunityParty.SumAssured = 1000.00;
                        opportunityParty.Premium = 35.00;
                    }
                    if($A.util.isEmpty(opportunityParty.Relationship__c)){
                        opportunityParty.Relationship__c = component.get("v.memberTypeChild");  
                    }
                    //opportunityParty.Relationship__c = component.get("v.memberTypeChild");
                    opportunityParty.DD_Cross_Sell_Product_Member_Type__c = component.get("v.productNameHealthAssistance");
                    policyFound = true;
                    
                }
				else if((memberType === component.get("v.memberTypeParent")
                        || opportunityParty.Relationship__c === component.get("v.memberTypeParent"))
                        && ageAsNumber != undefined
                        && ageAsNumber > 39
                        && ageAsNumber < 66)
                {
                    if(selectedValue === component.get("v.valueEquals400"))
                    {
                        opportunityParty.SumAssured = 400.00;
                        opportunityParty.Premium = 75.00;
                    }
                    else if(selectedValue === component.get("v.valueEquals600"))
                    {
                        opportunityParty.SumAssured = 600.00;
                        opportunityParty.Premium = 110.00;
                    }
					else if(selectedValue === component.get("v.valueEquals800"))
                    {
                        opportunityParty.SumAssured = 800.00;
                        opportunityParty.Premium = 145.00;
                    }
					else if(selectedValue === component.get("v.valueEquals1000"))
                    {
                        opportunityParty.SumAssured = 1000.00;
                        opportunityParty.Premium = 180.00;
                    }
                    if($A.util.isEmpty(opportunityParty.Relationship__c)){
                        opportunityParty.Relationship__c = component.get("v.memberTypeParent");  
                    }
                   // opportunityParty.Relationship__c = component.get("v.memberTypeParent");
                    opportunityParty.DD_Cross_Sell_Product_Member_Type__c = component.get("v.productNameHealthAssistance");
                    policyFound = true;
                }
                
                console.log("PREMIUM " + opportunityParty.Premium);
                console.log("SUM ASSURED " + opportunityParty.SumAssured);
                console.log("POLICY FOUND " + policyFound);
                console.log("CURRENT DATA " + currentData.length);
                
                if(policyFound === true)
                {
                    if(currentData != undefined
                       && currentData.length > 0)
                    {
                        let hasMainMember = false;
                        let hasSpouse = false;
                        let alreadyAdded = false;
                        let parentsCount = 1;
                        
                        for(var i = 0; i < currentData.length; i++)
                        {
                            if(currentData[i].Relationship__c === component.get("v.memberTypeMainMember"))
                            {
                                hasMainMember = true;
                            }
                            
                            if(currentData[i].Relationship__c === component.get("v.memberTypeSpouse"))
                            {
                                hasSpouse = true;
                            }
                            
                            if(currentData[i].Relationship__c === component.get("v.memberTypeParent"))
                            {
                                parentsCount += 1;
                            }
                            
                            let currentDataMemberName = currentData[i].First_Name__c +''+ currentData[i].Last_Name__c;
                            let oppPartyName = opportunityParty.First_Name__c +''+ opportunityParty.Last_Name__c;
                            
                            if(currentDataMemberName === oppPartyName)
                            {
                                alreadyAdded = true;
                            }
                        }
                        
                        if(alreadyAdded === false
                           && (((memberType === component.get("v.memberTypeMainMember")
                                || opportunityParty.Relationship__c === component.get("v.memberTypeMainMember"))
                                && hasMainMember === false)
                               || ((memberType === component.get("v.memberTypeSpouse")
                                    || opportunityParty.Relationship__c === component.get("v.memberTypeSpouse"))
                                   && hasSpouse === false)
                               || ((memberType === component.get("v.memberTypeParent")
                                    || opportunityParty.Relationship__c === component.get("v.memberTypeParent"))
                                   && parentsCount < 5)
                               || (memberType === component.get("v.memberTypeChild")
                                   || opportunityParty.Relationship__c === component.get("v.memberTypeChild"))))
                        {
                            currentData.push(opportunityParty);
                        }
                        
                        if((memberType === component.get("v.memberTypeMainMember")
                            || opportunityParty.Relationship__c === component.get("v.memberTypeMainMember"))
                           && hasMainMember === true)
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Main Member Already Added",
                                "type":"error"
                            });
                            toastEvent.fire();          
                        }
                        
                        if((memberType === component.get("v.memberTypeSpouse")
                            || opportunityParty.Relationship__c === component.get("v.memberTypeSpouse"))
                           && hasSpouse === true)
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Spouse Already Added",
                                "type":"error"
                            });
                            toastEvent.fire();          
                        }
                        
                        if((memberType === component.get("v.memberTypeParent")
                            || opportunityParty.Relationship__c === component.get("v.memberTypeParent"))
                           && parentsCount > 4)
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Maximum Number of Parents Reached",
                                "type":"error"
                            });
                            toastEvent.fire();          
                        }
                        
                        if(alreadyAdded === true
                           && (memberType === component.get("v.memberTypeParent")
                               || opportunityParty.Relationship__c === component.get("v.memberTypeParent")
                               || opportunityParty.Relationship__c === component.get("v.memberTypeChild")
                               || memberType === component.get("v.memberTypeChild")))
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Record Already Added",
                                "type":"error"
                            });
                            toastEvent.fire();          
                        }
                        
                    }
                    else
                    {
                        currentData = [];
                        currentData.push(opportunityParty);
                    }
                    
                    component.set("v.allBeneficiaries", currentData);
                    component.set("v.showTableDetails", true);
                    component.set("v.isQuoteDone", true);
                    component.set("v.memberDetails",{});
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "No Applicable Policy Cover Found for this Member Type and Age",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
                
            }
        });
        $A.enqueueAction(action);
    },
})