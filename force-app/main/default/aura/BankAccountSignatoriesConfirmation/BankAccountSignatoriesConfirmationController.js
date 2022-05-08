({
    doInit : function(component, event, helper) {
        component.set("v.IsSpinner", true);
        helper.doInit(component, event);
        component.set("v.IsSpinner", false);
    },
    
    generateDoc :function(component, event, helper) {
       	console.log('Get the Document ');
        helper.showSpinner(component);
        var action = component.get("c.getDocument");
        var clientAccountNumber = component.get("v.selectedAccountNumberToFlow");
        var accId=component.get("v.clientAccountIdFromFlow");
        var Signatories = JSON.stringify(component.get("v.transactionData"));
        var noOfSignatories =component.get("v.noofSignatories");
        console.log('clientAccountNUmber from Flow recieved: '+ clientAccountNumber);
        console.log('accId: '+ accId);
        console.log('templateName : '+ component.get("v.templateName"));
        console.log('Case Id --> : '+ component.get("v.caseRecordId"));
        console.log('Signatories --> : '+ Signatories);
        console.log('noOfSignatories --> : '+ noOfSignatories);
        
        
        action.setParams({accountId: accId , accNo:clientAccountNumber,noofSign:noOfSignatories,lstOfSignatories : Signatories, templateName:component.get("v.templateName") , caseId:component.get("v.caseRecordId")});
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('Document State'+state);
            if (state === "SUCCESS") {
                 console.log('response'+response.getReturnValue());
                var respObj = response.getReturnValue();
                if(respObj=='Success'){
                    console.log('-----SUCCESS Generating Document-----');
                    
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "SUCCESS",
                        "message": "Document Generated Succesfully",
                        "type":"SUCCESS"
                    });
                    toastEvent.fire();
                }else{
                    console.log('-----ERROR  Generating Document-----');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR",
                        "message": "Error in Generating  Document ",
                        "type":"ERROR"
                    });
                    toastEvent.fire();
                }
            }else {
                console.log('-----ERROR In Service -----');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message": "Error in Generating Document..Please contact Admin ",
                    "type":"ERROR"
                });
                toastEvent.fire();
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
})