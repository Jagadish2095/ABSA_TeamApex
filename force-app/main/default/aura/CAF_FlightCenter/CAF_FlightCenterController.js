({
    doInit: function (component,evt,helper) {
        console.log('recordId##' + component.get("v.recordId"));
        var currentUser = $A.get("$SObjectType.CurrentUser.Id");
        var caseOwner = component.get("v.caseRecord.OwnerId");
        if(currentUser != caseOwner){
            component.set("v.isEditable", true);
        }
        else{
            component.set("v.isEditable", false);
        }
        
      
    },
onAttestSecurityDocs: function(component, event, helper) {
    console.log('In Attest##');
    var attestSecurityDocs = component.find("attestSecurityDocs").get("v.checked");
    console.log('attestSecurityDocs##' + attestSecurityDocs);
    if (attestSecurityDocs == true) {
        component.set("v.isAttestSecurityDocs", "true");
    } else {
        component.set("v.isAttestSecurityDocs", "false");
    }

},

handleReleaseSecuritDocs: function(component, event, helper) {
 var queueName = 'Sales Support Consultants';
 var caseStatus = 'Submit for Fulfilment'; 
    helper.changeOwner(component, event, helper, queueName,caseStatus);

},
})