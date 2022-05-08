({
    doInit : function(component, event, helper) {

        var action = component.get("c.getAccountDetails");
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        console.log('clientAccountId'+ clientAccountId);
        action.setParams({clientAccountId:clientAccountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state :' +state)
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                var respObj = JSON.parse(response.getReturnValue());
                component.set('v.accountDetailsList',respObj);
                
                var prodList = [];
                var prodSet = new Set();
                
                for(var key in respObj){
                   if (!prodList.includes(respObj[key].productType)) {
                        prodList.push(respObj[key].productType);
                       console.log("The length : "+prodList.length);
                   } 
                }
                
                component.set('v.columns', [
                        {label: 'Account Number', fieldName: 'oaccntnbr', type: 'text'},
                        {label: 'Product', fieldName: 'productType', type: 'text'},
                        {label: 'Balance', fieldName: 'balance', type: 'text'},
                        {label: 'Available balance', fieldName: 'availableBalance', type: 'text'},
                        {label: 'ErrorCode'}
                    ]); 
                
            } else if(state === "ERROR"){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
            } else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message":state,
                    "type":"error"
            })
            }
           /* $A.get('e.force:refreshView').fire();
            location.reload();*/
        });
        $A.enqueueAction(action);

        
    },
    
    closeCase : function(component,event,helper){
        
        //debugger;
        helper.caseCurrentCaseHelper(component, event, helper);
        component.set("v.showCloseCase",false);
        
        /* $A.get('e.force:refreshView').fire();
          location.reload();
        component.set("v.showCloseCaseSuccess",true);
        
        /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "message":"Case has been closed",
                    "type":"success"
            })
        //return toastEvent;
        helper.initialPage(component, event);  */
        
        /*var toastEvent = helper.getToast("Success", "Case is closed successfully ", "Success");
         toastEvent.fire();
                 $A.get('e.force:refreshView').fire();
                location.reload();*/
        
    }
    
})