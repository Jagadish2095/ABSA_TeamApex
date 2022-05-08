({
	helperMethod: function() {},

	fetchPickListVal: function(component, fieldName, elementId) {
		this.showSpinner(component);

		var action = component.get('c.getselectOptions');
		action.setParams({
			objObject: component.get('v.pricingMatrix'),
			fld: fieldName
		});
		var opts = [];
		action.setCallback(this, function(response) {
			if (response.getState() == 'SUCCESS') {
				var allValues = response.getReturnValue();
				if (allValues != undefined && allValues.length > 0) {
					opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
					});
				}
				for (var i = 0; i < allValues.length; i++) {
					opts.push({
						class: 'optionClass',
						label: allValues[i],
						value: allValues[i]
					});
				}
				if (elementId == 'flexiFuneralCover') {
                    for (var i = 1; i < opts.length; i++) {
                        if(Number(opts[i].value) > component.get("v.MainMemberCoverAvailable")){
                            opts.splice(i,1);
                            i--;
                        }                           
                    }
					component.set('v.CoverOptions', opts);
				} else if (elementId == 'GroceryBenefitCover') {
					component.set('v.GroceryBenefitCoverOptions', opts);
				} else if (elementId == 'funeralBenefit') {
                    
					component.set('v.FuneralBenefitCoverOptions', opts);
				}
				this.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},
    
    getPolicyCreate: function(component) {
		component.set('v.showSpinner', true);

		var oppId = component.get('v.selectedOppIdFromFlow');
		var action = component.get('c.getPolicy');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				component.set('v.policySession', data);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
    
    getMemberPremium : function(component, sumInsured, recordType,sumSource) {
        component.set('v.showSpinner', true);
		var oppId = component.get("v.selectedOppIdFromFlow");
		var action = component.get('c.getMemberPremiumWbif');
        console.log('policySession',component.get('v.policySession'));
        console.log('sumInsured',sumInsured);
        console.log('recordType',recordType);
		action.setParams({
			oppId: oppId,
			sumInsured: sumInsured,
			recordType: recordType,
			policy: component.get('v.policySession')
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
                console.log('***'+a.getReturnValue());
                var total = a.getReturnValue();
                this.calculatePremium(component, total,sumInsured,sumSource);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	retrieveQuoteData: function(component) {
		component.set('v.showSpinner', true);

		var oppId = component.get('v.recordId');
		var action = component.get('c.getQuoteLineItemsData');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                console.log('returnValue',returnValue);
                var mainLife = [];
                if (returnValue != null) {
					var i;
					var totalMainLifePremium = 0;
					for (i = 0; i < returnValue.length; i++) {
                       if(returnValue[i].Relationship_Type__c == 'Main Member'){
							totalMainLifePremium += Number(returnValue[i].Premium__c);
                           	mainLife.push(returnValue[i]);
                            if(returnValue[i].Benefit__c == 'Flexi Funeral')
                                component.set("v.selectedCoverAmountToFlow", returnValue[i].Policy_Cover__c);
                       }   
					}
                    component.set("v.response", mainLife);
					component.set('v.quoteTotal', totalMainLifePremium.toFixed(2));
                    component.set('v.secondYearPremium', (Number(totalMainLifePremium) + Number(totalMainLifePremium * 0.05)).toFixed(2));
                    component.set('v.totalPremium', totalMainLifePremium.toFixed(2));
					component.set('v.totalPremiumLbl', 'Total Premium : R' + totalMainLifePremium.toFixed(2));
				} 
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	fetchTotalQuoteData: function(component) {
		var oppId = component.get('v.recordId');
		var action = component.get('c.getTotalQuoteData');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				component.set('v.quoteTotal', data);
                component.set('v.secondYearPremium', (Number(data) + Number(data * 0.05)).toFixed(2));
			}
		});
		$A.enqueueAction(action);
	},

	quoteExists: function(component) {
		component.set('v.showSpinner', true);

		var oppId = component.get('v.recordId');

		var action = component.get('c.checkIfQuoteExists');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				var totalPremium = a.getReturnValue();
				if (totalPremium != null) {
					component.set('v.showQuoteScreen', false);
					component.set('v.showCommissionScreen', true);
					this.getExistingQuote(component);//addded

				} else {
					component.set('v.showQuoteScreen', true);
					component.set('v.showCommissionScreen', false);

					this.getExistingQuote(component);
				}
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
	
    fetchOpportunityDetails: function(component) {
		component.set('v.showSpinner', true);
        
        if(component.get('v.recordId') !== undefined)
			var oppId = component.get('v.recordId');
        else{
            var oppId = component.get('v.selectedOppIdFromFlow');
            component.set("v.recordId", oppId);
        }
            
		console.log('oppId',oppId);
		var action = component.get('c.fetchOpportunityRecord');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
                
                var opportunities = a.getReturnValue();
                console.log('opportunities',opportunities);
                if (a.getReturnValue() != null){
					component.set("v.objTypes", opportunities[0]);
                	var opptyRecordType = opportunities[0].Opportunity_Record_Type_Name__c;
                    for(var k in opportunities[0]){
                        if(k == 'Product_Interest__c'){
                            var opptyProductInt = opportunities[0].Product_Interest__r.Product__c;
                        	component.set('v.opptyProductInt', opptyProductInt);
                        }
                   		if(k == 'Quote_on_Spouse__c')
                            component.set('v.isSpouseAdded', opportunities[0].Quote_on_Spouse__c);
                        if(k == 'Quote_on_Child__c')
                            component.set('v.isChildAdded', opportunities[0].Quote_on_Child__c);
                        if(k == 'Quote_on_Extended_Family__c')
                            component.set('v.isExtendedFamilyAdded', opportunities[0].Quote_on_Extended_Family__c);
                	}
                    component.set('v.opptyRecordType', opptyRecordType);
                    component.set('v.MainMemberCoverAvailable', opportunities[0].Available_Cover__c);
                 }
                //Set picklist values
                if(opptyRecordType === 'Direct Delivery Sales Opportunity'){
                    this.fetchPickListVal(component, 'Flexi_Funeral_Cover__c', 'flexiFuneralCover');
					this.fetchPickListVal(component, 'Grocery_Benefit_Cover__c', 'GroceryBenefitCover');
            		this.fetchPickListVal(component, 'Benefit_Cover__c', 'funeralBenefit');
                    this.getPremiumMatrices(component, '', 'Flexi Funeral Rate');
                }
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
    
	getExistingQuote: function(component) {
		component.set('v.showSpinner', true);

		var oppId = component.get('v.recordId');
		var opptyRecordType = component.get('v.opptyRecordType'); 
        var opptyProductInt = component.get('v.opptyProductInt');
		var oppdata =component.get("v.objTypes");//added by pranav on 20 2 2021
		var quoteStatus;
		var action = component.get('c.getQuoteLineItemsData');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				if (a.getReturnValue() != null && a.getReturnValue().length > 0) { // made changes by pranav added size check
					var quoteLineItems = a.getReturnValue();
					component.set('v.quoteLineItems', quoteLineItems);
                    var newlst = [];
                    var benefit = component.get('v.benefitMap');
					var i;
					for (i = 0; i < quoteLineItems.length; i++) {
                     if(opptyRecordType === 'Direct Delivery Sales Opportunity'){
                         if(quoteLineItems[i].Relationship_Type__c == 'Main Member'){

							/**Added by pranav on 20 02 2021 */
							oppdata.Quote_Outcome__c=quoteLineItems[i].Quote.Quote_Outcome__c;//addedd by pranv 19022021
                            oppdata.Quote_Outcome_Reason__c=quoteLineItems[i].Quote.Quote_Outcome_Reason__c;//addedd by pranv 19022021
                            quoteStatus=quoteLineItems[i].Quote.Status;//addedd by pranv 19022021
							/**End */
                                newlst.push({
        						Name: quoteLineItems[i].Benefit__c,
        						premium: quoteLineItems[i].Premium__c,
                                OppPartyId: '',
                                SumInsured: quoteLineItems[i].Policy_Cover__c
                                
    						});
 						if (quoteLineItems[i].Benefit__c == 'Flexi Funeral') {
                            component.set('v.selectedCoverValue',quoteLineItems[i].Policy_Cover__c);
                            // added newly by pranav on 22-06-2021 for PPR
                            if(quoteLineItems[i].Policy_Cover__c == '100000'){
                                component.set('v.hideBenifits',false);
                            }else{
                                component.set('v.hideBenifits',true); 
                            }//changes end
                            component.set('v.CoverPremium',quoteLineItems[i].Premium__c);
                            component.set('v.CoverPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
                        }
                        else if(quoteLineItems[i].Benefit__c == 'Grocery Benefit'){
                            component.set('v.isGroceryBenefitSelected',true);
                            component.set('v.disabled4', false);//find('GroceryBenefitSelect').
                            component.set('v.selectedGroceryBenefitCoverValue',quoteLineItems[i].Policy_Cover__c);
                            component.set('v.GroceryBenefitPremium',quoteLineItems[i].Premium__c);
                            component.set('v.GroceryBenefitPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
						}
						else if(quoteLineItems[i].Benefit__c == 'Unveiling Benefit'){
                            component.set('v.isUnveilingBenefitSelected',true);
                            component.set('v.disabled2', false);//find("unveilingSelect").
                            component.set('v.selectedUnveilingBenefitCoverValue',quoteLineItems[i].Policy_Cover__c);
                            component.set('v.UnveilingBenefitPremium',quoteLineItems[i].Premium__c);
                            component.set('v.UnveilingBenefitPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
						}
                		else if(quoteLineItems[i].Benefit__c == 'After Funeral Benefit'){
                            component.set('v.isFuneralBenefitSelected',true);
                            component.set('v.disabled3', false);//find('afterfuneralSelect').
                            component.set('v.selectedFuneralBenefitCoverValue',quoteLineItems[i].Policy_Cover__c);
                            component.set('v.AfterFuneralBenefitPremium',quoteLineItems[i].Premium__c);
                            component.set('v.AfterFuneralBenefitPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
						}
            			else if(quoteLineItems[i].Benefit__c == 'Car Hire Benefit'){
                            if(quoteLineItems[i].Premium__c == 25)
                            	component.set('v.selectedCarTypeValue','Standard');
                            else
                                component.set('v.selectedCarTypeValue','Luxury');
                            component.set('v.isCarHireSelected',true);
                            component.set('v.disabled1', false);//find('carTypeSelect').
                            component.set('v.CarHireBenefitPremium',quoteLineItems[i].Premium__c);
                            component.set('v.CarHireBenefitPremiumLbl',  'Premium : R' + quoteLineItems[i].Premium__c);
						}
                        else if(quoteLineItems[i].Benefit__c == 'Premium Payment Benefit'){
                            if(quoteLineItems[i].Premium__c == 5)
                                component.set('v.isPremiumPaymentSelected',true);
                            component.set('v.PremiumPaymnetBenefitPremium',quoteLineItems[i].Premium__c);
						}
                      }
                      }
					}
					console.log('quoteStatus '+quoteStatus);
                  component.set("v.objTypes",oppdata);//addedd by pranv 20022021
				  component.set("v.quoteStatus",quoteStatus);////addedd by pranv 20022021
					component.set('v.benefitMap',newlst);
				}//quote line item fetch end
				else{// fetching quote data for outcome and reasons
						var action = component.get('c.getQuoteDatawithoutchilds');
						action.setParams({
							"oppId": oppId,
							"productName" : 'Flexi Funeral'
						});

						action.setCallback(this, function(a){
							var state = a.getState();
							if (state === "SUCCESS") { 
								var quoteResp = a.getReturnValue();
								console.log('quoteResp '+JSON.stringify(quoteResp));
								if(quoteResp!=null && quoteResp.length > 0){
									oppdata.Quote_Outcome__c=quoteResp[0].Quote_Outcome__c;
									oppdata.Quote_Outcome_Reason__c=quoteResp[0].Quote_Outcome_Reason__c;
									quoteStatus=quoteResp[0].Status;
									}
									
									console.log('quoteStatus '+quoteStatus);
								component.set("v.objTypes",oppdata);//addedd by pranv 20022021
								component.set("v.quoteStatus",quoteStatus);////addedd by pranv 20022021
							}
						});
						$A.enqueueAction(action);

				}// quote logic end
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

    getPremiumMatrices: function(component, sumInsured, product, sumSource) {
        
		component.set('v.showSpinner', true);
		var oppId = component.get('v.recordId');
		var action = component.get('c.getPricingMatrix');
		action.setParams({
			oppId: oppId,
			sumInsured: sumInsured,
			product: product
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
                var pricingMatrix = a.getReturnValue();
                console.log('pricingMatrix',pricingMatrix);
                for(var k in pricingMatrix){
                if(product == 'Flexi Funeral Rate'){
                    if(k == 'Main_Member_Rate__c')
                     	component.set('v.MainMemberPremiumRate', pricingMatrix.Main_Member_Rate__c);
                    if(k == 'Grocery_Benefit_Rate__c')
                     	component.set('v.MainMemberGroceryRate', pricingMatrix.Grocery_Benefit_Rate__c);
                    if(k == 'Unveiling_Benefit_Rate__c')
                     	component.set('v.MainMemberUnveilingRate', pricingMatrix.Unveiling_Benefit_Rate__c);
                    if(k == 'After_Burial_Benefit_Rate__c')
                     	component.set('v.MainMemberFuneralRate', pricingMatrix.After_Burial_Benefit_Rate__c);
                }
                else if(product == 'Flexi Funeral Discount'){
                    if(sumSource == 'flexiFuneralCover'){
                        if(k == 'FF_Main_Member_Discount_Rate__c'){
                        	component.set('v.MainMemberDiscountRate', pricingMatrix.FF_Main_Member_Discount_Rate__c);
                        	this.calculatePremium(component, component.get('v.MainMemberPremiumRate'),pricingMatrix.FF_Main_Member_Discount_Rate__c, sumInsured, sumSource);
                        }
                     }
                    if(sumSource == 'GroceryBenefitSelect'){
                        if(k == 'FF_Grocery_Benefit_Discount_Rate__c'){
                        	component.set('v.MainMemberGroceryDiscountRate', pricingMatrix.FF_Grocery_Benefit_Discount_Rate__c);
                        	this.calculatePremium(component, component.get('v.MainMemberGroceryRate'), pricingMatrix.FF_Grocery_Benefit_Discount_Rate__c, sumInsured, sumSource);
                        }
                     }
                  }
              }
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

    calculateTotal: function(component) {
		var coverPremium = component.get('v.CoverPremium');
		var GroceryBenefitPremium = component.get('v.GroceryBenefitPremium');
		var funeralFeePremium = component.get('v.AfterFuneralBenefitPremium');
		var UnveilingBenefitPremium = component.get('v.UnveilingBenefitPremium');
		var CarHireBenefitPremium = component.get('v.CarHireBenefitPremium');
		var PremiumPaymnetBenefitPremium = component.get('v.PremiumPaymnetBenefitPremium');

		var total =
			(Number(coverPremium) +
			Number(GroceryBenefitPremium) +
			Number(funeralFeePremium) +
			Number(UnveilingBenefitPremium) +
			Number(CarHireBenefitPremium) +
			Number(PremiumPaymnetBenefitPremium)).toFixed(2);
		component.set('v.totalPremium', total);
		component.set('v.totalPremiumLbl', 'Total Premium : R' + total);
	},
    
    calculatePremium: function(component, rate, discount,sumInsured,sumSource) {
     // calculatePremium: function(component, total,sumInsured,sumSource) {  
		var label = '';
        var premium = '';
        var total = (((sumInsured * rate) - ((discount * sumInsured * rate)/100))/1000);
        if(sumSource === 'flexiFuneralCover'){
            component.set('v.CoverPremium', total.toFixed(2));
			component.set('v.CoverPremiumLbl',  'Premium : R' + total.toFixed(2));
            label = 'Flexi Funeral';
            premium = total.toFixed(2);
        }	
        else if(sumSource == 'GroceryBenefitSelect'){
            component.set('v.GroceryBenefitPremium', (Number(total)*12).toFixed(2));
		    component.set('v.GroceryBenefitPremiumLbl', 'Premium : R' + (Number(total)*12).toFixed(2));
		    //component.set('v.GroceryBenefitPremium', total.toFixed(2));
		    //component.set('v.GroceryBenefitPremiumLbl', 'Premium : R' + total.toFixed(2));
            label = 'Grocery Benefit';
            premium = (Number(total)*12).toFixed(2);
            //premium = total.toFixed(2);
        }
        else if(sumSource == 'afterfuneralSelect'){
            component.set('v.AfterFuneralBenefitPremium', total.toFixed(2));
			component.set('v.AfterFuneralBenefitPremiumLbl', 'Premium : R' + total.toFixed(2));
            label = 'After Funeral Benefit';
            premium = total.toFixed(2);
        }
        else if(sumSource == 'unveilingSelect'){
            component.set('v.UnveilingBenefitPremium', total.toFixed(2));
			component.set('v.UnveilingBenefitPremiumLbl', 'Premium : R' + total.toFixed(2));
            label = 'Unveiling Benefit';
            premium = total.toFixed(2);
        }
        else if(sumSource == 'carTypeSelect'){
            if(sumInsured === 'Standard'){
                 component.set('v.CarHireBenefitPremium', 25);
			     component.set('v.CarHireBenefitPremiumLbl', 'Premium : R' + 25);
            }
            else {
                 component.set('v.CarHireBenefitPremium', 35);
				 component.set('v.CarHireBenefitPremiumLbl', 'Premium : R' + 35);
            }
            label = 'Car Hire Benefit';
            sumInsured = 0;
            premium = component.get('v.CarHireBenefitPremium');
        }
        else if(sumSource == 'PremiumPaymentBenefitCheckbox'){
            if(sumInsured == true){
                 component.set('v.PremiumPaymnetBenefitPremium', 5);
				 component.set('v.PremiumPaymnetBenefitPremiumLbl', 'Premium : R' + 5);
            }
            else{
                 component.set('v.PremiumPaymnetBenefitPremium', 0);
				 component.set('v.PremiumPaymnetBenefitPremiumLbl', 'Premium : R0.00');
            }
            label = 'Premium Payment Benefit';
            sumInsured = 0;
            premium = component.get('v.PremiumPaymnetBenefitPremium');
	    }
            var benefitDetails = {};
            benefitDetails.Name = label;
            benefitDetails.premium = premium;//premium;
            benefitDetails.SumInsured = sumInsured;
        	benefitDetails.OppPartyId = '';
            var newlst = [];
            var benefit = component.get('v.benefitMap');
        	console.log('benefit',benefit);
            if(benefit.length > 0){
            	for (var i = 0; i < benefit.length; i++){
                    if(benefit[i].Name == label)
                    	 benefit.splice(i,1);
                }
        	}
            if(benefit[0] == undefined)
                newlst.push(benefitDetails);
            else{
                for (var i = 0; i < benefit.length; i++){
                	newlst[Number(i)+1] = benefit[i];
            	}
                newlst[0] = benefitDetails;  
           	}
            component.set('v.benefitMap',newlst);
            this.calculateTotal(component);
	},

	createNewQuote: function(component) {
		
		//if (component.get('v.totalPremium') !== 0) {
			this.showSpinner(component);
			/**Added by pranv for quote outocme functionality on 20022021 */
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
            /**end */
			var oppId = component.get('v.recordId');
            var benefit = component.get('v.benefitMap');
            console.log('Map',benefit);
			var action = component.get('c.createDDQuote');
            
			action.setParams({
				oppId: oppId,
				totalPremium: component.get('v.totalPremium').toString(),
				product: component.get('v.selectedProductNameFromFlow'),
                lineItems: JSON.stringify(benefit),
                partyType: 'Main Member',
                spouseChecked: component.find("SpouseCheckbox").get('v.value'),
                childChecked: component.find("ChildCheckbox").get('v.value'),
                extendedFamilyChecked: component.find("ExtendedFamilyCheckbox").get('v.value'),
				oppData : component.get("v.objTypes"),//added newly
            	quoteStatus :quoteStatus
			});
			action.setCallback(this, function(a) {
				var state = a.getState();
				if (state === 'SUCCESS') {
                    component.set('v.selectedCoverAmountToFlow',component.get('v.selectedCoverValue'))
					// show success notification
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						title: 'Success!',
						message: 'Quote Successfully Created',
						type: 'success'
					});
					toastEvent.fire();
					component.set('v.OutcomeToFlow',component.get("v.quoteStatus"));
                    var editQuote=component.get("v.showQuoteEdit");
                    if(editQuote ==false){
                          //showQuoteEditEvent
                        component.set("v.updateQuoteScreenClose",false);
                    }else{
					var navigate = component.get("v.navigateFlow");
      				navigate("NEXT");
                    //this.quoteExists(component);
                    }
				} else {
					// show error notification
					console.log('error',+JSON.stringify(a.getError()));
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
				this.hideSpinner(component);
				/*$A.get('e.force:refreshView').fire();

				var a = component.get('c.doInit');
				$A.enqueueAction(a);*/  //commebted on 20 02 2021
			});
			$A.enqueueAction(action);
		//}//prem end
	},

	showSpinner: function(component) {
		var spinner = component.find('TheSpinner');
		$A.util.removeClass(spinner, 'slds-hide');
	},

	hideSpinner: function(component) {
		var spinner = component.find('TheSpinner');
		$A.util.addClass(spinner, 'slds-hide');
	},

	setHelpTextAfterFuneral: function(component) {
	    var afterFuneralBenefitHelp = $A.get("$Label.c.DD_After_Funeral_Benefit");
        component.set('v.afterFuneralBenefitHelpText', afterFuneralBenefitHelp);
        },
     setHelpTextCarHire: function(component) {

            var carHireBenefitHelp = $A.get("$Label.c.DD_Car_Hire_Benefit");
            component.set('v.carHireBenefitHelpText', carHireBenefitHelp);
        },
      setHelpTextGrocery: function(component) {
      	    var groceryBenefitHelp = $A.get("$Label.c.DD_Grocery_Benefit");
            component.set('v.groceryBenefitHelpText', groceryBenefitHelp);
        },
       setHelpTextUnveiling: function(component) {
       	    var unveilingBenefitHelp = $A.get("$Label.c.DD_Unveiling_Benefit");
               component.set('v.unveilingBenefitHelpText', unveilingBenefitHelp);
        },
        setHelpTextWaiver: function(component) {

        	    var waiverBenefitHelp = $A.get("$Label.c.DD_Waiver_of_Premium");
                component.set('v.waiverBenefitHelpText', waiverBenefitHelp);
        }
});