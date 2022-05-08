/**
 * @description       : Mock ApiRest Bean for sMgetAsvSuretyshipsV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/

 @ isTest
global class sMgetAsvSuretyshipsV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description Mock method
    * @author Prashant Jain | 2021-06-11 
    * @param typeTest 
    **/
    global sMgetAsvSuretyshipsV1_Mock_ApiRest(final String typeTest) {
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
            response.setBody('{   "SMgetASVSuretyshipsV1Response": {     "nbsapdpo": {       "returnCode": "0",       "reasonCode": "0",       "serviceVersion": "BUSO001"     },     "nbsmsgo3": {       "version": "MSG3001",       "nbrUserMsgs": "0",       "nbrUserErrs": "0",       "msgEntry": {         "msgClass": null,         "msgCode": null,         "msgErrInd": null,         "msgTxt": null       }     },     "smn152o": {       "clcdOut": "CLOSE  001",       "successInd": "Y",       "tnomVal": "9999999999999",       "tsecVal": "0",       "tasvVal": "0",       "tmasvVal": "0",       "suretyTable": [         {           "apprvSec": "N",           "suppSec": "N",           "suretyName": "MR A INDIVIDUAL",           "suretyClcd": "INDIVA 001",           "seqno": "119",           "suretyAcc": "0",           "dateSign": "20160815",           "suretyAmt": "9999999999999",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": "N",           "suppSec": "N",           "suretyName": "MR A INDIVIDUAL",           "suretyClcd": "INDIVA 001",           "seqno": "121",           "suretyAcc": "0",           "dateSign": "20160815",           "suretyAmt": "9999999999999",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": "N",           "suppSec": "N",           "suretyName": "MR A INDIVIDUAL",           "suretyClcd": "INDIVA 001",           "seqno": "157",           "suretyAcc": "0",           "dateSign": "20170814",           "suretyAmt": "9999999999999",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         },         {           "apprvSec": null,           "suppSec": null,           "suretyName": null,           "suretyClcd": null,           "seqno": "0",           "suretyAcc": "0",           "dateSign": "0",           "suretyAmt": "0",           "refAcc": "0",           "secVal": "0",           "nomVal": "0",           "asv": "0",           "mortAsv": "0"         }       ]     }   } }');
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