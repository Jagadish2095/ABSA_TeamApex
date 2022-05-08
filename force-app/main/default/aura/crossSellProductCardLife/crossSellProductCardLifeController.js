({
    myAction : function(component, event, helper) {
        
    },
    
    doInit:function(component, event, helper) {
        component.set("v.oppPartyDetails",{});
        //console.log('**88'+component.get("v.oppPartyDetails"));
        var actions = [
            { label: 'View Details', iconName: 'utility:view', name: 'view_details' },
            // { label: 'Delete', iconName: 'utility:delete', name: 'delete' }
        ];
            
            component.set('v.columns', [
            { label: 'First Name', fieldName: 'Person_Account_First_Name__c', type: 'text' },
            { label: 'Last Name', fieldName: 'Person_Account_Last_Name__c', type: 'text' },
            { label: 'Gender', fieldName: 'Person_Account_Gender__c', type: 'text' },
            { label: 'Date of Birth', fieldName: 'Person_BirthDate__c', type: 'date' },
            { label: 'Id Number', fieldName: 'ID_Number__c', type: 'text' },
            { label: 'Plan Type', fieldName: 'Card_Life_Plan__c', type: 'text' },
            { label: 'CreditCard Number', fieldName: 'DD_Absa_Credit_Card_Number__c', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        helper.fetchPickListValForPlan(component,event);
        helper.getOpportunityDetails(component,event);
        helper.getOpportunityPartyDetails(component,event);
        helper.getPlanPremiums(component,event);
    },
    onPicklistselectedPlanChange : function(component,event,helper){
        //forming oopparty data
        var existOppPartyData = component.get("v.oppPartyDetailsList");
        console.log('leng'+existOppPartyData.length);
        if(existOppPartyData.length == 0){
            let objTest =component.get("v.oppPartyDetails");
            var partydata=[];
            var oppdata= component.get("v.opportunityDetails");
            objTest.First_Name__c =oppdata.Person_Account_First_Name__c;//component.get("v.opportunityDetails.Person_Account_First_Name__c");
            objTest.Last_Name__c =oppdata.Person_Account_Last_Name__c;//component.get("v.opportunityDetails.Person_Account_Last_Name__c");
            objTest.DD_Cross_Sell_Product_Member_Type__c ='Card Life';
            objTest.Relationship__c='Main Member';
            objTest.ID_Type__c =oppdata.Person_Id_Type__c;
            objTest.RSA_ID_Number__c =oppdata.ID_Number__c;//component.get("v.opportunityDetails.ID_Number__c");
            objTest.Date_of_Birth__c =oppdata.Person_BirthDate__c//component.get("v.opportunityDetails");
            objTest.Gender__c =oppdata.Person_Account_Gender__c;//component.get("v.opportunityDetails.Person_Account_Gender__c");
            objTest.Opportunity__c=oppdata.Id;
            partydata.push(objTest);
            component.set("v.oppPartyDetailsList",partydata);
            //===end
        }
        console.log('opppartydata'+JSON.stringify(component.get("v.oppPartyDetailsList")));
        var selectedVal =event.getSource().get("v.value");
        console.log('**'+selectedVal);
        component.set("v.selectedPlan",selectedVal );
        var existData =  component.get("v.data");
        var premMap = component.get("v.planpremiumMap");
        var covrMap= component.get("v.planCovergeMap");
        console.log('premMap '+JSON.stringify(Object.keys(premMap)));
        existData[0].Card_Life_Plan__c=selectedVal;
        if(Object.keys(premMap).includes(selectedVal) && Object.keys(covrMap).includes(selectedVal) ){
            console.log('eneter if');
            existData[0].Premium =  premMap[selectedVal];
            existData[0].Coverage =  covrMap[selectedVal];
            component.set("v.premium",premMap[selectedVal]);
            component.set("v.coverage",covrMap[selectedVal]);
        }else{
            existData[0].Premium='';
            existData[0].Coverage = '';
            component.set("v.premium",'');
            component.set("v.coverage",'');
        }
        console.log('existData '+JSON.stringify(existData));
        component.set("v.data",existData);
        component.set("v.opportunityDetails",existData[0]);
        component.set("v.isQuoteDone",false);
        // console.log('oppdat '+JSON.stringify(component.get("v.opportunityDetails")));
    },
    
    handleRowAction : function(component,event,helper){
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        //cmp.set("v.updateRecordId", row.Id);
        switch (action.name) {
            case 'view_details':
                //console.log('oppdataa '+JSON.stringify(component.get("v.opportunityDetails")));
                component.set("v.showViewPanelModal", true);
                break;  
        }
    },
    
    closeConfirmation: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.showViewPanelModal", false);
    }, 
    handleChangePrev : function(component,event,helper){
        var actionClicked = event.getSource().getLocalId();
        // Call that action
        var navigate = component.getEvent("navigateFlowEvent");
        navigate.setParam("action", actionClicked);
        navigate.fire();
    },
    handleChangeNext :function(component,event,helper){
        var LabelName = event.getSource().get("v.label");
		var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
        if(quoteOutcome == '' || quoteOutcome == null){
		var toastEvent = $A.get('e.force:showToast');
            	toastEvent.setParams({
                    title: 'Validation',
                    message: 'Please select Outcome.',
                    type: 'Warning',
                    mode: 'sticky'
                });
                toastEvent.fire();
                return null;
        }
        else if(LabelName == 'Quote'){
              if((component.get("v.selectedPlan") == '' || component.get("v.selectedPlan") == null) && quoteOutcome == 'Client Interested'){
            	var toastEvent = $A.get('e.force:showToast');
            	toastEvent.setParams({
                    title: 'Validation',
                    message: 'Please select Card Life Plan.',
                    type: 'Warning',
                    mode: 'sticky'
                });
                toastEvent.fire(); 
                  return null;
	        }
            else if(component.get("v.selectedPlan") == 'Plan A' && component.get('v.ageNum') >= 18 && component.get('v.ageNum') <= 63 ){
                helper.createQuoteData(component,event,helper);
            }
            else if(component.get("v.selectedPlan") == 'Plan B' && component.get('v.ageNum') >= 18){
                helper.createQuoteData(component,event,helper);
            }
            else if( quoteOutcome == 'Client Interested'){
                var textmsg = '';
                var toastEvent = $A.get('e.force:showToast');
                if(component.get("v.selectedPlan") == 'Plan A'){
                    textmsg='Entry Age for Plan A should be minimum 18 Years and maximum 63 Years';
                }
                else if(component.get("v.selectedPlan") == 'Plan B'){
                    textmsg='Entry Age for Plan B should be minimum 18 Years and maximum Unlimited';
                }
                toastEvent.setParams({
                    title: 'Validation',
                    message: textmsg,
                    type: 'Warning',
                    mode: 'sticky'
                });
                toastEvent.fire();  
                return null;
            }
            else{
            var actionClicked = event.getSource().getLocalId();
            // Call that action
            var navigate = component.getEvent("navigateFlowEvent");
            navigate.setParam("outcome", component.get("v.quoteStatus"));
            navigate.setParam("action", actionClicked);
            navigate.fire();
        }
       }
        else{
             if((component.get("v.selectedPlan") == '' || component.get("v.selectedPlan") == null) && quoteOutcome == 'Client Interested'){
            	var toastEvent = $A.get('e.force:showToast');
            	toastEvent.setParams({
                    title: 'Validation',
                    message: 'Please select Card Life Plan.',
                    type: 'Warning',
                    mode: 'sticky'
                });
                toastEvent.fire(); 
                 return null;
	        }
            var actionClicked = event.getSource().getLocalId();
            // Call that action
            var navigate = component.getEvent("navigateFlowEvent");
            navigate.setParam("outcome", component.get("v.quoteStatus"));
            navigate.setParam("action", actionClicked);
            navigate.fire();
        }
    },
})