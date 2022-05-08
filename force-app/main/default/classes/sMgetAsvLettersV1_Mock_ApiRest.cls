/*
 * Mock ApiRest Bean for sMgetAsvLettersV1 Service
 * @author Prashant Jain
 * @created 2020-03-09
 */

 @ isTest
global class sMgetAsvLettersV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description Mock Method
    * @author Prashant Jain | 2021-06-11 
    * @param typeTest 
    **/
    global sMgetAsvLettersV1_Mock_ApiRest(final String typeTest) {
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
            response.setBody('{ "SMgetASVLettersV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smn140o": { "clcdOut": null, "successInd": null, "tnomVal": null, "tsecVal": null, "tasvVal": null, "tmasvVal": null, "lettersTable": [ { "specific": "N", "status": "A", "seqno": "163", "refAcc": "0", "nomVal": "1", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "status": null, "seqno": "0", "refAcc": "0", "nomVal": "0", "secVal": "0", "masvVal": "0", "ocasVal": "0", "svperc": "0", "asvperc": "0" } ] } } }');
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