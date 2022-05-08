({
getAppPrdctCpfRec :function(component, event, helper) {
var action = component.get("c.getAppProdctCpfRec");
action.setParams({
"oppId": component.get("v.recordId"),
});

action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appPrdctCpfRec = response.getReturnValue();
component.set("v.appPrdctCpfRec", appPrdctCpfRec);
component.set("v.value", appPrdctCpfRec.Multiple_phases_applicable__c);
                
}else {
console.log("Failed with state: " + JSON.stringify(appPrdctCpfRec));
}
});

$A.enqueueAction(action);
},
getAppPhaseCpfSingleRec :function(component, event, helper) {

var interestratebasissingle=component.find("interestratebasissingle").get("v.value");
component.set("v.interestratebasis", interestratebasissingle);

var action = component.get("c.getApphaseCpfRec");
action.setParams({
"oppId": component.get("v.recordId"),
"Type":'Single Phase'
});
action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appPhaseCpfRec = response.getReturnValue();
 if(appPhaseCpfRec!=null && appPhaseCpfRec!=''){
component.set("v.appPhaseCpfRecSingle", appPhaseCpfRec[0]);
component.set("v.vatonchargessingle", appPhaseCpfRec[0].Include_VAT_on_charges__c);
component.set("v.balexistingacctsingle", appPhaseCpfRec[0].Include_balance_on_existing_account__c);
component.set("v.otheramountsincludedintotalfacilitysingle", appPhaseCpfRec[0].Other_amounts_included_in_total_facility__c);
component.set("v.AdminFeesingle", appPhaseCpfRec[0].Admin_fee__c	);
component.set("v.ValuationFeesingle", appPhaseCpfRec[0].Valuation_fee__c);
component.set("v.PrePaymentFeesingle", appPhaseCpfRec[0].Prepayment_fee__c);
component.set("v.otherfeesapplicablevalfeesingle", appPhaseCpfRec[0].Other_fees_applicable__c);
component.set("v.drawdowninspectionfeesingle", appPhaseCpfRec[0].Drawdown_inspection_fee__c);
component.set("v.IncludeAminTotFacilitysingle", appPhaseCpfRec[0].Include_admin_fee_in_total_facility__c);
component.set("v.IncludeAminTotFacility2single", appPhaseCpfRec[0].Include_admin_fee_in_total_facility2__c);
                    if(appPhaseCpfRec[0].Interest_rate_basis__c !=null || appPhaseCpfRec[0].Interest_rate_basis__c !='')
{component.set("v.interestratebasis", appPhaseCpfRec[0].Interest_rate_basis__c);}
component.set("v.marginRate", appPhaseCpfRec[0].Prime_rate_margin__c);
component.set("v.finalrepaymentdatesingle", appPhaseCpfRec[0].Final_repayment_date__c);
if(appPhaseCpfRec[0].Repayment_options_during_development__c == 'Capitalised Interest with Bullet (No Conversion)' || appPhaseCpfRec[0].Repayment_options_during_development__c == 'Capitalised Interest with Bullet (Converting)' ||
appPhaseCpfRec[0].Repayment_options_during_development__c == 'Interest only with a bullet capital repayment'){
component.set("v.showIntrestServiceFreqandAmt", true);
                        
}
 }


}else {
console.log("Failed with state: " + JSON.stringify(appPhaseCpfRec));
}
});

$A.enqueueAction(action);
},
getAppPhaseCpfMultipleRecRepetator :function(component, event, helper) {
var action = component.get("c.getApphaseCpfRec");
action.setParams({
"oppId": component.get("v.recordId"),
"Type":'Multiple Phase'
});
action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appPhaseCpfRec = response.getReturnValue();
component.set("v.newMultiplePhase", appPhaseCpfRec);
                
}else {
console.log("Failed with state: " + JSON.stringify(appPhaseCpfRec));
}
});
$A.enqueueAction(action);
},
updateAppPrdctcpf : function(component, event, helper,changeValue) {
var multiplephaseapplicable=component.get("v.multiplephaseapplicable");
var action = component.get("c.updateAppPrdctcpf");
action.setParams({
"oppId": component.get("v.recordId"),
"multiplephaseapplicable":changeValue
});
action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appcpfrec = response.getReturnValue();
                this.fireToast('Success!', "Application Product CPF record updated Successfully", 'success');
} else if (state === "ERROR") {
var errors = response.getError();
if (errors) {
if (errors[0] && errors[0].message) {
console.log("Error message: " +errors[0].message);
                        this.fireToast('Error!', errors[0].message, 'error');
}
}else{
console.log("Unknown error");
}
}
});
$A.enqueueAction(action);

},
addAccount : function(component, event) {
var facacountlist = component.get("v.newFacilityAccount");
facacountlist.push({
'sobjectType' : 'Application_Financial_Account__c',
'Existing_Number__c' : '',
'Existing_Account_Number__c' : '',
'Outstanding_Balance__c' : '',
'Balance_as_at__c' : '',
            'Account_to_be_closed__c' : 'No',
});
component.set("v.newFacilityAccount",facacountlist);
},
AddOtherFees : function(component, event) {
var otherFeesdetails = component.get("v.newFeesOther");
otherFeesdetails.push({
'sobjectType' : 'Application_Fees__c',

});
component.set("v.newFeesOther",otherFeesdetails);
},
AddOtherFeesRec : function(component, event) {
var otherFeeslst = component.get("v.newFeesOtherFees");
otherFeeslst.push({
'sobjectType' : 'Application_Fees__c',
            'Include_other_fee_in_total_facility__c':'No'

});
component.set("v.newFeesOtherFees",otherFeeslst);
},

