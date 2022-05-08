({
    //Function for setting the table columns.
    getColumns : function(component) {
        var colDateFormat = {day: "2-digit", month: "2-digit", year: "numeric"};
        component.set('v.tableColumns', [
            {label: 'Section Code', fieldName: 'Section_Code__c', type: 'text'},
            {label: 'Cover Code', fieldName: 'Cover_Code__c', type: 'Text'},
            {label: 'Effective From', fieldName: 'Effective_From_Date__c', type: 'date', typeAttributes: colDateFormat},
            {label: 'Effective To', fieldName: 'Effective_To_Date__c', type: 'date', typeAttributes: colDateFormat},
            {label: 'Conditions', fieldName: '*', type: 'text'},
            {label: 'Sum Insured', fieldName: 'Sum_Insured__c', type: 'text'},
            {label: 'Premium Excl', fieldName: 'Premium_Excl_VAT__c', type: 'text'},
            {label: 'Log Date', fieldName: 'Log_Date__c', type: 'date', typeAttributes: colDateFormat}                       
        ]);
    },

    //Function for getting the data from the Apex controller
    getDataHelper : function(component, event) {

        var action     = component.get("c.fetchCoverAuditList");
        
        action.setParams({
            policyId   : component.get("v.policyRecordId"),
            pageSize   : component.get("v.pageSize"),
            pageNumber : component.get("v.pageNumber")
        });
        action.setCallback(this,function(response){
            // store the response return value 
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }

                component.set("v.totalRows", resultData.length);
                component.set("v.coverAuditList", resultData);

            }else if(state === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error InsurancePolicyCoverAuditController.fetchCoverAuditList: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
        component.set("v.showLoadingSpinner", false);
    },

})