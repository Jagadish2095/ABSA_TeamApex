({
    saveOppPartyData : function(component,event,helper){
        component.set("v.showSpinner",true);
        var oppPartyData =component.get("v.allBeneficiaries");
        console.log('oppPartyDataBefore',oppPartyData);
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
        for(var j = 0; j < oppPartyData.length; j++){
            if(oppPartyData[j].hasOwnProperty('Premium')){
                partylst.push({
                                    Name: oppPartyData[j].First_Name__c,
                                    lastName: oppPartyData[j].Last_Name__c,
        							premium: oppPartyData[j].Premium,
                        			SumInsured: 0
    			});
                delete oppPartyData[j].Premium;
            }
                  
        }
        console.log('partylst ',partylst);
        console.log('oppPartyData ',oppPartyData);
        if(oppPartyData.length >0 ){
            var action = component.get("c.insertOppPartyData");
            action.setParams({
            "oppPartyList": oppPartyData
        });
            action.setCallback(this, function(a) {
               var state = a.getState();
                console.log('state '+state);
                if (state === "SUCCESS") {
                    var oppParties = a.getReturnValue();
                 	console.log('oppParties after save'+oppParties);
                    console.log('selectedProductFromFlow',component.get('v.selectedProductFromFlow'));
                    var action = component.get('c.createDDQuote');
                    for(var i = 0; i < oppParties.length; i++){
            			for(var j = 0; j < partylst.length; j++){
                            if((oppParties[i].First_Name__c == partylst[j].Name) && (oppParties[i].Last_Name__c == partylst[j].lastName) )
                				newlst.push({
        							Name: 'Road Cover',
        							premium: partylst[j].premium,
                        			SumInsured: 0,
                    				OppPartyId : oppParties[i].Id
    						});
          				}
        			}
                    console.log('newlst',newlst); 
                    console.log('Oppdata '+JSON.stringify(component.get("v.opportunityDetails")));
					action.setParams({
						oppId: component.get('v.OpportunityFromFlow'),
						totalPremium: '',
						product: 'Road Cover',
                		lineItems: JSON.stringify(newlst),
                		partyType: 'Road Cover',
                        oppData : component.get("v.opportunityDetails"),//added newly
                        quoteStatus :quoteStatus
                        
					});
						action.setCallback(this, function(a) {
						var state = a.getState();
						if (state === 'SUCCESS') {
							// show success notification
							component.set("v.showSpinner",false);
							var toastEvent = $A.get('e.force:showToast');
							toastEvent.setParams({
							title: 'Success!',
							message: 'Quote Successfully Created',
							type: 'success'
							});
							toastEvent.fire();
                        //added
                        //
                        var editQuote=component.get("v.showQuoteEdit");
                            if(editQuote ==true){
                                //showQuoteEditEvent
                                component.set("v.updateQuoteScreenClose",false);
                                
                            }else{
                                var actionClicked = event.getSource().getLocalId();
                                // Call that action
                                var navigate = component.getEvent("navigateFlowEvent");
                                navigate.setParam("action", actionClicked);
                                navigate.setParam("outcome", quoteStatus);
                                navigate.fire();
                            }
							//this.quoteExists(component);
							//component.set('v.showQuoteScreen', false);
							//component.set('v.showCommissionScreen', true);
						} else {
							// show error notification
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
					//this.retrieveQuoteData(component);
					//this.hideSpinner(component);
					$A.get('e.force:refreshView').fire();

				//var a = component.get('c.doInit');
				//$A.enqueueAction(a);
				});
				$A.enqueueAction(action);
                    
                }else{
                    component.set("v.showSpinner",false);
                    console.log('Error '+JSON.stringify(a.getError()));
                }
            });
            $A.enqueueAction(action);
        }
    },
    getOpportunitypartyDetails :function(component,event) {
        //component.set("v.OpportunityPartyDetailsList",{});
        var outCome;
        var outComeReason;
        var quoteStatus;
        var oppdata=component.get("v.opportunityDetails");
        component.set("v.showSpinner",true);
        var oppId = component.get("v.OpportunityFromFlow");
        var action = component.get("c.getPartyData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
             var state = a.getState();
            console.log('state '+state)
            if (state === "SUCCESS") {
                var oppPartyDetailsMap = {};//OpportunityPartyDetailsMap
                var allBeneficiariesData = component.get("v.allBeneficiaries");
                var allOportunityParytData=component.get("v.OpportunityPartyDetailsList");//used for creating the existing members list
                var cntInd=component.get("v.riderIndCount");
                var cntFam=component.get("v.riderfamCount");
                var existingData =a.getReturnValue();
                console.log('existingData '+JSON.stringify(existingData));
                if(existingData.length > 0){

                    for(var i=0;i<existingData.length; i++){
                            if(existingData[i].DD_Cross_Sell_Product_Member_Type__c && existingData[i].DD_Cross_Sell_Product_Member_Type__c !=''){ //Rider_Type__c temp chnage
                                //counting the data
                                if(existingData[i].DD_Cross_Sell_Product_Member_Type__c.includes("Rider Individual")){
                                    cntInd=cntInd+1; 
                                    existingData[i].DD_Cross_Sell_Product_Member_Type__c="Rider Individual";   
                                    allBeneficiariesData.push(existingData[i]);
                                }else if(existingData[i].DD_Cross_Sell_Product_Member_Type__c.includes("Rider Family")){
                                    cntFam= cntFam+1;
                                    existingData[i].DD_Cross_Sell_Product_Member_Type__c="Rider Family";   
                                    allBeneficiariesData.push(existingData[i]);  
                                }else if(existingData[i].DD_Cross_Sell_Product_Member_Type__c.includes("Main Member")){
                                    existingData[i].DD_Cross_Sell_Product_Member_Type__c="Main Member";   
                                    allBeneficiariesData.push(existingData[i]);  
                                }else{
                                    allOportunityParytData.push(existingData[i]);
                                    oppPartyDetailsMap[existingData[i].Id]=existingData[i];
                                }
                               // allBeneficiariesData.push(existingData[i]);// Pushing the existing riderdata if any
                            }else{
                                allOportunityParytData.push(existingData[i]);
                                oppPartyDetailsMap[existingData[i].Id]=existingData[i];
                            }
                        
                    }
                    
                    
                    //making second server call for getting quoteline item data
                    var action2 = component.get("c.getQuoteLineItemsDataByProduct");
                    action2.setParams({
                        "oppId" : oppId,
                        "productName":'Road Cover'
                    });
                    action2.setCallback(this, function(res) {
                        var state1 = res.getState();
                        console.log('inside STATE 1 ' +state1);
                        if (state1 === 'SUCCESS') {
                            console.log('inside STATE 1');
                            var quoteData =res.getReturnValue();
                            var riderPremiumdata=[];
                            if(allBeneficiariesData!=null && allBeneficiariesData.length >0 && quoteData!=null && quoteData.length >0){
                                for(var j =0; j< allBeneficiariesData.length;j++){
                                    for(var k=0; k< quoteData.length; k++){
                                        if(allBeneficiariesData[j].Id == quoteData[k].OpportunityPartyId__c){
                                            allBeneficiariesData[j].Premium=quoteData[k].Premium__c;
                                            oppdata.Quote_Outcome__c=quoteData[k].Quote.Quote_Outcome__c;//addedd by pranv 19022021
                                            oppdata.Quote_Outcome_Reason__c=quoteData[k].Quote.Quote_Outcome_Reason__c;//addedd by pranv 19022021
                                            quoteStatus=quoteData[k].Quote.Status;//addedd by pranv 19022021
                                        }
                                    }
                                    riderPremiumdata.push(allBeneficiariesData[j]);
                                }
                                console.log('quoteStatus '+quoteStatus);
                                component.set("v.opportunityDetails",oppdata);
                                console.log('Oppdata '+JSON.stringify(component.get("v.opportunityDetails")))
                                console.log('riderPremiumdata '+JSON.stringify(riderPremiumdata));
                                component.set("v.outCome",outCome);////addedd by pranv 19022021
                                component.set("v.outComeReason",outComeReason);////addedd by pranv 19022021
                                component.set("v.quoteStatus",quoteStatus);////addedd by pranv 19022021
                                component.set("v.allBeneficiaries",riderPremiumdata);
                                component.set("v.isQuoteDone",true);
                                component.set("v.showSpinner",false);
                                
                            }
                            else{
                                component.set("v.allBeneficiaries",allBeneficiariesData) ;
                                if(allBeneficiariesData.length == 0){
                                    this.getOpportunityDetails(component,event);
                                    component.set("v.isQuoteDone",false);
                                }else{
                                    component.set("v.showSpinner",false);
                                }
                                
                            }
                            console.log('benfdata '+ JSON.stringify(component.get("v.allBeneficiaries")));
                        }
                    });
                    $A.enqueueAction(action2);
                    //process end   
                    
                    component.set("v.riderIndCount",cntInd);
                    component.set("v.riderfamCount",cntFam);
                    component.set("v.OpportunityPartyDetailsMap",oppPartyDetailsMap); //opportunity party data except rider details
                    component.set("v.OpportunityPartyDetailsList",allOportunityParytData);
                    
                }else{
                    this.getOpportunityDetails(component,event);
					component.set("v.isQuoteDone",false);
                    component.set("v.showSpinner",false);
                }
               // console.log('allBeneficiariesData',allBeneficiariesData);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getOpportunityDetails :function(component,event) {
       // component.set("v.showSpinner",true);
        var oppId = component.get("v.OpportunityFromFlow");
        console.log(component.get("v.OpportunityFromFlow")+' oppId Road cover '+oppId);
        
        var action = component.get("c.fetchOpportunityRecord");
        
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state '+state)
            if (state === "SUCCESS") {
                console.log('** '+JSON.stringify(a.getReturnValue()));
                var oppRecord = a.getReturnValue();
                oppRecord[0].Quote_Outcome__c=component.get("v.outCome");//addded 
				oppRecord[0].Quote_Outcome_Reason__c=component.get("v.outComeReason");   //added             
                component.set("v.opportunityDetails",oppRecord[0]);
                let objTest =component.get("v.raiderDetails");
                console.log('inside yes '+JSON.stringify(objTest));
                //First_Name__c,Last_Name__c,Rider_Type__c,ID_Type__c,RSA_ID_Number__c,Date_of_Birth__c
                console.log('8888'+oppRecord[0].Person_Account_First_Name__c);
                console.log('8888123'+JSON.stringify(a.getReturnValue().Person_Account_First_Name__c));
                objTest.First_Name__c =oppRecord[0].Person_Account_First_Name__c;//component.get("v.opportunityDetails.Person_Account_First_Name__c");
                objTest.Last_Name__c =oppRecord[0].Person_Account_Last_Name__c;//component.get("v.opportunityDetails.Person_Account_Last_Name__c");
                objTest.DD_Cross_Sell_Product_Member_Type__c ='Main Member';
                objTest.Relationship__c='Main Member';
                objTest.ID_Type__c =oppRecord[0].Person_Id_Type__c;
                objTest.RSA_ID_Number__c =oppRecord[0].ID_Number__c;//component.get("v.opportunityDetails.ID_Number__c");
                objTest.Date_of_Birth__c =oppRecord[0].Person_BirthDate__c//component.get("v.opportunityDetails");
                objTest.Gender__c =oppRecord[0].Person_Account_Gender__c;//component.get("v.opportunityDetails.Person_Account_Gender__c");
                objTest.Opportunity__c=oppId;
                objTest.Premium='49.00';
                var existedData = component.get("v.allBeneficiaries");
                console.log('existedData yes'+JSON.stringify(existedData));
                if(existedData.length >0){
                    existedData.push(objTest);
                }else{
                    existedData=[];
                    existedData.push(objTest);
                }
                component.set("v.showSpinner",false);
                component.set("v.allBeneficiaries",existedData);
                component.set("v.selectedCaptureResponse", '');
                component.set("v.showraiderAsMainMemOption",false); 
                component.set("v.selectedRiderType",'');
                component.set("v.showMainMemberOneTime",true);
            }
        });
        $A.enqueueAction(action);
    },
    
    /**Added Newly by pranav on 11032021for sti product casa verify check**/
    checkAccountValid: function (component,event) {
		component.set('v.showSpinner', true);
		var oppId = component.get("v.OpportunityFromFlow");//component.get('v.recordId');
		var action = component.get('c.casaCheck');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function (response) {
			var state = response;
			var result = response.getReturnValue();
			if (result == 'Valid') {
				component.set('v.accountNotValid', false);
				this.getOpportunitypartyDetails(component);
			} else {
				component.set('v.accountInValidReason', result);
				component.set('v.accountNotValid', true);
                component.set('v.showSpinner', false);
				//component.set("v.showUpScreen", false);
				//component.set("v.showErrorScreen", false);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
  
    
    fetchPickListValForRiderType : function(component,event) {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "--- None ---",
            value: ""
        });
        opts.push({
            class: "optionClass",
            label: "Rider Individual",
            value: "Rider Individual"
        });
        opts.push({
            class: "optionClass",
            label: "Rider Family",
            value: "Rider Family"
        });
        
        component.set("v.RiderTypeOptions",opts);
        
    },
    
    fetchPickListValForIdType : function(component,event) {
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
        opts.push({
            class: "optionClass",
            label: "Passport",
            value: "Passport"
        });
        opts.push({
            class: "optionClass",
            label: "Temporary ID Document",
            value: "Temporary ID Document"
        });
        component.set("v.IdTypeOptions",opts);
        
    },
    generateFamilyPicklistOptions :function(component,event){
        var oppPrtyData = component.get("v.OpportunityPartyDetailsList");
        console.log('*** '+oppPrtyData.length);
        console.log('*** '+JSON.stringify(oppPrtyData));
        var opts = [];
        if(oppPrtyData.length > 0){
            opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
            for(var i = 0; i < oppPrtyData.length; i++){
                console.log('rel '+oppPrtyData[i].Relationship__c +' '+oppPrtyData[i].Name );
                if(oppPrtyData[i].Relationship__c && oppPrtyData[i].Relationship__c!='Main Member'){
                
                    opts.push({
                        class: "optionClass",
                        label: oppPrtyData[i].First_Name__c,
                        value: oppPrtyData[i].Id
                    });
                }else if(oppPrtyData[i].Relationship__c == undefined){
                    opts.push({
                        class: "optionClass",
                        label: oppPrtyData[i].First_Name__c,
                        value: oppPrtyData[i].Id
                    });
                }
            }
            component.set("v.existingFamilyOptions",opts);
            component.set("v.showexistingFamilyOptions",true);//only show when options are there
        }else{
            var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Warning!",
                            "message": "There are no existing Contacts!!",
                            "type":"warning"
                        });
                        toastEvent.fire();
        }
        
    },

    validationCheck :function(component,allValid,formId){
        var firstName = component.get("v.raiderDetails.First_Name__c");
        if (!(/\S/.test(firstName))) {
            firstName = firstName.replace(/\s+/g, '');
            component.set("v.raiderDetails.First_Name__c", firstName);
        }
        
        var lastName = component.get("v.raiderDetails.Last_Name__c");
        if (!(/\S/.test(lastName))) {
            lastName = lastName.replace(/\s+/g, '');
            console.log('lastName'+lastName);
            component.set("v.raiderDetails.Last_Name__c", lastName);
        }
        
        allValid = component.find(formId).reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        //Check if date is in past
        var now = new Date();
        var selectedDate = new Date(component.get("v.raiderDetails.Date_of_Birth__c"));
        /* if(selectedDate > now){
            allValid = false; 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Date of Birth cannot be in the future.",
                "type":"error"
            });
            toastEvent.fire();
        }*/ //coomented fro stndalone app purpose
        return allValid;
    },
    
   
})