({
    doInit: function (component, event, helper) {
        var InterestRateBasis = component.find("interestratebasissingle").get("v.value");
        if(InterestRateBasis ==undefined  ){
            component.set("v.accItem.Interest_rate_basis__c", 'Prime Rate');
        }
        if(InterestRateBasis == 'Prime Rate'){
        var primeratechangeValue = component.find("primeratemarginsingle").get("v.value");
        if(primeratechangeValue ==undefined){
            component.set("v.accItem.Prime_rate_margin__c", 'Plus per annum');
        }}
        
        
    },
    
    onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeAccount: function (component, event, helper) {
        helper.removeMultiplePhaseRec(component, event);
    },
    addNewAccount: function (component, event, helper) {
        component.set("v.showSpinner", true);
        //helper.addNewAccount(component, event);
        helper.addAccount(component, event);
    },
    addOtherfees: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddOtherFees(component, event);
    },
    addOtherfeesbtn: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddOtherFeesbtn(component, event);
    },
    handleApplicationEvent: function (component, event, helper) {
        var opportunityId = event.getParam("opportunityId");
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var AppFinAccId = event.getParam("AppFinAccId");
        var rowinex = event.getParam("RowIndex");
        var faclilitylist = component.get("v.newFacilityAccountMulti");
        faclilitylist.splice(rowinex, 1);
        component.set("v.newFacilityAccountMulti", faclilitylist);
    },
    handleOthefaciApplicationEvent: function (component, event, helper) {
        var rowinex = event.getParam("RowIndex");
        var otherfeeslist = component.get("v.newFeesOtherFaciMulti");
        otherfeeslist.splice(rowinex, 1);
        component.set("v.newFeesOtherFaciMulti", otherfeeslist);
    },
    handleOthefeesApplicationEvent: function (component, event, helper) {
        var rowinex = event.getParam("RowIndex");
        var otherfeeslist = component.get("v.newFeesOtherFeesMulti");
        otherfeeslist.splice(rowinex, 1);
        component.set("v.newFeesOtherFeesMulti", otherfeeslist);
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
    
    multiPhaseSaveAFA : function(component, event) {
        var params = event.getParam('arguments');
        if (params) {
            var message = params.message;
            var afaRecs = params.afaRecs;
            
            var childCmp = component.find("newFacilityAcc");
            // call the aura:method in the child component
            if (childCmp) {
                if (Array.isArray(childCmp)) {
                    for (var i = 0; i<childCmp.length; i++) {
                        var auraMethodResult = childCmp[i].saveAFA("message sent by parent component cpfMultiPhaseChild mid of food chain");
                    }
                } else {
                    var auraMethodResult = childCmp.saveAFA("message sent by parent component cpfMultiPhaseChild mid of food chain");
                }
            }
            return message;
        }
        
    },
    multiPhaseSavefacifees : function(component, event) {
        var params = event.getParam('arguments');
        if (params) {
            var message = params.message;
            var facifeesRecs = params.facifeesRecs;
            
            
            var childCmp = component.find("newotherfeesIdFaci");
            
            // call the aura:method in the child component
            if (childCmp) {
                if (Array.isArray(childCmp)) {
                    for (var i = 0; i<childCmp.length; i++) {
                        var auraMethodResult = childCmp[i].saveAFA("message sent by parent component cpfMultiPhaseChild for facifees");
                    }
                } else {
                    var auraMethodResult = childCmp.saveAFA("message sent by parent component cpfMultiPhaseChild for facifees");
                }
            }
            return message;
        }
        
    },
    multiPhaseSaveotherfees : function(component, event) {
        var params = event.getParam('arguments');
        if (params) {
            var message = params.message;
            var otherfeesRecs = params.otherfeesRecs;
            
            var childCmp = component.find("newotherfeesId");
            // call the aura:method in the child component
            if (childCmp) {
                if (Array.isArray(childCmp)) {
                    for (var i = 0; i<childCmp.length; i++) {
                        var auraMethodResult = childCmp[i].saveAFA("message sent by parent component cpfMultiPhaseChild for otherfees");
                    }
                } else {
                    var auraMethodResult = childCmp.saveAFA("message sent by parent component cpfMultiPhaseChild for otherfees");
                }
            }
            return message;
        }
    },
    
})