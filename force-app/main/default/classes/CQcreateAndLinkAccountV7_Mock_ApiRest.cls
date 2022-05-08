/*
 * Mock ApiRest Bean for CQcreateAndLinkAccountV7 Service
 * @author Prashant Jain
 * @created 2020-02-21
 */

 @ isTest
global class CQcreateAndLinkAccountV7_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global CQcreateAndLinkAccountV7_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"CQcreateAndLinkAccountV7Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO002"},"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"0","nbrUserErrs":"0"},"cqh411o":{"accountNbrOut":"00000004048259869","sicCode":"0","clientType":"2301","relatedAcctNbr":"+00000000000000000","corpCode":"ABS","siteName":"DIGITAL ABSA","siteNameA":"P","clientName":"K2019001793 ( SOUTH AFRICA ) (PTY) LTD","clientNameA":"P","accountNameA":"M","acctOpenDate":"20200217","acctOpenDateA":"M","acctOpenReason":"0","acctOpenReasonA":"M","managerNbr":"1","managerNbrA":"M","riskType":"H","riskTypeA":"M","lowRiskHoldAmount":"0","lowRiskHoldAmountA":"M","acctStoppedInd":"N","acctStoppedIndA":"M","unilateralLimitInd":"N","unilateralLimitIndA":"M","acbUser":"N","acbUserA":"M","debitBackdateLimit":"S","debitBackdateLimitA":"M","creditBackdateLimit":"S","crditBackdateLimitA":"M","corpSubProduct":"0","corpSubProductA":"P","surechequeInd":"N","surechequeIndA":"M","surechequeRetention":"0","surechequeRetentionA":"M","businessAcct":"0","businessAcctA":"P","trustS781Acct":"0","trustS781AcctA":"P","lawSocietyRegionA":"P","chqBookCollectSite":"1334","chqBookColectSiteA":"P","studentNbrA":"P","fullTimeStudentA":"P","postGradStudentA":"P","studyCourseA":"P","normalDuration":"0","normalDurationA":"P","currentAcademicYear":"0","curentAcademicYearA":"P","finalYearA":"P","studyInstitution":"000","studyInstitutionA":"P","nbrYearsRepeated":"0","nbrYearsRepeatedA":"P","extraFinanceReqrdA":"P","studiesCompletedA":"P","repayingIndA":"P","repaymentStartDate":"0","repaymentStartDateA":"P","mandateNbr":"0","mandateNbrA":"M","studentLoanInd":"N","trustSweepingInd":"N","trustSweepingIndA":"P","shadowLimitInd":"Y","shadowLimitIndA":"M"}}}');
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        } else if (typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS) {
            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response;
    }
}