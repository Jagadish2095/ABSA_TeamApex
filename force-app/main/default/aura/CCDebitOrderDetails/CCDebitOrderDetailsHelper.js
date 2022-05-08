({
    doInitHelperMethod : function(component, event) {
        var application = {};
        var requestCommons = {};
        var mandateDetails = {};
        mandateDetails.macCode = '';
        mandateDetails.accountNumber = '';
        mandateDetails.authType = '0230';
        application.mandateDetails = mandateDetails;
        application.applicationNumber = '';
        application.LockVersionId = '';
        application.corpCode = 'ABSA';
        application.creditStatus = '';
        application.customerId = ''; // UI
        application.customerSourceCode = 'VSF';
        application.customerSourceReferenceNumber = '';
        application.marketingSiteId = '';
        application.productGroupId = '1';
        application.statusGroup = '';
        application.transactionType = '';
        application.knockoutQuestions = '';
        requestCommons.channelCode = 'T';
        requestCommons.employeeNumber = '';
        requestCommons.messageLanguage = 'E';
        requestCommons.siteId = '4512';
        requestCommons.validateDetails = 'true';
        application.requestCommons = requestCommons;
    }
})