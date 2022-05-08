({
    helperMethod : function() {
    },

    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },    
      //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    //Lightning toastie
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
    
    getOpportunityDetails :function(component,event) {
       component.set("v.showSpinner",true);
        var oppId = component.get("v.OpportunityFromFlow");
        var action = component.get("c.fetchOpportunityRecord");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a){
        var state = a.getState();
        
            if (state === "SUCCESS") {
                var resp = a.getReturnValue();
                if(resp[0].Secondary_Life__c== true){
                    resp[0].Secondary_Life__c="true";
                }else if(resp[0].Secondary_Life__c== false){
                    resp[0].Secondary_Life__c="false";
                }
                console.log('resp',resp);
                if(resp[0].Person_Account_Age__c < 18 || resp[0].Person_Account_Age__c > 60)
                    component.set("v.showInvalidScreen", true);
                component.set("v.opportunityDetailsDummy",resp);
                component.set("v.opportunityDetails",resp[0]);
                if(resp[0].Commission__c != undefined && resp[0].Commission__c != null){
                      component.set('v.Commission', Number(resp[0].Commission__c));
                	  component.set('v.CommissionLbl', 'Commission : R' + resp[0].Commission__c); 
                }
                if(resp[0].CreditLife_Plans__c != undefined && resp[0].CreditLife_Plans__c != null){
                    this.getPlanPremiumMatrices(component, resp[0].CreditLife_Plans__c, '','','Credit Life Cover');  
                }  
                this.getOpportunitypartyDetails(component,event);                
            }          
        });
         $A.enqueueAction(action);
    },
    
    getPlanPremiumMatrices: function(component, planName, lowestRange, highestRange, recordType) {
        
		component.set('v.showSpinner', true);
		var oppId = component.get('v.recordId');
		var action = component.get('c.getPricingMatrix');
		action.setParams({
			oppId: oppId,
			planName: planName,
            lowestRange: lowestRange,
            highestRange: highestRange,
			recordType: recordType
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
                var pricingMatrix = a.getReturnValue();
                console.log('pricingMatrix',pricingMatrix);
              for(var k in pricingMatrix){
                if(recordType == 'Credit Life Cover'){
                    if(k == 'Credit_Life_Gross_Premium_Rate__c')
                     	component.set('v.GrossPremiumRate', pricingMatrix.Credit_Life_Gross_Premium_Rate__c);
                    if(k == 'Credit_Life_Secondary_Life_Rate__c')
                     	component.set('v.SecondaryLifePremiumRate', pricingMatrix.Credit_Life_Secondary_Life_Rate__c);
                    if(k == 'Credit_Life_Staff_Rate__c')
                     	component.set('v.StaffPremiumRate', pricingMatrix.Credit_Life_Staff_Rate__c);
                }
                else if(recordType == 'Credit Life Discount Fee'){
                    if(k == 'Credit_Life_Plan_A_Discount_Rate__c')
                     	component.set('v.PlanADiscountRate', pricingMatrix.Credit_Life_Plan_A_Discount_Rate__c);
                    if(k == 'Credit_Life_Plan_B_Discount_Rate__c')
                     	component.set('v.PlanBDiscountRate', pricingMatrix.Credit_Life_Plan_B_Discount_Rate__c);
                    if(k == 'Credit_Life_Plan_C_Discount_Rate__c')
                     	component.set('v.PlanCDiscountRate', pricingMatrix.Credit_Life_Plan_C_Discount_Rate__c);
                     if(k == 'Credit_Life_Plan_D_Discount_Rate__c')
                     	component.set('v.PlanDDiscountRate', pricingMatrix.Credit_Life_Plan_D_Discount_Rate__c);
                     if(k == 'Credit_Life_Plan_E_Discount_Rate__c')
                     	component.set('v.PlanEDiscountRate', pricingMatrix.Credit_Life_Plan_E_Discount_Rate__c);                     
                  }
              }
              if(recordType == 'Credit Life Discount Fee')
              	this.calculatePremium(component);
              else if(recordType == 'Credit Life Cover' && component.find('Intial_Loan_Amount__c').get("v.value") != '' 
                      && component.find('Intial_Loan_Amount__c').get("v.value") != null)
                this.calculatePremium(component);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
    
    calculatePremium: function(component) {
		var coverPlan = component.find('CreditLife_Plans__c').get("v.value");
        var loanAmount = Number(component.find('Intial_Loan_Amount__c').get("v.value"));
        var staffSelected = component.find('Absa_Staff_Member__c').get("v.value");
        var secondarySelected = component.find('guarantorSelectionVal').get("v.value");
		var GrossPremiumRate = Number(component.get('v.GrossPremiumRate'));
		var SecondaryLifePremiumRate = Number(component.get('v.SecondaryLifePremiumRate'));
		var StaffPremiumRate = Number(component.get('v.StaffPremiumRate'));
		var PlanADiscountRate = Number(component.get('v.PlanADiscountRate'));
		var PlanBDiscountRate = Number(component.get('v.PlanBDiscountRate'));
        var PlanCDiscountRate = Number(component.get('v.PlanCDiscountRate'));
        var PlanDDiscountRate = Number(component.get('v.PlanDDiscountRate'));
        var PlanEDiscountRate = Number(component.get('v.PlanEDiscountRate'));
        var discount ;
        var premium ;
        if(coverPlan != null && coverPlan != undefined && loanAmount != null){

        	if(coverPlan == 'Plan A')
            	discount = PlanADiscountRate;
        	else if(coverPlan == 'Plan B')
            	discount = PlanBDiscountRate;
         	else if(coverPlan == 'Plan C')
            	discount = PlanCDiscountRate;
         	else if(coverPlan == 'Plan D')
            	discount = PlanDDiscountRate;
         	else if(coverPlan == 'Plan E')
            	discount = PlanEDiscountRate;
        	console.log('discount',discount);
            console.log('secondarySelected',secondarySelected);
        	if(staffSelected == false && (secondarySelected == 'false' || secondarySelected == ''))
            	premium = (((loanAmount * GrossPremiumRate)/1000) * (1-(discount/100)));
        	else if(staffSelected == true && (secondarySelected == 'false' || secondarySelected == ''))
            	premium = (((loanAmount * StaffPremiumRate)/1000) * (1-(discount/100)));
        	else if(staffSelected == true && secondarySelected == 'true')
            	premium = 2 * (loanAmount/1000 * StaffPremiumRate) * (1-(discount/100));
        	else if(staffSelected == false && secondarySelected == 'true')
            	premium = ((((loanAmount * GrossPremiumRate)/1000) + ((loanAmount * SecondaryLifePremiumRate)/1000)) * (1-(discount/100)));   

          	component.set('v.CoverPremium', premium.toFixed(2));
			component.set('v.CoverPremiumLbl', 'Premium : R' + premium.toFixed(2));
            if(staffSelected == false)
        		this.calculateCommission(component);
            else{
                component.set('v.Commission', 0.0);
				component.set('v.CommissionLbl', 'Commission : R' + 0.0);
            }
        }

	},
    
    calculateCommission: function(component) {
		var coverPremium = component.get('v.CoverPremium');
		var total =(Number(coverPremium) * 0.225).toFixed(2);
		component.set('v.Commission', total);
		component.set('v.CommissionLbl', 'Commission : R' + total);
    },
    
    saveOppPartyData : function(component,event,helper){
        component.set("v.showSpinner",true);
        var OppPrtyDetailsExisting =component.get("v.OppPrtyDetailsExisting");//using for updating the saame party if exists for the second time
        var opportunityNewData = component.get("v.opportunityDetails");
        var selctedResponse = component.find('guarantorSelectionVal').get("v.value");
        opportunityNewData.Commission__c=component.get("v.Commission");
        if(selctedResponse=="true"){
            opportunityNewData.Secondary_Life__c=true;
        }else if(selctedResponse=="false"){
            opportunityNewData.Secondary_Life__c=false;
        }
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

        console.log('oppData '+JSON.stringify(component.get("v.opportunityDetails")));
        var opportunityExistingData = component.get("v.opportunityDetailsDummy");
        var mainMemCreation ={};
        var partyList=[];
        mainMemCreation.Name = opportunityExistingData[0].Person_Account_Last_Name__c;
        mainMemCreation.First_Name__c = opportunityNewData.Person_Account_Last_Name__c;
        mainMemCreation.DD_Cross_Sell_Product_Member_Type__c='AVAF Credit Life';
        //mainMemCreation.DD_Cross_Sell_Product_Member_Type__c= opportunityNewData.Product_Interest__r.Product__c;
        mainMemCreation.Premium =component.get("v.CoverPremium");
        mainMemCreation.Opportunity__c = component.get("v.OpportunityFromFlow");

        var oppPartyData =component.get("v.OppPrtyDetails");
		//appending ID if exist for upddate
      	for(var j = 0; j < OppPrtyDetailsExisting.length; j++){
          console.log(j,'OppPrtyDetailsExisting[j]',OppPrtyDetailsExisting[j]);
        if(OppPrtyDetailsExisting[j].Last_Name__c){
            oppPartyData.Id=OppPrtyDetailsExisting[j].Id;
        }
        else{//if(OppPrtyDetailsExisting[j].Last_Name__c ==''){
            mainMemCreation.Id=OppPrtyDetailsExisting[j].Id;
        }
      }

        console.log('oppPartyData '+JSON.stringify(oppPartyData));
        if( selctedResponse == "true" && oppPartyData.Last_Name__c  && (oppPartyData.Last_Name__c !='' && oppPartyData.Last_Name__c != null) ){
                //oppPartyData.DD_Cross_Sell_Product_Member_Type__c=opportunityNewData.Product_Interest__r.Product__c;
                oppPartyData.DD_Cross_Sell_Product_Member_Type__c='AVAF Credit Life';
                oppPartyData.Opportunity__c = component.get("v.OpportunityFromFlow");
                partyList.push(oppPartyData);
        }
        console.log('oppPartyData '+JSON.stringify(oppPartyData));
        partyList.push(mainMemCreation);// fromation of opportunity party creation end

        var newlst = [];
        var partylst = [];
        for(var j = 0; j < partyList.length; j++){
            if(partyList[j].hasOwnProperty('Premium')){
                partylst.push({
                                    Name: partyList[j].Name,
                                   // lastName: partyList[j].Last_Name__c,
        							premium: partyList[j].Premium,
                        			sumInsured: component.get("v.opportunityDetails").Outstanding_Capital__c
    			});
                delete partyList[j].Premium;
            }
                  
        }
        console.log('partylst '+JSON.stringify(partylst));
        if(partyList.length >0 ){
                var action = component.get("c.insertOppPartyData");
                action.setParams({
                "oppPartyList": partyList
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                    if (state === "SUCCESS") {
                        var oppParties = a.getReturnValue();
                        var action2 = component.get('c.createDDQuote');
                        for(var i = 0; i < oppParties.length; i++){
                            for(var j = 0; j < partylst.length; j++){
                                if((oppParties[i].Name == partylst[j].Name) )
                                    newlst.push({
                                        Name: 'AVAF Credit Life',
                                        premium: partylst[j].premium,
                                        SumInsured: partylst[j].sumInsured,
                                        OppPartyId : oppParties[i].Id
                                });
                              }
                        }//outer For ends
                        console.log('opportunityNewDatasavee###',opportunityNewData); 
					    action2.setParams({
						oppId: component.get('v.OpportunityFromFlow'),
						totalPremium: '',
						product: 'AVAF Credit Life',
                		lineItems: JSON.stringify(newlst),
                        partyType: 'AVAF Credit Life',
                        oppData :opportunityNewData,
                        quoteStatus :quoteStatus
                    });
                    
                    action2.setCallback(this, function(a) {
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
                            var editQuote=component.get("v.showQuoteEdit");
                            if(editQuote ==true){
                                //showQuoteEditEvent
                                component.set("v.updateQuoteScreenClose",false);
                                
                            }else{
                        //added
                         var actionClicked = event.getSource().getLocalId();
                        // Call that action
                        var navigate = component.getEvent("navigateFlowEvent");
                        navigate.setParam("action", actionClicked);
                        navigate.setParam("outcome", quoteStatus);
                        navigate.fire();
                            }
						} else {
							// show error notification
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
				$A.enqueueAction(action2); 
                    }//frst success ends
                    else{
                        component.set("v.showSpinner",false);
                        console.log('Error '+JSON.stringify(a.getError()));
                    }
            });
            $A.enqueueAction(action);
        }
    },//method endds

    getOpportunitypartyDetails :function(component,event) {
        //component.set("v.OpportunityPartyDetailsList",{});
        var oppdetails= component.get("v.opportunityDetails");
        var quotestatus;
        component.set("v.showSpinner",true);
        var oppId = component.get("v.OpportunityFromFlow");
        console.log('oppId',oppId);
        var action = component.get("c.getPartyData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(res) {
             var state = res.getState();
            console.log('state '+state)
            if (state === "SUCCESS") {
                var oppPartyDetailsMap = {};//OpportunityPartyDetailsMap
                var oppPartyData =res.getReturnValue();
                component.set("v.OppPrtyDetailsExisting",oppPartyData);
                component.set("v.OppPrtyDetails",oppPartyData[0]);
                console.log('oppPartyData',oppPartyData);
                for(var j = 0; j < oppPartyData.length; j++){
                    if(oppPartyData[j].Last_Name__c ){
                        component.set("v.opportunityPartyId",oppPartyData[j].Id);
                        component.set("v.showGuarantorFields",true);
                    }
                }
                var action2 = component.get("c.getQuoteLineItemsDataByProduct");
                    action2.setParams({
                        "oppId" : oppId,
                        "productName":'AVAF Credit Life'
                    });
                    action2.setCallback(this, function(res) {
                        var state1 = res.getState();
                        if (state1 === 'SUCCESS') {
                            var quoteData =res.getReturnValue();
                            if(quoteData!=null && quoteData.length >0){
                                
                                for(var j =0; j< oppPartyData.length;j++){
                                    for(var k=0; k< quoteData.length; k++){
                                        if(oppPartyData[j].Id == quoteData[k].OpportunityPartyId__c){
                                            component.set('v.CoverPremium', Number(quoteData[k].Premium__c));
		                                    component.set('v.CoverPremiumLbl', 'Premium : R' + quoteData[k].Premium__c);
                                        	oppdetails.Quote_Outcome__c=quoteData[k].Quote.Quote_Outcome__c;
                                            oppdetails.Quote_Outcome_Reason__c=quoteData[k].Quote.Quote_Outcome_Reason__c;
                                            quotestatus=quoteData[k].Quote.Status;
                                        }
                                    }
                                }
								component.set("v.quoteStatus",quotestatus);
                                console.log('quotestatus'+quotestatus);
								component.set("v.opportunityDetails",oppdetails);
                                component.set("v.isQuoteDone",true);
                                component.set("v.showEditButton",true);
                                component.set("v.readOnlyFields",true); //
                                component.set("v.showSpinner",false);
                            }else{
                                component.set("v.isQuoteDone",false);
                                component.set("v.showSpinner",false);
                                component.set("v.readOnlyFields",false); 
                                component.set("v.showEditButton",false);
                            }
                        }

                    });
                    $A.enqueueAction(action2);

                //component.set("v.showSpinner",true);
            }//success If ends
            else{
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
})