AddMultiPhase: function(component, event) {
        
var multiplePhasedetails = component.get("v.newMultiplePhase");
multiplePhasedetails.push({
'sobjectType' : 'Application_Phase_CPF__c',
'Include_VAT_on_charges__c':'No',
'Include_balance_on_existing_account__c':'No',
'Other_amounts_included_in_total_facility__c':'No',
'Admin_fee__c':'No',
'Valuation_fee__c':'No',
'Prepayment_fee__c':'No',
'Other_fees_applicable__c':'No',
'Drawdown_inspection_fee__c':'No Fee'


});
component.set("v.newMultiplePhase",multiplePhasedetails);
component.set("v.showSpinner", false);
},
getAppOtherFeesRec :function(component, event, helper) {
var action = component.get("c.getApplicationFeesRec");
action.setParams({
"oppId": component.get("v.recordId"),
"Type" :'Facility',
"multiplephaseapplicable":'No'
});
action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appFeesRec = response.getReturnValue();
component.set("v.newFeesOther",response.getReturnValue());
                
}else {
console.log("Failed with state: " + JSON.stringify(appFeesRec));
}
});
$A.enqueueAction(action);
},

getAppOtherFeesRecMulti :function(component, event, helper) {
var action = component.get("c.getApplicationFeesRec");
action.setParams({
"oppId": component.get("v.recordId"),
"Type" :'Facility',
"multiplephaseapplicable":'Yes'
});
action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appFeesRec = response.getReturnValue();
component.set("v.newFeesOtherFaciMulti",response.getReturnValue());
                
}else {
console.log("Failed with state: " + JSON.stringify(appFeesRec));
}
});
$A.enqueueAction(action);
},
getAppOtherFeesRecFeesDetails :function(component, event, helper) {
var action = component.get("c.getApplicationFeesRec");
action.setParams({
"oppId": component.get("v.recordId"),
"Type" :'Fees Details',
"multiplephaseapplicable":'No'
});
action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appFeesRec = response.getReturnValue();
component.set("v.newFeesOtherFees",response.getReturnValue());
                
}else {
console.log("Failed with state: " + JSON.stringify(appFeesRec));
}
});
$A.enqueueAction(action);
},
getAppOtherFeesRecFeesDetailsMulti :function(component, event, helper) {
var action = component.get("c.getApplicationFeesRec");
action.setParams({
"oppId": component.get("v.recordId"),
"Type" :'Fees Details',
"multiplephaseapplicable":'Yes'
});
action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appFeesRec = response.getReturnValue();
component.set("v.newFeesOtherFeesMulti",response.getReturnValue());
                
}else {
console.log("Failed with state: " + JSON.stringify(appFeesRec));
}
});
$A.enqueueAction(action);
},
getAppFinAccCpfRec :function(component, event, helper) {
var action = component.get("c.getAppFinAccfRec");
var oppRecId=component.get("v.recordId");
var multiplephaseapplicable= component.get("v.value")
console.log(multiplephaseapplicable);
action.setParams({
"oppId": component.get("v.recordId"),
"multiplephaseapplicable":'No'
});

action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appFinAccRec = response.getReturnValue();
component.set("v.newFacilityAccount",response.getReturnValue());
}else {
console.log("Failed with state: " + JSON.stringify(appFinAccRec));
}
});
$A.enqueueAction(action);
},
getAppFinAccCpfRecMulti :function(component, event, helper) {
var action = component.get("c.getAppFinAccfRec");
var oppRecId=component.get("v.recordId");
var multiplephaseapplicable= component.get("v.value")
action.setParams({
"oppId": component.get("v.recordId"),
"multiplephaseapplicable":'Yes'
});

action.setCallback(this, function(response) {
var state = response.getState();
if (state === "SUCCESS"){
var appFinAccRec = response.getReturnValue();
component.set("v.newFacilityAccountMulti",response.getReturnValue());
}else {
console.log("Failed with state: " + JSON.stringify(appFinAccRec));
}
});
$A.enqueueAction(action);
},

