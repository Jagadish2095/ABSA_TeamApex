({
	  // function automatic called by aura:doneWaiting event 
    changeOwner : function(component,event,helper,queueName,caseStatus,infoSource){ 
         this.showSpinner(component);
        var caseId = component.get("v.recordId");
         console.log('caseId@@@ '+caseId);
         console.log('queueName@@@ '+ queueName);
         console.log('caseStatus@@@ '+ caseStatus);
        
        var action = component.get("c.changeOwner");
        action.setParams({"caseId" : caseId,
                          "processName" : queueName,
                          "caseStatus" : caseStatus,
                          "infoSource" : infoSource,
                         });
         
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {                   
                   
            }else 
            {
                console.log ('error');
            }
             $A.get('e.force:refreshView').fire();
             this.hideSpinner(component);
        });
       
        $A.enqueueAction(action);

    },
    
     refreshData: function(component, event, helper,isInsert,queueName,caseStatus,decision,details,comments,infoSource) {
         //helper.refreshData(component, event, helper, decision,details,comments,isInsert,infoSource);
        this.showSpinner(component); 
        var caseId = component.get("v.recordId");
        var queueName = queueName;
        var caseStatus = caseStatus;
        var decision = decision;
        var details = details;
        var comments = comments;
        var isInsert = isInsert; 
        var processName = 'Sales Support Consultant';
        var infoSource = infoSource;
        var action = component.get("c.createDecisionHistory");
        action.setParams({"caseId" : caseId,
                          "decision" : decision,
                          "details" : details,
                          "comments" : comments,
                          "processName" : processName,
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
                
         var currentUser = $A.get("$SObjectType.CurrentUser.Id");
         var caseOwner = component.get("v.caseRecord.OwnerId");
         var caseStatus = component.get("v.caseRecord.Status");
         console.log("init currentUser "+currentUser);
         console.log("init caseOwner "+caseOwner);
         console.log("init caseStatus "+caseStatus); 
         
       
            if(currentUser != caseOwner || caseStatus == 'Complete Securities' ){
            component.set("v.isEditable", true);
            component.set("v.autoChecked", true);
            component.set("v.isAttestSecurities", true);
                
            
            }
                else{
                    
                component.set("v.isEditable", false);
            component.set("v.autoChecked", false); 
            component.set("v.isAttestSecurities", false);
                    
                }
        
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
                    label: 'Requester/Approver'
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