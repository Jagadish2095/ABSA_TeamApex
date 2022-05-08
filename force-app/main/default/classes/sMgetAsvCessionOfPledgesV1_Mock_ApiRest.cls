/*
 * Mock ApiRest Bean for sMgetAsvCessionOfPledgesV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

 @ isTest
global class sMgetAsvCessionOfPledgesV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description Mock method
    * @author Prashant Jain | 2021-06-11  
    * @param typeTest 
    **/
    global sMgetAsvCessionOfPledgesV1_Mock_ApiRest(final String typeTest) {
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
            response.setBody('{ "SMgetASVCessionOfGeneralPledgesV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smp149eo": { "clcdOut": null, "nomvalTotOut": null, "secvalTotOut": null, "asvamtTotOut": null, "msvamtTotOut": null, "successInd": null, "table": [ { "seqnoOut": "155", "asspldOut": "JEWELS", "pldamtOut": "1000000", "plddteOut": "20170814", "eotdteOut": "20180101", "remvalOut": "5000000", "limitedOut": "Y", "assrefOut": "0", "valdteOut": "20170814", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "nomvalOut": "1000000", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "asspldOut": null, "pldamtOut": "0", "plddteOut": "0", "eotdteOut": "0", "remvalOut": "0", "limitedOut": null, "assrefOut": "0", "valdteOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" } ] } } }');
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