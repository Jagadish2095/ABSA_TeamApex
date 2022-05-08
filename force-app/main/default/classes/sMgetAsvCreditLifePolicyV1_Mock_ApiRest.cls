/*
 * Mock ApiRest Bean for sMgetAsvCreditLifePolicyV1 Service
 * @author Prashant Jain
 * @created 2020-03-06
 */

 @ isTest
global class sMgetAsvCreditLifePolicyV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param typeTest 
    **/
    global sMgetAsvCreditLifePolicyV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param request 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "SMgetASVcreditLifePoliciesV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smn151o": { "tnomVal": null, "tsecVal": null, "tasvVal": null, "tmasvVal": null, "clTable": [ { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" }, { "polId": "0", "seqNo": "0", "polType": "0", "polNo": "0", "polAmt": "0", "startDate": "0", "renewDate": "0", "refAcc": "0" } ] } } }');
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