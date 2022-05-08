({
    doInit : function(component, event, helper) {
        var recid = component.get('v.recordId');
        if(recid.startsWith('006')){
            component.set('v.dynamicText','Transfer Opportunty');
        }else{
            component.set('v.dynamicText','Transfer Lead');
        }
        
    },
    
    clickTransfer : function(component, event, helper) {
        console.log(component.get('v.serviceGroupRecord.OwnerId'));
        
        var action = component.get('c.changeOwner'); 
        action.setParams({
            "recId" : component.get('v.recordId'),
            "newowner" : component.get('v.serviceGroupRecord.OwnerId')
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
              
            if(state == 'SUCCESS') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Record transferred Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                //window.open("/"+component.get('v.recordId'),"_self")
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else{
                var errors = a.getError();                       
                console.log('errors',errors);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Something went Wrong, please contact administrator',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})