({
    doInit: function (component, event, helper) {

        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.datetime', today);

        helper.getUserInfo(component, event, helper);

        //check if there is a region selected already
        //helper.checkRegion(component, event, helper);

        //1.decision Summary
        helper.getDecisionSum(component, event, helper);
        helper.getDecTime(component, event, helper);

        //2.Requested Products
        helper.getReqProd(component, event, helper);

        var actions = helper.getRowActions.bind(this, component);

        component.set("v.columnsReqProd", [
            { label: 'Product', fieldName: 'productName', type: 'String' }, //'Product_Name__c' +
            { label: 'Product Type', fieldName: 'productType', type: 'String' },
            { label: 'Account Number', fieldName: 'productAccountNumber', type: 'String' },
            { label: 'Amount', fieldName: 'productAmount', type: 'String' },
            { label: 'System Decision', fieldName: 'systemDecision', type: 'String' },
            { label: 'Final Decision', fieldName: 'finalDecision', type: 'String' },
            { label: 'Product Status', fieldName: 'productStatus', type: 'String' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);

        //3.Reasons & Exceptions
        helper.getReasonsAndException(component, event, helper);

        //4.Potential Total Group Exposure
        var ExposureDes = ["Potential Ordinary Credit Exposure", "Potential Total Group Exposure",
            "Potential Total Group Asset Exposure",
            "Potential Total Group Business Ordinary Credit Exposure",
            "Potential Total Financing Limit"];
        component.set("v.ExposureDescripList", ExposureDes);
        helper.getPotTotalGrpExp(component, event, helper);

        //5.Submission History
        component.set("v.columnsHistory", [
            { label: 'Stage ID', fieldName: 'StageId__c', type: 'String' },
            { label: 'System Decision', fieldName: 'System_Decision__c', type: 'String' },
            { label: 'Submited by', fieldName: 'Submitted_By__c', type: 'String' },
            { label: 'Version', fieldName: 'Version__c', type: 'String' },
            { label: 'Submitted', fieldName: 'Submitted__c', type: 'String' }
        ]);
        helper.getSubmissionHist(component, event, helper);

        //6.Activity History
        component.set("v.columnsActHist", [

            { label: 'Action', fieldName: 'Action__c', type: 'String' },
            { label: 'By/To', fieldName: 'Submitted_By__c', type: 'String' },
            { label: 'Date', fieldName: 'Submitted__c', type: 'String' },
            { label: 'Version', fieldName: 'Version__c', type: 'String' }
        ]);
        helper.getActivityHist(component, event, helper);

        helper.getAppRec(component, event, helper);
        helper.getOppRec(component, event, helper);
        helper.getApplicationRecord(component, event);//Added By Himani Joshi
    },

    refreshReqProd: function (component, event, helper) {

        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.datetime', today);

        helper.getUserInfo(component, event, helper);

        //check if there is a region selected already
        //helper.checkRegion(component, event, helper);

        //1.decision Summary
        helper.getDecisionSum(component, event, helper);
        helper.getDecTime(component, event, helper);

        //2.Requested Products
        helper.getReqProd(component, event, helper);

        var actions = helper.getRowActions.bind(this, component);

        component.set("v.columnsReqProd", [
            { label: 'Product', fieldName: 'productName', type: 'String' }, //'Product_Name__c' +
            { label: 'Product Type', fieldName: 'productType', type: 'String' },
            { label: 'Account Number', fieldName: 'productAccountNumber', type: 'String' },
            { label: 'Amount', fieldName: 'productAmount', type: 'String' },
            { label: 'System Decision', fieldName: 'systemDecision', type: 'String' },
            { label: 'Final Decision', fieldName: 'finalDecision', type: 'String' },
            { label: 'Product Status', fieldName: 'productStatus', type: 'String' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);

        //3.Reasons & Exceptions
        helper.getReasonsAndException(component, event, helper);

        //4.Potential Total Group Exposure
        var ExposureDes = ["Potential Ordinary Credit Exposure", "Potential Total Group Exposure",
            "Potential Total Group Asset Exposure",
            "Potential Total Group Business Ordinary Credit Exposure",
            "Potential Total Financing Limit"];
        component.set("v.ExposureDescripList", ExposureDes);
        helper.getPotTotalGrpExp(component, event, helper);

        //5.Submission History
        component.set("v.columnsHistory", [
            { label: 'Stage ID', fieldName: 'StageId__c', type: 'String' },
            { label: 'System Decision', fieldName: 'System_Decision__c', type: 'String' },
            { label: 'Submited by', fieldName: 'Submitted_By__c', type: 'String' },
            { label: 'Version', fieldName: 'Version__c', type: 'String' },
            { label: 'Submitted', fieldName: 'Submitted__c', type: 'String' }
        ]);
        helper.getSubmissionHist(component, event, helper);

        //6.Activity History
        component.set("v.columnsActHist", [

            { label: 'Action', fieldName: 'Action__c', type: 'String' },
            { label: 'By/To', fieldName: 'Submitted_By__c', type: 'String' },
            { label: 'Date', fieldName: 'Submitted__c', type: 'String' },
            { label: 'Version', fieldName: 'Version__c', type: 'String' }
        ]);
        helper.getActivityHist(component, event, helper);

        helper.getAppRec(component, event, helper);
        helper.getOppRec(component, event, helper);
        helper.getApplicationRecord(component,event);//Added By Himani Joshi
    },

    decision: function (component, event, helper) {
        var buttonlabel = event.getSource().get("v.label");
        //  console.log("Decision buttonlabel---"+buttonlabel);
        if (buttonlabel == 'Accept Decision') {
            component.set("v.isAcceptedDecision", true);
            component.set("v.isAccepted", true);
            component.set("v.isReferSanction", false);
            component.set("v.isBeginSanctioning", false);
            component.set("v.isReferred", false);
            component.set("v.isAmended", false);

        } else if (buttonlabel == 'Refer To Sanctioning') {

            //Added By Himani Joshi

            var appRecord = component.get('v.applicationUpdated');
            console.log('appRecord.NoOfDaysSinceBureauDate__c' + appRecord.NoOfDaysSinceBureauDate__c);
            console.log('appRecord.Lookup_Period__c' + appRecord.Lookup_Period__c);
            console.log('appRecord.Enforce_Rework__c' + appRecord.Enforce_Rework__c);

            if (appRecord.NoOfDaysSinceBureauDate__c >= appRecord.Lookup_Period__c && appRecord.Enforce_Rework__c === 'Y') {
                component.set("v.disableAccept", true);
                component.set("v.disableRefer", true);
                //component.set("v.isBeginSanctioning", true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "The Credit Bureau Report is no longer valid. Re-process the application ",
                    "type": "error"
                });
                toastEvent.fire();
            }
            else {

                component.set("v.isBeginSanctioning", false);
                component.set("v.isReferSanction", true);
                component.set("v.isReferred", true);

                component.set("v.isAcceptedDecision", false);
                component.set("v.isAccepted", false);
                component.set("v.isProceedSanctioning", false);
                component.set("v.isAmended", false);
            }


        } else {

            component.set("v.isAmended", true);

            component.set("v.isAcceptedDecision", false);
            component.set("v.isAccepted", false);
            component.set("v.isProceedSanctioning", false);

            component.set("v.isReferSanction", false);
            component.set("v.isReferred", false);
            component.set("v.isBeginSanctioning", false);

            alert(' You are about to amend the Credit application, Please confirm');
        }
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Not Taken Up':
                //alert('Showing Details: ' + JSON.stringify(row));
                component.set("v.showNotTakenUp", true);
                component.set("v.rowToNTU", row);
                break;
            case 'Withdraw':
                component.set("v.showNotTakenUp", false);
                component.set("v.showWithdraw", true);
                // alert('Showing Details: ' + JSON.stringify(row));
                component.set("v.rowToNTU", row);
                break;
        }

    },

    submitAcceptedApplication: function (component, event, helper) {
        helper.updateApplication(component, event);
    },

    beginSanctioning: function (component, event, helper) {

        helper.startSanctioning(component, event);
    },

    Amend: function (component, event, helper) {
        helper.startAmendmentProcess(component, event, helper);
        // alert('Work In Progress')
    },

    close: function (component, event, helper) {
        component.set("v.showNotTakenUp", false);
    },

    confirmNotTakenUp: function (component, event, helper) {

        if (!component.get("v.ntuReason") || component.get("v.ntuReason") == '') {
            var toastEvent = helper.getToast("Error!", 'Please fill the Reason', "error");
            toastEvent.fire();
        } else {
            helper.confirmNTU(component, event, helper);
        }
    },

    confirmWithdraw: function (component, event, helper) {

        if (!component.get("v.ntuReason") || component.get("v.ntuReason") == '') {
            var toastEvent = helper.getToast("Error!", 'Please fill the Reason', "error");
            toastEvent.fire();
        } else {
            helper.confirmWithdrawal(component, event, helper);
        }
    },
})