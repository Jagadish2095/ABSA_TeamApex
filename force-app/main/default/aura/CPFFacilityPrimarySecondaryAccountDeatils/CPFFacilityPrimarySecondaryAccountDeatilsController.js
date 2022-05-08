({
doInit : function(component, event, helper) {
helper.getAppPrdctCpfRec(component, event, helper);
helper.getSecondaryAcctRepaymentRec(component, event, helper);
helper.getPrimaryAcctRepaymentRecord(component, event, helper);    
helper.getopplineitemRec(component, event, helper);
component.set("v.repaymentoptions", 'Equal Instalment');
},
showHiddenFields: function (component, event,helper) {
var primeratechangeValue = event.getParam("value");
if(primeratechangeValue!= null && primeratechangeValue!= ''){
    component.set("v.marginRate", primeratechangeValue);
}},
showFinalRepaymentHiddenFields: function (component, event,helper) {
var finalrepaymentchangeValue = event.getParam("value");
    if(finalrepaymentchangeValue!= null && finalrepaymentchangeValue!=''){
    component.set("v.finalRepaymentDate", finalrepaymentchangeValue);
}},
showFieldsReqOnInterestBasis: function (component, event,helper) {
var InterestRateBasis = event.getParam("value");
if(InterestRateBasis!= null && InterestRateBasis!=''){
    component.set("v.interestratebasis", InterestRateBasis);
    }
},
showFieldsRepaymentOptions: function (component, event,helper) {
var repaymentoptions = event.getParam("value");
component.set("v.repaymentoptions", repaymentoptions);
},

handleChange: function (component, event,helper) {

var changeValue = event.getParam("value");
var secondaryaccoptionGiven = component.get("v.secondaryaccoptionGiven") ;

if(changeValue== 'N'){
    
    component.set("v.secondaryaccoptionGiven", 'N');
    component.set("v.showFacilityAndRepayment", 'No');
}
else if(changeValue=='Y'){
    
    component.set("v.secondaryaccoptionGiven", 'Y');
    component.set("v.showFacilityAndRepayment",'Yes');
}
},

IncluderepaymentschedulehandleChange: function (component, event,helper) {
var IncluderepaymentscheduleValue = event.getParam("value");
var IncluderepaymentscheduleoptionGiven = component.get("v.IncluderepaymentscheduleoptionGiven") ;

if(IncluderepaymentscheduleValue== 'N'){
    component.set("v.IncluderepaymentscheduleoptionGiven", 'N');
}
else if(IncluderepaymentscheduleValue=='Y'){
    component.set("v.IncluderepaymentscheduleoptionGiven", 'Y');
}
},
addNewSecondaryAccount: function (component, event, helper) {
helper.addNewSecondaryAccount(component, event);
},
handleFacityRepaymentSubmit : function(component, event, helper) {
component.set("v.showSpinner", true);
var termvalue = component.find('term').get('v.value');
/*var instalmentamt = component.find("Instalmentamount").get("v.value");
if(instalmentamt=='' || instalmentamt==undefined){
      var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Error!",
        "type":"error",
        "message": "Please complete all the fields"
    });
    toastEvent.fire();  
    component.set("v.showSpinner", false);
    }*/
 if(termvalue > 120) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Error!",
        "type":"error",
        "message": "Maximum valued allowed 120"
    });
    toastEvent.fire();
    component.set("v.showSpinner", false);
}else{                    
    helper.updateFacilityRepaymentcpf(component, event, helper);}

},
handlePrimaryRepaymentSubmit : function(component, event, helper) {
component.set("v.showSpinner", true);
var termId = component.find('primaryterm');
var termvalue = termId.get('v.value');
/*var instalmentamt = component.find("primaryInstalmentamount").get("v.value");
if(instalmentamt=='' || instalmentamt==undefined){
      var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Error!",
        "type":"error",
        "message": "Please complete all the fields"
    });
    toastEvent.fire();  
    component.set("v.showSpinner", false);
    }*/
 if(termvalue > 120) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            "title": "Error!",
            "type":"error",
            "message": "Maximum valued allowed 120"
            });
            toastEvent.fire();
    component.set("v.showSpinner", false);
}else{                    
    helper.InsertPrimaryRepaymentReqcpf(component, event, helper);}

},
renderField: function(component, event, helper) {

var wasadesktopvaluationdone = component.find("wasadesktopvaluationdone").get("v.value");
console.log('wasadesktopvaluationdone'+wasadesktopvaluationdone);
if (wasadesktopvaluationdone == "No"){
    component.set("v.renderfield", true);
}   
else{
    component.set("v.renderfield", false);
}
},

handleAppFinAcctobeClosedEvent : function(component, event,helper) {

var acctobeClosed=event.getParam("AccTobeClosed");
component.set("v.accounttobeclosedoptn",acctobeClosed);

},
handleSuccess : function(component, event, helper) {
var toastEvent = $A.get("e.force:showToast");
toastEvent.setParams({
    title : 'Property Valuation Saved Successfully',
    message: 'Property Valuation Saved Successfully!',
    duration:' 4000',
    key: 'info_alt',
    type: 'success',
    mode: 'pester'
});
toastEvent.fire();
},

handleError : function(component, event, helper) {

var componentName = 'CPFFacilityPrimarySecondaryAccountDetails';
console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
helper.fireToast("Error!", "There has been an error saving the data.", "error");
},
addNewSecondaryAccount: function (component, event, helper) {
helper.addNewSecondaryAccount(component, event);
},
handleApplicationEvent : function(component, event,helper) {
// var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
var rowinex =event.getParam("RowIndex");
var newSecondaryAcctRepaymentReqlist=component.get("v.newSecondaryAcctRepaymentReq");
newSecondaryAcctRepaymentReqlist.splice(rowinex,1);
component.set("v.newSecondaryAcctRepaymentReq",newSecondaryAcctRepaymentReqlist);
},

handleSubmit : function(component, event, helper) {
    component.set("v.showSpinner", true);
var itemsToPass=component.get("v.newSecondaryAcctRepaymentReq");
var item;
var checkStatus = false;
console.log('itemsToPass=== newSecondaryAcctRepaymentReq'+JSON.stringify(itemsToPass));
helper.InsertNewSecondaryAcctRepayementRecCpf(component, event, helper);

},
})