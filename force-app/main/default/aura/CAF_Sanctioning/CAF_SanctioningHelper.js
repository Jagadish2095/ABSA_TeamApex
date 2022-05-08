({
	helperMethod : function() {
		
	},
     refreshData: function(component, event, helper) {
          this.showSpinner(component); 
        var oppId = component.get("v.recordId");
        
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
             this.hideSpinner(component);
        });
        
        $A.enqueueAction(action);
   },
    
     handleApprovalRequest: function(component, event, helper, approvalName, comments, status) {
      this.showSpinner(component); 
       var oppId = component.get("v.recordId");
       var approverId = '';
         console.log('oppId@@@ '+oppId);
         console.log('approvalName@@@ '+approvalName);
         console.log('comments@@@ '+comments);
         console.log('status@@@ '+status);
         console.log('approverId@@@ '+approverId);
        var action = component.get("c.processRequest");
        action.setParams({"oppId" : oppId,
                          "approvalName" : approvalName,
                          "comments" : comments,
                          "status" : status,
                          "reasons" : '',
                          "approverId":approverId});
         
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {                   
            $A.get('e.force:refreshView').fire();
            }else 
            {
                console.log ('error');
            }
             this.hideSpinner(component);
        });
       
        $A.enqueueAction(action);
        helper.refreshData(component, event, helper);
   },
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})