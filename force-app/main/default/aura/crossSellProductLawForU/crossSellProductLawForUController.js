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
            { label: 'Plan Type', fieldName: 'Law_For_U_Plan__c', type: 'text' },
            { label: 'Coverage', fieldName: 'Coverage', type: 'text' },
            { label: 'Premium', fieldName: 'Premium', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        helper.fetchPickListValForPlan(component,event);
       // helper.getOpportunityDetails(component,event);
        //helper.getOpportunityPartyDetails(component,event);
        helper.getPlanPremiums(component,event);
        helper.checkAccountValid(component,event);
    },
    onOutcomeChange : function(component,event,helper){
        component.set("v.isQuoteDone",false);
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
            objTest.DD_Cross_Sell_Product_Member_Type__c ='Law For u';
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
        existData[0].Law_For_U_Plan__c=selectedVal;
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
            var toastEvent = $A.get("e.force:showToast");
                       toastEvent.setParams({
                           "title": "Error!",
                           "message": "please select Quote Outcome.",
                           "type":"error"
                       });
                toastEvent.fire();
               return null;
       }
       else if(LabelName == 'Quote'){
            
            if(quoteOutcome == 'Client Interested' && component.get("v.selectedPlan")!=''){
                helper.createQuoteData(component,event,helper); 
            }else if(quoteOutcome != 'Client Interested'){
                helper.createQuoteData(component,event,helper); 
            }
            else{
                component.set("v.showSpinner",false);
                              var toastEvent = $A.get('e.force:showToast');
                              toastEvent.setParams({
                                  title: 'Error!',
                                  message: 'Please select Plan First!',
                                  type: 'error',
                                  mode: 'sticky'
                              });
                              toastEvent.fire();
        
            }
        }else{
       var actionClicked = event.getSource().getLocalId();
   	    // Call that action
   		var navigate = component.getEvent("navigateFlowEvent");
   		navigate.setParam("action", actionClicked);
        navigate.setParam("outcome", component.get("v.quoteStatus"));
   		navigate.fire();
        }
     },
})