({
	helperMethod : function() {
		
    },
    //Creating a final quote.
    createQuoteData : function(component,event){
        //added
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
        component.set("v.showSpinner",true);
        var oppPartyData =component.get("v.oppPartyDetailsList");
        //if(component.get("v.selectedPlan")!=''){
	    var action = component.get("c.insertOppPartyData");
            action.setParams({
            "oppPartyList": oppPartyData
        });
          action.setCallback(this, function(a) {
                var state = a.getState();
              if (state === "SUCCESS") {
                  var oppParties = a.getReturnValue();
                  var oppPartyId='';
                  if(oppParties.length>0){
                      if(oppParties[0].Id){
                        oppPartyId =oppParties[0].Id
                      }
                  }
                  //--
                 // if(component.get("v.selectedPlan")!=''){
                     
                      var oppdata= component.get("v.opportunityDetails");
                      console.log('oppdata '+JSON.stringify(oppdata));
                      console.log('***'+component.get("v.selectedPlan"));
                      console.log('***'+component.get("v.premium"));
                      var qteList =[];
                      qteList.push({
                          Name: component.get("v.selectedPlan"),
                          premium: component.get("v.premium"),
                          SumInsured: component.get("v.coverage"),
                          OppPartyId : oppPartyId
                      });
                      var action1 = component.get("c.createDDQuote");
                      action1.setParams({
                          oppId: component.get('v.OpportunityFromFlow'),
                          totalPremium: '',
                          product: 'Law 4 u',
                          lineItems: JSON.stringify(qteList),
                          partyType: 'Law 4 u',
                          oppData : component.get("v.opportunityDetails"),//added newly
                        quoteStatus :quoteStatus
                      });
                      action1.setCallback(this, function(a) {
                          var state = a.getState();
                          console.log('state'+state)
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
                            navigate.setParam("outcome", quoteStatus);
                            navigate.setParam("action", actionClicked);
                            navigate.fire();
                            }
                          }else {
                              console.log('Error ==> '+ a.getError());
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
                          //$A.get('e.force:refreshView').fire();
                      });
                      $A.enqueueAction(action1);
             // }
                    
                  //--
              }//suucess check end 
              else{
                component.set("v.showSpinner",false);
            }  
            });
        	$A.enqueueAction(action);
        //} if pln empty end
        
    
        
        /*else{
            component.set("v.showSpinner",false);
                              var toastEvent = $A.get('e.force:showToast');
                              toastEvent.setParams({
                                  title: 'Error!',
                                  message: 'Please select Plan First!',
                                  type: 'error',
                                  mode: 'sticky'
                              });
                              toastEvent.fire();
        }*/
          
    },
    // geetting plan and preium values for creating the quote
    getPlanPremiums :function(component,event){
        var premiumMap ={};
        var coverageMap={};
        var action = component.get("c.getPremiumPlan");
        action.setCallback(this, function(a) {
            var state = a.getState();
            var data=a.getReturnValue();
            if (state === "SUCCESS") {
                for(var i=0 ;i <data.length; i++){
                    premiumMap[data[i].MasterLabel]=data[i].Premium__c;
                    coverageMap[data[i].MasterLabel]=data[i].Benefit_Level__c;
                }
                component.set("v.planpremiumMap",premiumMap);
                component.set("v.planCovergeMap",coverageMap);
            }
        });
        $A.enqueueAction(action);
        
    },
     //Law for u 
    fetchPickListValForPlan : function(component,event) {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "--- None ---",
            value: ""
        });
        opts.push({
            class: "optionClass",
            label: "Core",
            value: "Core"
        });
        opts.push({
            class: "optionClass",
            label: "Comprehensive",
            value: "Comprehensive"
        });
        opts.push({
            class: "optionClass",
            label: "Essential",
            value: "Essential"
        });
        opts.push({
            class: "optionClass",
            label: "Gold",
            value: "Gold"
        });
        opts.push({
            class: "optionClass",
            label: "Premium",
            value: "Premium"
        });
        component.set("v.planOptions",opts);
        
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
                this.getOpportunityDetails(component,event);
       			 this.getOpportunityPartyDetails(component,event);
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
  
    
    getOpportunityDetails :function(component,event) {
       component.set("v.showSpinner",true);
       var quoteStatus;
        var oppId = component.get("v.OpportunityFromFlow");
        //
        
        //
        console.log(component.get("v.OpportunityFromFlow")+' oppId Road cover '+oppId);
        var action = component.get("c.fetchOpportunityRecord");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a){
		var state = a.getState();
            if (state === "SUCCESS") {
                var resp =a.getReturnValue();
                var action = component.get('c.getQuoteLineItemsDataByProduct');
                action.setParams({
                    "oppId": oppId,
                    "productName" : 'Law 4 u'
                });
                action.setCallback(this, function(a){
                    var state = a.getState();
                    if (state === "SUCCESS") { 
                        var quoteResp = a.getReturnValue();
                        if(quoteResp!=null && quoteResp.length > 0){
                            var totresp =[];
                            resp[0].Premium=quoteResp[0].Premium__c;
                            resp[0].Law_For_U_Plan__c=quoteResp[0].Benefit__c;
                            resp[0].Coverage=quoteResp[0].Policy_Cover__c;
                            resp[0].Quote_Outcome__c=quoteResp[0].Quote.Quote_Outcome__c;//addedd by pranv 19022021
                            resp[0].Quote_Outcome_Reason__c=quoteResp[0].Quote.Quote_Outcome_Reason__c;//addedd by pranv 19022021
                            quoteStatus=quoteResp[0].Quote.Status;//addedd by pranv 19022021
                            totresp.push(resp[0]);
                            component.set("v.data",totresp);
                            component.set("v.selectedPlan",quoteResp[0].Benefit__c);
                            component.set("v.quoteStatus",quoteStatus);//addded
                            component.set("v.opportunityDetails",totresp[0]);
                            component.set("v.isQuoteDone",true);
                            component.set("v.showSpinner",false);
                        } //Ending quote length check
                        else{
                            var action = component.get('c.getQuoteData1');
                            action.setParams({
                                "oppId": oppId,
                                "productName" : 'Law 4 u'
                            });
                            action.setCallback(this, function(a){
                                var state = a.getState();
                                if (state === "SUCCESS") { 
                                    var quoteResp = a.getReturnValue();
                                    if(quoteResp!=null && quoteResp.length > 0){
                                        resp[0].Quote_Outcome__c=quoteResp[0].Quote_Outcome__c;
                                        resp[0].Quote_Outcome_Reason__c=quoteResp[0].Quote_Outcome_Reason__c;
                                        quoteStatus=quoteResp[0].Status;
                                        component.set("v.quoteStatus",quoteStatus);
                                        component.set("v.opportunityDetails",resp[0]);
                                        component.set("v.data",resp);
                                        component.set("v.isQuoteDone",true);
                                        component.set("v.showSpinner",false);
                                    }
                                    else{
                                        component.set("v.opportunityDetails",resp[0]);
                                        component.set("v.data",resp);
                                        component.set("v.isQuoteDone",false);
                                        component.set("v.showSpinner",false);
                                    }

                                }
                                else{
                                    component.set("v.showSpinner",false);
                                }
                            });
                            $A.enqueueAction(action);
                            /*component.set("v.opportunityDetails",resp[0]);
                             component.set("v.data",resp);
                             component.set("v.isQuoteDone",true);
                             component.set("v.showSpinner",false);*/
                        }
                    }
                    else{
                        component.set("v.showSpinner",false);
                    }
                });
                $A.enqueueAction(action); //server call for geeting quote line item data if exist to display on the table
            }
            else{
                component.set("v.showSpinner",false);
            }            
        });
         $A.enqueueAction(action);
    },
    
    getOpportunityPartyDetails:function(component,event){
        var oppId = component.get("v.OpportunityFromFlow");
        var allBeneficiariesData =component.get("v.oppPartyDetailsList");
        var action = component.get("c.getPartyData");
        
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var existingData =a.getReturnValue();
                for(var i=0;i<existingData.length; i++){
                    if(existingData[i].DD_Cross_Sell_Product_Member_Type__c && existingData[i].DD_Cross_Sell_Product_Member_Type__c !=''){
                        if(existingData[i].DD_Cross_Sell_Product_Member_Type__c.includes("Law For u")){
                           // cntInd=cntInd+1; 
                            existingData[i].DD_Cross_Sell_Product_Member_Type__c="Law For u";   
                            allBeneficiariesData.push(existingData[i]);
                        }
                    }
                }
                component.set("v.oppPartyDetailsList",allBeneficiariesData);
                console.log('opppartydate '+JSON.stringify(component.get("v.oppPartyDetailsList")));
            }
        });
        $A.enqueueAction(action);
    },
})