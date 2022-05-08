/*
 * Mock ApiRest Bean for sMgetAsvGeneralCessionsV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-03-09
 */
@ isTest
global class sMgetAsvGeneralCessionsV1_Mock_ApiRest implements HttpCalloutMock{
    private String typeTest;

    /**
    * @description Mock method
    * @author Prashant Jain | 2021-06-11  
    * @param typeTest 
    **/
    global sMgetAsvGeneralCessionsV1_Mock_ApiRest(final String typeTest) {
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
            response.setBody('{   "SMgetASVGeneralCessionsV1Response": {     "nbsapdpo": {       "returnCode": "0",       "reasonCode": "0",       "serviceVersion": "BUSO001"     },     "nbsmsgo3": {       "version": "MSG3001",       "nbrUserMsgs": "0",       "nbrUserErrs": "0"     },     "sms148o": {       "clcd": "BABICK 001",       "tnomVal": "55",       "tsecVal": "0",       "tasvVal": "0",       "tmasvVal": "0",       "cashAccVal": "0",       "gcessTable": [         {           "specific": "N",           "limited": "Y",           "status": "A",           "cessionType": "ELSILOCR",           "seqno": "74",           "cessionAmnt": "22",           "realmv": "20000",           "rentIncome": "0",           "dateSign": "20070215",           "valDate": "20160905",           "matureDate": "20080303",           "refAcc": "0",           "nomVal": "0",           "secVal": "0",           "asvVal": "0",           "masvVal": "0",           "svPerc": "0",           "asvPerc": "0"         },         {           "specific": "N",           "limited": "Y",           "status": "A",           "cessionType": "GENERAL",           "seqno": "75",           "cessionAmnt": "444",           "realmv": "0",           "rentIncome": "0",           "dateSign": "20070215",           "valDate": "0",           "matureDate": "0",           "refAcc": "0",           "nomVal": "444",           "secVal": "0",           "asvVal": "0",           "masvVal": "0",           "svPerc": "0",           "asvPerc": "0"         },         {           "specific": "N",           "limited": "Y",           "status": "A",           "cessionType": "LISALES",           "seqno": "77",           "cessionAmnt": "360",           "realmv": "720",           "rentIncome": "0",           "dateSign": "20070215",           "valDate": "20070215",           "matureDate": "20080404",           "refAcc": "0",           "nomVal": "0",           "secVal": "0",           "asvVal": "0",           "masvVal": "0",           "svPerc": "0",           "asvPerc": "0"         },         {           "specific": "N",           "limited": "Y",           "status": "A",           "cessionType": "LOANACC",           "seqno": "78",           "cessionAmnt": "200",           "realmv": "400",           "rentIncome": "0",           "dateSign": "20070215",           "valDate": "20070215",           "matureDate": "20080505",           "refAcc": "0",           "nomVal": "0",           "secVal": "0",           "asvVal": "0",           "masvVal": "0",           "svPerc": "0",           "asvPerc": "0"         },         {           "specific": "N",           "limited": "Y",           "status": "A",           "cessionType": "MULTIVST",           "seqno": "79",           "cessionAmnt": "290",           "realmv": "580",           "rentIncome": "0",           "dateSign": "0",           "valDate": "20070215",           "matureDate": "20070331",           "refAcc": "0",           "nomVal": "0",           "secVal": "0",           "asvVal": "0",           "masvVal": "0",           "svPerc": "0",           "asvPerc": "0"         },         {           "specific": "N",           "limited": "Y",           "status": "A",           "cessionType": "OTHER",           "seqno": "80",           "cessionAmnt": "290",           "realmv": "580",           "rentIncome": "0",           "dateSign": "20070215",           "valDate": "20070215",           "matureDate": "20070601",           "refAcc": "0",           "nomVal": "0",           "secVal": "0",           "asvVal": "0",           "masvVal": "0",           "svPerc": "0",           "asvPerc": "0"         },         {           "specific": "N",           "limited": "Y",           "status": "A",           "cessionType": "OTHEROFF",           "seqno": "81",           "cessionAmnt": "300",           "realmv": "600",           "rentIncome": "0",           "dateSign": "20070215",           "valDate": "20070215",           "matureDate": "20070315",           "refAcc": "0",           "nomVal": "0",           "secVal": "0",           "asvVal": "0",           "masvVal": "0",           "svPerc": "0",           "asvPerc": "0"         }       ]     }   } }');
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