({
    doInit: function (component, event, helper) {
        helper.getAppPrdctCpfRec(component, event, helper);
        helper.getAppConClauseCpfRec(component, event, helper);
        helper.getAppOtherFeesRec(component, event, helper);
        
    },
    showConversionFields:function(component, event, helper) {
        var conversionVal = component.find("conversion").get("v.value");
        component.set("v.showConversionField", conversionVal);
    },
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
    
    showFieldsRepaymentOptions: function (component, event,helper) {
        var repaymentoptions = event.getParam("value");
        component.set("v.repaymentoptions", repaymentoptions);
      /*  if(repaymentoptions!= 'Capitalised interest (Bullet)'){
            component.set("v.showIntrestServiceFreq", true);
            component.set("v.showInstallmentPeriod", true);
        }else{
            component.set("v.showInstallmentPeriod", false);
        }*/
    },
    
    addfeesafterconversion:function(component, event, helper) {
        helper.AddOtherFeesAfterConversion(component, event);
    },
    addconditionsafterconversion:function(component, event, helper) {
        helper.AddOtherConditionsAfterConversion(component, event);
    },
    
    handlefeesafterconversionAppEvent: function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var feesafterconversionlst=component.get("v.newFeesAfterConnversion");
        feesafterconversionlst.splice(rowinex,1);
        component.set("v.newFeesAfterConnversion",feesafterconversionlst);
    },
    
    handleconditonsafterconversionAppEvent: function(component, event,helper) {
        var rowinex =event.getParam("RowIndex");
        var conditionsafterconversionlst=component.get("v.newConditionsAfterConnversion");
        conditionsafterconversionlst.splice(rowinex,1);
        component.set("v.newConditionsAfterConnversion",conditionsafterconversionlst);
    },
    
    handleSubmit : function(component, event, helper) {
        helper.updateAppPrdctcpf(component, event, helper);
        
    }
    
    
    
})