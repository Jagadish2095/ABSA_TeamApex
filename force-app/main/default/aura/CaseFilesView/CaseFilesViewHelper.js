/**
* JavaScript Help class for the "CaseFilesViewCtrl" lightning component
*
* @author  Chenna
* @version v1.0
* @since   2020-09-11
*
**/

({
    showToastMsg : function(msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Info Message',
            message: msg,
            duration:' 5000',
            key: 'info_alt',
            type: 'Success',
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    bytesToSize: function(bytes) {
        var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        if (bytes == 0) return 'n/a';
        var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
        if (i == 0) return bytes + ' ' + sizes[i];
        return (bytes / Math.pow(1024, i)).toFixed(0) + ' ' + sizes[i];
    },
    fetchCaseNumber : function(component, event, helper) {
        var recId = component.get("v.recordId");
        console.log('recId::',recId);
        var action = component.get("c.fetchCaseNo");
        action.setParams({ caseId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('res::',response.getReturnValue());
                var caseNo = response.getReturnValue();
                component.set('v.caseNumber', caseNo);
            }
            else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);  
    }
})