({
    doInit: function (component, event, helper) {
        helper.getAppPrdctCpfRec(component, event, helper);
        helper.getAppPhaseCpfSingleRec(component, event, helper);
        helper.getAppPhaseCpfMultipleRecRepetator(component, event, helper);
        helper.getAppFinAccCpfRec(component, event, helper);
        helper.getAppFinAccCpfRecMulti(component, event, helper);
        helper.getAppOtherFeesRec(component, event, helper);
        helper.getAppOtherFeesRecMulti(component, event, helper);
        helper.getAppOtherFeesRecFeesDetails(component, event, helper);
        helper.getAppOtherFeesRecFeesDetailsMulti(component, event, helper);
        var InterestRateBasis = component.find("interestratebasissingle").get("v.value");
        if(InterestRateBasis ==undefined  ){
            component.set("v.interestratebasis", 'Prime Rate');
        }
        var primeratechangeValue = component.find("primeratemarginsingle").get("v.value");
        if(primeratechangeValue ==undefined){
            component.set("v.marginRate", 'Plus per annum');
        }

        
    },
    handleChange: function (component, event, helper) {
        var changeValue = event.getParam("value");
        helper.updateAppPrdctcpf(component, event, helper, changeValue);
    },
    addNewAccount: function (component, event, helper) {
        helper.addAccount(component, event);
    },
    addOtherfees: function (component, event, helper) {
        helper.AddOtherFees(component, event);
    },
    addOtherfeesbtn: function (component, event, helper) {
        helper.AddOtherFeesRec(component, event);
    },
    addMultiPhase: function (component, event, helper) {
        helper.AddMultiPhase(component, event);
        
    },
    handleApplicationEvent: function (component, event, helper) {
        var opportunityId = event.getParam("opportunityId");
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var AppFinAccId = event.getParam("AppFinAccId");
        var rowinex = event.getParam("RowIndex");
        var faclilitylist = component.get("v.newFacilityAccount");
        faclilitylist.splice(rowinex, 1);
        component.set("v.newFacilityAccount", faclilitylist);
    },
    handleOthefeesApplicationEvent: function (component, event, helper) {
        var rowinex = event.getParam("RowIndex");
        var appOtherFeesId = event.getParam("appOtherFeesId");
        var otherfacilist = component.get("v.newFeesOther");
        otherfacilist.splice(rowinex, 1);
        component.set("v.newFeesOther", otherfacilist);
    },
    handleFessApplicationEvent: function (component, event, helper) {
        var rowinex = event.getParam("RowIndex");
        var appOtherFeesId = event.getParam("appOtherFeesId");
        var otherfeeslist = component.get("v.newFeesOtherFees");
        otherfeeslist.splice(rowinex, 1);
        component.set("v.newFeesOtherFees", otherfeeslist);
    },
    
    handleMultiPhaseApplicationEvent : function(component, event,helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var rowinex =event.getParam("RowIndex");
        var newMultiplePhaselist=component.get("v.newMultiplePhase");
        newMultiplePhaselist.splice(rowinex,1);
        component.set("v.newMultiplePhase",newMultiplePhaselist);
    },
    showFieldsRepaymentOptions: function (component, event,helper) {
        var repaymentoptions = event.getParam("value");
        component.set("v.repaymentoptions", repaymentoptions);
        if(repaymentoptions == 'Capitalised Interest with Bullet (No Conversion)' || repaymentoptions == 'Capitalised Interest with Bullet (Converting)' ||
           repaymentoptions == 'Interest only with a bullet capital repayment'){
            component.set("v.showIntrestServiceFreqandAmt", true);
            // component.set("v.showInstallmentPeriod", true);
        }else{
            component.set("v.showIntrestServiceFreqandAmt", false);
        }
        
    },
    showFinalRepaymentHiddenFields: function (component, event,helper) {
        var finalrepaymentchangeValue = event.getParam("value");
        if(finalrepaymentchangeValue!= null && finalrepaymentchangeValue!=''){
            component.set("v.finalrepaymentdatesingle", finalrepaymentchangeValue);
        }},
    showFieldsReqOnInterestBasis: function (component, event,helper) {
        var InterestRateBasis = event.getParam("value");
        if(InterestRateBasis!= null && InterestRateBasis!=''){
            component.set("v.interestratebasis", InterestRateBasis);
        }
    },
    showHiddenFields: function (component, event,helper) {
        var primeratechangeValue = event.getParam("value");
        if(primeratechangeValue!= null && primeratechangeValue!= ''){
            component.set("v.marginRate", primeratechangeValue);
        }},
    handleSinglePhaseFacility: function (component, event,helper) {
        helper.insertSinglePhaseRec(component,event,helper);
    },
    handleMultiPhaseFacility: function (component, event,helper) {
        helper.insertMultiPhaseRec(component,event,helper);
        helper.callAuraMethod(component, event, helper);
    },
});