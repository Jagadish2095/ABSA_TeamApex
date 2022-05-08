/**
 * @description       : Mock ApiRest Bean for sMgetAsvDematSharesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

 @ isTest
global class sMgetAsvDematSharesV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description Mock method
    * @author Prashant Jain | 2021-06-11 
    * @param typeTest 
    **/
    global sMgetAsvDematSharesV1_Mock_ApiRest(final String typeTest) {
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
            response.setBody('{ "SMgetASVDematerializedSharesV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smn336o": { "clcdOut": null, "tnomVal": null, "tsecVal": null, "tasvVal": null, "tmasvVal": null, "outputTbl": [ { "specific": "N", "status": "A", "limited": "Y", "shareNm": "ABSA", "seqno": "161", "accNo": "890199104", "noshares": "100", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "90000", "signdte": "0", "ackndte": "20170814", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" }, { "specific": null, "status": null, "limited": null, "shareNm": null, "seqno": "0", "accNo": "0", "noshares": "0", "nomVal": "0", "secVal": "0", "ascVal": "0", "mascVal": "0", "cessamt": "0", "signdte": "0", "ackndte": "0", "refAcc": "0" } ] } } }');
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