/*
 * Mock ApiRest Bean for CqUpdAcctDomicileChangev2 Service
 * @author Saurabh
 * @created 2020-04-07
 */
@isTest
global class CqUpdAcctDomicileChangev2_Mock_ApiRest implements HttpCalloutMock{
    private String typeTest;

    global CqUpdAcctDomicileChangev2_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "CQupdAcctDomicileChangeV2Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo": { "version": "MSG3001", "sysErrTxt": null, "nbrUserMsgs": "1", "nbrUserErrs": "1", "msgEntry": { "msgClass": "CQSMGC01", "msgCode": "0854", "msgErrInd": "E", "msgTxt": "Enter new branch." } }, "cqh538o": { "accountNbrOut": "0", "clientName": null, "oldDomcNum": "0", "oldDomcDiv": null, "newDomcNum": "0", "newDomcDiv": null, "oldCntrlNum": "0", "oldCntrlDiv": null, "newCntrlNum": "0", "newCntrlDiv": null } } }');
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