({
    doInit : function(component, event, helper) { 
        component.set('v.isMaturity',false);
        component.set('v.mycolumns', [
            { label: 'Product Name', fieldName: 'Product_Name__c', type: 'text'},
            { label: 'Policy Number', fieldName: 'Policy_Number__c', type: 'text'},
            { label: 'Product Provider', fieldName: 'Product_Provider__c', type: 'text'},
            { label: 'Policy Type', fieldName: 'Policy_Type__c', type: 'text'}
            
        ]);
        
        var action = component.get("c.getCaseDetails");
        var caseId=component.get("v.recordId");
        action.setParams({caseId:caseId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                var caseRecord=response.getReturnValue();
                console.log('Respoce-'+caseRecord.RecordType.Name +'id and v'+caseRecord.ID_V_Completed__c);
                component.set("v.recortType",caseRecord.RecordType.Name);    
                if(caseRecord.RecordType.Name =='VA Maturity'){
                    component.set('v.isMaturity',true);
                    component.set('v.mycolumns', [
                        { label: 'Policy Number', fieldName: 'Policy_Number__c', type: 'text'},
                        { label: 'Product Provider', fieldName: 'Product_Provider__c', type: 'text'},
                        { label: 'Policy Type', fieldName: 'Policy_Type__c', type: 'text'}                        
                    ]);
                    
                }
                if(caseRecord.RecordType.Name =='VA Maturity' && caseRecord.ID_V_Completed__c==true){
                    component.set('v.mycolumns', [
                        { label: 'Policy Number', fieldName: 'Policy_Number__c', type: 'text'},
                        { label: 'Product Provider', fieldName: 'Product_Provider__c', type: 'text'},
                        { label: 'Policy Type', fieldName: 'Policy_Type__c', type: 'text'},
                        { label: 'Maturity Date', fieldName: 'Maturity_Date__c', type: 'date'},
                        { label: 'Maturity Value', fieldName: 'Maturity_Value__c', type: 'Number'}
                    ]); 
                    helper.getPolicDetails(component, event, helper);
                }else{
                    helper.getPolicDetails(component, event, helper);
                }  
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });        
        $A.enqueueAction(action);
    }
})