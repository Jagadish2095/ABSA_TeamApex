/*
 * Mock ApiRest Bean for sMgetAsvSecurityAndHoldsV1 Service
 * @author Prashant Jain
 * @created 2020-03-10
 */

 @ isTest
global class sMgetAsvSecurityAndHoldsV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10  
    * @param typeTest 
    **/
    global sMgetAsvSecurityAndHoldsV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    
    /**
    * @description  Implement this interface method
    * @author Prashant Jain | 2021-06-10 
    * @param request 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "SMgetASVOutstandingSecurityAndHoldsV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smp155eo": { "clcd": "CLOSE  001", "outsecInd": null, "holdInd": "Y", "successInd": null, "osv": null } } }');
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