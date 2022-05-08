/*
 * Mock ApiRest Bean for MpsCreateMerchantPlanv1 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

 @ isTest
global class MpsCreateMerchantPlanv1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global MpsCreateMerchantPlanv1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "MPScreateMerchantPlanV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "zbp005o": { "mrchAcctNbr": "00000000000000001037894", "refNum": "GN20202010378", "result": "00000 SUCCESS" } } }');
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