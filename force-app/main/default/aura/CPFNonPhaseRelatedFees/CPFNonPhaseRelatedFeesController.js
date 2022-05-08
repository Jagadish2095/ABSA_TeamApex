({
doInit: function (component, event, helper) {
helper.getAppPrdctCpfRec(component, event, helper);
},

handleNonPhaseUpdate:function(component, event, helper) {
helper.updateAppPrdctcpf(component, event, helper);
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

var componentName = 'CPFNonPhaseRelatedFees';
console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
helper.fireToast("Error!", "There has been an error saving the data.", "error");
},



})