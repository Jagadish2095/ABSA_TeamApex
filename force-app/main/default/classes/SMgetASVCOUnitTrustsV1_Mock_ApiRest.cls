/**
 * @description       : 
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/
@ isTest
global class SMgetASVCOUnitTrustsV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description Mock Method
    * @author Prashant Jain | 2021-06-11 
    * @param typeTest 
    **/
    global SMgetASVCOUnitTrustsV1_Mock_ApiRest(final String typeTest) {
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
            response.setBody('{"SMgetASVCessionOfUnitTrustsV1Response": {"nbsapdpo": {"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001"},"nbsmsgo3": {"version": "MSG3001","nbrUserMsgs": "0","nbrUserErrs": "0"},"smn236o": {"clcdOut": "CGCC   002","tnomVal": "960","tsecVal": "0","tasvVal": "0","tmasvVal": "0","outputTbl": [{"specific": "N","status": "A","redmFrmHeld": "N","shareNm": "U-ABSA","seqno": "8","noshares": "100","nomVal": "0","secVal": "0","ascVal": "0","mascVal": "0","cessamt": "25000","signdte": "20180213","ackndte": "20180305","refAcc": "0"},{"specific": "N","status": "A","redmFrmHeld": "N","shareNm": "U-SADI","seqno": "9","noshares": "250","nomVal": "285","secVal": "0","ascVal": "0","mascVal": "0","cessamt": "250000","signdte": "20180213","ackndte": "0","refAcc": "0"},{"specific": "N","status": "A","redmFrmHeld": "N","shareNm": "U-PTIC","seqno": "10","noshares": "500","nomVal": "675","secVal": "0","ascVal": "0","mascVal": "0","cessamt": "220000","signdte": "20180112","ackndte": "20180120","refAcc": "0"}]}}}');
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