insertSinglePhaseRec : function(component, event, helper) {
var primeratemarginsingle,marginsingle,interestonlyperiodsingle,finalinstalmentamtsingle,
freeflowoptionsingle,interestservicefreqsingle,finalrepaymentdatesingle,dateofFinalrepaymentsingle,
numberofPeriodsMonthssingle,netmarginsingle,allinriskmarginsingle,fixedrateperiodsingle,
practicaldatesingle,devperiodmnthssingle,cancellationfeessingle,adminAmtsingle,payablesingle,
accTypesingle,restruFeesingle,commFeesingle,ValfeeAmtsingle,earlyPrepFeeYr1single,
earlyPrepFeeYr2single,earlyPrepFeeYr3single,drawdowninspfeesingle,captialrepaysingle,capitalinterestsingle;
if(component.find("primeratemarginsingle") == undefined){
primeratemarginsingle=null;
}else{
primeratemarginsingle = component.find("primeratemarginsingle").get("v.value");
}
if(component.find("marginsingle") == undefined){
marginsingle=null;
}else{
marginsingle = component.find("marginsingle").get("v.value");
}if(component.find("interestonlyperiodsingle") == undefined){
interestonlyperiodsingle=null;
}else{
interestonlyperiodsingle = component.find("interestonlyperiodsingle").get("v.value");
}if(component.find("finalinstalmentamtsingle") == undefined){
finalinstalmentamtsingle=null;
}else{
finalinstalmentamtsingle = component.find("finalinstalmentamtsingle").get("v.value");
}if(component.find("freeflowoptionsingle") == undefined){
freeflowoptionsingle=null;
}else{
freeflowoptionsingle = component.find("freeflowoptionsingle").get("v.value");
}if(component.find("interestservicefreqsingle") == undefined){
interestservicefreqsingle=null;
}else{
interestservicefreqsingle = component.find("interestservicefreqsingle").get("v.value");
}if(component.find("finalrepaymentdatesingle") == undefined){
finalrepaymentdatesingle=null;
}else{
finalrepaymentdatesingle = component.find("finalrepaymentdatesingle").get("v.value");
}
if(component.find("dateofFinalrepaymentsingle") == undefined){
dateofFinalrepaymentsingle=null;
}else{
dateofFinalrepaymentsingle = component.find("dateofFinalrepaymentsingle").get("v.value");
}if(component.find("numberofPeriodsMonthssingle") == undefined){
numberofPeriodsMonthssingle=null;
}else{
numberofPeriodsMonthssingle = component.find("numberofPeriodsMonthssingle").get("v.value");
}if(component.find("netmarginsingle") == undefined){
netmarginsingle=null;
}else{
netmarginsingle = component.find("netmarginsingle").get("v.value");
}if(component.find("allinriskmarginsingle") == undefined){
allinriskmarginsingle=null;
}else{
allinriskmarginsingle = component.find("allinriskmarginsingle").get("v.value");
}if(component.find("fixedrateperiodsingle") == undefined){
fixedrateperiodsingle=null;
}else{
fixedrateperiodsingle = component.find("fixedrateperiodsingle").get("v.value");
}
if(component.find("practicaldatesingle") == undefined){
practicaldatesingle=null;
}else{
practicaldatesingle = component.find("practicaldatesingle").get("v.value");
}if(component.find("devperiodmnthssingle") == undefined){
devperiodmnthssingle=null;
}else{
devperiodmnthssingle = component.find("devperiodmnthssingle").get("v.value");
}
if(component.find("cancellationfeessingle") == undefined){
cancellationfeessingle=null;
}else{
cancellationfeessingle = component.find("cancellationfeessingle").get("v.value");
}if(component.find("adminAmtsingle") == undefined){
adminAmtsingle=null;
}else{
adminAmtsingle = component.find("adminAmtsingle").get("v.value");
}if(component.find("payablesingle") == undefined){
payablesingle=null;
}else{
payablesingle = component.find("payablesingle").get("v.value");
}if(component.find("accTypesingle") == undefined){
accTypesingle=null;
}else{
accTypesingle = component.find("accTypesingle").get("v.value");
}if(component.find("restruFeesingle") == undefined){
restruFeesingle=null;
}else{
restruFeesingle = component.find("restruFeesingle").get("v.value");
}if(component.find("commFeesingle") == undefined){
commFeesingle=null;
}else{
commFeesingle = component.find("commFeesingle").get("v.value");
}if(component.find("ValfeeAmtsingle") == undefined){
ValfeeAmtsingle=null;
}else{
ValfeeAmtsingle = component.find("ValfeeAmtsingle").get("v.value");
}if(component.find("earlyPrepFeeYr1single") == undefined){
earlyPrepFeeYr1single=null;
}else{
earlyPrepFeeYr1single = component.find("earlyPrepFeeYr1single").get("v.value");
}if(component.find("earlyPrepFeeYr2single") == undefined){
earlyPrepFeeYr2single=null;
}else{
earlyPrepFeeYr2single = component.find("earlyPrepFeeYr2single").get("v.value");
}if(component.find("earlyPrepFeeYr3single") == undefined){
earlyPrepFeeYr3single=null;
}else{
earlyPrepFeeYr3single = component.find("earlyPrepFeeYr3single").get("v.value");
}if(component.find("drawdowninspfeesingle") == undefined){
drawdowninspfeesingle=null;
}else{
drawdowninspfeesingle = component.find("drawdowninspfeesingle").get("v.value");
}
if(component.find("captialrepaysingle") == undefined){
    captialrepaysingle=null;
    }else{
    captialrepaysingle = component.find("captialrepaysingle").get("v.value");
    }
    if(component.find("capitalinterestsingle") == undefined){
    capitalinterestsingle=null;
    }else{
    capitalinterestsingle = component.find("capitalinterestsingle").get("v.value");
    }
        
var appPhaseobj = new Object();
appPhaseobj.vatonchargessingle=component.get("v.vatonchargessingle");
appPhaseobj.balexistingacctsingle=component.get("v.balexistingacctsingle");
appPhaseobj.otheramountsincludedintotalfacilitysingle=component.get("v.otheramountsincludedintotalfacilitysingle");
appPhaseobj.repaymentoptionssingle=component.find("repaymentoptionssingle").get("v.value");
appPhaseobj.drawdownamtsingle= component.find("drawdownamtsingle").get("v.value");
appPhaseobj.retentionamtsingle= component.find("retentionamtsingle").get("v.value");
appPhaseobj.interestratebasissingle= component.find("interestratebasissingle").get("v.value");
appPhaseobj.primeratemarginsingle = primeratemarginsingle;
appPhaseobj.marginsingle = marginsingle;
appPhaseobj.interestonlyperiodsingle = interestonlyperiodsingle;
appPhaseobj.finalinstalmentamtsingle = finalinstalmentamtsingle;
appPhaseobj.freeflowoptionsingle = freeflowoptionsingle;
appPhaseobj.interestservicefreqsingle = interestservicefreqsingle;
appPhaseobj.finalrepaymentdatesingle =finalrepaymentdatesingle;
appPhaseobj.dateofFinalrepaymentsingle= dateofFinalrepaymentsingle;
appPhaseobj.numberofPeriodsMonthssingle = numberofPeriodsMonthssingle;
appPhaseobj.netmarginsingle=netmarginsingle;
appPhaseobj.allinriskmarginsingle=allinriskmarginsingle;
appPhaseobj.fixedrateperiodsingle=fixedrateperiodsingle;
appPhaseobj.practicaldatesingle=practicaldatesingle;
appPhaseobj.devperiodmnthssingle=devperiodmnthssingle;
appPhaseobj.cancellationfeessingle=cancellationfeessingle;
appPhaseobj.AdminFeesingle= component.get("v.AdminFeesingle");
appPhaseobj.adminAmtsingle = adminAmtsingle;
appPhaseobj.payablesingle=payablesingle;
appPhaseobj.IncludeAminTotFacilitysingle=component.get("v.IncludeAminTotFacilitysingle");
appPhaseobj.accTypesingle=accTypesingle;
appPhaseobj.restruFeesingle=restruFeesingle;
appPhaseobj.commFeesingle=commFeesingle;
appPhaseobj.ValuationFeesingle=component.get("v.ValuationFeesingle");
appPhaseobj.ValfeeAmtsingle=ValfeeAmtsingle;
appPhaseobj.IncludeAminTotFacility2single=component.get("v.IncludeAminTotFacility2single");
appPhaseobj.PrePaymentFeesingle=component.get("v.PrePaymentFeesingle");
appPhaseobj.earlyPrepFeeYr1single=earlyPrepFeeYr1single;
appPhaseobj.earlyPrepFeeYr2single=earlyPrepFeeYr2single;
appPhaseobj.earlyPrepFeeYr3single=earlyPrepFeeYr3single;
appPhaseobj.otherfeesapplicablevalfeesingle=component.get("v.otherfeesapplicablevalfeesingle");
appPhaseobj.drawdowninspectionfeesingle=component.get("v.drawdowninspectionfeesingle");
appPhaseobj.drawdowninspfeesingle=drawdowninspfeesingle;
appPhaseobj.captialrepaysingle=captialrepaysingle;
appPhaseobj.capitalinterestsingle=capitalinterestsingle;


var action = component.get("c.insertSinglePhaseCPFRec");
action.setParams({
"appProductCpfId" : component.get("v.appPrdctCpfRec.Id"),
"multiplephaseapplicable":'No',
"appPhaseCpfRecSingleId":component.get("v.appPhaseCpfRecSingle.Id"),
"objData": JSON.stringify(appPhaseobj),
"FacAcclist":component.get("v.newFacilityAccount"),
"otherfeesdetaillist": component.get("v.newFeesOther"),
"otherfeeslst"   :component.get("v.newFeesOtherFees")

});
// Add callback behavior for when response is received
action.setCallback(this, function(response) {
var state = response.getState();

if (state === "SUCCESS"){
var appPhaseRec = response.getReturnValue();
                this.fireToast('Success!', "Application Phase CPF record updated Successfully", 'success');
} else if (state === "ERROR") {
var errors = response.getError();
if (errors) {
if (errors[0] && errors[0].message) {
console.log("Error message: " +errors[0].message);
                        this.fireToast('Error!', errors[0].message, 'error');
                        
}
}else{
console.log("Unknown error");
}
}
});
$A.enqueueAction(action);
},
    
