/*
 * Mock ApiRest Bean for SMgetASVCessionOfFireShortTermInsuranceV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-03-22
 */
@ isTest
global class SMgetASVCessionOfFireSrtV1_Mock_ApiRest implements HttpCalloutMock{
	private String typeTest;
    
    /**
    * @description 
    * @author Muvhuso Nekhubvi | 2020-03-22 
    * @param typeTest 
    **/
    global SMgetASVCessionOfFireSrtV1_Mock_ApiRest(final String typeTest) {
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
            response.setBody('{   "SMgetASVCessionOfFireShortTermInsuranceV1Response": {     "nbsapdpo": {       "returnCode": "0",       "reasonCode": "0",       "serviceVersion": "BUSO001"     },     "nbsmsgo3": {       "version": "MSG3001",       "nbrUserMsgs": "0",       "nbrUserErrs": "0"     },     "smp132eo": {       "clcdOut": "BABICK 001",       "nomvalTotOut": "0",       "secvalTotOut": "0",       "asvamtTotOut": "0",       "msvamtTotOut": "0",       "successInd": "Y",       "table": [         {           "seqnoOut": "123",           "institOut": "HOLLARD",           "polnoOut": "TEST J STATUS 1",           "polamtOut": "33333333",           "poltypOut": "3",           "ackdteOut": "0",           "peotdaOut": "20171027",           "specifOut": "N",           "refaccOut": "0",           "statusOut": "A"         },         {           "seqnoOut": "159",           "institOut": "HOLLARD",           "polnoOut": "H23344",           "polamtOut": "100000",           "poltypOut": "2",           "ackdteOut": "0",           "peotdaOut": "20180208",           "specifOut": "N",           "refaccOut": "0",           "statusOut": "T"         },         {           "seqnoOut": "162",           "institOut": "ABSA",           "polnoOut": "65465456",           "polamtOut": "50000",           "poltypOut": "1",           "ackdteOut": "0",           "peotdaOut": "20190101",           "specifOut": "N",           "refaccOut": "0",           "statusOut": "A"         },         {           "seqnoOut": "170",           "institOut": "ABSA",           "polnoOut": "66666",           "polamtOut": "60001",           "poltypOut": "1",           "ackdteOut": "0",           "peotdaOut": "20180908",           "specifOut": "N",           "refaccOut": "0",           "statusOut": "A"         }       ]     }   } }');
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