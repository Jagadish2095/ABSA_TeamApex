/*
 * Mock ApiRest Bean for sMgetAsvCessionOfSchemesV1 Service
 * @author Prashant Jain
 * @created 2020-03-05
 */

 @ isTest
global class sMgetAsvCessionOfSchemesV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description 
    * @author Prashant Jain | 2021-06-11 
    * @param typeTest 
    **/
    global sMgetAsvCessionOfSchemesV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method

    /**
    * @description 
    * @author Prashant Jain | 2021-06-11 
    * @param request 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "SMgetASVCessionOfSchemesV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smp135eo": { "clcdOut": null, "nomvalTotOut": null, "secvalTotOut": null, "asvamtTotOut": null, "msvamtTotOut": null, "successInd": null, "table": [ { "seqnoOut": "160", "schtypOut": "MLOAN", "schnumOut": "123", "schamtOut": "500000", "origlnOut": "5000000", "guarntOut": "9", "crisdtOut": "0", "specifOut": "Y", "refaccOut": "-539662969", "statusOut": "A" }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null }, { "seqnoOut": "0", "schtypOut": null, "schnumOut": "0", "schamtOut": "0", "origlnOut": "0", "guarntOut": null, "crisdtOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null } ] } } }');
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