({
    myAction : function(component, event, helper) {

    },
    
    doInit:function(component, event, helper) {
        //helper.getOpportunityDetails(component,event);
        helper.fetchPickListVal(component, 'Accidental_Death_Benefit_Disability__c', 'accidentalDeathBenefit');
        helper.fetchPickListVal(component, 'Death_Accidental_Disability__c', 'deathBenifit');
        helper.getPolicyCreate(component);
        //helper.getOpportunitypartyDetails(component);
        helper.checkAccountValid(component);
        component.set("v.OppPrtyDetails",{});
        console.log('chkbx '+component.get("v.quest1Res"));
    },
    
    onOutcomeChange : function(component,event,helper){
        //Deed newly
        var existOppPartyData = component.get("v.oppPartyDetailsList");
        
        console.log('oppRecord 123 '+JSON.stringify(component.get("v.opportunityDetails")));
        console.log('oppRecord '+JSON.stringify(oppRecord));
        if(existOppPartyData.length == 0){
            var oppRecord =component.get("v.opportunityDetails");
            let objTest =component.get("v.OppPrtyDetails");

            var partydata=[];
                console.log('inside yes '+JSON.stringify(objTest));
                objTest.First_Name__c =oppRecord.Person_Account_First_Name__c;//component.get("v.opportunityDetails.Person_Account_First_Name__c");
                objTest.Last_Name__c =oppRecord.Person_Account_Last_Name__c;//component.get("v.opportunityDetails.Person_Account_Last_Name__c");
                objTest.DD_Cross_Sell_Product_Member_Type__c ='Ultimate Protector';
                objTest.Relationship__c='Main Member';
                objTest.ID_Type__c =oppRecord.Person_Id_Type__c;
                objTest.RSA_ID_Number__c =oppRecord.ID_Number__c;//component.get("v.opportunityDetails.ID_Number__c");
                objTest.Date_of_Birth__c =oppRecord.Person_BirthDate__c//component.get("v.opportunityDetails");
                objTest.Gender__c =oppRecord.Person_Account_Gender__c;//component.get("v.opportunityDetails.Person_Account_Gender__c");
                objTest.Opportunity__c=component.get("v.OpportunityFromFlow");
                partydata.push(objTest);
				component.set("v.oppPartyDetailsList",partydata);
        }
    
        component.set("v.isQuoteDone",false);

    },
    handleChange :function(component, event, helper) {
        component.set("v.isQuoteDone",true);
        var q1Res = component.get("v.quest1Res");
        console.log(component.get("v.quest1Res"));
        var q2Res = component.get("v.quest2Res");
        var q3Res = component.get("v.quest3Res");

        var existOppPartyData = component.get("v.oppPartyDetailsList");
        
       // console.log('oppRecord 123 '+JSON.stringify(component.get("v.opportunityDetails")));
        //console.log('oppRecord '+JSON.stringify(oppRecord));
       /* if(existOppPartyData.length == 0){
            var oppRecord =component.get("v.opportunityDetails");
            let objTest =component.get("v.OppPrtyDetails");

            var partydata=[];
                console.log('inside yes '+JSON.stringify(objTest));
                objTest.First_Name__c =oppRecord.Person_Account_First_Name__c;//component.get("v.opportunityDetails.Person_Account_First_Name__c");
                objTest.Last_Name__c =oppRecord.Person_Account_Last_Name__c;//component.get("v.opportunityDetails.Person_Account_Last_Name__c");
                objTest.DD_Cross_Sell_Product_Member_Type__c ='Ultimate Protector';
                objTest.Relationship__c='Main Member';
                objTest.ID_Type__c =oppRecord.Person_Id_Type__c;
                objTest.RSA_ID_Number__c =oppRecord.ID_Number__c;//component.get("v.opportunityDetails.ID_Number__c");
                objTest.Date_of_Birth__c =oppRecord.Person_BirthDate__c//component.get("v.opportunityDetails");
                objTest.Gender__c =oppRecord.Person_Account_Gender__c;//component.get("v.opportunityDetails.Person_Account_Gender__c");
                objTest.Opportunity__c=component.get("v.OpportunityFromFlow");
                partydata.push(objTest);
				component.set("v.oppPartyDetailsList",partydata);
        }*/

        if((q1Res =="No") && (q2Res =="No") && (q3Res =="No") ){
            console.log('No');
            component.set("v.showDeathDisablity",true);
            component.set("v.selectedDeathDisablity",true);

            component.set("v.showAccidentalDeathDisablity",false);
            component.set("v.selectedAccidentalDeathDisablity",false);

            component.set("v.showBenfit",true);
            component.set("v.Premium",0.0);
            component.set("v.coverage",'');
            component.set('v.totalPremiumLbl', 'Total Premium: R0.00');
        }else if((q1Res!=undefined && q2Res!= undefined  && q3Res!= undefined ) && ((q1Res =="Yes") || (q2Res =="Yes") || (q3Res =="Yes"))){
            component.set("v.showDeathDisablity",false);
            component.set("v.selectedDeathDisablity",false);
            component.set("v.showAccidentalDeathDisablity",true);
            component.set("v.selectedAccidentalDeathDisablity",true);
            component.set("v.showBenfit",true);
           component.set("v.Premium",0.0);
            component.set("v.coverage",'');
            component.set('v.totalPremiumLbl', 'Total Premium: R0.00');
            

        }/*else{
            component.set("v.showBenfit",false);
            component.set("v.showAccidentalDeathDisablity",false);
            component.set("v.showDeathDisablity",false);
        }*/
    },
    onPicklistDeathDisableChange : function(component, event, helper) {
        var sumInsured = event.getSource().get('v.value');
       // component.set("v.isQuoteDone",false); //commented by pranav on 25112020 for handling 0 Premiums
        component.set("v.coverage",sumInsured);
		if (sumInsured == '') {
            component.set("v.Premium",0);
        }else{
            helper.getMemberPremium(component, sumInsured, 'Death and Accidental Disability');
        }
    },
    onPicklistAccidentalDeathDisableChange : function(component, event, helper) {
        var sumInsured = event.getSource().get('v.value');
       // component.set("v.isQuoteDone",false); //commented by pranav on 25112020 for handling 0 Premiums
        component.set("v.coverage",sumInsured);
		if (sumInsured == '') {
            component.set("v.Premium",0);
        }else{
            helper.getMemberPremium(component, sumInsured,'Accidental Death Benifit and Accidental Disability');
        } 
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
     var q1Res = component.get("v.quest1Res");
        var q2Res = component.get("v.quest2Res");
        var q3Res = component.get("v.quest3Res");
        var covr =component.get("v.coverage");
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
      if(quoteOutcome == 'Client Interested' && (q1Res=='' || q2Res=='' || q3Res =='')){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "please finsih Health Questions section .",
            "type":"error"
        });
            toastEvent.fire();
            return null;
      } 
      else  if(quoteOutcome == 'Client Interested' && covr =='' ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "please select the coverage under benfit section.",
            "type":"error"
        });
            toastEvent.fire();
            return null;
      }
     else{
     if(LabelName == 'Quote'){
         helper.saveOppPartyData(component,event,helper); 
     }else{
        var actionClicked = event.getSource().getLocalId();
        // Call that action
        var navigate = component.getEvent("navigateFlowEvent");
        navigate.setParam("outcome", component.get("v.quoteStatus"));
        navigate.setParam("action", actionClicked);
        navigate.fire();
     }
     }
 },
 
})