({
    myAction : function(component, event, helper) {

    },

    doInit : function(component, event, helper) {
        component.set("v.OppPrtyDetailsExisting",{})
        component.set("v.OppPrtyDetails",{})
        helper.getOpportunityDetails(component,event);
    },
    
    onPlanChange: function(component, event, helper) {
        var  opportunityNewData = component.get("v.opportunityDetails");
		var planName = event.getSource().get('v.value');       
        if (planName !== '' || planName !== '--None--'){
             var loanAmount = Number(component.find('Intial_Loan_Amount__c').get("v.value"));
        	 if (loanAmount !== '' || loanAmount !== null){
            		if(loanAmount <= 50000){
                		component.set('v.PlanADiscountRate', 0);
                		component.set('v.PlanBDiscountRate', 0);
                		component.set('v.PlanCDiscountRate', 0);
                		component.set('v.PlanDDiscountRate', 0);
                		component.set('v.PlanEDiscountRate', 0);
                		helper.calculatePremium(component);
           	 		}
            		else if(loanAmount > 1000000){
                
                		var toastEvent = helper.getToast("Error", "The Initial Loan amount cannot be more than 1000000.", "error");
                		toastEvent.fire();
                		helper.hideSpinner(component);
            		}
            		else{
                 		var lowestRange = Number(loanAmount - (loanAmount % 5000));
            	 		var highestRange = Number((loanAmount + 5000) - (loanAmount % 5000));
                        highestRange = highestRange.toFixed(0);
                 		if(lowestRange >= 125000 && highestRange <= 250000){
                    		lowestRange = 125000;
                    		highestRange = 250000;
                 		}
                 		console.log('lowestRange',lowestRange);
                 		console.log('highestRange',highestRange);
            	 		helper.getPlanPremiumMatrices(component, '', lowestRange, highestRange, 'Credit Life Discount Fee');
            		}
                 }
                 else{
                     var rate = '';
                     if(planName == 'Plan A')
                         rate = 0.8;
                     else if(planName == 'Plan B')
                         rate = 0.9;
                     else if(planName == 'Plan C' || planName == 'Plan E')
                         rate = 1.0;
                     else if(planName == 'Plan D')
                         rate = 1.3;
                     var premium = (Number(loanAmount) * rate)/1000;
                     component.set('v.CoverPremium', premium.toFixed(2));
					component.set('v.CoverPremiumLbl', 'Premium : R' + premium.toFixed(2));                     
                 }
        	}    
          helper.getPlanPremiumMatrices(component, planName, '','','Credit Life Cover');
    },
    
    handleEdit :  function(component, event, helper) {
        component.set("v.isQuoteDone",false);
        component.set("v.showEditButton",false);
        component.set("v.readOnlyFields",false); 
    },

    handleCancel : function(component, event, helper) {
        component.set("v.isQuoteDone",true);
        component.set("v.showEditButton",true);
        component.set("v.readOnlyFields",true); 
    },
    
    /*onLoanAmountChange: function(component, event, helper) {
        var loanAmount = Number(component.find('Intial_Loan_Amount__c').get("v.value"));
        if (loanAmount !== '' || loanAmount !== null){
            if(loanAmount <= 50000){
                component.set('v.PlanADiscountRate', 0);
                component.set('v.PlanBDiscountRate', 0);
                component.set('v.PlanCDiscountRate', 0);
                component.set('v.PlanDDiscountRate', 0);
                component.set('v.PlanEDiscountRate', 0);
                helper.calculatePremium(component);
            }
            else if(loanAmount > 1000000){
                
                var toastEvent = helper.getToast("Error", "The Initial Loan amount cannot be more than 1000000.", "error");
                toastEvent.fire();
                helper.hideSpinner(component);
            }
            else{
                 var lowestRange = loanAmount - (loanAmount % 5000);
            	 var highestRange = (Number(loanAmount) + 5000) - (loanAmount % 5000);
            	 helper.getPlanPremiumMatrices(component, '', lowestRange, highestRange, 'Credit Life Discount Fee');
            }
        }         
	},*/
    
    onCheckboxChange: function(component, event, helper) {
		var checkboxName = component.find('Absa_Staff_Member__c').get("v.value");
  		console.log('checkboxName',checkboxName);
        console.log('component.get("v.StaffPremiumRate")',component.get("v.StaffPremiumRate"));
        if(checkboxName === true ){
            if(component.get("v.StaffPremiumRate") == '' && component.find('CreditLife_Plans__c').get("v.value") != '')
                helper.getPlanPremiumMatrices(component, component.find('CreditLife_Plans__c').get("v.value"), 'Credit Life Cover');
            else
                helper.calculatePremium(component);
        } 
        else
            helper.calculatePremium(component);
	},

    showGuarantorFieldsSection : function(component, event, helper) {
        var selctedResponse = component.find('guarantorSelectionVal').get("v.value");
        var loanAmount = Number(component.find('Intial_Loan_Amount__c').get("v.value"));
        console.log('selctedResponse',selctedResponse);
        if(selctedResponse == "true"){
            if(component.get("v.SecondaryLifePremiumRate") == '' && component.find('CreditLife_Plans__c').get("v.value") == ''){
                var c = component.get('c.onLoanAmountChange');
                $A.enqueueAction(c);
            }
            else
                 helper.calculatePremium(component);
            component.set("v.showGuarantorFields",true);
        }else{
            helper.calculatePremium(component);
            component.set("v.showGuarantorFields",false)
            component.set("v.OppPrtyDetails",{'sobjectType':'Opportunity_Party__c'});
        }
    },

    handleChangeNext :function(component,event,helper){
        var opportunityNewData = component.get("v.opportunityDetails");
        var secondlifefields = component.get("v.showGuarantorFields");
        var cardLifePlan = component.find('CreditLife_Plans__c').get("v.value");
        var initialAmount = component.find('Intial_Loan_Amount__c').get("v.value");
        var gurantorSelected = component.find('guarantorSelectionVal').get("v.value");
        var oppPartydetails =component.get("v.OppPrtyDetails");
        console.log('oppPartydetails '+JSON.stringify(oppPartydetails));
    
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");

        if( component.get("v.showInvalidScreen") == true){
            var toastEvent = helper.getToast("Error", "Main Member Age should be between 18 and 60", "error");
                toastEvent.fire();
                return null;
        }
         if(quoteOutcome == '' || quoteOutcome == null){
            var toastEvent = helper.getToast("Error", "Please select Quote Outcome.", "error");
                toastEvent.fire();
                return null;
        }
        else{        
        	if(quoteOutcome == 'Client Interested'){
        		if( cardLifePlan == '' || cardLifePlan == null){
            		var toastEvent = helper.getToast("Error", "Please select Credit Life Plan.", "error");
                	toastEvent.fire();
                	return null;
        		}
        		else if( initialAmount == '' || initialAmount == null){
            		var toastEvent = helper.getToast("Error", "Please select Initial Loan Amount.", "error");
                	toastEvent.fire();
                	return null;
        		}
        		else if(gurantorSelected == '' || gurantorSelected == null){
            		var toastEvent = helper.getToast("Error", "Please select the client adding a guarantor to the policy", "error");
                	toastEvent.fire();
                	return null;
        		}
        		else if(secondlifefields == true){
                    if($A.util.isEmpty(oppPartydetails) ){
                        var toast = helper.getToast("Validation Warning", "Please fill the Guarantor Fields", "warning");
            			toast.fire();
            		return null;
                    }
           		    else if(oppPartydetails.Initials__c == null || oppPartydetails.Initials__c == '' ){
            			var toast = helper.getToast("Validation Warning", "Please provide Intials for the Guarantor", "warning");
            			toast.fire();
            		return null;
        		}
         			else if(oppPartydetails.Last_Name__c == null || oppPartydetails.Last_Name__c == '' ){
            		var toast = helper.getToast("Validation Warning", "Please provide Last name for the Guarantor", "warning");
            		toast.fire();
            		return null;
        		}
            		else if(oppPartydetails.Date_of_Birth__c == null || oppPartydetails.Date_of_Birth__c == ''){
            		var toast = helper.getToast("Validation Warning", "Please provide Date of Birth  for the Guarantor", "warning");
            		toast.fire();
            		return null;
        		}
            		else if( oppPartydetails.RSA_ID_Number__c == null || oppPartydetails.RSA_ID_Number__c == ''){
            		var toast = helper.getToast("Validation Warning", "Please provide ID number for the Guarantor", "warning");
            		toast.fire();
            		return null;
        		}
                    //aded here for second life check 
                    
                    else{
                        var LabelName = event.getSource().get("v.label");
        				if(LabelName == 'Quote'){
            				helper.saveOppPartyData(component,event,helper); 
                    	}
                        else{
           					var actionClicked = event.getSource().getLocalId();
           					// Call that action
           					var navigate = component.getEvent("navigateFlowEvent");
           					navigate.setParam("action", actionClicked);
           					navigate.setParam("outcome", component.get("v.quoteStatus"));
           					navigate.fire();
        					}
                    }
                    //--end on 04032020
                    
                    
        		}
                else{
                        var LabelName = event.getSource().get("v.label");
        				if(LabelName == 'Quote'){
            				helper.saveOppPartyData(component,event,helper); 
                    	}
                        else{
           					var actionClicked = event.getSource().getLocalId();
           					// Call that action
           					var navigate = component.getEvent("navigateFlowEvent");
           					navigate.setParam("action", actionClicked);
           					navigate.setParam("outcome", component.get("v.quoteStatus"));
           					navigate.fire();
        					}
                    }
        	}
            else{
        		var LabelName = event.getSource().get("v.label");
        		if(LabelName == 'Quote'){
            		helper.saveOppPartyData(component,event,helper); 
        		}else{
           		var actionClicked = event.getSource().getLocalId();
           		// Call that action
           		var navigate = component.getEvent("navigateFlowEvent");
           		navigate.setParam("action", actionClicked);
           		navigate.setParam("outcome", component.get("v.quoteStatus"));
           		navigate.fire();
        		}
            }
        } 
    },
    handleChangePrev : function(component,event,helper){
        var actionClicked = event.getSource().getLocalId();
            // Call that action
            var navigate = component.getEvent("navigateFlowEvent");
            navigate.setParam("action", actionClicked);
            navigate.fire();
 },
})