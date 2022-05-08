({
     refreshData: function(component, event, helper) {
          //this.showSpinner(component); 
        var oppId = component.get("v.oppId");
        
        var action = component.get("c.getApprovalRequests");
        action.setParams({"oppId" : oppId});
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {
                                
                var data = response.getReturnValue();
                component.set('v.gridData',  data);     
                console.log('data@@@'+data);
                console.log('grid data@@@'+component.get("v.gridData"));
            }else 
            {
                console.log ('error');
            }
            
            var columns = [
                {
                    type: 'text',
                    fieldName: 'decision',
                    label: 'Decision'
                },
                {
                    type: 'text',
                    fieldName: 'comments',
                    label: 'Comments'
                },
                {
                    type: 'text',
                    fieldName: 'approver',
                    label: 'Approver'
                },
                {
                    type: 'text',
                    fieldName: 'region',
                    label: 'Region',
                    sortable: true
                },
                {
                    type: 'text',
                    fieldName: 'approvalDate',
                    label: 'Date'
                }
            ];
            
            component.set('v.gridColumns', columns);
             //this.hideSpinner(component);
        });
        
        $A.enqueueAction(action);
   },
    
    successMsg : function(component, msg) {
     
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": msg
        });
        toastEvent.fire();		
    },
    errorMsg : function(msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": msg
    	});
    	toastEvent.fire();
	}
        
    
    
    
})