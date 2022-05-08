({
    //Function for setting the table columns and setting the fields to be quried.
    getColumns : function(component) { 
        var colDateFormat = {day: "2-digit", month: "2-digit", year: "numeric"};
        component.set('v.tableColumns', [
            {label: 'Action', fieldName: 'Action__c', type: 'text'},
            {label: 'Policy Number', fieldName: 'Insurance_Policy_Number__c', type: 'text'},
            {label: 'Product', fieldName: 'Product_Code__c', type: 'Text'},
            {label: 'Effective From', fieldName: 'Effective_From_Date__c', type: 'date', typeAttributes: colDateFormat},
            {label: 'Effective To', fieldName: 'Effective_To_Date__c', type: 'date', typeAttributes: colDateFormat},
            {label: 'Policy Status', fieldName: 'Status__c', type: 'text'},
            {label: 'Policy Action', fieldName: 'Policy_Action__c', type: 'text'},
            {label: 'Log Date', fieldName: 'Log_Date__c', type: 'date', typeAttributes:colDateFormat}                     
        ]);

    },

    //Function for getting the data from the Apex controller
    getDataHelper : function(component, event){

        var action     = component.get("c.fetchPolicyAuditList");

        //Setting params
        action.setParams({
            policyId  : component.get("v.policyRecordId"),
            pageSize  : component.get("v.pageSize"),
            pageNumber: component.get("v.pageNumber")
        });

        //Callback function
        action.setCallback(this,function(response){
            // store the response return value 
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                console.log("policyAuditList==> " + resultData);
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }

                component.set("v.totalRows", resultData.length);
                component.set("v.policyAuditList", resultData);


            }else if(state === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error InsurancePolicyCoverAuditController.fetchAuditList: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
        component.set("v.showLoadingSpinner", false);
    },
})