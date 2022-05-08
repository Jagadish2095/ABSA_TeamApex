({
	helperMethod : function() {
		
    },
    //Creating a final quote.
    createQuoteData : function(component,event){
        //added
        component.set("v.showSpinner",true);
        var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
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
            
        var oppPartyData =component.get("v.oppPartyDetailsList");        
            var action = component.get("c.insertOppPartyData");
            action.setParams({
            "oppPartyList": oppPartyData
        });
          action.setCallback(this, function(a) {
                var state = a.getState();
              if (state === "SUCCESS") {
                  var oppParties = a.getReturnValue();
                  //--
                  if(component.get("v.selectedPlan")!=''){
                     
                      var oppdata= component.get("v.opportunityDetails");
                      console.log('oppdata '+JSON.stringify(oppdata));
                      console.log('***'+component.get("v.selectedPlan"));
                      console.log('***'+component.get("v.premium"));
                      var qteList =[];
                      qteList.push({
                          Name: component.get("v.selectedPlan"),
                          //premium: component.get("v.premium"),
                         // SumInsured: component.get("v.coverage"),
                          OppPartyId : oppParties[0].Id
                      });
                      var action1 = component.get("c.createDDQuote");
                      action1.setParams({
                          oppId: component.get('v.OpportunityFromFlow'),
                          totalPremium: '',
                          product: 'Card Life',
                          lineItems: JSON.stringify(qteList),
                          partyType: 'Card Life',
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
                               //added
                             var actionClicked = event.getSource().getLocalId();
                            // Call that action
                            var navigate = component.getEvent("navigateFlowEvent");
                            navigate.setParam("action", actionClicked);
                            navigate.setParam("outcome", quoteStatus);
                            navigate.fire();
        
                          }else {
                              console.log('Error ==> '+ JSON.stringify(a.getError()));
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
              }
              else{
                component.set("v.showSpinner",false);
              }
                  //--
              }   
            });
        	$A.enqueueAction(action);
        
          
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
     //Card Life for u 
    fetchPickListValForPlan : function(component,event) {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "--- None ---",
            value: ""
        });
        opts.push({
            class: "optionClass",
            label: "Plan A",
            value: "Plan A"
        });
        opts.push({
            class: "optionClass",
            label: "Plan B",
            value: "Plan B"
        });
        
        
        component.set("v.planOptions",opts);
        
    },
    
    getOpportunityDetails :function(component,event) {
       component.set("v.showSpinner",true);
        var oppId = component.get("v.OpportunityFromFlow");
        //
        var oppdata= component.get("v.opportunityDetails");
        var quotestatus;
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
                component.set('v.ageNum',resp[0].Person_Account_Age__c);
                console.log('credit '+ resp);
                var action = component.get('c.getQuoteData');
                action.setParams({
                    "oppId": oppId,
                    //"productName" : 'Card Life'
                });
                action.setCallback(this, function(a){
                    var state = a.getState();
                    if (state === "SUCCESS") { 
                        var quoteResp = a.getReturnValue();
                        /*if(quoteResp!=null && quoteResp.length > 0){
                            var totresp =[];
                            resp[0].Premium=quoteResp[0].Premium__c;
                            resp[0].Card_Life_Plan__c=quoteResp[0].Benefit__c;
                            resp[0].Coverage=quoteResp[0].Policy_Cover__c;
                            //added
                            totresp[0].Quote_Outcome__c=quoteResp[0].Quote.Quote_Outcome__c;
                            totresp[0].Quote_Outcome_Reason__c=quoteResp[0].Quote.Quote_Outcome_Reason__c;
                             quotestatus=quoteResp[0].Quote.Status;
                             //end
                            totresp.push(resp[0]);
                            component.set("v.quoteStatus",quotestatus);
                            component.set("v.data",totresp);
                            component.set("v.opportunityDetails",totresp[0]);
                            component.set("v.isQuoteDone",true);
                            component.set("v.showSpinner",false);
                        }*/ //Ending quote length check
                       // else{
                        if(quoteResp!=null && quoteResp.length > 0){
                        resp[0].Quote_Outcome__c=quoteResp[0].Quote_Outcome__c;
                        resp[0].Quote_Outcome_Reason__c=quoteResp[0].Quote_Outcome_Reason__c;
                         quotestatus=quoteResp[0].Status;
                        }
                            component.set("v.opportunityDetails",resp[0]);
                            component.set("v.quoteStatus",quotestatus);
                             component.set("v.data",resp);
                             component.set("v.isQuoteDone",true);
                             component.set("v.showSpinner",false);
                        //}
                    }
                });
                $A.enqueueAction(action); //server call for geeting quote line item data if exist to display on the table
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
                        if(existingData[i].DD_Cross_Sell_Product_Member_Type__c.includes("Card Life")){
                           // cntInd=cntInd+1; 
                            existingData[i].DD_Cross_Sell_Product_Member_Type__c="Card Life";   
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