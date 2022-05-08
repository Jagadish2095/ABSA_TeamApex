({
    doInit: function (component, event, helper) {
        if(component.get("v.enquiryData")) {
            component.set("v.showSpinner", true);
            let enquiryDataJSON = component.get("v.enquiryData");
            let enquiryData = JSON.parse(enquiryDataJSON);
            let reportName = enquiryData.enquiryType.replace('/r','/') + '_Report.pdf';
            component.set("v.reportName", reportName);

            helper.getDataFromApex(component, helper, "c.getEnquiryReport", {enquiryDataJSON: enquiryDataJSON}, "v.pdfData", helper.changePDFDataReceivedStatus, helper.errorHandle);
        }
    },

    closeCaseAndTab : function(component, event, helper) {
        component.set("v.showSpinner", true);
        let enquiryData = JSON.parse(component.get("v.enquiryData"));
        helper.getDataFromApex(component, helper, "c.closeCase", {caseId: enquiryData.caseId}, null, null, null);
        helper.closeFocusedTab(component);
    },

    restartEnquiry : function(component, event, helper) {
        helper.restartEnquiry(component);
    }
})