insertMultiPhaseRec: function(component, event, helper) {

var action = component.get("c.insertMultiplePhaseCPFRec");
action.setParams({
"appProductCpfId" : component.get("v.appPrdctCpfRec.Id"),
"multiplephaseapplicable":'Yes',
"MultiplePhaselist": component.get("v.newMultiplePhase"),
});
// Add callback behavior for when response is received
action.setCallback(this, function(response) {
var state = response.getState();

if (state === "SUCCESS"){
var appPhaseRec = response.getReturnValue();
                this.fireToast('Success!', "Application Phase CPF record updated Successfully", 'success');
                
} else if (state === "ERROR") {
var errors = response.getError();
if (errors) {
if (errors[0] && errors[0].message) {
console.log("Error message: " +errors[0].message);
                        this.fireToast('Error!', errors[0].message, 'error');
                        
}
}else{
console.log("Unknown error");
}
}
});
$A.enqueueAction(action);
},

    callAuraMethod : function(component, event, helper,appPhaseRec) {
        var childCmp = component.find("newmultiphaseId");
        // call the aura:method in the child component
        if (childCmp) {
            if (Array.isArray(childCmp)) {
                for (var i = 0; i<childCmp.length; i++) {
                    var auraMethodResult = childCmp[i].multiPhaseSaveAFA("message sent by parent component cpfSingleMultiPhaseSection top of food chain", component.get('v.newFacilityAccountMulti'));
                    var auraMethodResult = childCmp[i].multiPhaseSavefacifees("message sent by parent component cpfSingleMultiPhaseSection for facifees", component.get('v.newFeesOtherFaciMulti'));
                    var auraMethodResult = childCmp[i].multiPhaseSaveotherfees("message sent by parent component cpfSingleMultiPhaseSection for otherfees", component.get('v.newFeesOtherFeesMulti'));
                    
                    
                    
}
}else{
                var auraMethodResult = childCmp.multiPhaseSaveAFA("message sent by parent component cpfSingleMultiPhaseSection top of food chain", component.get('v.newFacilityAccountMulti'));
                var auraMethodResult = childCmp.multiPhaseSavefacifees("message sent by parent component cpfSingleMultiPhaseSection for facifees", component.get('v.newFeesOtherFaciMulti'));
                var auraMethodResult = childCmp.multiPhaseSaveotherfees("message sent by parent component cpfSingleMultiPhaseSection for otherfees", component.get('v.newFeesOtherFeesMulti'));
                
}
}
    },
    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
});
        toastEvent.fire();
    }


})