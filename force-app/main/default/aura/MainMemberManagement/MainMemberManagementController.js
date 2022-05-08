({
	myAction: function(component, event, helper) {},

	doInit: function(component, event, helper) {
       var opts = [];
       opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
		});
        opts.push({
						class: 'optionClass',
						label: 10000,
						value: 10000
		});
        component.set('v.UnveilingBenefitCoverOptions', opts);// aaded by pranav
        helper.fetchOpportunityDetails(component);
		helper.quoteExists(component);
		helper.retrieveQuoteData(component);
		helper.setHelpTextAfterFuneral(component);
		helper.setHelpTextCarHire(component);
		helper.setHelpTextGrocery(component);
		helper.setHelpTextUnveiling(component);
		helper.setHelpTextWaiver(component);
	},

	onBenefitCheck: function(component, event, helper) {
        
        var benefitCheckSource = event.getSource().getLocalId();
        var benefitCheckValue = event.getSource().get('v.value');
        var benefitName = event.getSource().get("v.label");
		if (benefitCheckSource == 'GroceryBenefitCheckbox') {
           var groceryBenefit = component.find("GroceryBenefitSelect");
            if(benefitCheckValue == true)
			component.set('v.disabled4',false);//groceryBenefit
            else{
				component.set('v.disabled4',true);
                 component.set('v.selectedGroceryBenefitCoverValue', '');
                 component.set('v.GroceryBenefitPremium', 0);
				 component.set('v.GroceryBenefitPremiumLbl', 'Premium : R0.00');
           		 }
               
			} else if(benefitCheckSource == 'AfterfuneralBenefitCheckbox'){
				var funeralBenefit = component.find("afterfuneralSelect");
            	if(benefitCheckValue == true)
				component.set('v.disabled3',false);//funeralBenefit
            	else{
					component.set('v.disabled3',true);
                 	component.set('v.selectedFuneralBenefitCoverValue', '--- None ---');
                 	component.set('v.AfterFuneralBenefitPremium', 0);
				 	component.set('v.AfterFuneralBenefitPremiumLbl', 'Premium : R0.00');
            	}
               
			}
        	else if(benefitCheckSource == 'UnveilingBenefitCheckbox'){
				var unveilingBenefit = component.find("unveilingSelect");
                if(benefitCheckValue == true){
           			component.set('v.disabled2',false);
                    var opts = [];
                    opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
					});
                    opts.push({
						class: 'optionClass',
						label: 10000,
						value: 10000
					});
                    component.set('v.UnveilingBenefitCoverOptions', opts);
                }
            	else{
                	component.set('v.disabled2',true);//unveilingBenefit
                	component.set('v.selectedUnveilingBenefitCoverValue', '--- None ---');
                	component.set('v.UnveilingBenefitPremium', 0);
					component.set('v.UnveilingBenefitPremiumLbl', 'Premium : R0.00');
            	}     
			}
        	else if(benefitCheckSource == 'CarHireBenefitCheckbox'){
				var carHireBenefit = component.find("carTypeSelect");
            	if(benefitCheckValue == true)
				component.set('v.disabled1',false);//carHireBenefit.set('v.disabled',false);
            	else{
                	component.set('v.disabled1',true);//carHireBenefit.set('v.disabled',true);
                	component.set('v.selectedCarTypeValue', '--- None ---');
					component.set('v.CarHireBenefitPremiumLbl', 'Premium : R0.00');
            	}
                
			}
        	else if(benefitCheckSource == 'PremiumPaymentBenefitCheckbox'){
            	if(benefitCheckValue == true)
           			helper.calculatePremium(component, 0, 0 , benefitCheckValue, benefitCheckSource);
			}
        
        	else if(benefitCheckSource == 'SpouseCheckbox'){
            	if(benefitCheckValue == true)
           			component.set('v.isSpouseAdded',true);
            	else
                	component.set('v.isSpouseAdded',false);
			}
        	else if(benefitCheckSource == 'ChildCheckbox'){
            	if(benefitCheckValue == true)
           			component.set('v.isChildAdded',true);
            	else
                	component.set('v.isChildAdded',false);
			}
        	else if(benefitCheckSource == 'ExtendedFamilyCheckbox'){
            	if(benefitCheckValue == true)
           			component.set('v.isExtendedFamilyAdded',true);
            	else
                	component.set('v.isExtendedFamilyAdded',false);
			}  
		
        	if(benefitCheckValue == false && benefitCheckSource != 'SpouseCheckbox' && benefitCheckSource != 'ChildCheckbox' && benefitCheckSource != 'ExtendedFamilyCheckbox'){
            	var benefitMap = component.get('v.benefitMap');
                var Premium;
            	for(var i = 0; i < benefitMap.length; i++){
                	if(benefitMap[i].Name == benefitName){
                        Premium = benefitMap[i].premium;
                    	benefitMap.splice(i,1);
                	}
            	}
                var finalPremium = Number(component.get('v.totalPremium')) - Number(Premium);
                component.set('v.totalPremium', finalPremium);
				component.set('v.totalPremiumLbl', 'Total Premium : R' + finalPremium);
            	component.set('v.benefitMap',benefitMap);
        }
	},
    
    //Cancel button 
    cancelAndCloseTab : function(component, event, helper) {
        //Close focus tab and navigate home
        component.set("v.showQuoteScreen", false);
        component.set("v.showCommissionScreen", true);
    },

	onPicklistCoverChange: function(component, event, helper) {
		var sumInsured = event.getSource().get('v.value');
        var sumSource = event.getSource().getLocalId();
        var benefitName = event.getSource().get("v.label");
        var opptyRecordType = component.get('v.opptyRecordType');
        var opptyProductInt = component.get('v.opptyProductInt');
        // added below changes by pranav on 22-06-0-2021 for ppr
        if(sumInsured == '100000'){
            component.set('v.hideBenifits',false);
            
            component.set('v.isGroceryBenefitSelected',false);
            component.set('v.selectedGroceryBenefitCoverValue','');
            component.set('v.GroceryBenefitPremium', 0);
		    component.set('v.GroceryBenefitPremiumLbl', 'Premium : R0.00');// resseting grocery benfit 
            
              component.set('v.isFuneralBenefitSelected',false);
           	 component.set('v.selectedFuneralBenefitCoverValue', '--- None ---');
             component.set('v.AfterFuneralBenefitPremium', 0);
			 component.set('v.AfterFuneralBenefitPremiumLbl', 'Premium : R0.00');// reseting After Funeral Benefit
            
              component.set('v.isUnveilingBenefitSelected',false);
            component.set('v.selectedUnveilingBenefitCoverValue', '--- None ---');
            component.set('v.UnveilingBenefitPremium', 0);
			component.set('v.UnveilingBenefitPremiumLbl', 'Premium : R0.00');// Unveiling Benefit
            
              component.set('v.isCarHireSelected',false);
            component.set('v.selectedCarTypeValue', '--- None ---');
		  component.set('v.CarHireBenefitPremiumLbl', 'Premium : R0.00');// carhire
            var dummylist =[];
            component.set('v.benefitMap',dummylist);
            console.log('benifitmap',JSON.stringify(component.get('v.benefitMap')));
			
        }else{
           component.set('v.hideBenifits',true); 
        }
        //--changes end by pranav
		if (sumInsured == '') {
            if(sumSource == 'flexiFuneralCover'){
                component.set('v.CoverPremium', 0);
				component.set('v.CoverPremiumLbl', 'Premium : R0.00');
            }
            else if(sumSource == 'GroceryBenefitSelect'){
                component.set('v.GroceryBenefitPremium', 0);
				component.set('v.GroceryBenefitPremiumLbl', 'Premium : R0.00');
            }
            else if(sumSource == 'afterfuneralSelect'){
                component.set('v.AfterFuneralBenefitPremium', 0);
				component.set('v.AfterFuneralBenefitPremiumLbl', 'Premium : R0.00');
            }
            else if(sumSource == 'unveilingSelect'){
                component.set('v.UnveilingBenefitPremium', 0);
				component.set('v.UnveilingBenefitPremiumLbl', 'Premium : R0.00');
            }
            else if(sumSource == 'carTypeSelect'){
                component.set('v.CarHireBenefitPremium', 0);
				component.set('v.CarHireBenefitPremiumLbl', 'Premium : R0.00');
            }
        } else {
            if(opptyRecordType === 'Direct Delivery Sales Opportunity'){

                if(sumSource === 'flexiFuneralCover' || sumSource === 'GroceryBenefitSelect'){
                    if(sumInsured == 15000)
                        helper.calculatePremium(component, component.get('v.MainMemberPremiumRate'), 0 , sumInsured, sumSource);
                    else if(sumInsured == 1000)
                        helper.calculatePremium(component, component.get('v.MainMemberGroceryRate'), 0 , sumInsured, sumSource);
                    else
                        helper.getPremiumMatrices(component, sumInsured, 'Flexi Funeral Discount',sumSource);
                  }
            	else if(sumSource === 'afterfuneralSelect')
                	helper.calculatePremium(component, component.get('v.MainMemberFuneralRate'), 0 , sumInsured, sumSource);
                else if(sumSource === 'unveilingSelect')
                        helper.calculatePremium(component, component.get('v.MainMemberUnveilingRate'), 0 , sumInsured, sumSource);
                else if(sumSource === 'carTypeSelect')
                    helper.calculatePremium(component, 0, 0 , sumInsured, sumSource); 
			   }
            }
            helper.calculateTotal(component);
		},

	newQuoteProcess: function(component, event, helper) {
		component.set('v.showQuoteScreen', true);
		component.set('v.showCommissionScreen', false);
		helper.getExistingQuote(component);
        helper.retrieveQuoteData(component);
		//helper.checkAccountValid(component);
	},
 
    handleNext : function(component, event, helper) {
		
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
      if(response == 'NEXT'){
            component.set('v.selectedSpouseToFlow',component.get("v.isSpouseAdded"));
   			component.set('v.selectedChildToFlow',component.get("v.isChildAdded"));
      		component.set('v.selectedExtendedFamilyToFlow',component.get("v.isExtendedFamilyAdded")); 
            component.set('v.OutcomeToFlow',component.get("v.quoteStatus"));
        }
      var navigate = component.get("v.navigateFlow");
      //navigate("NEXT");
      navigate(response);
   },
    
    
    handleChange : function(component, event, helper) {
      var response = event.getSource().getLocalId();
      component.set("v.value", response);
	  var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
      var coverValue = component.find("flexiFuneralCover").get('v.value');//added by pranav 20 02 2021
	
        if(quoteOutcome==undefined){
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
					title: 'Error!',
					message: 'Please select Quote Outcome',
					type: 'error'
			});
	toastEvent.fire();
	}//added by pranav 20 02 2021 ends
     else{
      	if((coverValue == null || coverValue == '') && quoteOutcome == 'Client Interested'){
            var toastEvent = $A.get('e.force:showToast');
	  		toastEvent.setParams({
					title: 'Error!',
					message: 'Please enter the Cover value.',
					type: 'error'
		    });
	   toastEvent.fire();
      } else if((component.get("v.objTypes.Person_Account_Age__c") < 18 || component.get("v.objTypes.Person_Account_Age__c") > 70 ) && quoteOutcome == 'Client Interested') {
          var toastEvent = $A.get('e.force:showToast');
	  		toastEvent.setParams({
					title: 'Error!',
					message: 'Main Member Age should be in between 18 and 70.',
					type: 'error'
		    });
	   toastEvent.fire();
      }
      else{
            component.set('v.selectedSpouseToFlow',component.get("v.isSpouseAdded"));
      		component.set('v.selectedChildToFlow',component.get("v.isChildAdded"));
      		component.set('v.selectedExtendedFamilyToFlow',component.get("v.isExtendedFamilyAdded"));
          	component.set('v.OutcomeToFlow',component.get("v.quoteStatus"));
          	helper.createNewQuote(component);
        }
     }
   }
});