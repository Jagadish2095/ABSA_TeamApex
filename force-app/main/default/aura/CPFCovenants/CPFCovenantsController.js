({
    doInit : function(component, event, helper) {
        helper.getAppContractClausedata(component, event, helper);
        helper.getAppContractClausedatacoperate(component, event, helper);
        helper.getLoanToValueCovenant(component, event, helper);
        helper.getopplineitemRec(component, event, helper);
        helper.getAppProdRec(component, event, helper);
    },
    
    AddTranConv : function(component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
        helper.AddTranConv(component, event);
    },
    AddCoperateConv: function(component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
        helper.AddCopConv(component, event);
    },
    addLoanValue : function(component, event, helper) {
        //alert('line13');
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
        helper.addLoanValue(component, event);
    },
    addDebitServiceRatio : function(component, event, helper) {
        // alert('line14');
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
        helper.addDebitService(component, event);
    },
     addInterestServiceRatio : function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.addInterestService(component, event);
    },
    AddOtherentity : function(component, event, helper) {
        // alert('line14');
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
        helper.AddOtherentityCVT(component, event);
    },
    handleRemoveTranConv : function(component, event, helper) {
        
        helper.removeNewUnlimitedtrnas(component,event);
    },
    
    handleFcg : function(component, event, helper) {
        
        //VALIDATION SECTION START 
        var isValid = true;
        var financialConvenantApplicable = component.get("v.financialConvenantApplicable");
        // alert('financialConvenantApplicable'+financialConvenantApplicable);
        if(financialConvenantApplicable != '' && financialConvenantApplicable != null && financialConvenantApplicable != undefined){
            if(financialConvenantApplicable == 'Yes'){
                var measurementPeriod = component.get("v.measurementPeriod");
                var financialCovRef = component.get("v.financialCovRef");
                var financialYear = component.get("v.financialYear");
                var consecutivePeriod = component.get("v.consecutivePeriod");
                if($A.util.isUndefinedOrNull(measurementPeriod) || measurementPeriod == '' || measurementPeriod == null){
                    isValid = false;
                }else {
                    if(measurementPeriod == 'each consecutive period' || measurementPeriod == 'each period of twelve months ending on the last day of a financial year'){
                        if(!$A.util.isUndefinedOrNull(financialYear) &&  !$A.util.isUndefinedOrNull(consecutivePeriod)){
                            isValid = true;
                        }else{
                            isValid = false;
                        }
                    }else if(measurementPeriod == 'each period of six months ending on the last day of each financial half year' || measurementPeriod == 'each period of twelve months ending on the last day of a financial quarter'){
                        if(!$A.util.isUndefinedOrNull(financialYear)){
                            isValid = true;
                        }else{
                            isValid = false;
                        }
                    }
                }
                
            }
        }
        //alert(isValid);
        if(!isValid){
            var toast = helper.getToast(
                "Error!",
                "Please fill all required fields indicated with a red asterisk (*)",
                "Error"
            );
            toast.fire();
            return;
        }
        //VALIDATION SECTION END
        
        component.set("v.showSpinner", true);
        var measurementPeriod = component.get("v.measurementPeriod");
        var financialYear = component.get("v.financialYear");
        var consecutivePeriod = component.get("v.consecutivePeriod");
        var financialCovRef = component.get("v.financialCovRef");
        var financialConvenantApplicable = component.get("v.financialConvenantApplicable");
        var transactionalConvenantApplicable = component.get("v.transactionalConvenantApplicable");
        helper.updateFCG(component, event, helper,financialYear,measurementPeriod,consecutivePeriod,financialCovRef,transactionalConvenantApplicable,financialConvenantApplicable);
    },
    handleOtherTransSubmit : function(component, event, helper) {
        var newOtherTrans = component.get("v.newOtherTrans");
        var isValid = true;
        if(newOtherTrans != null && newOtherTrans != undefined){
            for(var i in newOtherTrans){
                if(newOtherTrans[i].Description__c == null || newOtherTrans[i].Description__c == '' || newOtherTrans[i].Description__c == undefined ){
                    isValid = false;
                    break;
                }
            }
        }
        if(!isValid){
            var toast = helper.getToast(
                "Error!",
                "Please fill all required fields indicated with a red asterisk (*)",
                "Error"
            );
            toast.fire();
            return;
        }
        var itemsToPass=component.get("v.otherTransactionalConvenants");
        helper.InsertOtherTransCpf(component, event, helper);
    },
    handleOtherCoperateSubmit: function(component, event, helper) {
        helper.InsertOtherCoperateCpf(component, event, helper);
    },
    handleLoanValueSubmit: function(component, event, helper) {
    //VALIDATION SECTION START
    var isValid = true;
    var loanToValueCovenant = component.get("v.loanToValueCovenant");
    //var Indebtedness = component.get("v.Indebtedness");
    var propertyValueNTE = component.get("v.propertyValueNTE");
    var indebtednessFldVal = '';
    var period = component.get("v.period");
    if(loanToValueCovenant != null && loanToValueCovenant != '' && loanToValueCovenant != undefined){
    if(loanToValueCovenant == 'No Ratcheting'){
    indebtednessFldVal = component.find("indebtednessFld").get("v.value");
    if(indebtednessFldVal == null || indebtednessFldVal == '' || indebtednessFldVal == undefined ||
    propertyValueNTE == null || propertyValueNTE == '' || propertyValueNTE == undefined || 
    period == null || period == '' || period == undefined){
    isValid = false;
}
 }else if(loanToValueCovenant == 'Ratcheting'){
    indebtednessFldVal = component.find("indebtednessFld").get("v.value");
    if(indebtednessFldVal == null || indebtednessFldVal == '' || indebtednessFldVal == undefined){
        isValid = false;
    }
    var newLoanValue = component.get("v.newLoanValue");
    if(newLoanValue != undefined && newLoanValue != null){
        for(var i in newLoanValue){
            if(newLoanValue[i].Measurement_period_number_years__c == null || newLoanValue[i].Measurement_period_number_years__c == '' || newLoanValue[i].Measurement_period_number_years__c == undefined || 
               newLoanValue[i].Property_value_to_not_be_exceeded__c == null || newLoanValue[i].Property_value_to_not_be_exceeded__c == '' || newLoanValue[i].Property_value_to_not_be_exceeded__c == undefined){
                isValid = false;
                break;
            }
        }
    }
}
}else{
    isValid = false;
}
if(!isValid){
    var toast = helper.getToast(
        "Error!",
        "Please fill all required fields indicated with a red asterisk (*)",
        "Error"
    );
    toast.fire();
    return;
}
//VALIDATION SECTION START
component.set("v.showSpinner", true);
var itemsToPass=component.get("v.nloanvalueItem");
var propertyValueNTE = component.get("v.propertyValueNTE");
var period = component.get("v.period");
helper.InsertLoanValueCpf(component, event, helper,indebtednessFldVal,loanToValueCovenant,propertyValueNTE,period);
},
    handlevacancySubmit: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var vacancyCoverRatio = component.get("v.vacancyCoverRatio");
        var nvacancyCoverRatio  = component.find("nvacancyCoverRatio").get("v.value");
        /*if(nvacancyCoverRatio == null || nvacancyCoverRatio==undefined || nvacancyCoverRatio==''){
            var toast = helper.getToast(
                    "Required fields",
                    "Please fill all required fields indicated with a red asterisk (*)",
                    "Error"
                );
                component.set("v.showSpinner", false);
                //helper.hideSpinner(component);
                toast.fire();
                return null;
        }else{*/
        helper.InsertVacancyCoverRatio(component, event, helper,vacancyCoverRatio);
        // }
    },
        handleloantocost: function(component, event, helper) {
            helper.Insertloantocost(component, event, helper);
        },
            handleDebitCoverSubmit: function(component, event, helper) {
                var debtservicecvrration = component.get("v.debtservicecvrration");
                var isValid = true;
                if(debtservicecvrration != null && debtservicecvrration != undefined && debtservicecvrration !=''){
                    if(debtservicecvrration == 'No Ratcheting'){
                        var Debt_service_cover_ratio2 = component.find("Debt_service_cover_ratio2").get("v.value");
                        if(Debt_service_cover_ratio2 == null || Debt_service_cover_ratio2 =='' || Debt_service_cover_ratio2 == undefined){
                            isValid = false;
                        }
                    }else if(debtservicecvrration == 'Ratcheting'){
                        var newDebitCoverList = component.get("v.newDebitCoverList");
                        if(newDebitCoverList != null && newDebitCoverList != undefined){
                            for(var i in newDebitCoverList){
                                if(newDebitCoverList[i].Measurement_period_number_years__c == null || newDebitCoverList[i].Measurement_period_number_years__c == '' || newDebitCoverList[i].Measurement_period_number_years__c == undefined || 
                                   newDebitCoverList[i].Debit_Service_Cover_Ratio__c == null || newDebitCoverList[i].Debit_Service_Cover_Ratio__c == '' || newDebitCoverList[i].Debit_Service_Cover_Ratio__c == undefined){
                                    isValid = false;
                                    break;
                                }
                            }
                        }
                    }
                }else{
                    isValid = false;
                }
                if(!isValid){
                    var toast = helper.getToast(
                        "Error!",
                        "Please fill all required fields indicated with a red asterisk (*)",
                        "Error"
                    );
                    toast.fire();
                    return;
                }
                component.set("v.showSpinner", true);
                helper.InsertDebitCoverCpf(component, event, helper);
            },
    handleinterestCoverSubmit: function(component, event, helper) {
                var interestervicecvrration = component.get("v.interestervicecvrration");
                var isValid = true;
                if(interestervicecvrration != null && interestervicecvrration != undefined && interestervicecvrration !=''){
                    if(interestervicecvrration == 'No Ratcheting'){
                        var interestcoverratio2 = component.find("interestcoverratio2").get("v.value");
                        if(interestcoverratio2 == null || interestcoverratio2 =='' || interestcoverratio2 == undefined){
                            isValid = false;
                        }
                    }else if(interestervicecvrration == 'Ratcheting'){
                        var newInterestCoverList = component.get("v.newInterestCoverList");
                        if(newInterestCoverList != null && newInterestCoverList != undefined){
                            for(var i in newInterestCoverList){
                                if(newInterestCoverList[i].Measurement_period_number_interest__c == null || newInterestCoverList[i].Measurement_period_number_interest__c == '' || newInterestCoverList[i].Measurement_period_number_interest__c == undefined || 
                                   newInterestCoverList[i].Interest_Service_Cover_Ratio__c == null || newInterestCoverList[i].Interest_Service_Cover_Ratio__c == '' || newInterestCoverList[i].Interest_Service_Cover_Ratio__c == undefined){
                                    isValid = false;
                                    break;
                                }
                            }
                        }
                    }
                }else{
                    isValid = false;
                }
                if(!isValid){
                    var toast = helper.getToast(
                        "Error!",
                        "Please fill all required fields indicated with a red asterisk (*)",
                        "Error"
                    );
                    toast.fire();
                    return;
                }
                component.set("v.showSpinner", true);
                helper.InsertInterestCoverCpf(component, event, helper);
            },
                handleOtherEntitySubmit: function(component, event, helper) {
                    var isValid = true;
                    var applicableToTheBorrower = component.get("v.applicableToTheBorrower");
                    var applicable_to_the_Parent = component.get("v.applicable_to_the_Parent");
                    var applicable_to_the_Guarantor = component.get("v.applicable_to_the_Guarantor");
                    var applicable_to_the_Security_Pro = component.get("v.applicable_to_the_Security_Pro");
                    var otherentity = component.get("v.otherentity");
                    if(applicableToTheBorrower != '' && applicableToTheBorrower != undefined && 
                       applicable_to_the_Parent != '' && applicable_to_the_Parent != undefined && 
                       applicable_to_the_Guarantor != '' && applicable_to_the_Guarantor != undefined && 
                       applicable_to_the_Security_Pro != '' && applicable_to_the_Security_Pro != undefined && 
                       otherentity != '' && otherentity != undefined){
                        if(otherentity == 'Yes'){
                            var newOtherEntityList = component.get("v.newOtherEntityList");
                            if(newOtherEntityList != null && newOtherEntityList != undefined){
                                for(var i in newOtherEntityList){
                                    if(newOtherEntityList[i].Covenants_applicable_to_the_Other_Entity__c == null || newOtherEntityList[i].Covenants_applicable_to_the_Other_Entity__c == '' || newOtherEntityList[i].Covenants_applicable_to_the_Other_Entity__c == undefined || 
                                       newOtherEntityList[i].Other_Entity_details__c == null || newOtherEntityList[i].Other_Entity_details__c == '' || newOtherEntityList[i].Other_Entity_details__c == undefined){
                                        isValid = false;
                                        break;
                                    }
                                }
                            }
                        }
                    }else{
                        isValid = false;            
                    }
                    if(!isValid){
                        var toast = helper.getToast(
                            "Error!",
                            "Please fill all required fields indicated with a red asterisk (*)",
                            "Error"
                        );
                        toast.fire();
                        return;
                    }
                    component.set("v.showSpinner", true);
                    helper.InsertOtherEntityCpf(component, event, helper);
                },
                    handleApplicationEvent : function(component, event,helper) {
                        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
                        var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
                        var unlimitedGauranteelist=component.get("v.newOtherTrans");
                        unlimitedGauranteelist.splice(unlimitedrowinex,1);
                        component.set("v.newOtherTrans",unlimitedGauranteelist);
                        
                    },
                        handleloanevent : function(component, event,helper) {
                            var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
                            var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
                            var unlimitedloanlist=component.get("v.newLoanValue");
                            unlimitedloanlist.splice(unlimitedrowinex,1);
                            component.set("v.newLoanValue",unlimitedloanlist);
                            
                        },
                            handledebitevent : function(component, event,helper) {
                                var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
                                var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
                                var unlimitedloanlist=component.get("v.newDebitCoverList");
                                unlimitedloanlist.splice(unlimitedrowinex,1);
                                component.set("v.newDebitCoverList",unlimitedloanlist);
                                
                            },
     						handleinterestevent : function(component, event,helper) {
                                var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
                                var rowindex =event.getParam("UnlimitedRowIndex");
                                var newinterestlist=component.get("v.newInterestCoverList");
                                newinterestlist.splice(rowindex,1);
                                component.set("v.newInterestCoverList",newinterestlist);
                                
                            },
                                handleOtherEntityEvent : function(component, event,helper) {
                                    var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
                                    var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
                                    var unlimitedloanlist=component.get("v.newOtherEntityList");
                                    unlimitedloanlist.splice(unlimitedrowinex,1);
                                    component.set("v.newOtherEntityList",unlimitedloanlist);
                                    
                                },
                                    UpdateAppProdRec: function(component, event,helper) {
                                        helper.UpdateAppProdDetails(component, event, helper);
                                    },
});