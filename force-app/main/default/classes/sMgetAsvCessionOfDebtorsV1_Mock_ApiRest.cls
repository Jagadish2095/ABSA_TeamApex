/*
 * Mock ApiRest Bean for sMgetAsvCessionOfDebtorsV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

 @ isTest
global class sMgetAsvCessionOfDebtorsV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description 
    * @author Prashant Jain | 2021-06-11  
    * @param typeTest 
    **/
    global sMgetAsvCessionOfDebtorsV1_Mock_ApiRest(final String typeTest) {
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
            response.setBody('{ "SMgetASVCessionOfDebtorsV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smp170eo": { "clcdOut": null, "nomvalTotOut": null, "secvalTotOut": null, "asvamtTotOut": null, "msvamtTotOut": null, "successInd": null, "table": [ { "seqnoOut": "156", "anldteOut": "20170730", "cesdteOut": "20170814", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "1", "num30Out": "1", "num60Out": "1", "num90Out": "1", "num120Out": "1", "numtotOut": "5", "amt0Out": "123", "amt30Out": "1234", "amt60Out": "12345", "amt90Out": "123456", "amt120Out": "1234567", "amttotOut": "1371725", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "1371725", "secvalOut": "457195", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "175", "anldteOut": "20170814", "cesdteOut": "20170812", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "20000", "num30Out": "1", "num60Out": "1", "num90Out": "1", "num120Out": "1", "numtotOut": "20004", "amt0Out": "20000", "amt30Out": "200123", "amt60Out": "300123", "amt90Out": "30123", "amt120Out": "30000", "amttotOut": "580369", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "580369", "secvalOut": "193436", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "176", "anldteOut": "20170814", "cesdteOut": "20170812", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "1", "num30Out": "1", "num60Out": "1", "num90Out": "1", "num120Out": "1", "numtotOut": "5", "amt0Out": "122", "amt30Out": "20000", "amt60Out": "30000", "amt90Out": "20000", "amt120Out": "30000", "amttotOut": "100122", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "100122", "secvalOut": "33370", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "178", "anldteOut": "20170814", "cesdteOut": "20170812", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "1", "num30Out": "1", "num60Out": "1", "num90Out": "1", "num120Out": "1", "numtotOut": "5", "amt0Out": "800", "amt30Out": "850", "amt60Out": "900", "amt90Out": "950", "amt120Out": "1200", "amttotOut": "4700", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "4700", "secvalOut": "1566", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "179", "anldteOut": "20170814", "cesdteOut": "20170812", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "2", "num30Out": "1", "num60Out": "1", "num90Out": "1", "num120Out": "1", "numtotOut": "6", "amt0Out": "369", "amt30Out": "963", "amt60Out": "369", "amt90Out": "963", "amt120Out": "369", "amttotOut": "3033", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "3033", "secvalOut": "1010", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "182", "anldteOut": "20170814", "cesdteOut": "20170812", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "2", "num30Out": "2", "num60Out": "2", "num90Out": "2", "num120Out": "1", "numtotOut": "9", "amt0Out": "200", "amt30Out": "200", "amt60Out": "200", "amt90Out": "200", "amt120Out": "800", "amttotOut": "1600", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "1600", "secvalOut": "533", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "185", "anldteOut": "20170714", "cesdteOut": "20170714", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "1", "num30Out": "1", "num60Out": "1", "num90Out": "1", "num120Out": "1", "numtotOut": "5", "amt0Out": "770", "amt30Out": "771", "amt60Out": "772", "amt90Out": "773", "amt120Out": "774", "amttotOut": "3860", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "3860", "secvalOut": "1286", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "186", "anldteOut": "20170712", "cesdteOut": "20170712", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "1", "num30Out": "1", "num60Out": "1", "num90Out": "1", "num120Out": "1", "numtotOut": "5", "amt0Out": "20000", "amt30Out": "20000", "amt60Out": "30000", "amt90Out": "30000", "amt120Out": "100000", "amttotOut": "200000", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "200000", "secvalOut": "66660", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "187", "anldteOut": "20170707", "cesdteOut": "20170707", "cgicinOut": "N", "cgiccdOut": "N", "num0Out": "1", "num30Out": "1", "num60Out": "1", "num90Out": "1", "num120Out": "1", "numtotOut": "5", "amt0Out": "300000", "amt30Out": "300000", "amt60Out": "500000", "amt90Out": "500000", "amt120Out": "1000000", "amttotOut": "2600000", "specifOut": "N", "refaccOut": "0", "statusOut": "A", "keynumOut": "DEBTORS", "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "2600000", "secvalOut": "866580", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "anldteOut": "0", "cesdteOut": "0", "cgicinOut": null, "cgiccdOut": null, "num0Out": "0", "num30Out": "0", "num60Out": "0", "num90Out": "0", "num120Out": "0", "numtotOut": "0", "amt0Out": "0", "amt30Out": "0", "amt60Out": "0", "amt90Out": "0", "amt120Out": "0", "amttotOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "keynumOut": null, "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "anldteOut": "0", "cesdteOut": "0", "cgicinOut": null, "cgiccdOut": null, "num0Out": "0", "num30Out": "0", "num60Out": "0", "num90Out": "0", "num120Out": "0", "numtotOut": "0", "amt0Out": "0", "amt30Out": "0", "amt60Out": "0", "amt90Out": "0", "amt120Out": "0", "amttotOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "keynumOut": null, "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" }, { "seqnoOut": "0", "anldteOut": "0", "cesdteOut": "0", "cgicinOut": null, "cgiccdOut": null, "num0Out": "0", "num30Out": "0", "num60Out": "0", "num90Out": "0", "num120Out": "0", "numtotOut": "0", "amt0Out": "0", "amt30Out": "0", "amt60Out": "0", "amt90Out": "0", "amt120Out": "0", "amttotOut": "0", "specifOut": null, "refaccOut": "0", "statusOut": null, "keynumOut": null, "eotdteOut": "0", "amtcedOut": "0", "nomvalOut": "0", "secvalOut": "0", "asvamtOut": "0", "msvamtOut": "0" } ] } } }');
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