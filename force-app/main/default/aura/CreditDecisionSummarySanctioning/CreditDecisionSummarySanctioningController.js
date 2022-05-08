({
    
    refreshReqProd: function(component, event, helper) {
        helper.getReqProd(component, event, helper);   
    },
    
    doInit : function(component, event, helper) {
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.datetime', today);
        
        helper.getUserInfo(component, event, helper);
        
        //1.decision Summary
        helper.getDecisionSum(component, event, helper);
        
        //2.Requested Products   
        helper.getReqProd(component, event, helper);
        
        
        component.set("v.columnsReqProd", [
            {label: 'Product', fieldName:  'productName', type: 'String'}, //'Product_Name__c' +
            {label: 'Product Type', fieldName: 'productType', type: 'String'},
            {label: 'Account Number', fieldName: 'productAccountNumber', type: 'String'},
            {label: 'Amount', fieldName: 'productAmount', type: 'String'},
            {label: 'System Decision', fieldName: 'systemDecision', type: 'String'},
            {label: 'Final Decision', fieldName: 'finalDecision', type: 'String'},
            {label: 'Product Status', fieldName: 'productStatus', type: 'String'},
        ]);
            
            //3.Reasons & Exceptions
            helper.getReasonsAndException(component, event, helper);
            
            //4.Potential Total Group Exposure
            var ExposureDes = ["Potential Ordinary Credit Exposure", "Potential Total Group Exposure",
            "Potential Total Group Asset Exposure",
            "Potential Total Group Business Ordinary Credit Exposure",
            "Potential Total Financing Limit" ];
                      component.set("v.ExposureDescripList", ExposureDes);
        helper.getPotTotalGrpExp(component, event, helper);
        
        //5.Submission History    
        component.set("v.columnsHistory", [
            {label: 'Stage ID', fieldName: 'StageId__c', type: 'String'},
            {label: 'System Decision', fieldName: 'System_Decision__c', type: 'String'},
            {label: 'Submited by', fieldName: 'Submitted_By__c', type: 'String'},
            {label: 'Version', fieldName: 'Version__c', type: 'String'},
            {label: 'Submitted', fieldName: 'Submitted__c', type: 'String'}
        ]);
        helper.getSubmissionHist(component, event, helper);
        
        helper.getAppRec(component, event, helper);
        helper.getOppRec(component, event, helper);
        
    },
    
    close : function(component, event, helper) {
        component.set("v.showNotTakenUp", false);
    },
    
    confirmNotTakenUp : function(component, event, helper) {
        helper.showSpinner(component);
        helper.confirmNTU(component, event, helper);
        helper.hideSpinner(component);
    },
})