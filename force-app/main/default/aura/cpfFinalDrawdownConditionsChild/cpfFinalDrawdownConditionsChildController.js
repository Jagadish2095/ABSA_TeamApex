({
doInit: function (component, event, helper) {

},
onCheckedRemoveAccount: function (component, event, helper) {
    var chkBoxCmp = component.find("chkRemoveThisAccount");
    component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
},
onCheckedRemoveAccountfinal: function (component, event, helper) {
    var chkBoxCmpfinal = component.find("chkRemoveThisAccountfinal");
    component.set("v.isActiveRemoveAccountfinal", chkBoxCmpfinal.get("v.value"));
},

removeAccount: function (component, event, helper) {
    helper.removeotherdrawdown(component, event);
},
removeAccountfinal: function (component, event, helper) {
    helper.removeotherfinaldrawdown(component, event);
},




})