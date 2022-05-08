({
    successMsg : function(component, msg) {
     
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": msg
        });
        toastEvent.fire();		
    },
    errorMsg : function(component,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": msg
    	});
    	toastEvent.fire();
	},
    infoMsg : function(component,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "info",
            "title": "Information!",
            "message": msg
    	});
    	toastEvent.fire();
	},
    
    // function automatic called by aura:doneWaiting event 
    changeOwnerHelper : function(component,event,helper){ 
        var caseId = component.get("v.recordId");
        var infoSource = 'Sales Support Consultant';
        var queueName = 'Flight Center';
        var caseStatus = 'Validate Securities';
        
        var action = component.get("c.changeOwner");
        action.setParams({"caseId" : caseId,
                          "processName" : queueName,
                          "caseStatus" : caseStatus,
                          "infoSource" : infoSource});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {                   
             console.log('success@@@ ');   
            }else 
            {
                console.log ('error');
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    changeOwner : function(component,event,helper){ 
        this.showSpinner(component);  
        var caseId = component.get("v.recordId");
        var infoSource = '';
        var queueName = 'Validate Securities';
        var caseStatus = 'Validate Securities';
        console.log('caseId@@@ '+caseId);
        console.log('queueName@@@ '+queueName);
        console.log('caseStatus@@@ '+caseStatus);
        console.log('infoSource@@@ '+infoSource);
        
        var action = component.get("c.changeOwner");
        action.setParams({"caseId" : caseId,
                          "processName" : queueName,
                          "caseStatus" : caseStatus,
                          "infoSource" : infoSource});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {                   
             this.refreshData(component, event, helper);   
            }else 
            {
                console.log ('error');
            }
           
        });
        
        $A.enqueueAction(action);
    },
    
    refreshData: function(component, event, helper) {
        
        
        var queueName = 'Flight Center';
        var caseStatus = 'Validate Securities';
        var decision = 'Approved';
        var details = 'Validate Securities'
        var comments = 'Approved to Validate Securities';
        var isInsert = true;  
        var infoSource = 'Sales Support Consultant';  
        
        var caseId = component.get("v.recordId");
        
        var action = component.get("c.createDecisionHistory");
        action.setParams({"caseId" : caseId,
                          "decision" : decision,
                          "details" : details,
                          "comments" : comments,
                          "processName" : 'Sales Support Consultant',
                          "isInsert" : isInsert,
                          "infoSource" : infoSource});
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
                    fieldName: 'outcome',
                    label: 'Outcome'
                },
                {
                    type: 'text',
                    fieldName: 'decision',
                    label: 'Decision'
                },
                {
                    type: 'text',
                    fieldName: 'details',
                    label: 'Detail'
                },
                
                {
                    type: 'text',
                    fieldName: 'comments',
                    label: 'Comments'
                },
                {
                    type: 'text',
                    fieldName: 'sanctioner',
                    label: 'Sanctioner'
                },
                {
                    type: 'text',
                    fieldName: 'changes',
                    label: 'Changes'
                },
                {
                    type: 'text',
                    fieldName: 'decisionDate',
                    label: 'Date'
                }
            ];
            
            component.set('v.gridColumns', columns);
            this.hideSpinner(component);
             $A.get('e.force:refreshView').fire();
        });
        
        $A.enqueueAction(action);
        
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