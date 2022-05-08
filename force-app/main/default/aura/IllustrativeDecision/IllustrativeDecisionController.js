({
    doInit : function(component, event, helper) {
       
        helper.getDecisionSum(component, event, helper);
        helper.getDecTime(component, event, helper);
        helper.getReasonsAndExceptions(component, event, helper);
        helper.getRequestedProducts(component, event, helper);
        //Submission History    
        component.set("v.columnsHistory", [
            {label: 'Stage ID', fieldName: 'StageId__c', type: 'String'},
            {label: 'System Decision', fieldName: 'System_Decision__c', type: 'String'},
            {label: 'Submited by', fieldName: 'Submitted_By__c', type: 'String'},
            {label: 'Version', fieldName: 'Version__c', type: 'String'},
            {label: 'Submitted', fieldName: 'Submitted__c', type: 'String'}
        ]);
        helper.getSubmissionHist(component, event, helper);
        
    },
    refreshReqProd : function(component, event, helper) {
       
        helper.getDecisionSum(component, event, helper);
        helper.getDecTime(component, event, helper);
        helper.getReasonsAndExceptions(component, event, helper);
        helper.getRequestedProducts(component, event, helper);
        //Submission History    
        component.set("v.columnsHistory", [
            {label: 'Stage ID', fieldName: 'StageId__c', type: 'String'},
            {label: 'System Decision', fieldName: 'System_Decision__c', type: 'String'},
            {label: 'Submited by', fieldName: 'Submitted_By__c', type: 'String'},
            {label: 'Version', fieldName: 'Version__c', type: 'String'},
            {label: 'Submitted', fieldName: 'Submitted__c', type: 'String'}
        ]);
        helper.getSubmissionHist(component, event, helper);
        
    },
    /*
    showRefreshBtn : function(component, event, helper) {
        var target = event.getSource();
        var chValue = target.get("v.value"); //is checkbox selected
        if (!chValue) {
        component.set('v.refresh',false);
        }
        if (chValue){
        component.set('v.refresh',true);
        }
       },
   
    showSubmitBtn: function(component, event, helper) {
        var target = event.getSource();
        var chValue = target.get("v.value"); //is checkbox selected
        if (!chValue) {
        component.set('v.submit',false);
        }
        if (chValue){
        component.set('v.submit',true);
        }
    },
    */
     amendApplication : function(component, event, helper) {
        //Amend Application
        helper.amend(component,event,helper);
               
    },
    submitApplication : function(component, event, helper) {
        console.log('aa');
        helper.submitStage(component,event,helper);
    },
    handleChange : function(component, event, helper) {
    var radioGrpValue = component.get("v.radioGrpValue");
    console.log('radioGrpValue',radioGrpValue);
        if(radioGrpValue=='Amend'){
            component.set('v.refresh',true);
        }
        if(radioGrpValue!='Amend'){
            component.set('v.refresh',false);
        }
        if(radioGrpValue=='Submit'){
             component.set('v.submit',true);   
        }
        if(radioGrpValue!='Submit'){
             component.set('v.submit',false);   
        }
},
})