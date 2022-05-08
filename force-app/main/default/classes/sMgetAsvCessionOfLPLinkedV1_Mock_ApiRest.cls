/*
 * Mock ApiRest Bean for sMgetAsvCessionOfLPLinkedV1 Service
 * @author Prashant Jain
 * @created 2020-03-05
 */

 @ isTest
global class sMgetAsvCessionOfLPLinkedV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description Mock Method
    * @author Prashant Jain | 2021-06-11 
    * @param typeTest 
    **/
    global sMgetAsvCessionOfLPLinkedV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    
    /**
    * @description Implement this interface method
    * @author Prashant Jain | 2021-06-11 
    * @param request 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "SMgetASVCessionOfLifePoliciesLinkedV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smp332eo": { "clcdOut": null, "nomvalTotOut": null, "secvalTotOut": null, "asvamtTotOut": null, "msvamtTotOut": null, "successInd": null, "table": [ { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "polamtOut": "0", "poltypOut": "0", "ackdteOut": "0", "peotdaOut": "0", "ltddteOut": "0", "valdteOut": "0", "covamtOut": "0", "totpolOut": "0", "netvalOut": "0", "refaccOut": "0", "supsnoOut": "0", "polidOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" } ] } } }');
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